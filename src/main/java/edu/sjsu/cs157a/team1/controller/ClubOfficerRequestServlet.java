package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.ClubOfficerRequestDAO;
import edu.sjsu.cs157a.team1.model.ClubOfficerRequest;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

public class ClubOfficerRequestServlet extends HttpServlet {

    private final ClubOfficerRequestDAO requestDAO = new ClubOfficerRequestDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        request.getRequestDispatcher("/clubOfficerRequest.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer sessionUserId = (Integer) session.getAttribute("userId");

        String sjsuId = trim(request.getParameter("sjsuId"));
        String clubName = trim(request.getParameter("clubName"));
        String justification = trim(request.getParameter("justification"));

        request.setAttribute("submittedSjsuId", sjsuId);
        request.setAttribute("submittedClubName", clubName);
        request.setAttribute("submittedJustification", justification);

        try {
            String validationError = validateInput(sjsuId, clubName, justification);
            if (validationError != null) {
                request.setAttribute("errorMessage", validationError);
                request.getRequestDispatcher("/clubOfficerRequest.jsp").forward(request, response);
                return;
            }

            if (requestDAO.userHasRole(sessionUserId, "Club Officer")) {
                request.setAttribute("errorMessage", "You already have the Club Officer role.");
                request.getRequestDispatcher("/clubOfficerRequest.jsp").forward(request, response);
                return;
            }

            if (requestDAO.hasPendingRequest(sessionUserId)) {
                request.setAttribute("errorMessage", "You already have a pending officer request.");
                request.getRequestDispatcher("/clubOfficerRequest.jsp").forward(request, response);
                return;
            }

            ClubOfficerRequest officerRequest = new ClubOfficerRequest();
            officerRequest.setSjsuId(sjsuId);
            officerRequest.setClubName(clubName);
            officerRequest.setJustification(justification);
            officerRequest.setUserId(sessionUserId);

            boolean created = requestDAO.createRequest(officerRequest);

            if (created) {
                request.removeAttribute("submittedSjsuId");
                request.removeAttribute("submittedClubName");
                request.removeAttribute("submittedJustification");
                request.setAttribute("successMessage", "Your club officer request has been submitted successfully.");
            } else {
                request.setAttribute("errorMessage", "Unable to submit request. Please try again.");
            }

            request.getRequestDispatcher("/clubOfficerRequest.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred while submitting your request.");
            request.getRequestDispatcher("/clubOfficerRequest.jsp").forward(request, response);
        }
    }

    private String validateInput(String sjsuId, String clubName, String justification) {
        if (sjsuId == null || !sjsuId.matches("\\d{9}")) {
            return "SJSU ID must be exactly 9 digits.";
        }

        if (clubName == null || clubName.isBlank()) {
            return "Club name is required.";
        }

        if (clubName.length() > 255) {
            return "Club name must be 255 characters or fewer.";
        }

        if (justification == null || justification.isBlank()) {
            return "Justification is required.";
        }

        if (justification.length() > 500) {
            return "Justification must be 500 characters or fewer.";
        }

        return null;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }
}

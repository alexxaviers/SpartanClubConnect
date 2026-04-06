package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.ClubDAO;
import edu.sjsu.cs157a.team1.model.Club;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class CreateClubServlet extends HttpServlet {

    private static final String CLUB_OFFICER_ROLE = "Club Officer";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!CLUB_OFFICER_ROLE.equals(role)) {
            request.setAttribute("errorMessage", "Only club officers can create a club profile.");
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/createClub.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!CLUB_OFFICER_ROLE.equals(role)) {
            request.setAttribute("errorMessage", "Only club officers can create a club profile.");
            request.getRequestDispatcher("/home.jsp").forward(request, response);
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String contactEmail = request.getParameter("contactEmail");
        String meetingInfo = request.getParameter("meetingInfo");

        String error = validateCreate(name, description, category, contactEmail, meetingInfo);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.getRequestDispatcher("/createClub.jsp").forward(request, response);
            return;
        }

        ClubDAO clubDAO = new ClubDAO();
        if (clubDAO.nameExistsNormalized(name)) {
            request.setAttribute("errorMessage", "A club with this name already exists.");
            request.getRequestDispatcher("/createClub.jsp").forward(request, response);
            return;
        }

        Club club = new Club();
        club.setName(name.trim());
        club.setDescription(description);
        club.setCategory(category);
        club.setContactEmail(contactEmail);
        club.setMeetingInfo(meetingInfo);

        Integer newId = clubDAO.createClub(club, userId);
        if (newId == null) {
            request.setAttribute("errorMessage", "Could not create the club. Please try again.");
            request.getRequestDispatcher("/createClub.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/club?id=" + newId);
    }

    private String validateCreate(String name, String description, String category,
                                  String contactEmail, String meetingInfo) {
        if (name == null || name.trim().isEmpty()) {
            return "Club name is required.";
        }
        if (name.trim().length() > 200) {
            return "Club name must be at most 200 characters.";
        }

        if (description != null && description.length() > 8000) {
            return "Description is too long.";
        }

        if (category != null && category.trim().length() > 100) {
            return "Category must be at most 100 characters.";
        }

        if (contactEmail != null && !contactEmail.trim().isEmpty()) {
            String e = contactEmail.trim();
            if (!e.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                return "Please enter a valid contact email.";
            }
            if (e.length() > 255) {
                return "Contact email is too long.";
            }
        }

        if (meetingInfo != null && meetingInfo.length() > 500) {
            return "Meeting info must be at most 500 characters.";
        }

        return null;
    }
}
package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.ClubDAO;
import edu.sjsu.cs157a.team1.model.Club;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class EditClubServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("clubId");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/clubs");
            return;
        }

        int clubId;
        try {
            clubId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/clubs");
            return;
        }

        ClubDAO clubDAO = new ClubDAO();
        Club club = clubDAO.findById(clubId);
        if (club == null) {
            response.sendRedirect(request.getContextPath() + "/clubs");
            return;
        }

        if (!clubDAO.isOfficer(clubId, userId)) {
            response.sendRedirect(request.getContextPath() + "/club?id=" + clubId);
            return;
        }

        request.setAttribute("club", club);
        request.getRequestDispatcher("/editClub.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("clubId");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/clubs");
            return;
        }

        int clubId;
        try {
            clubId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/clubs");
            return;
        }

        ClubDAO clubDAO = new ClubDAO();
        if (!clubDAO.isOfficer(clubId, userId)) {
            response.sendRedirect(request.getContextPath() + "/club?id=" + clubId);
            return;
        }

        Club existing = clubDAO.findById(clubId);
        if (existing == null) {
            response.sendRedirect(request.getContextPath() + "/clubs");
            return;
        }

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String contactEmail = request.getParameter("contactEmail");
        String meetingInfo = request.getParameter("meetingInfo");

        String error = validateEdit(name, description, category, contactEmail, meetingInfo);
        if (error != null) {
            Club stale = buildStale(clubId, name, description, category, contactEmail, meetingInfo, existing);
            request.setAttribute("club", stale);
            request.setAttribute("errorMessage", error);
            request.getRequestDispatcher("/editClub.jsp").forward(request, response);
            return;
        }

        if (clubDAO.nameExistsNormalizedExcludingClub(name, clubId)) {
            Club stale = buildStale(clubId, name, description, category, contactEmail, meetingInfo, existing);
            request.setAttribute("club", stale);
            request.setAttribute("errorMessage", "Another club already uses this name.");
            request.getRequestDispatcher("/editClub.jsp").forward(request, response);
            return;
        }

        Club updated = new Club();
        updated.setClubId(clubId);
        updated.setName(name.trim());
        updated.setDescription(description);
        updated.setCategory(category);
        updated.setContactEmail(contactEmail);
        updated.setMeetingInfo(meetingInfo);

        if (!clubDAO.updateClub(updated)) {
            request.setAttribute("club", updated);
            request.setAttribute("errorMessage", "Could not update the club. Please try again.");
            request.getRequestDispatcher("/editClub.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/club?id=" + clubId);
    }

    private static Club buildStale(int clubId, String name, String description, String category,
                                   String contactEmail, String meetingInfo, Club existing) {
        Club stale = new Club();
        stale.setClubId(clubId);
        stale.setName(name != null ? name : existing.getName());
        stale.setDescription(description);
        stale.setCategory(category);
        stale.setContactEmail(contactEmail);
        stale.setMeetingInfo(meetingInfo);
        stale.setCreatedAt(existing.getCreatedAt());
        stale.setManagerFullName(existing.getManagerFullName());
        return stale;
    }

    private String validateEdit(String name, String description, String category,
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

package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.ClubDAO;
import edu.sjsu.cs157a.team1.model.Club;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class ClubProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");
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

        Integer userId = (Integer) session.getAttribute("userId");
        boolean canEdit = userId != null && clubDAO.isOfficer(clubId, userId);

        request.setAttribute("club", club);
        request.setAttribute("canEdit", canEdit);
        request.getRequestDispatcher("/clubProfile.jsp").forward(request, response);
    }
}

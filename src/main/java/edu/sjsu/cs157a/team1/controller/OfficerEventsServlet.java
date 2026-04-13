package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.EventDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Collections;

public class OfficerEventsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        EventDAO eventDAO = new EventDAO();

        req.setAttribute("success", req.getParameter("success"));
        req.setAttribute("error", req.getParameter("error"));

        try {
            if (!eventDAO.isClubOfficer(userId)) {
                resp.sendRedirect("events?error=" + encode("Club Officer access required"));
                return;
            }

            req.setAttribute("events", eventDAO.getManagedEvents(userId));
        } catch (Exception e) {
            req.setAttribute("events", Collections.emptyList());
            req.setAttribute("error", "Unable to load your managed events right now.");
        }

        req.getRequestDispatcher("officerEvents.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        EventDAO eventDAO = new EventDAO();

        String action = req.getParameter("action");
        if (!"delete".equalsIgnoreCase(action)) {
            resp.sendRedirect("officer-events?error=" + encode("Unknown action"));
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(req.getParameter("eventId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect("officer-events?error=" + encode("Invalid event ID"));
            return;
        }

        try {
            if (!eventDAO.isClubOfficer(userId)) {
                resp.sendRedirect("events?error=" + encode("Club Officer access required"));
                return;
            }

            boolean deleted = eventDAO.softDeleteEvent(userId, eventId);
            if (!deleted) {
                resp.sendRedirect("officer-events?error=" + encode("Unable to delete event"));
                return;
            }

            resp.sendRedirect("officer-events?success=" + encode("Event deleted"));
        } catch (Exception e) {
            resp.sendRedirect("officer-events?error=" + encode("Unable to delete event right now"));
        }
    }

    private String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}

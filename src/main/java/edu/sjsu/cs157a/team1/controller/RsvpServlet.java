package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.RsvpDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class RsvpServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String action = req.getParameter("action");
        String returnTo = req.getParameter("returnTo");

        int eventId;
        try {
            eventId = Integer.parseInt(req.getParameter("eventId"));
        } catch (NumberFormatException e) {
            resp.sendRedirect("events?error=Invalid+event+ID");
            return;
        }

        RsvpDAO rsvpDAO = new RsvpDAO();

        try {
            if ("register".equalsIgnoreCase(action)) {
                handleRegister(rsvpDAO, userId, eventId, returnTo, resp);
                return;
            }

            if ("cancel".equalsIgnoreCase(action)) {
                handleCancel(rsvpDAO, userId, eventId, returnTo, resp);
                return;
            }

            redirectWithMessage(resp, returnTo, eventId, "error", "Unknown action");
        } catch (Exception e) {
            redirectWithMessage(resp, returnTo, eventId, "error", "Unable to process RSVP right now");
        }
    }

    private void handleRegister(RsvpDAO rsvpDAO, int userId, int eventId, String returnTo, HttpServletResponse resp)
            throws Exception {
        if (rsvpDAO.hasActiveRsvp(userId, eventId)) {
            redirectWithMessage(resp, returnTo, eventId, "error", "Already RSVPed");
            return;
        }

        RsvpDAO.EventView event = rsvpDAO.getEventById(eventId, userId);
        if (event == null) {
            redirectWithMessage(resp, returnTo, eventId, "error", "Event not found");
            return;
        }

        if (event.isFull()) {
            redirectWithMessage(resp, returnTo, eventId, "error", "Event is full");
            return;
        }

        boolean inserted = rsvpDAO.createRsvp(userId, eventId);
        if (!inserted) {
            redirectWithMessage(resp, returnTo, eventId, "error", "Could not RSVP");
            return;
        }

        redirectWithMessage(resp, returnTo, eventId, "success", "RSVP successful");
    }

    private void handleCancel(RsvpDAO rsvpDAO, int userId, int eventId, String returnTo, HttpServletResponse resp)
            throws Exception {
        if (!rsvpDAO.hasActiveRsvp(userId, eventId)) {
            redirectWithMessage(resp, returnTo, eventId, "error", "No active RSVP found");
            return;
        }

        boolean deleted = rsvpDAO.deleteRsvp(userId, eventId);
        if (!deleted) {
            redirectWithMessage(resp, returnTo, eventId, "error", "Could not cancel RSVP");
            return;
        }

        redirectWithMessage(resp, returnTo, eventId, "success", "RSVP cancelled");
    }

    private void redirectWithMessage(HttpServletResponse resp, String returnTo, int eventId, String key, String value)
            throws IOException {
        String encoded = URLEncoder.encode(value, StandardCharsets.UTF_8);

        if ("my-rsvps".equals(returnTo)) {
            resp.sendRedirect("my-rsvps?" + key + "=" + encoded);
            return;
        }

        resp.sendRedirect("event-details?eventId=" + eventId + "&" + key + "=" + encoded);
    }
}

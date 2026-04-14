package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.RsvpDAO;
import edu.sjsu.cs157a.team1.util.CsrfUtil;

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

        if (!CsrfUtil.isValid(session, req.getParameter("csrfToken"))) {
            resp.sendRedirect("events?error=Invalid+request");
            return;
        }

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
        RsvpDAO.RegisterResult result = rsvpDAO.registerUserAtomically(userId, eventId);
        if (!result.isSaved()) {
            redirectWithMessage(resp, returnTo, eventId, "error", result.getError());
            return;
        }

        String targetStatus = result.getStatus();
        if ("Waitlisted".equals(targetStatus)) {
            redirectWithMessage(resp, returnTo, eventId, "success", "Event is full. You were added to the waitlist");
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

        String oldStatus = rsvpDAO.getRsvpStatus(userId, eventId);
        boolean cancelled = rsvpDAO.cancelRsvp(userId, eventId);
        if (!cancelled) {
            redirectWithMessage(resp, returnTo, eventId, "error", "Could not cancel RSVP");
            return;
        }

        if ("Going".equals(oldStatus)) {
            rsvpDAO.promoteFirstWaitlisted(eventId);
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

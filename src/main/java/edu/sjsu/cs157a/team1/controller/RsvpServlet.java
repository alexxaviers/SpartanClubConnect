package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.RsvpDAO;
import edu.sjsu.cs157a.team1.dao.UserDAO;
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
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        String action = req.getParameter("action");
        String returnTo = req.getParameter("returnTo");
        UserDAO userDAO = new UserDAO();

        if (userDAO.findById(userId) == null) {
            session.invalidate();
            req.setAttribute("error", "Your session is no longer valid. Please log in again.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
            return;
        }

        if (!CsrfUtil.isValid(session, req.getParameter("csrfToken"))) {
            setToast(session, "Invalid request.", "error");
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        int eventId;
        try {
            eventId = Integer.parseInt(req.getParameter("eventId"));
        } catch (NumberFormatException e) {
            setToast(session, "Invalid event ID.", "error");
            resp.sendRedirect(req.getContextPath() + "/events");
            return;
        }

        RsvpDAO rsvpDAO = new RsvpDAO();

        try {
            if ("register".equalsIgnoreCase(action)) {
                handleRegister(session, rsvpDAO, userId, eventId, returnTo, resp, req.getContextPath());
                return;
            }

            if ("cancel".equalsIgnoreCase(action)) {
                handleCancel(session, rsvpDAO, userId, eventId, returnTo, resp, req.getContextPath());
                return;
            }

            redirectWithMessage(resp, req.getContextPath(), returnTo, eventId, "error", "Unknown action");
        } catch (Exception e) {
            log("Unexpected RSVP processing failure for userId=" + userId + ", eventId=" + eventId, e);
            redirectWithMessage(resp, req.getContextPath(), returnTo, eventId, "error", "Unable to process RSVP right now");
        }
    }

    private void handleRegister(HttpSession session, RsvpDAO rsvpDAO, int userId, int eventId, String returnTo,
                                HttpServletResponse resp, String ctx)
            throws Exception {
        RsvpDAO.RegisterResult result = rsvpDAO.registerUserAtomically(userId, eventId);
        if (!result.isSaved()) {
            redirectWithMessage(resp, ctx, returnTo, eventId, "error", result.getError());
            return;
        }

        String targetStatus = result.getStatus();
        if ("Waitlisted".equals(targetStatus)) {
            setToast(session, "Event is full. You were added to the waitlist.", "success");
            redirectWithoutParams(resp, ctx, returnTo, eventId);
            return;
        }

        setToast(session, "RSVP successful!", "success");
        redirectWithoutParams(resp, ctx, returnTo, eventId);
    }

    private void handleCancel(HttpSession session, RsvpDAO rsvpDAO, int userId, int eventId, String returnTo,
                              HttpServletResponse resp, String ctx)
            throws Exception {
        boolean cancelled = rsvpDAO.cancelAndPromoteAtomically(userId, eventId);
        if (!cancelled) {
            redirectWithMessage(resp, ctx, returnTo, eventId, "error", "No active RSVP found");
            return;
        }

        setToast(session, "RSVP cancelled.", "success");
        redirectWithoutParams(resp, ctx, returnTo, eventId);
    }

    private void redirectWithoutParams(HttpServletResponse resp, String ctx, String returnTo, int eventId)
            throws IOException {
        if ("my-rsvps".equals(returnTo)) {
            resp.sendRedirect(ctx + "/my-rsvps");
            return;
        }

        resp.sendRedirect(ctx + "/event-details?eventId=" + eventId);
    }

    private void redirectWithMessage(HttpServletResponse resp, String ctx, String returnTo, int eventId, String key, String value)
            throws IOException {
        String encoded = URLEncoder.encode(value, StandardCharsets.UTF_8);

        if ("my-rsvps".equals(returnTo)) {
            resp.sendRedirect(ctx + "/my-rsvps?" + key + "=" + encoded);
            return;
        }

        resp.sendRedirect(ctx + "/event-details?eventId=" + eventId + "&" + key + "=" + encoded);
    }

    private void setToast(HttpSession session, String message, String type) {
        session.setAttribute("toastMessage", message);
        session.setAttribute("toastType", type);
    }
}

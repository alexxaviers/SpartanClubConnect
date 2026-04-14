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
import java.util.Collections;
import java.util.List;

public class EventDetailsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String eventIdParam = req.getParameter("eventId");
        int eventId;

        try {
            eventId = Integer.parseInt(eventIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect("events?error=Invalid+event+ID");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        Boolean isClubOfficer = Boolean.TRUE.equals(session.getAttribute("isClubOfficer"));
        RsvpDAO rsvpDAO = new RsvpDAO();

        try {
            RsvpDAO.EventView event = rsvpDAO.getEventById(eventId, userId);
            if (event == null) {
                resp.sendRedirect("events?error=Event+not+found");
                return;
            }

            boolean canViewAttendees = isClubOfficer
                    && rsvpDAO.canOfficerViewAttendees(userId, eventId);

            List<RsvpDAO.AttendeeView> attendees = canViewAttendees
                    ? rsvpDAO.getAttendeesForEvent(eventId)
                    : Collections.emptyList();

            req.setAttribute("event", event);
            req.setAttribute("canViewAttendees", canViewAttendees);
            req.setAttribute("attendees", attendees);
            req.setAttribute("success", req.getParameter("success"));
            req.setAttribute("error", req.getParameter("error"));

            req.getRequestDispatcher("eventDetails.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.sendRedirect("events?error=" + URLEncoder.encode("Unable to load event details right now", StandardCharsets.UTF_8));
        }
    }
}

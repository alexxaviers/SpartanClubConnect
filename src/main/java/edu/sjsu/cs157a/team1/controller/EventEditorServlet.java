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
import java.sql.Date;
import java.sql.Time;

public class EventEditorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        EventDAO eventDAO = new EventDAO();

        try {
            if (!eventDAO.isClubOfficer(userId)) {
                resp.sendRedirect("events?error=" + encode("Club Officer access required"));
                return;
            }

            String eventIdParam = req.getParameter("eventId");
            if (eventIdParam != null && !eventIdParam.trim().isEmpty()) {
                int eventId = Integer.parseInt(eventIdParam);
                EventDAO.ManagedEventView event = eventDAO.getManagedEventById(userId, eventId);
                if (event == null) {
                    resp.sendRedirect("officer-events?error=" + encode("Event not found or not managed by you"));
                    return;
                }
                req.setAttribute("event", event);
            }

            req.setAttribute("clubs", eventDAO.getManagedClubs(userId));
            req.setAttribute("error", req.getParameter("error"));
            req.getRequestDispatcher("eventForm.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect("officer-events?error=" + encode("Invalid event ID"));
        } catch (Exception e) {
            resp.sendRedirect("officer-events?error=" + encode("Unable to load event form"));
        }
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

        String eventIdParam = clean(req.getParameter("eventId"));
        String clubIdParam = clean(req.getParameter("clubId"));
        String title = clean(req.getParameter("title"));
        String description = clean(req.getParameter("description"));
        String dateParam = clean(req.getParameter("date"));
        String startTimeParam = clean(req.getParameter("startTime"));
        String endTimeParam = clean(req.getParameter("endTime"));
        String location = clean(req.getParameter("location"));
        String capacityParam = clean(req.getParameter("capacity"));
        String category = clean(req.getParameter("category"));
        String imageUrl = clean(req.getParameter("imageUrl"));

        try {
            if (!eventDAO.isClubOfficer(userId)) {
                resp.sendRedirect("events?error=" + encode("Club Officer access required"));
                return;
            }

            if (title.isEmpty() || description.isEmpty() || dateParam.isEmpty() ||
                    startTimeParam.isEmpty() || endTimeParam.isEmpty() || location.isEmpty()) {
                redirectToForm(resp, eventIdParam, "Please fill all required fields");
                return;
            }

            if (!imageUrl.isEmpty() && !imageUrl.startsWith("http://") && !imageUrl.startsWith("https://")) {
                redirectToForm(resp, eventIdParam, "Image URL must start with http:// or https://");
                return;
            }

            Date eventDate = Date.valueOf(dateParam);
            Time startTime = Time.valueOf(startTimeParam + ":00");
            Time endTime = Time.valueOf(endTimeParam + ":00");

            if (!endTime.after(startTime)) {
                redirectToForm(resp, eventIdParam, "End time must be after start time");
                return;
            }

            Integer capacity = null;
            if (!capacityParam.isEmpty()) {
                capacity = Integer.parseInt(capacityParam);
                if (capacity <= 0) {
                    redirectToForm(resp, eventIdParam, "Capacity must be a positive number");
                    return;
                }
            }

            if (eventIdParam.isEmpty()) {
                if (clubIdParam.isEmpty()) {
                    redirectToForm(resp, "", "Club is required for new events");
                    return;
                }

                int clubId = Integer.parseInt(clubIdParam);
                if (!eventDAO.canManageClub(userId, clubId)) {
                    redirectToForm(resp, "", "You can only create events for clubs you manage");
                    return;
                }

                boolean created = eventDAO.createEvent(userId, clubId, title, description, eventDate,
                        startTime, endTime, location, capacity, emptyToNull(category), emptyToNull(imageUrl));
                if (!created) {
                    redirectToForm(resp, "", "Unable to create event");
                    return;
                }

                resp.sendRedirect("officer-events?success=" + encode("Event created and published"));
                return;
            }

            int eventId = Integer.parseInt(eventIdParam);
            boolean updated = eventDAO.updateEvent(userId, eventId, title, description, eventDate,
                    startTime, endTime, location, capacity, emptyToNull(category), emptyToNull(imageUrl));
            if (!updated) {
                redirectToForm(resp, eventIdParam, "Unable to update event");
                return;
            }

            resp.sendRedirect("officer-events?success=" + encode("Event updated"));
        } catch (IllegalArgumentException e) {
            redirectToForm(resp, eventIdParam, "Invalid date/time format");
        } catch (Exception e) {
            redirectToForm(resp, eventIdParam, "Unable to save event right now");
        }
    }

    private void redirectToForm(HttpServletResponse resp, String eventId, String error) throws IOException {
        StringBuilder redirect = new StringBuilder("officer-event?error=").append(encode(error));
        String normalizedEventId = normalizeEventId(eventId);
        if (normalizedEventId != null) {
            redirect.append("&eventId=").append(encode(normalizedEventId));
        }
        resp.sendRedirect(redirect.toString());
    }

    private String normalizeEventId(String eventId) {
        if (eventId == null) {
            return null;
        }
        String trimmed = eventId.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        try {
            return Integer.toString(Integer.parseInt(trimmed));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private String emptyToNull(String value) {
        return value == null || value.trim().isEmpty() ? null : value.trim();
    }

    private String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}

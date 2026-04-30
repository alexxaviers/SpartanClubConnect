package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.EventDAO;
import edu.sjsu.cs157a.team1.util.CsrfUtil;

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

    private static final int MAX_TITLE_LENGTH = 200;
    private static final int MAX_LOCATION_LENGTH = 200;
    private static final int MAX_CATEGORY_LENGTH = 100;
    private static final int MAX_IMAGE_URL_LENGTH = 255;
    private static final String[] ALLOWED_CATEGORY_OPTIONS = {
            "Academic",
            "Workshop",
            "Networking / Career",
            "Social",
            "Volunteer / Service",
            "Competition / Tournament",
            "Performance / Showcase",
            "Sports / Recreation"
    };

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

        if (!CsrfUtil.isValid(session, req.getParameter("csrfToken"))) {
            forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Invalid request");
            return;
        }

        String clubIdParam = clean(req.getParameter("clubId"));
        String title = clean(req.getParameter("title"));
        String description = clean(req.getParameter("description"));
        String dateParam = clean(req.getParameter("date"));
        String startTimeParam = clean(req.getParameter("startTime"));
        String endTimeParam = clean(req.getParameter("endTime"));
        String location = clean(req.getParameter("location"));
        String capacityParam = clean(req.getParameter("capacity"));
        String categoryPreset = clean(req.getParameter("categoryPreset"));
        String categoryOther = clean(req.getParameter("categoryOther"));
        String legacyCategory = clean(req.getParameter("category"));
        String imageUrl = clean(req.getParameter("imageUrl"));

        try {
            if (!eventDAO.isClubOfficer(userId)) {
                resp.sendRedirect("events?error=" + encode("Club Officer access required"));
                return;
            }

            if (title.isEmpty() || description.isEmpty() || dateParam.isEmpty() ||
                    startTimeParam.isEmpty() || endTimeParam.isEmpty() || location.isEmpty()) {
                forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Please fill all required fields");
                return;
            }

            if (!imageUrl.isEmpty() && !imageUrl.startsWith("http://") && !imageUrl.startsWith("https://")) {
                forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Image URL must start with http:// or https://");
                return;
            }

            String category = resolveCategory(categoryPreset, categoryOther, legacyCategory);
            if (category == null && !categoryPreset.isEmpty() && !"other".equals(categoryPreset) && !isAllowedCategory(categoryPreset)) {
                forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Please select a valid category");
                return;
            }

            String lengthError = validateFieldLengths(title, location, category, imageUrl);
            if (lengthError != null) {
                forwardToForm(req, resp, eventDAO, userId, eventIdParam, lengthError);
                return;
            }

            Date eventDate = Date.valueOf(dateParam);
            Time startTime = Time.valueOf(startTimeParam + ":00");
            Time endTime = Time.valueOf(endTimeParam + ":00");

            if (!endTime.after(startTime)) {
                forwardToForm(req, resp, eventDAO, userId, eventIdParam, "End time must be after start time");
                return;
            }

            Integer capacity = null;
            if (!capacityParam.isEmpty()) {
                capacity = Integer.parseInt(capacityParam);
                if (capacity <= 0) {
                    forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Capacity must be a positive number");
                    return;
                }
            }

            if (eventIdParam.isEmpty()) {
                if (clubIdParam.isEmpty()) {
                    forwardToForm(req, resp, eventDAO, userId, "", "Club is required for new events");
                    return;
                }

                int clubId = Integer.parseInt(clubIdParam);
                if (!eventDAO.canManageClub(userId, clubId)) {
                    forwardToForm(req, resp, eventDAO, userId, "", "You can only create events for clubs you manage");
                    return;
                }

                boolean created = eventDAO.createEvent(userId, clubId, title, description, eventDate,
                        startTime, endTime, location, capacity, emptyToNull(category), emptyToNull(imageUrl));
                if (!created) {
                    forwardToForm(req, resp, eventDAO, userId, "", "Unable to create event");
                    return;
                }

                req.getSession().setAttribute("toastMessage", "Event created successfully.");
                req.getSession().setAttribute("toastType", "success");
                resp.sendRedirect("officer-events");
                return;
            }

            int eventId = Integer.parseInt(eventIdParam);
            boolean updated = eventDAO.updateEvent(userId, eventId, title, description, eventDate,
                    startTime, endTime, location, capacity, emptyToNull(category), emptyToNull(imageUrl));
            if (!updated) {
                forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Unable to update event");
                return;
            }

            req.getSession().setAttribute("toastMessage", "Event updated successfully.");
            req.getSession().setAttribute("toastType", "success");
            resp.sendRedirect("officer-events");
        } catch (NumberFormatException e) {
            forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Invalid numeric value");
        } catch (IllegalArgumentException e) {
            forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Invalid date/time format");
        } catch (Exception e) {
            forwardToForm(req, resp, eventDAO, userId, eventIdParam, "Unable to save event right now");
        }
    }

    private void forwardToForm(HttpServletRequest req, HttpServletResponse resp, EventDAO eventDAO, int userId, String eventId, String error)
            throws IOException, ServletException {
        try {
            req.setAttribute("error", error);
            req.setAttribute("clubs", eventDAO.getManagedClubs(userId));

            String normalizedEventId = normalizeEventId(eventId);
            if (normalizedEventId != null) {
                EventDAO.ManagedEventView event = eventDAO.getManagedEventById(userId, Integer.parseInt(normalizedEventId));
                if (event != null) {
                    req.setAttribute("event", event);
                }
            }

            req.getRequestDispatcher("eventForm.jsp").forward(req, resp);
        } catch (Exception ex) {
            resp.sendRedirect("officer-events?error=" + encode(error));
        }
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

    private String validateFieldLengths(String title, String location, String category, String imageUrl) {
        if (title.length() > MAX_TITLE_LENGTH) {
            return "Title cannot exceed " + MAX_TITLE_LENGTH + " characters";
        }

        if (location.length() > MAX_LOCATION_LENGTH) {
            return "Location cannot exceed " + MAX_LOCATION_LENGTH + " characters";
        }

        if (!category.isEmpty() && category.length() > MAX_CATEGORY_LENGTH) {
            return "Category cannot exceed " + MAX_CATEGORY_LENGTH + " characters";
        }

        if (!imageUrl.isEmpty() && imageUrl.length() > MAX_IMAGE_URL_LENGTH) {
            return "Image URL cannot exceed " + MAX_IMAGE_URL_LENGTH + " characters";
        }

        return null;
    }

    private String resolveCategory(String categoryPreset, String categoryOther, String legacyCategory) {
        if (categoryPreset.isEmpty()) {
            if (!legacyCategory.isEmpty() && isAllowedCategory(legacyCategory)) {
                return legacyCategory;
            }
            return null;
        }

        if ("other".equals(categoryPreset)) {
            if (categoryOther.isEmpty()) {
                return null;
            }
            return categoryOther;
        }

        if (isAllowedCategory(categoryPreset)) {
            return categoryPreset;
        }

        return null;
    }

    private boolean isAllowedCategory(String category) {
        for (String option : ALLOWED_CATEGORY_OPTIONS) {
            if (option.equals(category)) {
                return true;
            }
        }
        return false;
    }
}

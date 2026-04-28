package edu.sjsu.cs157a.team1.controller;

import edu.sjsu.cs157a.team1.dao.EventDAO;
import edu.sjsu.cs157a.team1.model.Event;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class AdminEventsServlet extends HttpServlet {

    private final EventDAO eventDAO = new EventDAO();

    private Integer getSessionUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Integer) session.getAttribute("userId");
    }

    private boolean isAdmin(HttpServletRequest request) throws SQLException {
        Integer userId = getSessionUserId(request);
        return userId != null && eventDAO.userHasRole(userId, "Admin");
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException, SQLException {
        Integer sessionUserId = getSessionUserId(request);

        if (sessionUserId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            if (!requireAdmin(request, response)) {
                return;
            }

            List<Event> events = eventDAO.getAllEventsForAdmin();
            request.setAttribute("events", events);
            request.getRequestDispatcher("/adminEvents.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unable to load events.");
            request.getRequestDispatcher("/adminEvents.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            if (!requireAdmin(request, response)) {
                return;
            }

            String action = request.getParameter("action");
            String eventIdParam = request.getParameter("eventId");

            if (eventIdParam == null || eventIdParam.isBlank()) {
                request.getSession().setAttribute("adminEventsMessage", "Invalid event ID.");
                response.sendRedirect(request.getContextPath() + "/admin/events");
                return;
            }

            int eventId = Integer.parseInt(eventIdParam);
            Event targetEvent = eventDAO.getEventById(eventId);

            if (targetEvent == null) {
                request.getSession().setAttribute("adminEventsMessage", "Event not found.");
                response.sendRedirect(request.getContextPath() + "/admin/events");
                return;
            }

            boolean success;

            if ("disable".equalsIgnoreCase(action)) {
                if (!targetEvent.isActive()) {
                    request.getSession().setAttribute("adminEventsMessage", "This event is already disabled.");
                    response.sendRedirect(request.getContextPath() + "/admin/events");
                    return;
                }

                String moderationReason = request.getParameter("reason");
                success = eventDAO.disableEventWithAudit(eventId, getSessionUserId(request), moderationReason);
                request.getSession().setAttribute(
                        "adminEventsMessage",
                        success ? "Event disabled successfully." : "No changes were made."
                );

            } else if ("enable".equalsIgnoreCase(action)) {
                if (targetEvent.isActive()) {
                    request.getSession().setAttribute("adminEventsMessage", "This event is already active.");
                    response.sendRedirect(request.getContextPath() + "/admin/events");
                    return;
                }

                success = eventDAO.enableEventAndClearAudit(eventId);
                request.getSession().setAttribute(
                        "adminEventsMessage",
                        success ? "Event enabled successfully." : "No changes were made."
                );

            } else {
                request.getSession().setAttribute("adminEventsMessage", "Invalid action.");
                response.sendRedirect(request.getContextPath() + "/admin/events");
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/events");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("adminEventsMessage", "Event ID must be a valid number.");
            response.sendRedirect(request.getContextPath() + "/admin/events");
        } catch (SQLException e) {
            e.printStackTrace();
            request.getSession().setAttribute("adminEventsMessage", "A database error occurred.");
            response.sendRedirect(request.getContextPath() + "/admin/events");
        }
    }
}

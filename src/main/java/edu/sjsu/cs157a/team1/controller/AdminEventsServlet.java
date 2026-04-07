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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer sessionUserId = getSessionUserId(request);

            if (sessionUserId == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            if (!isAdmin(request)) {
                response.sendRedirect("dashboard.jsp");
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
            Integer sessionUserId = getSessionUserId(request);

            if (sessionUserId == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            if (!isAdmin(request)) {
                response.sendRedirect("dashboard.jsp");
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

                success = eventDAO.setEventActiveStatus(eventId, false);

            } else if ("enable".equalsIgnoreCase(action)) {
                if (targetEvent.isActive()) {
                    request.getSession().setAttribute("adminEventsMessage", "This event is already active.");
                    response.sendRedirect(request.getContextPath() + "/admin/events");
                    return;
                }

                success = eventDAO.setEventActiveStatus(eventId, true);

            } else {
                request.getSession().setAttribute("adminEventsMessage", "Invalid action.");
                response.sendRedirect(request.getContextPath() + "/admin/events");
                return;
            }

            request.getSession().setAttribute(
                    "adminEventsMessage",
                    success ? "Event updated successfully." : "No changes were made."
            );

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

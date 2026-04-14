<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.sjsu.cs157a.team1.model.Event" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    List<Event> events = (List<Event>) request.getAttribute("events");

    String errorMessage = (String) request.getAttribute("errorMessage");
    String actionMessage = (String) session.getAttribute("adminEventsMessage");
    if (actionMessage != null) {
        session.removeAttribute("adminEventsMessage");
    }

    SimpleDateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy");

    request.setAttribute("activeAdminPage", "events");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Moderate Events - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubOfficer.css">
    <link rel="stylesheet" href="<%= ctx %>/css/admin.css">
</head>

<%@ include file="/WEB-INF/jspf/adminLayoutStart.jspf" %>

<section class="dashboard-page-header">
    <h1 class="dashboard-page-title">Moderate Events</h1>
    <p class="dashboard-page-subtitle">
        Review all event records and disable events that should not appear in the platform.
    </p>
</section>

<section class="dashboard-form-card dashboard-table-card">
    <% if (errorMessage != null) { %>
    <p class="message error-message-box"><%= errorMessage %></p>
    <% } %>

    <% if (actionMessage != null) { %>
    <p class="message success-message-box"><%= actionMessage %></p>
    <% } %>

    <h2 class="request-section-title">All Events</h2>

    <% if (events == null || events.isEmpty()) { %>
    <div class="dashboard-note-box">
        No events were found.
    </div>
    <% } else { %>
    <div class="request-table-wrap">
        <table class="request-table admin-table-events">
            <thead>
            <tr>
                <th>Event ID</th>
                <th>Title</th>
                <th>Club</th>
                <th>Created By</th>
                <th>Date</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (Event event : events) { %>
            <tr>
                <td><%= event.getEventId() %></td>
                <td><%= event.getTitle() %></td>
                <td><%= event.getClubName() %></td>
                <td><%= event.getCreatorName() %></td>
                <td><%= event.getDate() != null ? dateFormatter.format(event.getDate()) : "-" %></td>
                <td><%= event.getLocation() %></td>
                <td>
                    <span class="admin-badge <%= event.isActive() ? "admin-badge-active" : "admin-badge-inactive" %>">
                        <%= event.isActive() ? "Active" : "Disabled" %>
                    </span>
                </td>
                <td>
                    <div class="admin-action-stack">
                        <% if (event.isActive()) { %>
                        <form method="post" action="<%= ctx %>/admin/events">
                            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                            <input type="hidden" name="action" value="disable">
                            <button type="submit" class="secondary-btn request-action-btn"
                                    onclick="return confirm('Disable this event?');">
                                Disable
                            </button>
                        </form>
                        <% } else { %>
                        <form method="post" action="<%= ctx %>/admin/events">
                            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                            <input type="hidden" name="action" value="enable">
                            <button type="submit" class="primary-btn request-action-btn"
                                    onclick="return confirm('Re-enable this event?');">
                                Enable
                            </button>
                        </form>
                        <% } %>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</section>

<%@ include file="/WEB-INF/jspf/adminLayoutEnd.jspf" %>
</html>

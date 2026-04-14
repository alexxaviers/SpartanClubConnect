<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.EventDAO.ManagedEventView" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%@ page import="edu.sjsu.cs157a.team1.util.CsrfUtil" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    String csrfToken = CsrfUtil.getToken(session);

    List<ManagedEventView> events = (List<ManagedEventView>) request.getAttribute("events");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
</head>
<body>
<main style="max-width: 1060px; margin: 24px auto; padding: 0 16px;">
    <h1>Manage Events</h1>

    <p>
        <a href="<%= ctx %>/dashboard.jsp">Home</a> |
        <a href="<%= ctx %>/events">Browse Events</a> |
        <a href="<%= ctx %>/officer-event">Create New Event</a>
    </p>

    <% if (success != null && !success.isEmpty()) { %>
    <p style="color: #0f7b0f;"><strong><%= HtmlEscape.escape(success) %></strong></p>
    <% } %>

    <% if (error != null && !error.isEmpty()) { %>
    <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
    <% } %>

    <% if (events == null || events.isEmpty()) { %>
    <p>You do not have active events yet. Create one to publish it in the event feed.</p>
    <% } else { %>
    <table border="1" cellpadding="8" cellspacing="0" width="100%">
        <thead>
        <tr>
            <th>Event</th>
            <th>Club</th>
            <th>Date</th>
            <th>Time</th>
            <th>Location</th>
            <th>Capacity</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (ManagedEventView event : events) { %>
        <tr>
            <td><%= HtmlEscape.escape(event.getTitle()) %></td>
            <td><%= HtmlEscape.escape(event.getClubName()) %></td>
            <td><%= event.getDate() %></td>
            <td><%= event.getStartTime() %> - <%= event.getEndTime() %></td>
            <td><%= HtmlEscape.escape(event.getLocation()) %></td>
            <td><%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %></td>
            <td>
                <a href="<%= ctx %>/officer-event?eventId=<%= event.getEventId() %>">Edit</a>
                |
                <form action="<%= ctx %>/officer-events" method="post" style="display: inline; margin: 0;">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <button type="submit" onclick="return confirm('Delete this event?');">Delete</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>
</main>
</body>
</html>

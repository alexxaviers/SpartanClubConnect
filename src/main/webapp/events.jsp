<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.EventView" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String role = (String) session.getAttribute("role");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<EventView> events = (List<EventView>) request.getAttribute("events");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Events - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
</head>
<body>
<main style="max-width: 960px; margin: 24px auto; padding: 0 16px;">
    <h1>Upcoming Events</h1>

    <p>
        <a href="dashboard.jsp">Home</a> |
        <a href="my-rsvps">My RSVPs</a> |
        <a href="events?feed=all">Browse All Events</a> |
        <a href="#" onclick="return false;" title="Placeholder for teammate implementation">Browse Personalized Events (Coming Soon)</a>
        <% if ("Club Officer".equalsIgnoreCase(role)) { %>
            | <a href="officer-events">Manage My Club Events</a>
        <% } %>
    </p>

    <% if (success != null && !success.isEmpty()) { %>
        <p style="color: #0f7b0f;"><strong><%= success %></strong></p>
    <% } %>

    <% if (error != null && !error.isEmpty()) { %>
        <p style="color: #b00020;"><strong><%= error %></strong></p>
    <% } %>

    <% if (events == null || events.isEmpty()) { %>
        <p>No events available right now.</p>
    <% } else { %>
        <table border="1" cellpadding="8" cellspacing="0" width="100%">
            <thead>
            <tr>
                <th>Title</th>
                <th>Club</th>
                <th>Category</th>
                <th>Date</th>
                <th>Time</th>
                <th>Location</th>
                <th>Availability</th>
                <th>Your RSVP</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (EventView event : events) { %>
                <tr>
                    <td><%= event.getTitle() %></td>
                    <td><%= event.getClubName() %></td>
                    <td><%= event.getCategory() == null ? "-" : event.getCategory() %></td>
                    <td><%= event.getDate() %></td>
                    <td><%= event.getStartTime() %> - <%= event.getEndTime() %></td>
                    <td><%= event.getLocation() %></td>
                    <td>
                        <%= event.getGoingCount() %>
                        /
                        <%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %>
                        <%= event.isFull() ? " (Full)" : "" %>
                    </td>
                    <td><%= event.getUserRsvpStatus() == null ? "Not RSVPed" : event.getUserRsvpStatus() %></td>
                    <td><a href="event-details?eventId=<%= event.getEventId() %>">View Details</a></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    <% } %>
</main>
</body>
</html>

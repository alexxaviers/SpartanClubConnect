<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.EventView" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.AttendeeView" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    EventView event = (EventView) request.getAttribute("event");
    Boolean canViewAttendees = (Boolean) request.getAttribute("canViewAttendees");
    List<AttendeeView> attendees = (List<AttendeeView>) request.getAttribute("attendees");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Details - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
</head>
<body>
<main style="max-width: 960px; margin: 24px auto; padding: 0 16px;">
    <h1>Event Details</h1>

    <p>
        <a href="events">Back to Events</a> |
        <a href="my-rsvps">My RSVPs</a> |
        <a href="home.jsp">Home</a>
    </p>

    <% if (error != null && !error.isEmpty()) { %>
        <p style="color: #b00020;"><strong><%= error %></strong></p>
    <% } %>

    <% if (success != null && !success.isEmpty()) { %>
        <p style="color: #0f7b0f;"><strong><%= success %></strong></p>
    <% } %>

    <% if (event == null) { %>
        <p>Event not found.</p>
    <% } else { %>
        <section style="margin-bottom: 20px;">
            <h2><%= event.getTitle() %></h2>
            <p><strong>Club:</strong> <%= event.getClubName() %></p>
            <p><strong>Description:</strong> <%= event.getDescription() %></p>
            <p><strong>Date:</strong> <%= event.getDate() %></p>
            <p><strong>Time:</strong> <%= event.getStartTime() %> - <%= event.getEndTime() %></p>
            <p><strong>Location:</strong> <%= event.getLocation() %></p>
            <p>
                <strong>Capacity:</strong>
                <%= event.getGoingCount() %>
                /
                <%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %>
                <%= event.isFull() ? " (Full)" : "" %>
            </p>
        </section>

        <section style="margin-bottom: 28px;">
            <% if (event.isUserRsvped()) { %>
                <form action="rsvp" method="post">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <button type="submit">Cancel RSVP</button>
                </form>
            <% } else if (event.isFull()) { %>
                <p><strong>Event is full.</strong></p>
            <% } else { %>
                <form action="rsvp" method="post">
                    <input type="hidden" name="action" value="register">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <button type="submit">RSVP / Register</button>
                </form>
            <% } %>
        </section>

        <% if (Boolean.TRUE.equals(canViewAttendees)) { %>
            <section>
                <h3>Attendee List (Going)</h3>
                <% if (attendees == null || attendees.isEmpty()) { %>
                    <p>No attendees yet.</p>
                <% } else { %>
                    <table border="1" cellpadding="8" cellspacing="0" width="100%">
                        <thead>
                        <tr>
                            <th>User ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>RSVP Time</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (AttendeeView attendee : attendees) { %>
                            <tr>
                                <td><%= attendee.getUserId() %></td>
                                <td><%= attendee.getFullName() %></td>
                                <td><%= attendee.getEmail() %></td>
                                <td><%= attendee.getRsvpTime() %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                <% } %>
            </section>
        <% } %>
    <% } %>
</main>
</body>
</html>

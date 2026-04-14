<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.EventView" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%@ page import="edu.sjsu.cs157a.team1.util.CsrfUtil" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String csrfToken = CsrfUtil.getToken(session);

    List<EventView> events = (List<EventView>) request.getAttribute("events");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My RSVPs - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
</head>
<body>
<main style="max-width: 960px; margin: 24px auto; padding: 0 16px;">
    <h1>My Upcoming RSVPs</h1>

    <p>
        <a href="events">All Events</a> |
        <a href="dashboard.jsp">Home</a>
    </p>

    <% if (success != null && !success.isEmpty()) { %>
        <p style="color: #0f7b0f;"><strong><%= HtmlEscape.escape(success) %></strong></p>
    <% } %>

    <% if (error != null && !error.isEmpty()) { %>
        <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
    <% } %>

    <% if (events == null || events.isEmpty()) { %>
        <p>You have no upcoming RSVPs.</p>
    <% } else { %>
        <table border="1" cellpadding="8" cellspacing="0" width="100%">
            <thead>
            <tr>
                <th>Event</th>
                <th>Club</th>
                <th>Date</th>
                <th>Time</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (EventView event : events) { %>
                <tr>
                    <td>
                        <a href="event-details?eventId=<%= event.getEventId() %>"><%= HtmlEscape.escape(event.getTitle()) %></a>
                    </td>
                    <td><%= HtmlEscape.escape(event.getClubName()) %></td>
                    <td><%= event.getDate() %></td>
                    <td><%= event.getStartTime() %> - <%= event.getEndTime() %></td>
                    <td><%= HtmlEscape.escape(event.getLocation()) %></td>
                    <td><%= HtmlEscape.escape(event.getUserRsvpStatus()) %></td>
                    <td>
                        <form action="rsvp" method="post" style="margin: 0;">
                            <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                            <input type="hidden" name="returnTo" value="my-rsvps">
                            <button type="submit">Cancel RSVP</button>
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

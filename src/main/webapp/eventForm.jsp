<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.EventDAO.ClubView" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.EventDAO.ManagedEventView" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%@ page import="edu.sjsu.cs157a.team1.util.CsrfUtil" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String csrfToken = CsrfUtil.getToken(session);

    ManagedEventView event = (ManagedEventView) request.getAttribute("event");
    List<ClubView> clubs = (List<ClubView>) request.getAttribute("clubs");
    String error = (String) request.getAttribute("error");
    boolean isEdit = event != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Event" : "Create Event" %> - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
</head>
<body>
<main style="max-width: 760px; margin: 24px auto; padding: 0 16px;">
    <h1><%= isEdit ? "Edit Event" : "Create Event" %></h1>

    <p>
        <a href="officer-events">Back to Manage Events</a> |
        <a href="events">Browse Events</a>
    </p>

    <% if (error != null && !error.isEmpty()) { %>
    <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
    <% } %>

    <form action="officer-event" method="post" style="display: grid; gap: 12px;">
        <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
        <% if (isEdit) { %>
        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
        <p><strong>Club:</strong> <%= HtmlEscape.escape(event.getClubName()) %></p>
        <% } else { %>
        <label>
            Club *
            <select name="clubId" required>
                <option value="">Select a club</option>
                <% if (clubs != null) {
                    for (ClubView club : clubs) { %>
                <option value="<%= club.getClubId() %>"><%= HtmlEscape.escape(club.getClubName()) %></option>
                <%  }
                } %>
            </select>
        </label>
        <% } %>

        <label>
            Title *
            <input type="text" name="title" maxlength="200" required value="<%= isEdit ? HtmlEscape.escape(event.getTitle()) : "" %>">
        </label>

        <label>
            Description *
            <textarea name="description" rows="5" required><%= isEdit ? HtmlEscape.escape(event.getDescription()) : "" %></textarea>
        </label>

        <label>
            Date *
            <input type="date" name="date" required value="<%= isEdit ? event.getDate() : "" %>">
        </label>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
            <label>
                Start Time *
                <input type="time" name="startTime" required value="<%= isEdit && event.getStartTime() != null ? event.getStartTime().toString().substring(0, 5) : "" %>">
            </label>
            <label>
                End Time *
                <input type="time" name="endTime" required value="<%= isEdit && event.getEndTime() != null ? event.getEndTime().toString().substring(0, 5) : "" %>">
            </label>
        </div>

        <label>
            Location *
            <input type="text" name="location" maxlength="200" required value="<%= isEdit ? HtmlEscape.escape(event.getLocation()) : "" %>">
        </label>

        <label>
            Capacity (optional)
            <input type="number" name="capacity" min="1" value="<%= isEdit && event.getCapacity() != null ? event.getCapacity() : "" %>">
        </label>

        <label>
            Category (optional)
            <input type="text" name="category" maxlength="100" value="<%= isEdit && event.getCategory() != null ? HtmlEscape.escape(event.getCategory()) : "" %>">
        </label>

        <label>
            Image URL (optional)
            <input type="url" name="imageUrl" maxlength="255" value="<%= isEdit && event.getImageUrl() != null ? HtmlEscape.escape(event.getImageUrl()) : "" %>">
        </label>

        <button type="submit"><%= isEdit ? "Save Changes" : "Publish Event" %></button>
    </form>
</main>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.EventDAO.ManagedEventView" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%@ page import="edu.sjsu.cs157a.team1.util.CsrfUtil" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");
    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;
    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    request.setAttribute("activeNav", "createEvent");

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
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Manage Events</h1>
                <p class="dashboard-page-subtitle">
                    Create, edit, and remove events for the clubs you manage.
                </p>
            </section>

            <section class="dashboard-form-card clubs-shell-card">
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
                <p class="empty-hint">You do not have active events yet. Create one to publish it in the event feed.</p>
                <% } else { %>
                <ul class="club-list">
                    <% for (ManagedEventView event : events) { %>
                    <li class="club-list-item">
                        <h2><%= HtmlEscape.escape(event.getTitle()) %></h2>
                        <p class="club-meta">
                            <%= HtmlEscape.escape(event.getClubName()) %>
                            &middot; <%= event.getDate() %>
                            &middot; <%= event.getStartTime() %> - <%= event.getEndTime() %>
                            &middot; <%= HtmlEscape.escape(event.getLocation()) %>
                        </p>
                        <p class="club-meta">
                            Capacity: <%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %>
                        </p>
                        <p style="margin-top: 8px; margin-bottom: 0;">
                            <a href="<%= ctx %>/officer-event?eventId=<%= event.getEventId() %>">Edit</a>
                            |
                            <form action="<%= ctx %>/officer-events" method="post" style="display: inline; margin: 0;">
                                <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                <button type="submit" onclick="return confirm('Delete this event?');">Delete</button>
                            </form>
                        </p>
                    </li>
                    <% } %>
                </ul>
                <% } %>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

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
        response.sendRedirect(ctx + "/login");
        return;
    }

    request.setAttribute("activeNav", "officerEvents");

    String csrfToken = CsrfUtil.getToken(session);

    @SuppressWarnings("unchecked")
    List<ManagedEventView> events = (List<ManagedEventView>) request.getAttribute("events");

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    int eventCount = events == null ? 0 : events.size();
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
    <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header events-header">
    <h1 class="dashboard-page-title">Manage Events</h1>
    <p class="dashboard-page-subtitle">Create, edit, and manage events for the clubs you oversee.</p>
</section>

<section class="dashboard-form-card clubs-shell-card events-shell-card">
    <div class="events-top-actions">
        <a href="<%= ctx %>/officer-event" class="secondary-link">Create New Event</a>
        <a href="<%= ctx %>/events" class="secondary-link">Browse Events</a>
        <a href="<%= ctx %>/dashboard" class="secondary-link">Home</a>
    </div>

    <p class="club-meta events-results-count">
        <strong><%= eventCount %></strong> <%= eventCount == 1 ? "event" : "events" %> found
    </p>

    <% if (success != null && !success.isEmpty()) { %>
    <p class="message success-message-box"><%= HtmlEscape.escape(success) %></p>
    <% } %>

    <% if (error != null && !error.isEmpty()) { %>
    <p class="message error-message-box"><%= HtmlEscape.escape(error) %></p>
    <% } %>

    <% if (events == null || events.isEmpty()) { %>
    <p class="empty-hint">You do not have active events yet. Create one to publish it in the event feed.</p>
    <% } else { %>
    <ul class="event-feed">
        <% for (ManagedEventView event : events) { %>
        <li class="event-card">
            <h2 class="event-card-title">
                <a href="<%= ctx %>/event-details?eventId=<%= event.getEventId() %>">
                    <%= HtmlEscape.escape(event.getTitle()) %>
                </a>
            </h2>

            <p class="event-meta-row">
                <%= HtmlEscape.escape(event.getClubName()) %>
            </p>

            <p class="event-meta-row">
                <%= event.getDate() %>
                &middot;
                <%= event.getStartTime() %> - <%= event.getEndTime() %>
                &middot;
                <%= HtmlEscape.escape(event.getLocation()) %>
            </p>

            <div class="event-card-actions">
                    <span class="event-stat-pill">
                        Capacity: <%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %>
                    </span>
            </div>

            <div class="event-details-cta event-details-cta--in-card">
                <a href="<%= ctx %>/officer-event?eventId=<%= event.getEventId() %>" class="secondary-link">Edit Event</a>

                <form action="<%= ctx %>/officer-events" method="post" onsubmit="return confirm('Delete this event?');">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <button type="submit" class="secondary-btn">Delete Event</button>
                </form>
            </div>
        </li>
        <% } %>
    </ul>
    <% } %>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

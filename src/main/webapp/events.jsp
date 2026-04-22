<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.EventView" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
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

    request.setAttribute("activeNav", "");

    List<EventView> events = (List<EventView>) request.getAttribute("events");
    if (events == null) {
        response.sendRedirect(ctx + "/events");
        return;
    }
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String feedMode = (String) request.getAttribute("feedMode");
    if (feedMode == null || feedMode.isEmpty()) {
        feedMode = "all";
    }
    boolean personalizedFeed = "personalized".equalsIgnoreCase(feedMode);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Events - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Upcoming Events</h1>
                <p class="dashboard-page-subtitle">
                    Browse events across campus or jump into your RSVPs.
                </p>
            </section>

            <section class="dashboard-form-card clubs-shell-card">
                <div class="clubs-toolbar">
                    <div class="toolbar-actions">
                        <a href="<%= ctx %>/my-rsvps" class="secondary-link">My RSVPs</a>
						<a href="<%= ctx %>/events?feed=all" class="secondary-link<%= !personalizedFeed ? " active" : "" %>">Browse All Events</a>
                        <a href="<%= ctx %>/events?feed=personalized" class="secondary-link<%= personalizedFeed ? " active" : "" %>">Browse Personalized Events</a>
                        <% if (isClubOfficer) { %>
                            <a href="<%= ctx %>/officer-events" class="secondary-link">Manage My Club Events</a>
                        <% } %>
                    </div>
                </div>

                <% if (success != null && !success.isEmpty()) { %>
                    <p style="color: #0f7b0f;"><strong><%= HtmlEscape.escape(success) %></strong></p>
                <% } %>

                <% if (error != null && !error.isEmpty()) { %>
                    <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
                <% } %>

                <% if (events.isEmpty()) { %>
                    <% if (personalizedFeed) { %>
                        <p class="empty-hint">
                            No upcoming events from clubs you follow yet.
                            <a href="<%= ctx %>/clubs">Browse clubs</a> to follow organizations and personalize this feed.
                        </p>
                    <% } else { %>
                        <p class="empty-hint">No events available right now.</p>
                    <% } %>
                <% } else { %>
                    <ul class="club-list">
                        <% for (EventView event : events) { %>
                            <li class="club-list-item">
                                <h2><a href="<%= ctx %>/event-details?eventId=<%= event.getEventId() %>"><%= HtmlEscape.escape(event.getTitle()) %></a></h2>
                                <p class="club-meta">
                                    <%= HtmlEscape.escape(event.getClubName()) %>
                                    &middot;
                                    <%= event.getCategory() == null || event.getCategory().isEmpty()
                                            ? "Uncategorized"
                                            : HtmlEscape.escape(event.getCategory()) %>
                                </p>
                                <p class="club-meta">
                                    <%= event.getDate() %>
                                    &middot;
                                    <%= event.getStartTime() %> - <%= event.getEndTime() %>
                                    &middot;
                                    <%= HtmlEscape.escape(event.getLocation()) %>
                                </p>
                                <p class="club-meta">
                                    RSVP: <%= event.getUserRsvpStatus() == null ? "Not RSVPed" : HtmlEscape.escape(event.getUserRsvpStatus()) %>
                                    &middot;
                                    Attendance: <%= event.getGoingCount() %>/<%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %>
                                    <%= event.isFull() ? " (Full)" : "" %>
                                </p>
                            </li>
                        <% } %>
                    </ul>
                <% } %>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

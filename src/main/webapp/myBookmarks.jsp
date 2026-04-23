<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.EventView" %>
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

    request.setAttribute("activeNav", "myBookmarks");

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
    <title>Saved Events - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Saved Events</h1>
                <p class="dashboard-page-subtitle">
                    Review events you bookmarked for later.
                </p>
            </section>

            <div class="club-profile-actions club-profile-actions--shell event-details-top-nav">
                <div class="club-profile-actions-row">
                    <a href="<%= ctx %>/events" class="secondary-btn club-profile-follow-btn event-details-nav-link">All Events</a>
                    <a href="<%= ctx %>/my-bookmarks" class="secondary-btn club-profile-follow-btn event-details-nav-link" aria-current="page">Saved Events</a>
                    <a href="<%= ctx %>/dashboard.jsp" class="secondary-btn club-profile-follow-btn event-details-nav-link">Home</a>
                </div>
            </div>

            <section class="dashboard-form-card clubs-shell-card">
                <% if (success != null && !success.isEmpty()) { %>
                    <p style="color: #0f7b0f;"><strong><%= HtmlEscape.escape(success) %></strong></p>
                <% } %>

                <% if (error != null && !error.isEmpty()) { %>
                    <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
                <% } %>

                <% if (events == null || events.isEmpty()) { %>
                    <p class="empty-hint">
                        You have no saved events yet.
                        <a href="<%= ctx %>/events">Browse events</a> to bookmark events for later.
                    </p>
                <% } else { %>
                    <ul class="club-list">
                        <% for (EventView event : events) { %>
                        <li class="club-list-item">
                            <div class="club-list-item-body">
                                <h2><a href="<%= ctx %>/event-details?eventId=<%= event.getEventId() %>"><%= HtmlEscape.escape(event.getTitle()) %></a></h2>
                                <p class="club-meta">
                                    <%= HtmlEscape.escape(event.getClubName()) %>
                                    &middot; <%= event.getDate() %>
                                    &middot; <%= event.getStartTime() %> - <%= event.getEndTime() %>
                                    &middot; <%= HtmlEscape.escape(event.getLocation()) %>
                                </p>
                                <p class="club-meta">
                                    RSVP: <%= event.getUserRsvpStatus() == null ? "Not RSVPed" : HtmlEscape.escape(event.getUserRsvpStatus()) %>
                                    &middot;
                                    Attendance: <%= event.getGoingCount() %>/<%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %>
                                    <%= event.isFull() ? " (Full)" : "" %>
                                </p>
                            </div>
                            <div class="event-details-cta event-details-cta--in-card">
                                <form action="<%= ctx %>/bookmark" method="post">
                                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                    <input type="hidden" name="returnTo" value="my-bookmarks">
                                    <button type="submit" class="secondary-btn event-details-action-btn">Remove Bookmark</button>
                                </form>
                            </div>
                        </li>
                        <% } %>
                    </ul>
                <% } %>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

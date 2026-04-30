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
        response.sendRedirect(ctx + "/login");
        return;
    }

    request.setAttribute("activeNav", "myRsvps");

    String csrfToken = CsrfUtil.getToken(session);

    @SuppressWarnings("unchecked")
    List<EventView> events = (List<EventView>) request.getAttribute("events");

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    Integer currentPageAttr = (Integer) request.getAttribute("currentPage");
    Integer totalPagesAttr = (Integer) request.getAttribute("totalPages");
    Integer totalEventsAttr = (Integer) request.getAttribute("totalEvents");
    int currentPage = currentPageAttr != null ? currentPageAttr : 1;
    int totalPages = totalPagesAttr != null ? totalPagesAttr : 0;
    int eventCount = totalEventsAttr != null ? totalEventsAttr : (events == null ? 0 : events.size());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My RSVPs - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
    <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header events-header">
    <h1 class="dashboard-page-title">My RSVPs</h1>
    <p class="dashboard-page-subtitle">Review your upcoming events and manage your RSVP status.</p>
</section>

<section class="dashboard-form-card clubs-shell-card events-shell-card">
    <div class="events-top-actions">
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
    <p class="empty-hint">You have no upcoming RSVPs.</p>
    <% } else { %>
    <ul class="event-feed">
        <% for (EventView event : events) { %>
        <li class="event-card">
            <h2 class="event-card-title">
                <a href="<%= ctx %>/event-details?eventId=<%= event.getEventId() %>">
                    <%= HtmlEscape.escape(event.getTitle()) %>
                </a>
            </h2>

            <p class="event-meta-row">
                <a href="<%= ctx %>/club?id=<%= event.getClubId() %>"><%= HtmlEscape.escape(event.getClubName()) %></a>
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
                        RSVP: <%= HtmlEscape.escape(event.getUserRsvpStatus()) %>
                    </span>
                <span class="event-stat-pill">
                        Attendance: <%= event.getGoingCount() %>/<%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %><%= event.isFull() ? " (Full)" : "" %>
                    </span>
            </div>

            <div class="event-details-cta event-details-cta--in-card">
                <form action="<%= ctx %>/rsvp" method="post" onsubmit="return confirm('Are you sure you want to cancel your RSVP?');">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="my-rsvps">
                    <button type="submit" class="secondary-btn event-details-action-btn">
                        <%= "Waitlisted".equals(event.getUserRsvpStatus()) ? "Leave Waitlist" : "Cancel RSVP" %>
                    </button>
                </form>
            </div>
        </li>
        <% } %>
    </ul>
    <% if (totalPages > 1) { %>
    <nav class="clubs-pagination" aria-label="My RSVPs pagination">
        <a class="pagination-btn <%= currentPage == 1 ? "disabled" : "" %>"
           href="<%= currentPage == 1 ? "#" : (ctx + "/my-rsvps?page=" + (currentPage - 1)) %>"
           aria-disabled="<%= currentPage == 1 %>">&lsaquo;</a>
        <% for (int pageNum = 1; pageNum <= totalPages; pageNum++) { %>
        <a class="pagination-btn <%= pageNum == currentPage ? "active" : "" %>"
           href="<%= ctx + "/my-rsvps?page=" + pageNum %>"
           <%= pageNum == currentPage ? "aria-current=\"page\"" : "" %>><%= pageNum %></a>
        <% } %>
        <a class="pagination-btn <%= currentPage == totalPages ? "disabled" : "" %>"
           href="<%= currentPage == totalPages ? "#" : (ctx + "/my-rsvps?page=" + (currentPage + 1)) %>"
           aria-disabled="<%= currentPage == totalPages %>">&rsaquo;</a>
    </nav>
    <% } %>
    <% } %>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

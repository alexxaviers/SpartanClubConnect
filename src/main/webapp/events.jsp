<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
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

    request.setAttribute("activeNav", "browseEvents");

    @SuppressWarnings("unchecked")
    List<EventView> events = (List<EventView>) request.getAttribute("events");

    @SuppressWarnings("unchecked")
    Set<Integer> bookmarkedEventIds = (Set<Integer>) request.getAttribute("bookmarkedEventIds");

    if (events == null) {
        response.sendRedirect(ctx + "/events");
        return;
    }
    if (bookmarkedEventIds == null) {
        bookmarkedEventIds = java.util.Collections.emptySet();
    }

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String csrfToken = CsrfUtil.getToken(session);

    String feedMode = (String) request.getAttribute("feedMode");
    if (feedMode == null || feedMode.isEmpty()) {
        feedMode = "all";
    }

    String selectedClubName = (String) request.getAttribute("selectedClubName");
    Integer selectedClubId = (Integer) request.getAttribute("selectedClubId");
    Integer currentPageAttr = (Integer) request.getAttribute("currentPage");
    Integer totalPagesAttr = (Integer) request.getAttribute("totalPages");
    Integer totalEventsAttr = (Integer) request.getAttribute("totalEvents");

    boolean filteredByClub = selectedClubName != null && !selectedClubName.isEmpty();
    boolean personalizedFeed = "personalized".equalsIgnoreCase(feedMode) && !filteredByClub;
    int currentPage = currentPageAttr != null ? currentPageAttr : 1;
    int totalPages = totalPagesAttr != null ? totalPagesAttr : 0;
    int eventCount = totalEventsAttr != null ? totalEventsAttr : events.size();
    String feedParamValue = URLEncoder.encode(feedMode, StandardCharsets.UTF_8.toString());
    String clubIdQuery = selectedClubId != null ? "&clubId=" + selectedClubId : "";
    String paginationBase = ctx + "/events?feed=" + feedParamValue + clubIdQuery;
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
    <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header events-header">
    <h1 class="dashboard-page-title">
        <%= filteredByClub ? "Club Events" : (personalizedFeed ? "Personalized Events" : "Events") %>
    </h1>
    <% if (!filteredByClub) { %>
    <p class="dashboard-page-subtitle">
        <%= personalizedFeed ? "Upcoming events from clubs you follow." : "Browse upcoming events across campus." %>
    </p>
    <% } %>
</section>

<section class="dashboard-form-card clubs-shell-card events-shell-card">
    <div class="events-top-actions">
        <% if (filteredByClub && selectedClubId != null) { %>
        <a href="<%= ctx %>/club?id=<%= selectedClubId %>" class="secondary-link">Back to Club</a>
        <a href="<%= ctx %>/events" class="secondary-link">Browse All Events</a>
        <% } else { %>
        <a href="<%= ctx %>/my-rsvps" class="secondary-link">My RSVPs</a>
        <a href="<%= ctx %>/events?feed=all" class="secondary-link<%= !personalizedFeed ? " active" : "" %>">Browse All Events</a>
        <a href="<%= ctx %>/events?feed=personalized" class="secondary-link<%= personalizedFeed ? " active" : "" %>">Browse Personalized Events</a>
        <% if (isClubOfficer) { %>
        <a href="<%= ctx %>/officer-events" class="secondary-link">Manage My Club Events</a>
        <% } %>
        <% } %>
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

    <% if (events.isEmpty()) { %>
    <% if (filteredByClub) { %>
    <p class="empty-hint">This club has no upcoming events right now.</p>
    <% } else if (personalizedFeed) { %>
    <p class="empty-hint">
        No upcoming events from clubs you follow yet.
        <a href="<%= ctx %>/clubs">Browse clubs</a> to follow organizations and personalize this feed.
    </p>
    <% } else { %>
    <p class="empty-hint">No events available right now.</p>
    <% } %>
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
                        RSVP: <%= event.getUserRsvpStatus() == null ? "Not RSVPed" : HtmlEscape.escape(event.getUserRsvpStatus()) %>
                    </span>
                <span class="event-stat-pill">
                        Attendance: <%= event.getGoingCount() %>/<%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %><%= event.isFull() ? " (Full)" : "" %>
                    </span>
            </div>

            <div class="event-details-cta event-details-cta--in-card">
                <form action="<%= ctx %>/bookmark" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="events">
                    <input type="hidden" name="returnFeed" value="<%= personalizedFeed ? "personalized" : "all" %>">
                    <% if (bookmarkedEventIds.contains(event.getEventId())) { %>
                    <input type="hidden" name="action" value="remove">
                    <button type="submit" class="secondary-btn event-details-action-btn">Remove Bookmark</button>
                    <% } else { %>
                    <input type="hidden" name="action" value="save">
                    <button type="submit" class="primary-btn event-details-action-btn">Save Event</button>
                    <% } %>
                </form>
            </div>
        </li>
        <% } %>
    </ul>
    <% if (totalPages > 1) { %>
    <nav class="clubs-pagination" aria-label="Events pagination">
        <a class="pagination-btn <%= currentPage == 1 ? "disabled" : "" %>"
           href="<%= currentPage == 1 ? "#" : paginationBase + "&page=" + (currentPage - 1) %>"
           aria-disabled="<%= currentPage == 1 %>">&lsaquo;</a>
        <% for (int pageNum = 1; pageNum <= totalPages; pageNum++) { %>
        <a class="pagination-btn <%= pageNum == currentPage ? "active" : "" %>"
           href="<%= paginationBase + "&page=" + pageNum %>"
           <%= pageNum == currentPage ? "aria-current=\"page\"" : "" %>><%= pageNum %></a>
        <% } %>
        <a class="pagination-btn <%= currentPage == totalPages ? "disabled" : "" %>"
           href="<%= currentPage == totalPages ? "#" : paginationBase + "&page=" + (currentPage + 1) %>"
           aria-disabled="<%= currentPage == totalPages %>">&rsaquo;</a>
    </nav>
    <% } %>
    <% } %>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

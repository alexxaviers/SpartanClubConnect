<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.EventView" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.RsvpDAO.AttendeeView" %>
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

    String csrfToken = CsrfUtil.getToken(session);
    EventView event = (EventView) request.getAttribute("event");
    Boolean canViewAttendees = (Boolean) request.getAttribute("canViewAttendees");
    Boolean isBookmarked = (Boolean) request.getAttribute("isBookmarked");
    String activeTab = (String) request.getAttribute("activeTab");
    if (activeTab == null || activeTab.isEmpty()) {
        activeTab = "details";
    }

    @SuppressWarnings("unchecked")
    List<AttendeeView> attendees = (List<AttendeeView>) request.getAttribute("attendees");

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= event != null ? HtmlEscape.escape(event.getTitle()) + " - SpartanClubConnect" : "Event Details - SpartanClubConnect" %></title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
    <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

    <% if (event == null) { %>
<section class="dashboard-page-header">
    <h1 class="dashboard-page-title">Event Details</h1>
</section>

<section class="dashboard-form-card events-shell-card">
    <div class="event-detail-topbar">
        <a href="<%= ctx %>/events" class="secondary-link">Back to Events</a>
    </div>
    <p class="empty-hint">Event not found.</p>
</section>
    <% } else { %>

<section class="dashboard-page-header club-profile-dashboard-header">
    <h1 class="dashboard-page-title"><%= HtmlEscape.escape(event.getTitle()) %></h1>
    <p class="dashboard-page-subtitle club-profile-dashboard-meta">
        Hosted by
        <a href="<%= ctx %>/club?id=<%= event.getClubId() %>"><%= HtmlEscape.escape(event.getClubName()) %></a>
    </p>
</section>

<div class="club-profile-actions club-profile-actions--shell event-details-top-nav">
    <div class="club-profile-actions-row">
        <a href="<%= ctx %>/events" class="secondary-link">Back to Events</a>
        <a href="<%= ctx %>/my-rsvps" class="secondary-link">My RSVPs</a>

        <% if (Boolean.TRUE.equals(canViewAttendees)) { %>
        <a href="<%= ctx %>/event-details?eventId=<%= event.getEventId() %>&tab=details"
           class="secondary-link<%= "details".equals(activeTab) ? " active" : "" %>">Details</a>
        <a href="<%= ctx %>/event-details?eventId=<%= event.getEventId() %>&tab=attendees"
           class="secondary-link<%= "attendees".equals(activeTab) ? " active" : "" %>">Attendees</a>
        <% } %>
    </div>
</div>

    <% if (error != null && !error.isEmpty()) { %>
<section class="dashboard-form-card events-shell-card">
    <p class="message error-message-box"><%= HtmlEscape.escape(error) %></p>
</section>
    <% } %>

    <% if (success != null && !success.isEmpty()) { %>
<section class="dashboard-form-card events-shell-card">
    <p class="message success-message-box"><%= HtmlEscape.escape(success) %></p>
</section>
    <% } %>

    <% if (!"attendees".equals(activeTab)) { %>
<section class="dashboard-form-card events-shell-card">
    <div class="event-info-grid">
        <div class="event-info-card">
            <h2>About</h2>
            <% if (event.getDescription() != null && !event.getDescription().isEmpty()) { %>
            <p class="event-info-text"><%= HtmlEscape.escape(event.getDescription()) %></p>
            <% } else { %>
            <p class="event-info-text event-info-text--muted">No description provided.</p>
            <% } %>
        </div>

        <div class="event-info-card">
            <h2>When &amp; Where</h2>
            <p class="event-info-text">
                <strong>Date:</strong> <%= event.getDate() %><br>
                <strong>Time:</strong> <%= event.getStartTime() %> - <%= event.getEndTime() %><br>
                <strong>Location:</strong> <%= HtmlEscape.escape(event.getLocation()) %>
            </p>
        </div>

        <div class="event-info-card">
            <h2>Status</h2>
            <div class="event-stats-row">
                        <span class="event-stat-pill">
                            RSVP: <%= event.getUserRsvpStatus() == null ? "Not RSVPed" : HtmlEscape.escape(event.getUserRsvpStatus()) %>
                        </span>
                <span class="event-stat-pill">
                            Attendance: <%= event.getGoingCount() %>/<%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %><%= event.isFull() ? " (Full)" : "" %>
                        </span>
            </div>
        </div>

        <% if (event.getCategory() != null && !event.getCategory().isEmpty()) { %>
        <div class="event-info-card">
            <h2>Category</h2>
            <p class="event-info-text"><%= HtmlEscape.escape(event.getCategory()) %></p>
        </div>
        <% } %>

        <% if (event.getImageUrl() != null && !event.getImageUrl().isEmpty()) {
            String safeImageUrl = event.getImageUrl();
            if (safeImageUrl.startsWith("http://") || safeImageUrl.startsWith("https://")) { %>
        <div class="event-info-card">
            <h2>Event Image</h2>
            <img src="<%= HtmlEscape.escape(safeImageUrl) %>" alt="Event image" class="event-inline-image">
        </div>
        <%  }
        } %>

        <div class="event-info-card">
            <h2>Actions</h2>
            <div class="event-action-row event-action-row-centered">
                <% if ("Going".equals(event.getUserRsvpStatus()) || "Waitlisted".equals(event.getUserRsvpStatus())) { %>
                <form action="<%= ctx %>/rsvp" method="post" onsubmit="return confirm('Are you sure you want to cancel your RSVP?');">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <button type="submit" class="secondary-btn">
                        <%= "Waitlisted".equals(event.getUserRsvpStatus()) ? "Leave Waitlist" : "Cancel RSVP" %>
                    </button>
                </form>
                <% } else { %>
                <form action="<%= ctx %>/rsvp" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="register">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <button type="submit" class="primary-btn">
                        <%= event.isFull() ? "Join Waitlist" : "RSVP / Register" %>
                    </button>
                </form>
                <% } %>

                <form action="<%= ctx %>/bookmark" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <% if (Boolean.TRUE.equals(isBookmarked)) { %>
                    <input type="hidden" name="action" value="remove">
                    <button type="submit" class="secondary-btn">Remove Bookmark</button>
                    <% } else { %>
                    <input type="hidden" name="action" value="save">
                    <button type="submit" class="primary-btn">Save Event</button>
                    <% } %>
                </form>

                <% if (Boolean.TRUE.equals(canViewAttendees)) { %>
                <a href="<%= ctx %>/officer-event?eventId=<%= event.getEventId() %>" class="secondary-link">Edit Event</a>

                <form action="<%= ctx %>/officer-events" method="post" onsubmit="return confirm('Delete this event?');">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <button type="submit" class="secondary-btn">Delete Event</button>
                </form>
                <% } %>
            </div>
        </div>
    </div>
</section>
    <% } %>

    <% if (Boolean.TRUE.equals(canViewAttendees) && "attendees".equals(activeTab)) { %>
<section class="dashboard-form-card events-shell-card">
    <h2 class="club-profile-block-heading">Attendee List</h2>

    <% if (attendees == null || attendees.isEmpty()) { %>
    <p class="empty-hint">No attendees yet.</p>
    <% } else { %>
    <div class="event-details-attendees-table-wrap">
        <table class="event-details-attendees-table">
            <thead>
            <tr>
                <th>User ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Status</th>
                <th>RSVP Time</th>
            </tr>
            </thead>
            <tbody>
            <% for (AttendeeView attendee : attendees) { %>
            <tr>
                <td><%= attendee.getUserId() %></td>
                <td><%= HtmlEscape.escape(attendee.getFullName()) %></td>
                <td><%= HtmlEscape.escape(attendee.getEmail()) %></td>
                <td><%= HtmlEscape.escape(attendee.getStatus()) %></td>
                <td><%= attendee.getRsvpTime() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</section>
    <% } %>

    <% } %>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

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
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    request.setAttribute("activeNav", "");

    String csrfToken = CsrfUtil.getToken(session);
    EventView event = (EventView) request.getAttribute("event");
    Boolean canViewAttendees = (Boolean) request.getAttribute("canViewAttendees");
    Boolean isBookmarked = (Boolean) request.getAttribute("isBookmarked");
    List<AttendeeView> attendees = (List<AttendeeView>) request.getAttribute("attendees");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><% if (event != null) { %><%= HtmlEscape.escape(event.getTitle()) %> - SpartanClubConnect<% } else { %>Event Details - SpartanClubConnect<% } %></title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <% if (event != null) { %>
            <section class="dashboard-page-header club-profile-dashboard-header">
                <h1 class="dashboard-page-title"><%= HtmlEscape.escape(event.getTitle()) %></h1>
                <p class="dashboard-page-subtitle club-profile-dashboard-meta">
                    <a href="<%= ctx %>/club?id=<%= event.getClubId() %>"><%= HtmlEscape.escape(event.getClubName()) %></a>
                </p>
            </section>
            <% } else { %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Event Details</h1>
                <p class="dashboard-page-subtitle">
                    Review event information, RSVP, and manage the event if you are an officer.
                </p>
            </section>
            <% } %>
			            <div class="club-profile-actions club-profile-actions--shell event-details-top-nav">
                <div class="club-profile-actions-row">
                    <a href="<%= ctx %>/events" class="secondary-btn club-profile-follow-btn event-details-nav-link">Back to Events</a>
                    <a href="<%= ctx %>/my-rsvps" class="secondary-btn club-profile-follow-btn event-details-nav-link">My RSVPs</a>
                    <a href="<%= ctx %>/dashboard.jsp" class="secondary-btn club-profile-follow-btn event-details-nav-link">Home</a>
                </div>
            </div>
            
            <section class="dashboard-form-card clubs-shell-card">


                <% if (error != null && !error.isEmpty()) { %>
                    <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
                <% } %>

                <% if (success != null && !success.isEmpty()) { %>
                    <p style="color: #0f7b0f;"><strong><%= HtmlEscape.escape(success) %></strong></p>
                <% } %>

                <% if (event == null) { %>
                    <p class="empty-hint">Event not found.</p>
                <% } else { %>
                                        <ul class="club-list club-profile-details">
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Description</h2>
                            <% if (event.getDescription() != null && !event.getDescription().isEmpty()) { %>
                            <p class="club-profile-block-text"><%= HtmlEscape.escape(event.getDescription()) %></p>
                            <% } else { %>
                            <p class="club-profile-block-text club-profile-block-text--muted">No description provided.</p>
                            <% } %>
                        </li>
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Date</h2>
                            <p class="club-profile-block-text"><%= event.getDate() %></p>
                        </li>
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Time</h2>
                            <p class="club-profile-block-text"><%= event.getStartTime() %> – <%= event.getEndTime() %></p>
                        </li>
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Location</h2>
                            <p class="club-profile-block-text"><%= HtmlEscape.escape(event.getLocation()) %></p>
                        </li>
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Category</h2>
                            <% if (event.getCategory() != null && !event.getCategory().isEmpty()) { %>
                            <p class="club-profile-block-text"><%= HtmlEscape.escape(event.getCategory()) %></p>
                            <% } else { %>
                            <p class="club-profile-block-text club-profile-block-text--muted">—</p>
                            <% } %>
                        </li>
                        <% if (event.getImageUrl() != null && !event.getImageUrl().isEmpty()) {
                            String safeImageUrl = event.getImageUrl();
                            if (safeImageUrl.startsWith("http://") || safeImageUrl.startsWith("https://")) { %>
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Event image</h2>
                            <p class="club-profile-block-text">
                                <img src="<%= HtmlEscape.escape(safeImageUrl) %>" alt="Event image" class="event-details-image">
                            </p>
                        </li>
                        <%  }
                        } %>
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Capacity</h2>
                            <p class="club-profile-block-text event-details-capacity"><%= event.getGoingCount() %> / <%= event.getCapacity() == null ? "No limit" : event.getCapacity() %><%= event.isFull() ? " (full)" : "" %></p>
                            
                        </li>
                        <li class="club-list-item">
                            <h2 class="club-profile-block-heading">Your RSVP status</h2>
                            <p class="club-profile-block-text"><%= event.getUserRsvpStatus() == null ? "Not RSVPed" : HtmlEscape.escape(event.getUserRsvpStatus()) %></p>
                        </li>
                    </ul>
                <% } %>
            </section>

            <% if (event != null) { %>
            <div class="event-details-cta">
                <% if ("Going".equals(event.getUserRsvpStatus()) || "Waitlisted".equals(event.getUserRsvpStatus())) { %>
                <form action="<%= ctx %>/rsvp" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <button type="submit" class="secondary-btn event-details-action-btn"><%= "Waitlisted".equals(event.getUserRsvpStatus()) ? "Leave Waitlist" : "Cancel RSVP" %></button>
                </form>
                <% } else { %>
                <form action="<%= ctx %>/rsvp" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="register">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <button type="submit" class="primary-btn event-details-action-btn"><%= event.isFull() ? "Join Waitlist" : "RSVP / Register" %></button>
                </form>
                <% } %>
                <form action="<%= ctx %>/bookmark" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <input type="hidden" name="returnTo" value="event-details">
                    <% if (Boolean.TRUE.equals(isBookmarked)) { %>
                        <input type="hidden" name="action" value="remove">
                        <button type="submit" class="secondary-btn event-details-action-btn">Remove Bookmark</button>
                    <% } else { %>
                        <input type="hidden" name="action" value="save">
                        <button type="submit" class="primary-btn event-details-action-btn">Save Event</button>
                    <% } %>
                </form>
                <% if (Boolean.TRUE.equals(canViewAttendees)) { %>
                <a href="<%= ctx %>/officer-event?eventId=<%= event.getEventId() %>" class="club-profile-edit-btn event-details-edit-link">Edit event</a>
                <form action="<%= ctx %>/officer-events" method="post">
                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                    <button type="submit" class="secondary-btn event-details-action-btn" onclick="return confirm('Delete this event?');">Delete event</button>
                </form>
                <% } %>
            </div>
            <% } %>

            <% if (Boolean.TRUE.equals(canViewAttendees)) { %>
                <section class="dashboard-form-card">
                    <h3>Attendee List</h3>
                    <% if (attendees == null || attendees.isEmpty()) { %>
                        <p class="empty-hint">No attendees yet.</p>
                    <% } else { %>
                        <table border="1" cellpadding="8" cellspacing="0" width="100%">
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
                    <% } %>
                </section>
            <% } %>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

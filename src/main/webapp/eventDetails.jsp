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
    List<AttendeeView> attendees = (List<AttendeeView>) request.getAttribute("attendees");
    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Details - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Event Details</h1>
                <p class="dashboard-page-subtitle">
                    Review event information, RSVP, and manage the event if you are an officer.
                </p>
            </section>

            <section class="dashboard-form-card">
                <p>
                    <a href="<%= ctx %>/events">Back to Events</a> |
                    <a href="<%= ctx %>/my-rsvps">My RSVPs</a> |
                    <a href="<%= ctx %>/dashboard.jsp">Home</a>
                </p>

                <% if (error != null && !error.isEmpty()) { %>
                    <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
                <% } %>

                <% if (success != null && !success.isEmpty()) { %>
                    <p style="color: #0f7b0f;"><strong><%= HtmlEscape.escape(success) %></strong></p>
                <% } %>

                <% if (event == null) { %>
                    <p class="empty-hint">Event not found.</p>
                <% } else { %>
                    <div class="event-details-grid" style="display: grid; gap: 20px;">
                        <div>
                            <h2><%= HtmlEscape.escape(event.getTitle()) %></h2>
                            <p><strong>Club:</strong> <%= HtmlEscape.escape(event.getClubName()) %></p>
                            <p><strong>Description:</strong> <%= HtmlEscape.escape(event.getDescription()) %></p>
                            <p><strong>Date:</strong> <%= event.getDate() %></p>
                            <p><strong>Time:</strong> <%= event.getStartTime() %> - <%= event.getEndTime() %></p>
                            <p><strong>Location:</strong> <%= HtmlEscape.escape(event.getLocation()) %></p>
                            <p><strong>Category:</strong> <%= event.getCategory() == null ? "-" : HtmlEscape.escape(event.getCategory()) %></p>
                            <% if (event.getImageUrl() != null && !event.getImageUrl().isEmpty()) {
                                String safeImageUrl = event.getImageUrl();
                                if (safeImageUrl.startsWith("http://") || safeImageUrl.startsWith("https://")) { %>
                                    <p>
                                        <img src="<%= HtmlEscape.escape(safeImageUrl) %>" alt="Event image" style="max-width: 100%; max-height: 320px; border-radius: 8px;">
                                    </p>
                            <%  }
                            } %>
                            <p>
                                <strong>Capacity:</strong>
                                <%= event.getGoingCount() %>
                                /
                                <%= event.getCapacity() == null ? "No Limit" : event.getCapacity() %>
                                <%= event.isFull() ? " (Full)" : "" %>
                            </p>
                            <p><strong>Your RSVP Status:</strong> <%= event.getUserRsvpStatus() == null ? "Not RSVPed" : HtmlEscape.escape(event.getUserRsvpStatus()) %></p>
                        </div>

                        <div style="display: flex; gap: 12px; flex-wrap: wrap; align-items: center;">
                            <% if ("Going".equals(event.getUserRsvpStatus()) || "Waitlisted".equals(event.getUserRsvpStatus())) { %>
                                <form action="<%= ctx %>/rsvp" method="post" style="margin: 0;">
                                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                    <input type="hidden" name="returnTo" value="event-details">
                                    <button type="submit"><%= "Waitlisted".equals(event.getUserRsvpStatus()) ? "Leave Waitlist" : "Cancel RSVP" %></button>
                                </form>
                            <% } else { %>
                                <form action="<%= ctx %>/rsvp" method="post" style="margin: 0;">
                                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                                    <input type="hidden" name="action" value="register">
                                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                    <input type="hidden" name="returnTo" value="event-details">
                                    <button type="submit"><%= event.isFull() ? "Join Waitlist" : "RSVP / Register" %></button>
                                </form>
                            <% } %>

                            <% if (Boolean.TRUE.equals(canViewAttendees)) { %>
                                <a href="<%= ctx %>/officer-event?eventId=<%= event.getEventId() %>">Edit Event</a>
                                <form action="<%= ctx %>/officer-events" method="post" style="display: inline; margin: 0;">
                                    <input type="hidden" name="csrfToken" value="<%= HtmlEscape.escape(csrfToken) %>">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                    <button type="submit" onclick="return confirm('Delete this event?');">Delete Event</button>
                                </form>
                            <% } %>
                        </div>
                    </div>
                <% } %>
            </section>

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

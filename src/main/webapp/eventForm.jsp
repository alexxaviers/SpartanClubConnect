<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.dao.EventDAO.ClubView" %>
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

    ManagedEventView event = (ManagedEventView) request.getAttribute("event");
    List<ClubView> clubs = (List<ClubView>) request.getAttribute("clubs");
    String error = (String) request.getAttribute("error");
    boolean isEdit = event != null;

    boolean hasTitleParam = request.getParameterMap().containsKey("title");
    boolean hasDescriptionParam = request.getParameterMap().containsKey("description");
    boolean hasDateParam = request.getParameterMap().containsKey("date");
    boolean hasStartTimeParam = request.getParameterMap().containsKey("startTime");
    boolean hasEndTimeParam = request.getParameterMap().containsKey("endTime");
    boolean hasLocationParam = request.getParameterMap().containsKey("location");
    boolean hasCapacityParam = request.getParameterMap().containsKey("capacity");
    boolean hasCategoryParam = request.getParameterMap().containsKey("category");
    boolean hasImageUrlParam = request.getParameterMap().containsKey("imageUrl");
    boolean hasClubIdParam = request.getParameterMap().containsKey("clubId");

    String titleValue = hasTitleParam ? request.getParameter("title") : (isEdit && event.getTitle() != null ? event.getTitle() : "");
    String descriptionValue = hasDescriptionParam ? request.getParameter("description") : (isEdit && event.getDescription() != null ? event.getDescription() : "");
    String dateValue = hasDateParam ? request.getParameter("date") : (isEdit && event.getDate() != null ? event.getDate().toString() : "");
    String startTimeValue = hasStartTimeParam ? request.getParameter("startTime") : (isEdit && event.getStartTime() != null ? event.getStartTime().toString().substring(0, 5) : "");
    String endTimeValue = hasEndTimeParam ? request.getParameter("endTime") : (isEdit && event.getEndTime() != null ? event.getEndTime().toString().substring(0, 5) : "");
    String locationValue = hasLocationParam ? request.getParameter("location") : (isEdit && event.getLocation() != null ? event.getLocation() : "");
    String capacityValue = hasCapacityParam ? request.getParameter("capacity") : (isEdit && event.getCapacity() != null ? event.getCapacity().toString() : "");
    String categoryValue = hasCategoryParam ? request.getParameter("category") : (isEdit && event.getCategory() != null ? event.getCategory() : "");
    String imageUrlValue = hasImageUrlParam ? request.getParameter("imageUrl") : (isEdit && event.getImageUrl() != null ? event.getImageUrl() : "");
    String clubIdValue = hasClubIdParam ? request.getParameter("clubId") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Edit Event" : "Create Event" %> - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title"><%= isEdit ? "Edit Event" : "Create Event" %></h1>
                <p class="dashboard-page-subtitle">
                    Publish an event for one of the clubs you manage.
                </p>
            </section>

            <section class="dashboard-form-card">
                <p>
                    <a href="<%= ctx %>/officer-events">Back to Manage Events</a> |
                    <a href="<%= ctx %>/events">Browse Events</a>
                </p>

                <% if (error != null && !error.isEmpty()) { %>
                <p style="color: #b00020;"><strong><%= HtmlEscape.escape(error) %></strong></p>
                <% } %>

                <form action="<%= ctx %>/officer-event" method="post" style="display: grid; gap: 12px;">
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
                            <option value="<%= club.getClubId() %>" <%= Integer.toString(club.getClubId()).equals(clubIdValue) ? "selected" : "" %>><%= HtmlEscape.escape(club.getClubName()) %></option>
                            <%  }
                            } %>
                        </select>
                    </label>
                    <% } %>

                    <label>
                        Title *
                        <input type="text" name="title" maxlength="200" required value="<%= HtmlEscape.escape(titleValue) %>">
                    </label>

                    <label>
                        Description *
                        <textarea name="description" rows="5" required><%= HtmlEscape.escape(descriptionValue) %></textarea>
                    </label>

                    <label>
                        Date *
                        <input type="date" name="date" required value="<%= HtmlEscape.escape(dateValue) %>">
                    </label>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                        <label>
                            Start Time *
                            <input type="time" name="startTime" required value="<%= HtmlEscape.escape(startTimeValue) %>">
                        </label>
                        <label>
                            End Time *
                            <input type="time" name="endTime" required value="<%= HtmlEscape.escape(endTimeValue) %>">
                        </label>
                    </div>

                    <label>
                        Location *
                        <input type="text" name="location" maxlength="200" required value="<%= HtmlEscape.escape(locationValue) %>">
                    </label>

                    <label>
                        Capacity (optional)
                        <input type="number" name="capacity" min="1" value="<%= HtmlEscape.escape(capacityValue) %>">
                    </label>

                    <label>
                        Category (optional)
                        <input type="text" name="category" maxlength="100" value="<%= HtmlEscape.escape(categoryValue) %>">
                    </label>

                    <label>
                        Image URL (optional)
                        <input type="url" name="imageUrl" maxlength="255" value="<%= HtmlEscape.escape(imageUrlValue) %>">
                    </label>

                    <button type="submit"><%= isEdit ? "Save Changes" : "Publish Event" %></button>
                </form>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

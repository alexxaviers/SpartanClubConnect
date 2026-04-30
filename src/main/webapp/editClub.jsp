<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="edu.sjsu.cs157a.team1.model.Club" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    Club club = (Club) request.getAttribute("club");
    if (club == null) {
        response.sendRedirect(ctx + "/clubs");
        return;
    }

    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");
    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;

    request.setAttribute("activeNav", "");

    String errorMessage = (String) request.getAttribute("errorMessage");

    String nameVal = club.getName() != null ? club.getName() : "";
    String descVal = club.getDescription() != null ? club.getDescription() : "";
    String catVal = club.getCategory() != null ? club.getCategory() : "";
    String emailVal = club.getContactEmail() != null ? club.getContactEmail() : "";
    String meetVal = club.getMeetingInfo() != null ? club.getMeetingInfo() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit <%= HtmlEscape.escape(nameVal) %> - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
    <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<div class="event-detail-topbar">
    <a href="<%= ctx %>/club?id=<%= club.getClubId() %>" class="secondary-link">← Back to Club</a>
    <a href="<%= ctx %>/events?clubId=<%= club.getClubId() %>" class="secondary-link">View Events</a>
</div>

<section class="dashboard-page-header events-header">
    <h1 class="dashboard-page-title">Edit Club</h1>
    <p class="dashboard-page-subtitle">Update the club profile, category, contact info, and meeting details.</p>
</section>

<section class="dashboard-form-card clubs-shell-card clubs-form-card event-form-shell">
    <% if (errorMessage != null) { %>
    <p class="message error-message-box"><%= HtmlEscape.escape(errorMessage) %></p>
    <% } %>

    <form class="club-form event-form" action="<%= ctx %>/editClub" method="post">
        <input type="hidden" name="clubId" value="<%= club.getClubId() %>">

        <div class="form-group">
            <label for="name">Club Name</label>
            <input type="text" id="name" name="name" required maxlength="100"
                   value="<%= HtmlEscape.escape(nameVal) %>">
        </div>

        <div class="form-group">
            <label for="description">About</label>
            <textarea id="description" name="description" maxlength="8000"><%= HtmlEscape.escape(descVal) %></textarea>
        </div>

        <div class="form-group">
            <label for="category">Category</label>
            <select id="category" name="category">
                <option value="" <%= catVal == null || catVal.trim().isEmpty() ? "selected" : "" %>>Select a category</option>
                <option value="Academic" <%= "Academic".equals(catVal) ? "selected" : "" %>>Academic</option>
                <option value="Engineering" <%= "Engineering".equals(catVal) ? "selected" : "" %>>Engineering</option>
                <option value="Business" <%= "Business".equals(catVal) ? "selected" : "" %>>Business</option>
                <option value="Arts" <%= "Arts".equals(catVal) ? "selected" : "" %>>Arts</option>
                <option value="Cultural" <%= "Cultural".equals(catVal) ? "selected" : "" %>>Cultural</option>
                <option value="Technology" <%= "Technology".equals(catVal) ? "selected" : "" %>>Technology</option>
                <option value="Recreation &amp; Sports" <%= "Recreation & Sports".equals(catVal) ? "selected" : "" %>>Recreation &amp; Sports</option>
                <option value="Community Service" <%= "Community Service".equals(catVal) ? "selected" : "" %>>Community Service</option>
                <option value="Professional Development" <%= "Professional Development".equals(catVal) ? "selected" : "" %>>Professional Development</option>
                <option value="Media &amp; Entertainment" <%= "Media & Entertainment".equals(catVal) ? "selected" : "" %>>Media &amp; Entertainment</option>
            </select>
        </div>

        <div class="form-group">
            <label for="contactEmail">Contact Email</label>
            <input type="email" id="contactEmail" name="contactEmail" maxlength="100"
                   value="<%= HtmlEscape.escape(emailVal) %>">
        </div>

        <div class="form-group">
            <label for="meetingInfo">Meeting Info</label>
            <textarea id="meetingInfo" name="meetingInfo" maxlength="500"><%= HtmlEscape.escape(meetVal) %></textarea>
        </div>

        <div class="event-form-actions">
            <button type="submit" class="primary-btn">Save Changes</button>
        </div>
    </form>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

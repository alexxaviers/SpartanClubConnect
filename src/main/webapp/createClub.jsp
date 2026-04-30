<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    if (!Boolean.TRUE.equals(session.getAttribute("isClubOfficer"))) {
        response.sendRedirect(ctx + "/dashboard");
        return;
    }

    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");
    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;

    request.setAttribute("activeNav", "createClub");

    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Club - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
    <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header events-header">
    <h1 class="dashboard-page-title">Create Club</h1>
    <p class="dashboard-page-subtitle">
        Add a new student organization to SpartanClubConnect.
    </p>
</section>

<section class="dashboard-form-card clubs-shell-card clubs-form-card event-form-shell">
    <% if (errorMessage != null) { %>
    <p class="message error-message-box"><%= HtmlEscape.escape(errorMessage) %></p>
    <% } %>

    <form class="club-form event-form" action="<%= ctx %>/createClub" method="post">
        <div class="form-group">
            <label for="name">Club Name</label>
            <input type="text" id="name" name="name" required maxlength="100"
                   value="<%= request.getParameter("name") != null ? HtmlEscape.escape(request.getParameter("name")) : "" %>">
        </div>

        <div class="form-group">
            <label for="description">About</label>
            <textarea id="description" name="description" maxlength="8000"><%= request.getParameter("description") != null ? HtmlEscape.escape(request.getParameter("description")) : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="category">Category</label>
            <select id="category" name="category">
                <option value="" <%= request.getParameter("category") == null || request.getParameter("category").trim().isEmpty() ? "selected" : "" %>>Select a category</option>
                <option value="Academic" <%= "Academic".equals(request.getParameter("category")) ? "selected" : "" %>>Academic</option>
                <option value="Engineering" <%= "Engineering".equals(request.getParameter("category")) ? "selected" : "" %>>Engineering</option>
                <option value="Business" <%= "Business".equals(request.getParameter("category")) ? "selected" : "" %>>Business</option>
                <option value="Arts" <%= "Arts".equals(request.getParameter("category")) ? "selected" : "" %>>Arts</option>
                <option value="Cultural" <%= "Cultural".equals(request.getParameter("category")) ? "selected" : "" %>>Cultural</option>
                <option value="Technology" <%= "Technology".equals(request.getParameter("category")) ? "selected" : "" %>>Technology</option>
                <option value="Recreation &amp; Sports" <%= "Recreation & Sports".equals(request.getParameter("category")) ? "selected" : "" %>>Recreation &amp; Sports</option>
                <option value="Community Service" <%= "Community Service".equals(request.getParameter("category")) ? "selected" : "" %>>Community Service</option>
                <option value="Professional Development" <%= "Professional Development".equals(request.getParameter("category")) ? "selected" : "" %>>Professional Development</option>
                <option value="Media &amp; Entertainment" <%= "Media & Entertainment".equals(request.getParameter("category")) ? "selected" : "" %>>Media &amp; Entertainment</option>
            </select>
        </div>

        <div class="form-group">
            <label for="contactEmail">Contact Email</label>
            <input type="email" id="contactEmail" name="contactEmail" maxlength="100"
                   value="<%= request.getParameter("contactEmail") != null ? HtmlEscape.escape(request.getParameter("contactEmail")) : "" %>">
        </div>

        <div class="form-group">
            <label for="meetingInfo">Meeting Info</label>
            <textarea id="meetingInfo" name="meetingInfo" maxlength="500"><%= request.getParameter("meetingInfo") != null ? HtmlEscape.escape(request.getParameter("meetingInfo")) : "" %></textarea>
        </div>

        <div class="event-form-actions">
            <button type="submit" class="primary-btn">Create Club</button>
        </div>
    </form>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

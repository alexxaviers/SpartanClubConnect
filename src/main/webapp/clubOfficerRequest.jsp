<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");

    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    String submittedSjsuId = (String) request.getAttribute("submittedSjsuId");
    String submittedClubName = (String) request.getAttribute("submittedClubName");
    String submittedJustification = (String) request.getAttribute("submittedJustification");

    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");

    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;

    request.setAttribute("activeNav", "clubOfficer");
    request.setAttribute("dashboardExtraScript", "/js/clubOfficerRequest.js");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Club Officer Role - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubOfficer.css">
    <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header events-header">
    <h1 class="dashboard-page-title">Request Club Officer Role</h1>
    <p class="dashboard-page-subtitle">
        Submit a request to manage club-related content and officer workflows.
    </p>
</section>

<section class="dashboard-form-card events-shell-card event-form-shell">
    <% if (errorMessage != null) { %>
    <p class="message error-message-box"><%= errorMessage %></p>
    <% } %>

    <% if (successMessage != null) { %>
    <p class="message success-message-box"><%= successMessage %></p>
    <% } %>

    <form action="<%= ctx %>/clubOfficerRequest" method="post" class="dashboard-form event-form">
        <div class="form-group">
            <label for="fullName">Full Name</label>
            <input
                    type="text"
                    id="fullName"
                    name="fullName"
                    value="<%= fullName != null ? fullName : "" %>"
                    readonly
            >
        </div>

        <div class="form-group">
            <label for="sjsuId">SJSU ID</label>
            <input
                    type="text"
                    id="sjsuId"
                    name="sjsuId"
                    placeholder="Enter your 9-digit SJSU ID"
                    pattern="[0-9]{9}"
                    maxlength="9"
                    required
                    value="<%= submittedSjsuId != null ? submittedSjsuId : "" %>"
            >
        </div>

        <div class="form-group">
            <label for="clubName">Club Name</label>
            <input
                    type="text"
                    id="clubName"
                    name="clubName"
                    placeholder="Enter the club name"
                    maxlength="255"
                    required
                    value="<%= submittedClubName != null ? submittedClubName : "" %>"
            >
        </div>

        <div class="form-group">
            <label for="justification">Why are you requesting this role?</label>
            <textarea
                    id="justification"
                    name="justification"
                    class="dashboard-textarea"
                    placeholder="Write a short justification for your request"
                    maxlength="500"
                    required
            ><%= submittedJustification != null ? submittedJustification : "" %></textarea>

            <div id="justificationCount" class="field-hint">0/500 characters</div>
        </div>

        <div class="event-form-actions">
            <button type="submit" class="primary-btn">Submit Request</button>
        </div>
    </form>

    <div class="dashboard-note-box">
        Requests are reviewed by administrators. Once approved, your account can be assigned the Club Officer role.
    </div>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

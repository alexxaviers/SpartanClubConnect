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
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Edit club</h1>
                <p class="dashboard-page-subtitle">
                    <a href="<%= ctx %>/club?id=<%= club.getClubId() %>" class="club-edit-back-link">Back to club profile</a>
                </p>
            </section>

            <section class="dashboard-form-card clubs-shell-card clubs-form-card">
                <% if (errorMessage != null) { %>
                <p class="message error-message-box"><%= HtmlEscape.escape(errorMessage) %></p>
                <% } %>

                <form class="club-form" action="<%= ctx %>/editClub" method="post">
                    <input type="hidden" name="clubId" value="<%= club.getClubId() %>">
                    <div class="form-group">
                        <label for="name">Club name</label>
                        <input type="text" id="name" name="name" required maxlength="100"
                               value="<%= HtmlEscape.escape(nameVal) %>">
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" maxlength="8000"><%= HtmlEscape.escape(descVal) %></textarea>
                    </div>
                    <div class="form-group">
                        <label for="category">Category</label>
                        <input type="text" id="category" name="category" maxlength="100"
                               value="<%= HtmlEscape.escape(catVal) %>">
                    </div>
                    <div class="form-group">
                        <label for="contactEmail">Contact email</label>
                        <input type="email" id="contactEmail" name="contactEmail" maxlength="100"
                               value="<%= HtmlEscape.escape(emailVal) %>">
                    </div>
                    <div class="form-group">
                        <label for="meetingInfo">Meeting info</label>
                        <textarea id="meetingInfo" name="meetingInfo" maxlength="500"><%= HtmlEscape.escape(meetVal) %></textarea>
                    </div>
                    <button type="submit" class="primary-btn">Save changes</button>
                </form>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

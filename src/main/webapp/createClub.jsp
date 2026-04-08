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
        response.sendRedirect(ctx + "/dashboard.jsp");
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
    <title>Create club - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Create club</h1>
                <p class="dashboard-page-subtitle">
                    Add a new student organization to SpartanClubConnect.
                </p>
            </section>

            <section class="dashboard-form-card clubs-shell-card clubs-form-card">
                <% if (errorMessage != null) { %>
                <p class="message error-message-box"><%= HtmlEscape.escape(errorMessage) %></p>
                <% } %>

                <form class="club-form" action="<%= ctx %>/createClub" method="post">
                    <div class="form-group">
                        <label for="name">Club name</label>
                        <input type="text" id="name" name="name" required maxlength="100"
                               value="<%= request.getParameter("name") != null ? HtmlEscape.escape(request.getParameter("name")) : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" maxlength="8000"><%= request.getParameter("description") != null ? HtmlEscape.escape(request.getParameter("description")) : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label for="category">Category</label>
                        <input type="text" id="category" name="category" maxlength="100"
                               value="<%= request.getParameter("category") != null ? HtmlEscape.escape(request.getParameter("category")) : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="contactEmail">Contact email</label>
                        <input type="email" id="contactEmail" name="contactEmail" maxlength="100"
                               value="<%= request.getParameter("contactEmail") != null ? HtmlEscape.escape(request.getParameter("contactEmail")) : "" %>">
                    </div>
                    <div class="form-group">
                        <label for="meetingInfo">Meeting info</label>
                        <textarea id="meetingInfo" name="meetingInfo" maxlength="500"><%= request.getParameter("meetingInfo") != null ? HtmlEscape.escape(request.getParameter("meetingInfo")) : "" %></textarea>
                    </div>
                    <button type="submit" class="primary-btn">Create club</button>
                </form>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

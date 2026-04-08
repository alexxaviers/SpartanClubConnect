<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String ctx = request.getContextPath();
  Integer userId = (Integer) session.getAttribute("userId");
  String fullName = (String) session.getAttribute("fullName");
  String email = (String) session.getAttribute("email");
  String role = (String) session.getAttribute("role");

  if (userId == null) {
    response.sendRedirect(ctx + "/login.jsp");
    return;
  }

  Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
  Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");

  if (isAdmin == null) isAdmin = false;
  if (isClubOfficer == null) isClubOfficer = false;

  request.setAttribute("activeNav", "profile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile - SpartanClubConnect</title>
  <link rel="stylesheet" href="<%= ctx %>/css/global.css">
  <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
  <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
  <link rel="stylesheet" href="<%= ctx %>/css/profile.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
      <section class="dashboard-page-header">
        <h1 class="dashboard-page-title">Profile</h1>
        <p class="dashboard-page-subtitle">
          View your account details for SpartanClubConnect.
        </p>
      </section>

      <section class="dashboard-form-card">
        <div class="user-info">
          <div class="info-row">
            <span class="info-label">Full Name</span>
            <span class="info-value"><%= fullName %></span>
          </div>

          <div class="info-row">
            <span class="info-label">Email</span>
            <span class="info-value"><%= email %></span>
          </div>

          <div class="info-row">
            <span class="info-label">Role</span>
            <span class="info-value"><%= role != null ? role : "Student" %></span>
          </div>

          <div class="info-row">
            <span class="info-label">User ID</span>
            <span class="info-value"><%= userId %></span>
          </div>
        </div>

        <div class="dashboard-note-box">
          Profile editing can be added in a later phase.
        </div>
      </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

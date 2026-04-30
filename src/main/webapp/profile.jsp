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

  String profileError = (String) request.getAttribute("profileError");
  boolean success = "1".equals(request.getParameter("success"));
  boolean editMode = Boolean.TRUE.equals(request.getAttribute("profileEditMode"));

  String submittedFullName = (String) request.getAttribute("submittedFullName");
  String fullNameValue = submittedFullName != null ? submittedFullName : (fullName != null ? fullName : "");
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
  <link rel="stylesheet" href="<%= ctx %>/css/events.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header">
  <h1 class="dashboard-page-title">Profile</h1>
  <p class="dashboard-page-subtitle">
    View your account details and update your profile information.
  </p>
</section>

<section class="dashboard-form-card events-shell-card">
  <% if (success) { %>
  <p class="message success-message-box">Profile updated successfully.</p>
  <% } %>

  <% if (profileError != null && !profileError.isEmpty()) { %>
  <p class="message error-message-box"><%= profileError %></p>
  <% } %>

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
  </div>

  <div class="events-top-actions" style="margin-top: 24px;">
    <button type="button" class="secondary-btn" onclick="toggleProfileEdit()">
      <%= editMode ? "Hide Edit Form" : "Edit Profile" %>
    </button>
  </div>

  <div id="profileEditSection" style="<%= editMode ? "" : "display:none;" %>">
    <form action="<%= ctx %>/profile/update" method="post" class="event-form" style="margin-top: 20px;">
      <div class="form-group">
        <label for="fullName">Full Name</label>
        <input type="text" id="fullName" name="fullName" maxlength="100" required
               value="<%= fullNameValue %>">
      </div>

      <div class="form-group">
        <label for="password">New Password (optional)</label>
        <input type="password" id="password" name="password" minlength="8"
               placeholder="Leave blank to keep current password">
      </div>

      <div class="form-group">
        <label for="confirmPassword">Confirm New Password</label>
        <input type="password" id="confirmPassword" name="confirmPassword" minlength="8"
               placeholder="Re-enter new password">
      </div>

      <div class="event-form-actions">
        <button type="submit" class="primary-btn">Save Changes</button>
      </div>
    </form>
  </div>
</section>

<script>
  function toggleProfileEdit() {
    var section = document.getElementById("profileEditSection");
    if (!section) return;
    section.style.display = section.style.display === "none" ? "" : "none";
  }
</script>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  Integer userId = (Integer) session.getAttribute("userId");
  String fullName = (String) session.getAttribute("fullName");
  String email = (String) session.getAttribute("email");
  String role = (String) session.getAttribute("role");

  if (userId == null) {
    response.sendRedirect("login.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile - SpartanClubConnect</title>
  <link rel="stylesheet" href="css/global.css">
  <link rel="stylesheet" href="css/home.css">
</head>
<body class="landing-body">

<div class="dashboard-app">
  <aside class="dashboard-sidebar" id="dashboardSidebar">
    <div class="dashboard-sidebar-header">
      <span class="dashboard-sidebar-title">Menu</span>
      <button class="dashboard-sidebar-close" id="sidebarCloseBtn" type="button" aria-label="Close menu">×</button>
    </div>

    <nav class="dashboard-sidebar-nav">
      <a href="dashboard.jsp" class="dashboard-sidebar-link">Dashboard</a>
      <a href="profile.jsp" class="dashboard-sidebar-link active">Profile</a>
      <a href="clubOfficerRequest.jsp" class="dashboard-sidebar-link">Request Club Officer Role</a>
    </nav>

    <div class="dashboard-sidebar-footer">
      <form action="LogoutServlet" method="post">
        <button type="submit" class="dashboard-sidebar-logout">
          <svg class="dashboard-logout-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
               stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <polyline points="16 17 21 12 16 7"/>
            <line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
          <span>Log Out</span>
        </button>
      </form>
    </div>
  </aside>

  <div class="dashboard-overlay" id="dashboardOverlay"></div>

  <div class="dashboard-main-wrap">
    <nav class="landing-nav">
      <div class="landing-nav-inner">
        <div class="dashboard-nav-left">
          <button class="dashboard-menu-btn" id="sidebarOpenBtn" type="button" aria-label="Toggle menu">
            <span></span>
            <span></span>
            <span></span>
          </button>

          <a class="landing-logo" href="dashboard.jsp">
            <span class="blue">Spartan</span><span class="gold">Club</span><span class="blue">Connect</span>
          </a>
        </div>
      </div>
    </nav>

    <main class="dashboard-content">
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
    </main>

    <footer class="landing-footer-minimal">
      © 2026 SpartanClubConnect · CS157A Section 1 — Team 1
    </footer>
  </div>
</div>

<script src="js/home.js"></script>
</body>
</html>

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
</head>
<body class="landing-body">

<div class="dashboard-app">
    <aside class="dashboard-sidebar" id="dashboardSidebar">
        <div class="dashboard-sidebar-header">
            <span class="dashboard-sidebar-title">Menu</span>
            <button class="dashboard-sidebar-close" id="sidebarCloseBtn" type="button" aria-label="Close menu">×</button>
        </div>

        <nav class="dashboard-sidebar-nav">
            <a href="<%= ctx %>/dashboard.jsp" class="dashboard-sidebar-link">Dashboard</a>
            <a href="<%= ctx %>/profile.jsp" class="dashboard-sidebar-link">Profile</a>

            <% if (!isClubOfficer && !isAdmin) { %>
            <a href="<%= ctx %>/clubOfficerRequest.jsp" class="dashboard-sidebar-link active">Request Club Officer Role</a>
            <% } %>

            <% if (isClubOfficer) { %>
            <a href="<%= ctx %>/createClub.jsp" class="dashboard-sidebar-link">Create Club</a>
            <a href="<%= ctx %>/createEvent.jsp" class="dashboard-sidebar-link">Create Event</a>
            <% } %>

            <% if (isAdmin) { %>
            <a href="<%= ctx %>/AdminOfficerRequestsServlet" class="dashboard-sidebar-link">Manage Officer Requests</a>
            <a href="<%= ctx %>/admin/users" class="dashboard-sidebar-link">Manage Users</a>
            <a href="<%= ctx %>/admin/events" class="dashboard-sidebar-link">Moderate Events</a>
            <% } %>
        </nav>

        <div class="dashboard-sidebar-footer">
            <form action="<%= ctx %>/LogoutServlet" method="post">
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

                    <a class="landing-logo" href="<%= ctx %>/dashboard.jsp">
                        <span class="blue">Spartan</span><span class="gold">Club</span><span class="blue">Connect</span>
                    </a>
                </div>
            </div>
        </nav>

        <main class="dashboard-content">
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Request Club Officer Role</h1>
                <p class="dashboard-page-subtitle">
                    Submit a request to become a club officer and manage club-related content.
                </p>
            </section>

            <section class="dashboard-form-card">
                <% if (errorMessage != null) { %>
                <p class="message error-message-box"><%= errorMessage %></p>
                <% } %>

                <% if (successMessage != null) { %>
                <p class="message success-message-box"><%= successMessage %></p>
                <% } %>

                <form action="<%= ctx %>/ClubOfficerRequestServlet" method="post" class="dashboard-form">
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

                    <button type="submit" class="primary-btn">Submit Request</button>
                </form>

                <div class="dashboard-note-box">
                    Requests are reviewed by administrators. Once approved, your account can be assigned the Club Officer role.
                </div>
            </section>
        </main>

        <footer class="landing-footer-minimal">
            © 2026 SpartanClubConnect · CS157A Section 1 — Team 1
        </footer>
    </div>
</div>

<script src="<%= ctx %>/js/home.js"></script>
<script src="<%= ctx %>/js/clubOfficerRequest.js"></script>
</body>
</html>

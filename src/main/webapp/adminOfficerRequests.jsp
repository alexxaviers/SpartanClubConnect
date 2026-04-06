<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.sjsu.cs157a.team1.model.ClubOfficerRequest" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<ClubOfficerRequest> pendingRequests =
            (List<ClubOfficerRequest>) request.getAttribute("pendingRequests");

    List<ClubOfficerRequest> reviewedRequests =
            (List<ClubOfficerRequest>) request.getAttribute("reviewedRequests");

    String errorMessage = (String) request.getAttribute("errorMessage");
    String actionMessage = (String) session.getAttribute("adminOfficerRequestMessage");
    if (actionMessage != null) {
        session.removeAttribute("adminOfficerRequestMessage");
    }

    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");

    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;

    SimpleDateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy h:mm a");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Officer Requests - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/landing.css">
    <link rel="stylesheet" href="css/dashboard.css">
    <link rel="stylesheet" href="css/clubOfficer.css">
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
            <a href="profile.jsp" class="dashboard-sidebar-link">Profile</a>

            <% if (!isClubOfficer && !isAdmin) { %>
            <a href="clubOfficerRequest.jsp" class="dashboard-sidebar-link">Request Club Officer Role</a>
            <% } %>

            <% if (isClubOfficer) { %>
            <a href="createClub.jsp" class="dashboard-sidebar-link">Create Club</a>
            <a href="createEvent.jsp" class="dashboard-sidebar-link">Create Event</a>
            <% } %>

            <% if (isAdmin) { %>
            <a href="AdminOfficerRequestsServlet" class="dashboard-sidebar-link active">Manage Officer Requests</a>
            <% } %>
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

        <main class="dashboard-content dashboard-content-wide">
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Manage Officer Requests</h1>
                <p class="dashboard-page-subtitle">
                    Review pending requests from students who want to become club officers.
                </p>
            </section>

            <section class="dashboard-form-card dashboard-table-card">
                <% if (errorMessage != null) { %>
                <p class="message error-message-box"><%= errorMessage %></p>
                <% } %>

                <% if (actionMessage != null) { %>
                <p class="message success-message-box"><%= actionMessage %></p>
                <% } %>

                <h2 class="request-section-title">Pending Requests</h2>

                <% if (pendingRequests == null || pendingRequests.isEmpty()) { %>
                <div class="dashboard-note-box">
                    There are no pending officer requests right now.
                </div>
                <% } else { %>
                <div class="request-table-wrap">
                    <table class="request-table request-table-pending">
                        <thead>
                        <tr>
                            <th>Request ID</th>
                            <th>Student</th>
                            <th>Email</th>
                            <th>User ID</th>
                            <th>SJSU ID</th>
                            <th>Club Name</th>
                            <th>Justification</th>
                            <th>Submitted At</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (ClubOfficerRequest officerRequest : pendingRequests) { %>
                        <tr>
                            <td><%= officerRequest.getRequestId() %></td>
                            <td><%= officerRequest.getRequesterName() %></td>
                            <td><%= officerRequest.getRequesterEmail() %></td>
                            <td><%= officerRequest.getUserId() %></td>
                            <td><%= officerRequest.getSjsuId() %></td>
                            <td><%= officerRequest.getClubName() %></td>
                            <td><%= officerRequest.getJustification() %></td>
                            <td><%= officerRequest.getCreatedAt() != null ? dateFormatter.format(officerRequest.getCreatedAt()) : "-" %></td>
                            <td>
                                <div class="request-action-group">
                                    <form action="AdminOfficerRequestsServlet" method="post">
                                        <input type="hidden" name="requestId" value="<%= officerRequest.getRequestId() %>">
                                        <input type="hidden" name="action" value="approve">
                                        <button
                                                type="submit"
                                                class="primary-btn request-action-btn"
                                                onclick="return confirm('Approve this officer request?');">
                                            Approve
                                        </button>
                                    </form>

                                    <form action="AdminOfficerRequestsServlet" method="post">
                                        <input type="hidden" name="requestId" value="<%= officerRequest.getRequestId() %>">
                                        <input type="hidden" name="action" value="deny">
                                        <button
                                                type="submit"
                                                class="secondary-btn request-action-btn"
                                                onclick="return confirm('Are you sure you want to deny this request?');">
                                            Deny
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
            </section>

            <section class="dashboard-form-card dashboard-table-card request-history-card">
                <h2 class="request-section-title">Request History</h2>

                <% if (reviewedRequests == null || reviewedRequests.isEmpty()) { %>
                <div class="dashboard-note-box">
                    There is no reviewed request history yet.
                </div>
                <% } else { %>
                <div class="request-table-wrap">
                    <table class="request-table request-table-history">
                        <thead>
                        <tr>
                            <th>Request ID</th>
                            <th>Student</th>
                            <th>Email</th>
                            <th>User ID</th>
                            <th>SJSU ID</th>
                            <th>Club Name</th>
                            <th>Justification</th>
                            <th>Status</th>
                            <th>Submitted At</th>
                            <th>Reviewed At</th>
                            <th>Reviewed By</th>
                        </tr>
                        </thead>
                        <tbody>
                        <% for (ClubOfficerRequest officerRequest : reviewedRequests) { %>
                        <tr>
                            <td><%= officerRequest.getRequestId() %></td>
                            <td><%= officerRequest.getRequesterName() %></td>
                            <td><%= officerRequest.getRequesterEmail() %></td>
                            <td><%= officerRequest.getUserId() %></td>
                            <td><%= officerRequest.getSjsuId() %></td>
                            <td><%= officerRequest.getClubName() %></td>
                            <td><%= officerRequest.getJustification() %></td>
                            <td>
                                <span class="status-badge <%= "Approved".equals(officerRequest.getStatus()) ? "status-approved" : "status-denied" %>">
                                    <%= officerRequest.getStatus() %>
                                </span>
                            </td>
                            <td><%= officerRequest.getCreatedAt() != null ? dateFormatter.format(officerRequest.getCreatedAt()) : "-" %></td>
                            <td><%= officerRequest.getReviewedAt() != null ? dateFormatter.format(officerRequest.getReviewedAt()) : "-" %></td>
                            <td><%= officerRequest.getReviewerName() != null ? officerRequest.getReviewerName() : "-" %></td>
                        </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
                <% } %>
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

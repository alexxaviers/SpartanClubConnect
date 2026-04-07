<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="edu.sjsu.cs157a.team1.model.ClubOfficerRequest" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");

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

    SimpleDateFormat dateFormatter = new SimpleDateFormat("MM/dd/yyyy h:mm a");

    request.setAttribute("activeAdminPage", "officerRequests");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Officer Requests - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/global.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/landing.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/clubOfficer.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>

<%@ include file="/WEB-INF/jspf/adminLayoutStart.jspf" %>

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
                        <form action="<%= request.getContextPath() %>/AdminOfficerRequestsServlet" method="post">
                            <input type="hidden" name="requestId" value="<%= officerRequest.getRequestId() %>">
                            <input type="hidden" name="action" value="approve">
                            <button
                                    type="submit"
                                    class="primary-btn request-action-btn"
                                    onclick="return confirm('Approve this officer request?');">
                                Approve
                            </button>
                        </form>

                        <form action="<%= request.getContextPath() %>/AdminOfficerRequestsServlet" method="post">
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

<%@ include file="/WEB-INF/jspf/adminLayoutEnd.jspf" %>
</html>

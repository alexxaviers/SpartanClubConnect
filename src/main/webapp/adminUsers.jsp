<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="edu.sjsu.cs157a.team1.model.User" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    Map<Integer, String> userDisplayRoleMap =
            (Map<Integer, String>) request.getAttribute("userDisplayRoleMap");

    String errorMessage = (String) request.getAttribute("errorMessage");
    String actionMessage = (String) session.getAttribute("adminUsersMessage");
    if (actionMessage != null) {
        session.removeAttribute("adminUsersMessage");
    }

    int userCount = users == null ? 0 : users.size();

    request.setAttribute("activeAdminPage", "users");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubOfficer.css">
    <link rel="stylesheet" href="<%= ctx %>/css/admin.css">
</head>

<%@ include file="/WEB-INF/jspf/adminLayoutStart.jspf" %>

<section class="dashboard-page-header">
    <h1 class="dashboard-page-title">Manage Users</h1>
    <p class="dashboard-page-subtitle">
        Review user accounts, roles, and account status across the platform.
    </p>
</section>

<section class="dashboard-form-card dashboard-table-card">
    <p class="club-meta" style="margin-bottom: 18px;">
        <strong><%= userCount %></strong> <%= userCount == 1 ? "user" : "users" %> found
    </p>

    <% if (errorMessage != null) { %>
    <p class="message error-message-box"><%= errorMessage %></p>
    <% } %>

    <% if (actionMessage != null) { %>
    <p class="message success-message-box"><%= actionMessage %></p>
    <% } %>

    <% if (users == null || users.isEmpty()) { %>
    <div class="dashboard-note-box">
        No users were found.
    </div>
    <% } else { %>
    <div class="request-table-wrap">
        <table class="request-table admin-table-users">
            <thead>
            <tr>
                <th>User ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Role</th>
                <th>Status</th>
                <th>Account Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (User user : users) {
                String displayRole = userDisplayRoleMap != null
                        ? userDisplayRoleMap.get(user.getUserId())
                        : "Student";
            %>
            <tr>
                <td><%= user.getUserId() %></td>
                <td><%= user.getFullName() %></td>
                <td><%= user.getEmail() %></td>
                <td>
                    <span class="admin-role-chip"><%= displayRole %></span>
                </td>
                <td>
                    <span class="admin-badge <%= user.isActive() ? "admin-badge-active" : "admin-badge-inactive" %>">
                        <%= user.isActive() ? "Active" : "Inactive" %>
                    </span>
                </td>
                <td>
                    <div class="admin-action-stack">
                        <% if (user.getUserId() == userId) { %>
                        <div class="dashboard-note-box admin-self-note">
                            Current account
                        </div>
                        <% } else if ("Admin".equals(displayRole)) { %>
                        <div class="dashboard-note-box admin-self-note">
                            Admin account
                        </div>
                        <% } else if (user.isActive()) { %>
                        <form method="post" action="<%= ctx %>/admin/users">
                            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                            <input type="hidden" name="action" value="deactivate">
                            <input type="text" name="reason" maxlength="255" placeholder="Optional reason" style="margin-bottom: 8px;">
                            <button type="submit" class="secondary-btn request-action-btn"
                                    onclick="return confirm('Deactivate this user account?');">
                                Deactivate
                            </button>
                        </form>
                        <% } else { %>
                        <form method="post" action="<%= ctx %>/admin/users">
                            <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                            <input type="hidden" name="action" value="reactivate">
                            <button type="submit" class="primary-btn request-action-btn"
                                    onclick="return confirm('Reactivate this user account?');">
                                Reactivate
                            </button>
                        </form>
                        <% } %>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</section>

<%@ include file="/WEB-INF/jspf/adminLayoutEnd.jspf" %>
</html>

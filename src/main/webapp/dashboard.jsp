<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");
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
    <title>Dashboard - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/home.css">
</head>
<body>
<main class="home-page">
    <section class="home-card">
        <div class="home-header">
            <h1>Welcome, <%= fullName %></h1>
            <p class="subtitle">You are logged in successfully.</p>
        </div>

        <div class="user-info">
            <div class="info-row">
                <span class="info-label">Role</span>
                <span class="info-value"><%= role != null ? role : "Student" %></span>
            </div>

            <div class="info-row">
                <span class="info-label">User ID</span>
                <span class="info-value"><%= userId %></span>
            </div>
        </div>

        <div class="home-actions">
            <form action="LogoutServlet" method="post" style="width: 100%;">
                <button type="submit" class="primary-btn">Log Out</button>
            </form>
        </div>
    </section>
</main>
</body>
</html>

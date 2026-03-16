<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/auth.css">
</head>
<body>
<main class="login-page">
    <section class="auth-card">
        <h1 class="brand-title">
            <span class="blue">Spartan</span><span class="gold">Club</span><span class="blue">Connect</span>
        </h1>

        <% if (error != null) { %>
        <p class="message error-message-box"><%= error %></p>
        <% } %>

        <% if (successMessage != null) { %>
        <p class="message success-message-box"><%= successMessage %></p>
        <% } %>

        <form id="loginForm" action="LoginServlet" method="POST" novalidate>
            <div class="form-group">
                <label for="email">SJSU Email Address</label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="your.email@sjsu.edu"
                        required
                >
                <small class="field-error" id="emailError"></small>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Enter your password"
                        required
                >
                <small class="field-error" id="passwordError"></small>
            </div>

            <button type="submit" class="primary-btn">Log In</button>
        </form>

        <div class="divider"></div>

        <p class="bottom-link">
            Don't have an account?
            <a href="createAccount.jsp">Create Account</a>
        </p>
    </section>
</main>

<script src="js/login.js"></script>
</body>
</html>
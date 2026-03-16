<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/auth.css">
</head>
<body>
<main class="login-page">
    <section class="auth-card">
        <h1 class="brand-title">
            <span class="blue">Spartan</span><span class="gold">Club</span><span class="blue">Connect</span>
        </h1>

        <% if (errorMessage != null) { %>
        <p class="message error-message-box"><%= errorMessage %></p>
        <% } %>

        <% if (successMessage != null) { %>
        <p class="message success-message-box"><%= successMessage %></p>
        <% } %>

        <form id="createAccountForm" action="CreateAccountServlet" method="POST" novalidate>
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input
                        type="text"
                        id="fullName"
                        name="fullName"
                        placeholder="Enter your full name"
                        value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>"
                        required
                >
                <small class="field-error" id="fullNameError"></small>
            </div>

            <div class="form-group">
                <label for="email">SJSU Email Address</label>
                <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="your.email@sjsu.edu"
                        value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
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
                        placeholder="At least 8 characters"
                        required
                >
                <small class="field-error" id="passwordError"></small>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Re-enter your password"
                        required
                >
                <small class="field-error" id="confirmPasswordError"></small>
            </div>

            <button type="submit" class="primary-btn">Create Account</button>
        </form>

        <div class="divider"></div>

        <p class="bottom-link">
            Already have an account?
            <a href="login.jsp">Sign In</a>
        </p>
    </section>
</main>

<script src="js/createAccount.js"></script>
</body>
</html>
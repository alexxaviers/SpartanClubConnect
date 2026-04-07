<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="edu.sjsu.cs157a.team1.model.Club" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    Club club = (Club) request.getAttribute("club");
    if (club == null) {
        response.sendRedirect(request.getContextPath() + "/clubs");
        return;
    }
    String errorMessage = (String) request.getAttribute("errorMessage");
    String ctx = request.getContextPath();

    String nameVal = club.getName() != null ? club.getName() : "";
    String descVal = club.getDescription() != null ? club.getDescription() : "";
    String catVal = club.getCategory() != null ? club.getCategory() : "";
    String emailVal = club.getContactEmail() != null ? club.getContactEmail() : "";
    String meetVal = club.getMeetingInfo() != null ? club.getMeetingInfo() : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit <%= HtmlEscape.escape(nameVal) %> - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/auth.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<body>
<main class="login-page">
    <section class="auth-card" style="max-width: 560px;">
        <nav class="top-nav" style="margin-bottom: 16px;">
            <a href="<%= ctx %>/club?id=<%= club.getClubId() %>">Back to profile</a>
        </nav>
        <h1 class="brand-title" style="font-size: 1.6rem;">Edit club</h1>

        <% if (errorMessage != null) { %>
        <p class="message error-message-box"><%= HtmlEscape.escape(errorMessage) %></p>
        <% } %>

        <form class="club-form" action="<%= ctx %>/editClub" method="post">
            <input type="hidden" name="clubId" value="<%= club.getClubId() %>">
            <div class="form-group">
                <label for="name">Club name</label>
                <input type="text" id="name" name="name" required maxlength="100"
                       value="<%= HtmlEscape.escape(nameVal) %>">
            </div>
            <div class="form-group">
                <label for="description">Description</label>
                <textarea id="description" name="description" maxlength="8000"><%= HtmlEscape.escape(descVal) %></textarea>
            </div>
            <div class="form-group">
                <label for="category">Category</label>
                <input type="text" id="category" name="category" maxlength="100"
                       value="<%= HtmlEscape.escape(catVal) %>">
            </div>
            <div class="form-group">
                <label for="contactEmail">Contact email</label>
                <input type="email" id="contactEmail" name="contactEmail" maxlength="100"
                       value="<%= HtmlEscape.escape(emailVal) %>">
            </div>
            <div class="form-group">
                <label for="meetingInfo">Meeting info</label>
                <textarea id="meetingInfo" name="meetingInfo" maxlength="500"><%= HtmlEscape.escape(meetVal) %></textarea>
            </div>
            <button type="submit" class="primary-btn">Save changes</button>
        </form>
    </section>
</main>
</body>
</html>

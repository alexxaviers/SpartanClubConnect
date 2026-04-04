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
    Boolean canEdit = (Boolean) request.getAttribute("canEdit");
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlEscape.escape(club.getName()) %> - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<body>
<main class="clubs-page">
    <div class="clubs-card">
        <nav class="top-nav">
            <a href="<%= ctx %>/clubs">All clubs</a>
            &nbsp;&middot;&nbsp;
            <a href="<%= ctx %>/home.jsp">Home</a>
        </nav>

        <div class="clubs-header">
            <h1><%= HtmlEscape.escape(club.getName()) %></h1>
            <p class="club-meta">
                <%= club.getCategory() != null && !club.getCategory().isEmpty()
                        ? HtmlEscape.escape(club.getCategory()) : "Uncategorized" %>
                &middot; Primary manager (earliest assigned): <%= HtmlEscape.escape(
                        club.getManagerFullName() != null ? club.getManagerFullName() : "—") %>
            </p>
            <% if (club.getCreatedAt() != null) { %>
            <p class="club-meta">Created: <%= club.getCreatedAt() %></p>
            <% } %>
            <% if (Boolean.TRUE.equals(canEdit)) { %>
            <p style="margin-top: 12px;">
                <a class="secondary-link" href="<%= ctx %>/editClub?clubId=<%= club.getClubId() %>">Edit club</a>
            </p>
            <% } %>
        </div>

        <div class="club-profile-section">
            <h2>Description</h2>
            <div class="block"><%= club.getDescription() != null && !club.getDescription().isEmpty()
                    ? HtmlEscape.escape(club.getDescription()) : "No description yet." %></div>
        </div>

        <div class="club-profile-section">
            <h2>Contact</h2>
            <p>
                <% if (club.getContactEmail() != null && !club.getContactEmail().isEmpty()) { %>
                Email: <%= HtmlEscape.escape(club.getContactEmail()) %>
                <% } else { %>
                No contact email listed.
                <% } %>
            </p>
        </div>

        <div class="club-profile-section">
            <h2>Meeting info</h2>
            <div class="block"><%= club.getMeetingInfo() != null && !club.getMeetingInfo().isEmpty()
                    ? HtmlEscape.escape(club.getMeetingInfo()) : "No meeting info listed." %></div>
        </div>
    </div>
</main>
</body>
</html>

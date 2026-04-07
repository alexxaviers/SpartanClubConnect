<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="edu.sjsu.cs157a.team1.model.Club" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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


    String categoryLabel = club.getCategory() != null && !club.getCategory().isEmpty()
            ? club.getCategory()
            : "Uncategorized";
    String managerLabel = club.getManagerFullName() != null ? club.getManagerFullName() : "—";
    String createdFormatted = null;
    if (club.getCreatedAt() != null) {
        createdFormatted = DateTimeFormatter.ofPattern("MMMM d, yyyy")
                .format(club.getCreatedAt().toLocalDateTime());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlEscape.escape(club.getName()) %> - SpartanClubConnect</title>
    <%-- Relative to the browser URL (/context/club) so CSS resolves like the /clubs page --%>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/clubs.css">
</head>
<body>
<main class="clubs-page">
    <div class="clubs-card">
        <nav class="top-nav">
            <a href="<%= ctx %>/clubs">All clubs</a>
            <span class="club-profile-nav-dot">&middot;</span>
            <a href="<%= ctx %>/dashboard.jsp">Dashboard</a>
        </nav>


        <div class="clubs-header club-profile-header">
            <h1><%= HtmlEscape.escape(club.getName()) %></h1>
            <p class="club-meta">
                <%= HtmlEscape.escape(categoryLabel) %>
                &middot; Manager: <%= HtmlEscape.escape(managerLabel) %>
            </p>
            <% if (createdFormatted != null) { %>
            <p class="club-meta">Established <%= HtmlEscape.escape(createdFormatted) %></p>
            <% } %>
        </div>


        <% if (Boolean.TRUE.equals(canEdit)) { %>
        <div class="club-profile-actions">
            <a href="<%= ctx %>/editClub?clubId=<%= club.getClubId() %>" class="club-profile-edit-btn">Edit club</a>
        </div>
        <% } %>


        <ul class="club-list club-profile-details">
            <li class="club-list-item">
                <h2 class="club-profile-block-heading">Description</h2>
                <% if (club.getDescription() != null && !club.getDescription().isEmpty()) { %>
                <p class="club-profile-block-text"><%= HtmlEscape.escape(club.getDescription()) %></p>
                <% } else { %>
                <p class="club-profile-block-text club-profile-block-text--muted">No description yet.</p>
                <% } %>
            </li>
            <li class="club-list-item">
                <h2 class="club-profile-block-heading">Contact</h2>
                <% if (club.getContactEmail() != null && !club.getContactEmail().isEmpty()) {
                        String contactEmail = club.getContactEmail();
                %>
                <p class="club-profile-block-text">
                    <a href="mailto:<%= HtmlEscape.escape(contactEmail) %>"><%= HtmlEscape.escape(contactEmail) %></a>
                </p>
                <% } else { %>
                <p class="club-profile-block-text club-profile-block-text--muted">No contact email listed.</p>
                <% } %>
            </li>
            <li class="club-list-item">
                <h2 class="club-profile-block-heading">Meeting info</h2>
                <% if (club.getMeetingInfo() != null && !club.getMeetingInfo().isEmpty()) { %>
                <p class="club-profile-block-text"><%= HtmlEscape.escape(club.getMeetingInfo()) %></p>
                <% } else { %>
                <p class="club-profile-block-text club-profile-block-text--muted">No meeting info listed.</p>
                <% } %>
            </li>
        </ul>
    </div>
</main>
</body>
</html>






<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="edu.sjsu.cs157a.team1.model.Club" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");

    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }

    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");

    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;

    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    String q = (String) request.getAttribute("q");
    String category = (String) request.getAttribute("category");
    String sort = (String) request.getAttribute("sort");

    if (q == null) q = "";
    if (category == null) category = "";
    if (sort == null || sort.trim().isEmpty()) sort = "name_asc";

    int resultCount = clubs != null ? clubs.size() : 0;

    request.setAttribute("activeNav", "browseClubs");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Clubs - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header clubs-header">
    <h1 class="dashboard-page-title clubs-page-title">Clubs</h1>
    <p class="dashboard-page-subtitle">Search student organizations by keyword and category.</p>
</section>

<section class="dashboard-form-card clubs-shell-card">
    <form class="clubs-toolbar" action="<%= ctx %>/clubs" method="get" id="clubsFilterForm">
        <div class="form-group">
            <label for="q">Search</label>
            <input
                    type="text"
                    id="q"
                    name="q"
                    value="<%= HtmlEscape.escape(q) %>"
                    placeholder="Search clubs by name or description">
        </div>

        <div class="form-group">
            <label for="category">Category</label>
            <select id="category" name="category" onchange="document.getElementById('clubsFilterForm').submit();">
                <option value="" <%= category.isEmpty() ? "selected" : "" %>>All Categories</option>
                <option value="Academic" <%= "Academic".equals(category) ? "selected" : "" %>>Academic</option>
                <option value="Engineering" <%= "Engineering".equals(category) ? "selected" : "" %>>Engineering</option>
                <option value="Business" <%= "Business".equals(category) ? "selected" : "" %>>Business</option>
                <option value="Arts" <%= "Arts".equals(category) ? "selected" : "" %>>Arts</option>
                <option value="Cultural" <%= "Cultural".equals(category) ? "selected" : "" %>>Cultural</option>
                <option value="Technology" <%= "Technology".equals(category) ? "selected" : "" %>>Technology</option>
                <option value="Recreation &amp; Sports" <%= "Recreation & Sports".equals(category) ? "selected" : "" %>>Recreation &amp; Sports</option>
                <option value="Community Service" <%= "Community Service".equals(category) ? "selected" : "" %>>Community Service</option>
                <option value="Professional Development" <%= "Professional Development".equals(category) ? "selected" : "" %>>Professional Development</option>
                <option value="Media &amp; Entertainment" <%= "Media & Entertainment".equals(category) ? "selected" : "" %>>Media &amp; Entertainment</option>
            </select>
        </div>

        <div class="form-group">
            <label for="sort">Sort</label>
            <select id="sort" name="sort" onchange="document.getElementById('clubsFilterForm').submit();">
                <option value="name_asc" <%= "name_asc".equals(sort) ? "selected" : "" %>>Name A-Z</option>
                <option value="name_desc" <%= "name_desc".equals(sort) ? "selected" : "" %>>Name Z-A</option>
                <option value="newest" <%= "newest".equals(sort) ? "selected" : "" %>>Newest</option>
            </select>
        </div>

        <div class="toolbar-actions">
            <button type="submit" class="primary-btn clubs-filter-btn">Apply Filters</button>
            <a href="<%= ctx %>/clubs" class="secondary-link">Clear</a>
        </div>
    </form>
</section>

<section class="dashboard-form-card clubs-shell-card">
    <div class="clubs-results-meta">
        <p class="club-meta">
            <strong><%= resultCount %></strong> <%= resultCount == 1 ? "club" : "clubs" %> found
        </p>
    </div>

    <%
        if (clubs == null || clubs.isEmpty()) {
    %>
    <p class="empty-hint">No clubs found. Try adjusting your search or filters.</p>
    <%
    } else {
    %>
    <ul class="club-list">
        <%
            for (Club club : clubs) {
                String categoryLabel = (club.getCategory() != null && !club.getCategory().isEmpty())
                        ? club.getCategory()
                        : "Uncategorized";
                String clubUrl = ctx + "/club?id=" + club.getClubId();
                String contactLabel = (club.getContactEmail() != null && !club.getContactEmail().isEmpty())
                        ? club.getContactEmail()
                        : "No contact listed";
        %>
        <li class="club-list-item club-list-item-clickable"
            onclick="window.location.href='<%= clubUrl %>'"
            tabindex="0"
            role="link"
            onkeydown="if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); window.location.href='<%= clubUrl %>'; }">
            <h2>
                <a href="<%= clubUrl %>" onclick="event.stopPropagation();">
                    <%= HtmlEscape.escape(club.getName()) %>
                </a>
            </h2>

            <p class="club-meta">
                <%= HtmlEscape.escape(categoryLabel) %>
                &middot; <%= HtmlEscape.escape(contactLabel) %>
            </p>

            <div class="club-profile-details">
                <% if (club.getDescription() != null && !club.getDescription().isEmpty()) { %>
                <p class="club-profile-block-text club-list-description">
                    <%= HtmlEscape.escape(club.getDescription()) %>
                </p>
                <% } else { %>
                <p class="club-profile-block-text club-profile-block-text--muted">
                    No description available.
                </p>
                <% } %>
            </div>
        </li>
        <%
            }
        %>
    </ul>
    <%
        }
    %>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

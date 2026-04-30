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

    if (isAdmin) {
        response.sendRedirect(ctx + "/dashboard.jsp");
        return;
    }

    request.setAttribute("activeNav", "followedClubs");

    @SuppressWarnings("unchecked")
    List<Club> followedClubs = (List<Club>) request.getAttribute("followedClubs");
    if (followedClubs == null) {
        response.sendRedirect(ctx + "/followedClubs");
        return;
    }

    Integer currentPageAttr = (Integer) request.getAttribute("currentPage");
    Integer totalPagesAttr = (Integer) request.getAttribute("totalPages");
    Integer totalClubsAttr = (Integer) request.getAttribute("totalClubs");
    int currentPage = currentPageAttr != null ? currentPageAttr : 1;
    int totalPages = totalPagesAttr != null ? totalPagesAttr : 0;
    int resultCount = totalClubsAttr != null ? totalClubsAttr : followedClubs.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Followed Clubs - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>

<section class="dashboard-page-header clubs-header">
    <h1 class="dashboard-page-title clubs-page-title">Followed Clubs</h1>
    <p class="dashboard-page-subtitle">Clubs you follow and want to keep up with.</p>
</section>

<section class="dashboard-form-card clubs-shell-card">
    <p class="club-meta clubs-results-meta">
        <strong><%= resultCount %></strong> <%= resultCount == 1 ? "club" : "clubs" %> found
    </p>

    <% if (followedClubs.isEmpty()) { %>
    <p class="empty-hint">
        You are not following any clubs yet.
        <a href="<%= ctx %>/clubs">Browse clubs</a> to find organizations to follow.
    </p>
    <% } else { %>
    <ul class="club-list">
        <% for (Club c : followedClubs) {
            String clubUrl = ctx + "/club?id=" + c.getClubId();
            String categoryLabel = c.getCategory() != null && !c.getCategory().isEmpty()
                    ? c.getCategory()
                    : "Uncategorized";
            String contactLabel = c.getContactEmail() != null && !c.getContactEmail().isEmpty()
                    ? c.getContactEmail()
                    : "No contact listed";
        %>
        <li class="club-list-item club-list-item--with-action club-list-item-clickable"
            onclick="window.location.href='<%= clubUrl %>'"
            tabindex="0"
            role="link"
            onkeydown="if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); window.location.href='<%= clubUrl %>'; }">
            <div class="club-list-item-body">
                <h2>
                    <a href="<%= clubUrl %>" onclick="event.stopPropagation();"><%= HtmlEscape.escape(c.getName()) %></a>
                </h2>
                <p class="club-meta">
                    <%= HtmlEscape.escape(categoryLabel) %>
                    &middot; <%= HtmlEscape.escape(contactLabel) %>
                </p>

                <% if (c.getDescription() != null && !c.getDescription().isEmpty()) { %>
                <p class="club-profile-block-text club-list-description">
                    <%= HtmlEscape.escape(c.getDescription()) %>
                </p>
                <% } else { %>
                <p class="club-profile-block-text club-profile-block-text--muted">
                    No description available.
                </p>
                <% } %>
            </div>

            <form class="followed-club-unfollow-form" action="<%= ctx %>/clubFollow" method="post" onclick="event.stopPropagation();">
                <input type="hidden" name="clubId" value="<%= c.getClubId() %>">
                <input type="hidden" name="action" value="unfollow">
                <input type="hidden" name="returnTo" value="followedClubs">
                <button type="submit" class="secondary-btn followed-club-unfollow-btn"
                        onclick="return confirm('Unfollow this club?');">
                    Unfollow
                </button>
            </form>
        </li>
        <% } %>
    </ul>
    <% if (totalPages > 1) { %>
    <nav class="clubs-pagination" aria-label="Followed clubs pagination">
        <a class="pagination-btn <%= currentPage == 1 ? "disabled" : "" %>"
           href="<%= currentPage == 1 ? "#" : (ctx + "/followedClubs?page=" + (currentPage - 1)) %>"
           aria-disabled="<%= currentPage == 1 %>">&lsaquo;</a>
        <% for (int pageNum = 1; pageNum <= totalPages; pageNum++) { %>
        <a class="pagination-btn <%= pageNum == currentPage ? "active" : "" %>"
           href="<%= ctx + "/followedClubs?page=" + pageNum %>"
           <%= pageNum == currentPage ? "aria-current=\"page\"" : "" %>><%= pageNum %></a>
        <% } %>
        <a class="pagination-btn <%= currentPage == totalPages ? "disabled" : "" %>"
           href="<%= currentPage == totalPages ? "#" : (ctx + "/followedClubs?page=" + (currentPage + 1)) %>"
           aria-disabled="<%= currentPage == totalPages %>">&rsaquo;</a>
    </nav>
    <% } %>
    <% } %>
</section>

<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

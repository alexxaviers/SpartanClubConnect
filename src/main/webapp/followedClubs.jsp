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
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Followed clubs - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Followed Clubs</h1>
                <p class="dashboard-page-subtitle">
                    Clubs you follow.
                </p>
            </section>

            <section class="dashboard-form-card clubs-shell-card">
                <% if (followedClubs.isEmpty()) { %>
                <p class="empty-hint">You are not following any clubs yet.
                    <a href="<%= ctx %>/clubs">Browse clubs</a> to find organizations to follow.</p>
                <% } else { %>
                <ul class="club-list">
                    <% for (Club c : followedClubs) { %>
					<li class="club-list-item club-list-item--with-action">
                        <div class="club-list-item-body">
                            <h2><a href="<%= ctx %>/club?id=<%= c.getClubId() %>"><%= HtmlEscape.escape(c.getName()) %></a></h2>
                            <p class="club-meta">
                                <%= c.getCategory() != null && !c.getCategory().isEmpty()
                                        ? HtmlEscape.escape(c.getCategory()) : "Uncategorized" %>
                                &middot; Manager: <%= HtmlEscape.escape(c.getManagerFullName() != null ? c.getManagerFullName() : "—") %>
                            </p>
                        </div>
                        <form class="followed-club-unfollow-form" action="<%= ctx %>/clubFollow" method="post">
                            <input type="hidden" name="clubId" value="<%= c.getClubId() %>">
                            <input type="hidden" name="action" value="unfollow">
                            <input type="hidden" name="returnTo" value="followedClubs">
                            <button type="submit" class="secondary-btn followed-club-unfollow-btn">Unfollow</button>
                        </form>
                    </li>
                    <% } %>
                </ul>
                <% } %>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>
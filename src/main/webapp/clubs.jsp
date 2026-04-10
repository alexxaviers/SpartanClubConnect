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

    request.setAttribute("activeNav", "browseClubs");

    @SuppressWarnings("unchecked")
    List<Club> clubs = (List<Club>) request.getAttribute("clubs");
    if (clubs == null) {
        String qs = request.getQueryString();
        String dest = ctx + "/clubs";
        if (qs != null && !qs.isEmpty()) {
            dest += "?" + qs;
        }
        response.sendRedirect(dest);
        return;
    }
    String q = request.getAttribute("q") != null ? (String) request.getAttribute("q") : "";
    String category = request.getAttribute("category") != null ? (String) request.getAttribute("category") : "";
    String sort = request.getAttribute("sort") != null ? (String) request.getAttribute("sort") : "name_asc";
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
            <section class="dashboard-page-header">
                <h1 class="dashboard-page-title">Clubs</h1>
                <p class="dashboard-page-subtitle">
                    Search by name, category, or keywords in the description.
                </p>
            </section>

            <section class="dashboard-form-card clubs-shell-card">
                <form class="clubs-toolbar" method="get" action="<%= ctx %>/clubs">
                    <div class="form-group">
                        <label for="q">Search</label>
                        <input type="text" id="q" name="q" placeholder="Name, category, or keywords"
                               value="<%= HtmlEscape.escape(q) %>">
                    </div>
                    <div class="form-group">
                        <label for="category">Category filter</label>
                        <input type="text" id="category" name="category" placeholder="e.g. Academic"
                               value="<%= HtmlEscape.escape(category) %>">
                    </div>
                    <div class="form-group">
                        <label for="sort">Sort</label>
                        <select id="sort" name="sort">
                            <option value="name_asc" <%= "name_asc".equals(sort) ? "selected" : "" %>>Name (A–Z)</option>
                            <option value="name_desc" <%= "name_desc".equals(sort) ? "selected" : "" %>>Name (Z–A)</option>
                        </select>
                    </div>
                    <div class="toolbar-actions">
                        <button type="submit" class="primary-btn" style="width: auto; padding-left: 20px; padding-right: 20px;">Apply</button>
                    </div>
                </form>

                <% if (clubs.isEmpty()) { %>
                <p class="empty-hint">No clubs match your filters.</p>
                <% } else { %>
                <ul class="club-list">
                    <% for (Club c : clubs) { %>
                    <li class="club-list-item">
                        <h2><a href="<%= ctx %>/club?id=<%= c.getClubId() %>"><%= HtmlEscape.escape(c.getName()) %></a></h2>
                        <p class="club-meta">
                            <%= c.getCategory() != null && !c.getCategory().isEmpty()
                                    ? HtmlEscape.escape(c.getCategory()) : "Uncategorized" %>
                            &middot; Manager: <%= HtmlEscape.escape(c.getManagerFullName()) %>
                        </p>
                    </li>
                    <% } %>
                </ul>
                <% } %>
            </section>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

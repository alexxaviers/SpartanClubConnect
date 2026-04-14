<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="edu.sjsu.cs157a.team1.model.Club" %>
<%@ page import="edu.sjsu.cs157a.team1.util.HtmlEscape" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    String ctx = request.getContextPath();
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(ctx + "/login.jsp");
        return;
    }
    Club club = (Club) request.getAttribute("club");
    if (club == null) {
        response.sendRedirect(ctx + "/clubs");
        return;
    }
    Boolean canEdit = (Boolean) request.getAttribute("canEdit");
	Boolean canFollowClubs = (Boolean) request.getAttribute("canFollowClubs");
	Boolean isFollowing = (Boolean) request.getAttribute("isFollowing");
	
	if (canFollowClubs == null) canFollowClubs = false;
	if (isFollowing == null) isFollowing = false;
    
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    Boolean isClubOfficer = (Boolean) session.getAttribute("isClubOfficer");
    if (isAdmin == null) isAdmin = false;
    if (isClubOfficer == null) isClubOfficer = false;

    request.setAttribute("activeNav", "");

    String categoryLabel = club.getCategory() != null && !club.getCategory().isEmpty()
            ? club.getCategory()
            : "Uncategorized";
    String managerLabel = club.getManagerFullName() != null ? club.getManagerFullName() : "—";
    String createdFormatted = null;
    if (club.getCreatedAt() != null) {
        createdFormatted = DateTimeFormatter.ofPattern("MMMM d, yyyy")
                .format(club.getCreatedAt().toLocalDateTime());
    }
    Object followerCountObj = request.getAttribute("clubFollowerCount");
    int followerCount = 0;
    if (followerCountObj instanceof Number) {
        followerCount = ((Number) followerCountObj).intValue();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= HtmlEscape.escape(club.getName()) %> - SpartanClubConnect</title>
    <link rel="stylesheet" href="<%= ctx %>/css/global.css">
    <link rel="stylesheet" href="<%= ctx %>/css/landing.css">
    <link rel="stylesheet" href="<%= ctx %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= ctx %>/css/clubs.css">
</head>
<%@ include file="/WEB-INF/jspf/dashboardShellStart.jspf" %>
            <section class="dashboard-page-header club-profile-dashboard-header">
                <h1 class="dashboard-page-title"><%= HtmlEscape.escape(club.getName()) %></h1>
                <p class="dashboard-page-subtitle club-profile-dashboard-meta">
                    <%= HtmlEscape.escape(categoryLabel) %>
                    &middot; Manager: <%= HtmlEscape.escape(managerLabel) %>
                </p>
                <% if (createdFormatted != null) { %>
                <p class="dashboard-page-subtitle club-profile-dashboard-meta club-profile-dashboard-meta--secondary">
                    Established <%= HtmlEscape.escape(createdFormatted) %>
                </p>
                <% } %>
                <p class="dashboard-page-subtitle club-profile-dashboard-meta club-profile-follower-count"
                   id="club-follower-count"
                   aria-live="polite">
                    <%= followerCount == 1 ? "1 follower" : followerCount + " followers" %>
                </p>
            </section>

			<% if (Boolean.TRUE.equals(canEdit) || Boolean.TRUE.equals(canFollowClubs)) { %>
            <div class="club-profile-actions club-profile-actions--shell">
                <div class="club-profile-actions-row">
                    <% if (Boolean.TRUE.equals(canEdit)) { %>
                    <a href="<%= ctx %>/editClub?clubId=<%= club.getClubId() %>" class="club-profile-edit-btn">Edit club</a>
                    <% } %>
                    <% if (Boolean.TRUE.equals(canFollowClubs)) { %>
                    <form class="club-profile-follow-form" action="<%= ctx %>/clubFollow" method="post" data-live-follow="true">
                        <input type="hidden" name="clubId" value="<%= club.getClubId() %>">
                        <input type="hidden" name="action" value="<%= Boolean.TRUE.equals(isFollowing) ? "unfollow" : "follow" %>">
                        <% if (Boolean.TRUE.equals(isFollowing)) { %>
                        <button type="submit" class="secondary-btn club-profile-follow-btn">Unfollow</button>
                        <% } else { %>
                        <button type="submit" class="primary-btn club-profile-follow-btn">Follow</button>
                        <% } %>
                    </form>
                    <% } %>
                </div>
            </div>
            <% } %>

            <section class="dashboard-form-card clubs-shell-card">
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
            </section>
 <% if (Boolean.TRUE.equals(canFollowClubs)) { %>
            <script>
            (function () {
                var form = document.querySelector('form.club-profile-follow-form[data-live-follow="true"]');
                if (!form) return;
                form.addEventListener('submit', function (e) {
                    e.preventDefault();
                    var fd = new FormData(form);
                    fd.set('format', 'json');
                    fetch(form.action, {
                        method: 'POST',
                        body: fd,
                        credentials: 'same-origin',
                        headers: { 'X-Requested-With': 'XMLHttpRequest' }
                    }).then(function (res) {
                        if (!res.ok) throw new Error('request failed');
                        return res.json();
                    }).then(function (data) {
                        var el = document.getElementById('club-follower-count');
                        if (el && typeof data.followerCount === 'number') {
                            el.textContent = data.followerCount === 1
                                ? '1 follower'
                                : data.followerCount + ' followers';
                        }
                        var actionInput = form.querySelector('input[name="action"]');
                        var btn = form.querySelector('button[type="submit"]');
                        if (actionInput && btn && typeof data.isFollowing === 'boolean') {
                            if (data.isFollowing) {
                                actionInput.value = 'unfollow';
                                btn.textContent = 'Unfollow';
                                btn.className = 'secondary-btn club-profile-follow-btn';
                            } else {
                                actionInput.value = 'follow';
                                btn.textContent = 'Follow';
                                btn.className = 'primary-btn club-profile-follow-btn';
                            }
                        }
                    }).catch(function () {
                        form.submit();
                    });
                });
            })();
            </script>
            <% } %>
<%@ include file="/WEB-INF/jspf/dashboardShellEnd.jspf" %>

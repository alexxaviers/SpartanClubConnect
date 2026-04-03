<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId != null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SpartanClubConnect</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/home.css">
</head>
<body class="landing-body">

<nav class="landing-nav">
    <div class="landing-nav-inner">
        <a class="landing-logo" href="index.jsp">
            <span class="blue">Spartan</span><span class="gold">Club</span><span class="blue">Connect</span>
        </a>
        <a class="landing-login-btn" href="login.jsp">Log In</a>
    </div>
</nav>

<main class="landing-shell">
    <div class="landing-eyebrow">
        <span class="landing-pulse"></span>
        450+ clubs at SJSU
    </div>

    <h1 class="landing-title">Your campus,<br><em>all in one place.</em></h1>
    <p class="landing-subtitle">Log in to explore clubs, events, and campus activities.</p>

    <div class="landing-search-wrap">
        <form class="landing-search-bar" action="login.jsp" method="get">
            <input type="text" name="q" placeholder="Search clubs or events..." autocomplete="off">
            <button type="submit">Search</button>
        </form>
    </div>

    <div class="landing-chips">
        <a href="login.jsp" class="landing-chip">Academic</a>
        <a href="login.jsp" class="landing-chip">Engineering</a>
        <a href="login.jsp" class="landing-chip">Business</a>
        <a href="login.jsp" class="landing-chip">Cultural</a>
        <a href="login.jsp" class="landing-chip">Arts</a>
        <a href="login.jsp" class="landing-chip">Technology</a>
        <a href="login.jsp" class="landing-chip">Recreation &amp; Sports</a>
        <a href="login.jsp" class="landing-chip">Community Service</a>
    </div>

    <div class="landing-gateway-cards">
        <a href="login.jsp" class="landing-gateway-card">
            <div class="landing-card-icon landing-card-icon-blue">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                     stroke="#0055A2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="9" cy="7" r="3"/>
                    <path d="M3 20v-2a6 6 0 0 1 9.17-5.1"/>
                    <circle cx="17" cy="11" r="3"/>
                    <path d="M11 20v-2a6 6 0 0 1 12 0v2"/>
                </svg>
            </div>
            <h2>Discover Clubs</h2>
            <p>Browse all SJSU student organizations by category or keyword.</p>
            <span class="landing-card-arrow">Browse clubs →</span>
        </a>

        <a href="login.jsp" class="landing-gateway-card">
            <div class="landing-card-icon landing-card-icon-gold">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                     stroke="#92660a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2"/>
                    <line x1="16" y1="2" x2="16" y2="6"/>
                    <line x1="8" y1="2" x2="8" y2="6"/>
                    <line x1="3" y1="10" x2="21" y2="10"/>
                </svg>
            </div>
            <h2>Explore Events</h2>
            <p>Find upcoming events happening across campus this week and beyond.</p>
            <span class="landing-card-arrow">Browse events →</span>
        </a>
    </div>
</main>

<footer class="landing-footer-minimal">
    © 2026 SpartanClubConnect · CS157A Section 1 — Team 1
</footer>

</body>
</html>

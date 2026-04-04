<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String fullName = (String) session.getAttribute("fullName");

    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - SpartanClubConnect</title>
    <link rel="stylesheet" href="css/global.css">
    <link rel="stylesheet" href="css/home.css">
</head>
<body class="landing-body">

<div class="dashboard-app">
    <aside class="dashboard-sidebar" id="dashboardSidebar">
        <div class="dashboard-sidebar-header">
            <span class="dashboard-sidebar-title">Menu</span>
            <button class="dashboard-sidebar-close" id="sidebarCloseBtn" type="button" aria-label="Close menu">×</button>
        </div>

        <nav class="dashboard-sidebar-nav">
            <a href="dashboard.jsp" class="dashboard-sidebar-link active">Dashboard</a>
            <a href="profile.jsp" class="dashboard-sidebar-link">Profile</a>
            <a href="clubOfficerRequest.jsp" class="dashboard-sidebar-link">Request Club Officer Role</a>
        </nav>

        <div class="dashboard-sidebar-footer">
            <form action="LogoutServlet" method="post">
                <button type="submit" class="dashboard-sidebar-logout">
                    <svg class="dashboard-logout-icon" width="18" height="18" viewBox="0 0 24 24" fill="none"
                         stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
                        <polyline points="16 17 21 12 16 7"/>
                        <line x1="21" y1="12" x2="9" y2="12"/>
                    </svg>
                    <span>Log Out</span>
                </button>
            </form>
        </div>
    </aside>

    <div class="dashboard-overlay" id="dashboardOverlay"></div>

    <div class="dashboard-main-wrap">
        <nav class="landing-nav">
            <div class="landing-nav-inner">
                <div class="dashboard-nav-left">
                    <button class="dashboard-menu-btn" id="sidebarOpenBtn" type="button" aria-label="Toggle menu">
                        <span></span>
                        <span></span>
                        <span></span>
                    </button>

                    <a class="landing-logo" href="dashboard.jsp">
                        <span class="blue">Spartan</span><span class="gold">Club</span><span class="blue">Connect</span>
                    </a>
                </div>
            </div>
        </nav>

        <main class="dashboard-content">
            <section class="dashboard-hero-block">
                <h1 class="landing-title">Welcome back,<br><em><%= fullName %></em></h1>
                <p class="landing-subtitle">
                    Search clubs, browse events, and explore opportunities across SJSU.
                </p>
            </section>

            <section class="dashboard-search-section">
                <div class="landing-search-wrap">
                    <form class="landing-search-bar" action="clubs.jsp" method="get">
                        <input type="text" name="q" placeholder="Search clubs or events..." autocomplete="off">
                        <button type="submit">Search</button>
                    </form>
                </div>

                <div class="landing-chips">
                    <a href="clubs.jsp" class="landing-chip">Academic</a>
                    <a href="clubs.jsp" class="landing-chip">Engineering</a>
                    <a href="clubs.jsp" class="landing-chip">Business</a>
                    <a href="clubs.jsp" class="landing-chip">Cultural</a>
                    <a href="clubs.jsp" class="landing-chip">Arts</a>
                    <a href="clubs.jsp" class="landing-chip">Technology</a>
                    <a href="clubs.jsp" class="landing-chip">Recreation &amp; Sports</a>
                    <a href="clubs.jsp" class="landing-chip">Community Service</a>
                </div>
            </section>

            <section class="dashboard-main-cards">
                <a href="clubs.jsp" class="landing-gateway-card">
                    <div class="landing-card-icon landing-card-icon-blue">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                             stroke="#0055A2" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="9" cy="7" r="3"/>
                            <path d="M3 20v-2a6 6 0 0 1 9.17-5.1"/>
                            <circle cx="17" cy="11" r="3"/>
                            <path d="M11 20v-2a6 6 0 0 1 12 0v2"/>
                        </svg>
                    </div>
                    <h2>Browse Clubs</h2>
                    <p>View student organizations by category, interest, and keyword.</p>
                    <span class="landing-card-arrow">Go to clubs →</span>
                </a>

                <a href="events.jsp" class="landing-gateway-card">
                    <div class="landing-card-icon landing-card-icon-gold">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"
                             stroke="#92660a" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="4" width="18" height="18" rx="2"/>
                            <line x1="16" y1="2" x2="16" y2="6"/>
                            <line x1="8" y1="2" x2="8" y2="6"/>
                            <line x1="3" y1="10" x2="21" y2="10"/>
                        </svg>
                    </div>
                    <h2>Browse Events</h2>
                    <p>See upcoming events happening across campus and club communities.</p>
                    <span class="landing-card-arrow">Go to events →</span>
                </a>
            </section>
        </main>

        <footer class="landing-footer-minimal">
            © 2026 SpartanClubConnect · CS157A Section 1 — Team 1
        </footer>
    </div>
</div>

<script src="js/home.js"></script>
</body>
</html>

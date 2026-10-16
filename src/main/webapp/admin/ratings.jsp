<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.smartfix.modelcom.User"%>
<%@ page import="com.smartfix.modelcom.Rating"%>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null ||
        admin.getRole() == null ||
        !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Rating> ratings =
        (List<Rating>) request.getAttribute("ratings");

    int totalRatings = 0;
    double averageRating = 0.0;
    int fiveStar = 0;
    int lowRatings = 0;

    if (ratings != null) {
        totalRatings = ratings.size();
        int total = 0;

        for (Rating rating : ratings) {
            int value = rating.getRating();
            total += value;

            if (value == 5) fiveStar++;
            if (value <= 2) lowRatings++;
        }

        if (!ratings.isEmpty()) {
            averageRating = (double) total / ratings.size();
        }
    }

    String adminName = admin.getName() == null
        ? "SmartFix Admin" : admin.getName();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>SmartFix | Ratings & Feedback</title>

<style>
:root {
    --sidebar: #151b2e;
    --sidebar-card: #252c40;
    --primary: #4035b5;
    --primary-light: #efedff;
    --bg: #f5f7fc;
    --text: #182033;
    --muted: #71809b;
    --border: #e8edf5;
    --white: #fff;
    --success: #15803d;
    --warning: #d97706;
    --danger: #dc2626;
    --shadow: 0 5px 20px rgba(20, 35, 70, .05);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
    font-size: 14px;
}

a {
    color: inherit;
}

button, input, select {
    font: inherit;
}

button, a {
    -webkit-tap-highlight-color: transparent;
}

/* Sidebar */
.sidebar {
    position: fixed;
    inset: 0 auto 0 0;
    width: 250px;
    padding: 22px 15px;
    background: var(--sidebar);
    color: white;
    overflow-y: auto;
    z-index: 1000;
}

.logo {
    font-size: 27px;
    line-height: 1.2;
    font-weight: 800;
    letter-spacing: -.8px;
    padding: 0 8px;
    margin-bottom: 32px;
}

.logo span {
    color: #8b85ff;
}

.admin-info {
    background: var(--sidebar-card);
    border: 1px solid rgba(255,255,255,.07);
    border-radius: 16px;
    padding: 17px 15px;
    margin-bottom: 26px;
    overflow-wrap: anywhere;
}

.admin-avatar {
    width: 45px;
    height: 45px;
    border-radius: 13px;
    background: #4437d2;
    display: grid;
    place-items: center;
    font-size: 21px;
    margin-bottom: 12px;
}

.admin-info h3 {
    font-size: 15px;
    font-weight: 700;
    margin-bottom: 5px;
}

.admin-info p {
    color: #aab8d1;
    font-size: 12px;
}

.menu-heading {
    color: #8291b2;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.2px;
    margin: 24px 15px 11px;
}

.menu {
    list-style: none;
}

.menu li {
    margin-bottom: 7px;
}

.menu a {
    display: flex;
    align-items: center;
    gap: 13px;
    min-height: 47px;
    padding: 12px 15px;
    border-radius: 12px;
    text-decoration: none;
    color: #d0d8e8;
    font-size: 13px;
    font-weight: 600;
    transition: background .2s, color .2s;
}

.menu a:hover,
.menu a.active {
    background: var(--primary);
    color: white;
}

.menu-icon {
    width: 20px;
    text-align: center;
    font-size: 16px;
}

/* Mobile top bar */
.mobile-topbar {
    display: none;
    position: sticky;
    top: 0;
    z-index: 900;
    align-items: center;
    justify-content: space-between;
    background: white;
    padding: 12px 16px;
    border-bottom: 1px solid var(--border);
}

.mobile-logo {
    font-size: 20px;
    font-weight: 800;
}

.mobile-logo span {
    color: #5145cd;
}

.menu-toggle {
    width: 40px;
    height: 40px;
    border: 1px solid var(--border);
    background: white;
    border-radius: 10px;
    cursor: pointer;
    font-size: 19px;
}

/* Main */
.main {
    margin-left: 250px;
    padding: 30px;
    min-height: 100vh;
    max-width: 1700px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 18px;
    margin-bottom: 26px;
}

.eyebrow {
    color: #5145cd;
    text-transform: uppercase;
    letter-spacing: 1.5px;
    font-size: 10px;
    font-weight: 800;
    margin-bottom: 8px;
}

.topbar h1 {
    font-size: 27px;
    line-height: 1.25;
    font-weight: 750;
    letter-spacing: -.5px;
}

.topbar p {
    color: var(--muted);
    margin-top: 7px;
    font-size: 13px;
    line-height: 1.5;
}

.back-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 7px;
    background: white;
    border: 1px solid var(--border);
    color: #35415b;
    border-radius: 10px;
    padding: 10px 14px;
    text-decoration: none;
    font-size: 12px;
    font-weight: 650;
    white-space: nowrap;
    transition: .2s;
}

.back-btn:hover {
    color: white;
    background: var(--primary);
    border-color: var(--primary);
}

/* Summary cards */
.summary {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 17px;
    margin-bottom: 24px;
}

.summary-card {
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 15px;
    padding: 20px;
    box-shadow: var(--shadow);
    min-width: 0;
}

.summary-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 17px;
}

.summary-label {
    font-size: 12px;
    color: var(--muted);
    font-weight: 600;
}

.summary-icon {
    width: 40px;
    height: 40px;
    display: grid;
    place-items: center;
    border-radius: 12px;
    background: var(--primary-light);
    font-size: 19px;
    flex-shrink: 0;
}

.summary-card h2 {
    font-size: 28px;
    font-weight: 750;
    line-height: 1.2;
    overflow-wrap: anywhere;
}

.summary-card .subtext {
    font-size: 11px;
    color: var(--muted);
    margin-top: 7px;
}

.gold {
    color: #e5a000;
}

.green {
    color: var(--success);
}

/* Feedback panel */
.ratings-container {
    background: white;
    border: 1px solid var(--border);
    border-radius: 16px;
    padding: 23px;
    box-shadow: var(--shadow);
    min-width: 0;
}

.section-title {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 18px;
}

.section-title h2 {
    font-size: 18px;
    font-weight: 750;
}

.section-title p {
    color: var(--muted);
    font-size: 12px;
    margin-top: 5px;
}

.count {
    background: var(--primary-light);
    color: var(--primary);
    padding: 7px 11px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 750;
    white-space: nowrap;
}

/* Filters */
.filter-box {
    display: grid;
    grid-template-columns: minmax(0, 1fr) 180px auto;
    gap: 10px;
    margin-bottom: 20px;
    padding: 14px;
    background: #f8faff;
    border: 1px solid var(--border);
    border-radius: 12px;
}

.search-wrap {
    position: relative;
    min-width: 0;
}

.search-wrap span {
    position: absolute;
    left: 13px;
    top: 50%;
    transform: translateY(-50%);
    color: #8a96aa;
}

.search-input,
.rating-select {
    width: 100%;
    min-height: 42px;
    padding: 10px 12px;
    border: 1px solid #dfe5ef;
    border-radius: 9px;
    background: white;
    color: var(--text);
    font-size: 12px;
    outline: none;
}

.search-input {
    padding-left: 36px;
}

.search-input:focus,
.rating-select:focus {
    border-color: #8177eb;
    box-shadow: 0 0 0 3px rgba(64,53,181,.09);
}

.reset-btn {
    min-height: 42px;
    padding: 0 16px;
    background: #29334b;
    border: none;
    border-radius: 9px;
    color: white;
    font-size: 12px;
    font-weight: 650;
    cursor: pointer;
}

.reset-btn:hover {
    background: #151b2e;
}

/* Rating cards */
.rating-card {
    border: 1px solid var(--border);
    border-radius: 13px;
    padding: 19px;
    margin-bottom: 13px;
    background: white;
    transition: box-shadow .2s, border-color .2s;
    min-width: 0;
}

.rating-card:last-of-type {
    margin-bottom: 0;
}

.rating-card:hover {
    border-color: #d9d5ff;
    box-shadow: 0 6px 18px rgba(20,35,70,.05);
}

.rating-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 12px;
    margin-bottom: 12px;
}

.complaint-id {
    font-size: 14px;
    font-weight: 750;
    overflow-wrap: anywhere;
}

.date {
    color: #8793a7;
    font-size: 11px;
    text-align: right;
    overflow-wrap: anywhere;
}

.stars {
    color: #f3ac17;
    font-size: 19px;
    letter-spacing: 2px;
    margin-bottom: 13px;
}

.rating-details {
    display: flex;
    flex-wrap: wrap;
    gap: 9px 22px;
    margin-bottom: 14px;
}

.detail {
    color: var(--muted);
    font-size: 12px;
    overflow-wrap: anywhere;
}

.detail strong {
    color: #35415b;
    font-weight: 700;
}

.feedback {
    background: #f8faff;
    border: 1px solid #edf1f8;
    border-radius: 10px;
    padding: 13px 14px;
    font-size: 12px;
    color: #4e5b72;
    line-height: 1.7;
    overflow-wrap: anywhere;
    white-space: pre-wrap;
}

/* Empty states */
.empty,
.no-results {
    text-align: center;
    padding: 45px 18px;
    color: #8995a8;
}

.empty-icon {
    width: 58px;
    height: 58px;
    display: grid;
    place-items: center;
    border-radius: 18px;
    background: #f0eeff;
    font-size: 26px;
    margin: 0 auto 15px;
}

.empty h3,
.no-results h3 {
    color: #344056;
    font-size: 16px;
    margin-bottom: 7px;
}

.empty p,
.no-results p {
    font-size: 12px;
    line-height: 1.6;
}

.no-results {
    display: none;
}

.sidebar-overlay {
    display: none;
}

/* Tablet */
@media (max-width: 1050px) {
    .main {
        padding: 23px;
    }

    .summary {
        gap: 12px;
    }

    .summary-card {
        padding: 16px;
    }

    .filter-box {
        grid-template-columns: minmax(0, 1fr) 160px;
    }

    .reset-btn {
        grid-column: 1 / -1;
    }
}

/* Mobile */
@media (max-width: 760px) {
    .mobile-topbar {
        display: flex;
    }

    .sidebar {
        width: min(280px, 84vw);
        transform: translateX(-105%);
        transition: transform .25s ease;
        box-shadow: 8px 0 30px rgba(0,0,0,.15);
    }

    body.menu-open .sidebar {
        transform: translateX(0);
    }

    .sidebar-overlay {
        position: fixed;
        inset: 0;
        z-index: 950;
        background: rgba(12,18,32,.48);
    }

    body.menu-open .sidebar-overlay {
        display: block;
    }

    .main {
        margin-left: 0;
        padding: 22px 16px;
    }

    .topbar {
        align-items: flex-start;
        margin-bottom: 21px;
    }

    .topbar h1 {
        font-size: 23px;
    }

    .topbar p {
        font-size: 12px;
    }

    .summary {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .summary-card:last-child {
        grid-column: 1 / -1;
    }

    .ratings-container {
        padding: 16px;
    }

    .section-title h2 {
        font-size: 16px;
    }

    .filter-box {
        grid-template-columns: 1fr;
        padding: 12px;
    }

    .reset-btn {
        grid-column: auto;
    }
}

/* Small phones */
@media (max-width: 420px) {
    .main {
        padding: 18px 12px;
    }

    .topbar {
        flex-direction: column;
        gap: 13px;
    }

    .topbar h1 {
        font-size: 21px;
    }

    .summary {
        grid-template-columns: 1fr 1fr;
        gap: 10px;
    }

    .summary-card {
        padding: 14px;
    }

    .summary-card h2 {
        font-size: 23px;
    }

    .summary-icon {
        width: 34px;
        height: 34px;
        font-size: 16px;
    }

    .ratings-container {
        padding: 13px;
    }

    .section-title {
        align-items: flex-start;
    }

    .rating-card {
        padding: 14px;
    }

    .rating-header {
        flex-direction: column;
        gap: 6px;
    }

    .date {
        text-align: left;
    }

    .rating-details {
        flex-direction: column;
        gap: 8px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        transition-duration: .01ms !important;
        scroll-behavior: auto !important;
    }
}
</style>
</head>

<body>

<!-- Mobile header -->
<div class="mobile-topbar">
    <div class="mobile-logo">Smart<span>Fix</span></div>
    <button type="button"
            class="menu-toggle"
            id="menuToggle"
            aria-label="Open navigation"
            aria-expanded="false">☰</button>
</div>

<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <div class="logo">Smart<span>Fix</span></div>

    <div class="admin-info">
        <div class="admin-avatar">👤</div>
        <h3><%= adminName %></h3>
        <p>Administrator</p>
    </div>

    <div class="menu-heading">MAIN MENU</div>

    <ul class="menu">
        <li>
            <a href="<%= request.getContextPath() %>/admin/dashboard">
                <span class="menu-icon">⌂</span> Dashboard
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/complaints">
                <span class="menu-icon">▤</span> Complaints
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/users">
                <span class="menu-icon">♙</span> Users
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/admin/staff">
                <span class="menu-icon">⚒</span> Staff
            </a>
        </li>
        <li>
            <a class="active"
               href="<%= request.getContextPath() %>/admin/ratings"
               aria-current="page">
                <span class="menu-icon">♧</span> Ratings
            </a>
        </li>
    </ul>

    <div class="menu-heading">ACCOUNT</div>

    <ul class="menu">
        <li>
            <a href="<%= request.getContextPath() %>/admin/profile">
                <span class="menu-icon">⚙</span> My Profile
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/logout">
                <span class="menu-icon">⇥</span> Logout
            </a>
        </li>
    </ul>
</aside>

<!-- Main content -->
<main class="main">

    <header class="topbar">
        <div>
            <div class="eyebrow">OVERVIEW / RATINGS</div>
            <h1>Ratings &amp; Feedback</h1>
            <p>Review service ratings and feedback submitted by users.</p>
        </div>

        <a class="back-btn"
           href="<%= request.getContextPath() %>/admin/dashboard">
            ← Dashboard
        </a>
    </header>

    <!-- Summary -->
    <section class="summary">

        <div class="summary-card">
            <div class="summary-top">
                <span class="summary-label">Total Ratings</span>
                <span class="summary-icon">⭐</span>
            </div>
            <h2><%= totalRatings %></h2>
            <p class="subtext">Ratings submitted by users</p>
        </div>

        <div class="summary-card">
            <div class="summary-top">
                <span class="summary-label">Average Rating</span>
                <span class="summary-icon">🌟</span>
            </div>
            <h2 class="gold">
                <%= String.format(java.util.Locale.US, "%.1f", averageRating) %>
                <span style="font-size:14px;color:#8995a8">/ 5</span>
            </h2>
            <p class="subtext">Overall user satisfaction</p>
        </div>

        <div class="summary-card">
            <div class="summary-top">
                <span class="summary-label">5-Star Ratings</span>
                <span class="summary-icon">🏆</span>
            </div>
            <h2 class="green"><%= fiveStar %></h2>
            <p class="subtext">
                <%= totalRatings == 0 ? "No ratings yet" :
                    String.format(java.util.Locale.US, "%.0f",
                    (fiveStar * 100.0) / totalRatings) + "% of all ratings" %>
            </p>
        </div>

    </section>

    <!-- Ratings panel -->
    <section class="ratings-container">

        <div class="section-title">
            <div>
                <h2>User Feedback</h2>
                <p>Search feedback or filter by star rating.</p>
            </div>

            <span class="count" id="visibleCount">
                <%= totalRatings %> Ratings
            </span>
        </div>

        <div class="filter-box">
            <div class="search-wrap">
                <span>⌕</span>
                <input type="search"
                       id="searchInput"
                       class="search-input"
                       placeholder="Search complaint ID, user ID or feedback..."
                       aria-label="Search ratings">
            </div>

            <select id="ratingFilter"
                    class="rating-select"
                    aria-label="Filter by rating">
                <option value="all">All Ratings</option>
                <option value="5">★★★★★ 5 Stars</option>
                <option value="4">★★★★☆ 4 Stars</option>
                <option value="3">★★★☆☆ 3 Stars</option>
                <option value="2">★★☆☆☆ 2 Stars</option>
                <option value="1">★☆☆☆☆ 1 Star</option>
            </select>

            <button type="button"
                    class="reset-btn"
                    id="resetButton">Reset Filters</button>
        </div>

        <%
            if (ratings != null && !ratings.isEmpty()) {
                for (Rating rating : ratings) {
                    int ratingValue = rating.getRating();

                    String feedback = rating.getFeedback() == null
                        ? "" : rating.getFeedback().trim();

                    String createdAt = rating.getCreatedAt() == null
                        ? "Date unavailable" : rating.getCreatedAt().toString();

                    String searchable =
                        "Complaint " + rating.getComplaintId() +
                        " User " + rating.getUserId() + " " + feedback;
        %>

        <article class="rating-card"
                 data-complaint="<%= rating.getComplaintId() %>"
                 data-user="<%= rating.getUserId() %>"
                 data-rating="<%= ratingValue %>"
                 data-search="<%= searchable.replace("\"", "&quot;") %>">

            <div class="rating-header">
                <div class="complaint-id">
                    Complaint #<%= rating.getComplaintId() %>
                </div>
                <div class="date"><%= createdAt %></div>
            </div>

            <div class="stars" aria-label="<%= ratingValue %> out of 5 stars">
                <%
                    for (int i = 1; i <= 5; i++) {
                        out.print(i <= ratingValue ? "★" : "☆");
                    }
                %>
            </div>

            <div class="rating-details">
                <div class="detail">
                    👤 User ID: <strong><%= rating.getUserId() %></strong>
                </div>
                <div class="detail">
                    ⭐ Rating: <strong><%= ratingValue %>/5</strong>
                </div>
                <div class="detail">
                    📝 Rating ID: <strong><%= rating.getRatingId() %></strong>
                </div>
            </div>

            <div class="feedback"><%
                if (!feedback.isEmpty()) {
                    out.print(feedback
                        .replace("&", "&amp;")
                        .replace("<", "&lt;")
                        .replace(">", "&gt;")
                        .replace("\"", "&quot;")
                        .replace("'", "&#39;"));
                } else {
                    out.print("No written feedback was provided.");
                }
            %></div>

        </article>

        <%
                }
        %>

        <div class="no-results" id="noResults">
            <div class="empty-icon">🔍</div>
            <h3>No Ratings Found</h3>
            <p>Try another search term or choose a different rating.</p>
        </div>

        <%
            } else {
        %>

        <div class="empty">
            <div class="empty-icon">⭐</div>
            <h3>No Ratings Yet</h3>
            <p>User ratings and feedback will appear here once users submit their ratings.</p>
        </div>

        <%
            }
        %>

    </section>
</main>

<script>
(function () {
    const body = document.body;
    const menuToggle = document.getElementById("menuToggle");
    const overlay = document.getElementById("sidebarOverlay");
    const sidebar = document.getElementById("sidebar");

    function closeMenu() {
        body.classList.remove("menu-open");
        if (menuToggle) {
            menuToggle.setAttribute("aria-expanded", "false");
            menuToggle.setAttribute("aria-label", "Open navigation");
        }
    }

    if (menuToggle) {
        menuToggle.addEventListener("click", function () {
            const isOpen = body.classList.toggle("menu-open");
            menuToggle.setAttribute("aria-expanded", String(isOpen));
            menuToggle.setAttribute(
                "aria-label",
                isOpen ? "Close navigation" : "Open navigation"
            );
        });
    }

    if (overlay) {
        overlay.addEventListener("click", closeMenu);
    }

    if (sidebar) {
        sidebar.querySelectorAll("a").forEach(function (link) {
            link.addEventListener("click", closeMenu);
        });
    }

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") closeMenu();
    });

    const searchInput = document.getElementById("searchInput");
    const ratingFilter = document.getElementById("ratingFilter");
    const visibleCount = document.getElementById("visibleCount");
    const noResults = document.getElementById("noResults");
    const resetButton = document.getElementById("resetButton");

    function filterRatings() {
        if (!searchInput || !ratingFilter || !visibleCount) return;

        const query = searchInput.value.trim().toLowerCase();
        const selectedRating = ratingFilter.value;
        const cards = document.querySelectorAll(".rating-card");
        let visible = 0;

        cards.forEach(function (card) {
            const searchableText =
                (card.getAttribute("data-search") || "").toLowerCase();

            const complaintId =
                (card.getAttribute("data-complaint") || "").toLowerCase();

            const userId =
                (card.getAttribute("data-user") || "").toLowerCase();

            const rating = card.getAttribute("data-rating") || "";

            const matchesSearch =
                searchableText.includes(query) ||
                complaintId.includes(query) ||
                userId.includes(query);

            const matchesRating =
                selectedRating === "all" || rating === selectedRating;

            const matches = matchesSearch && matchesRating;

            card.style.display = matches ? "" : "none";

            if (matches) visible++;
        });

        visibleCount.textContent =
            visible + (visible === 1 ? " Rating" : " Ratings");

        if (noResults) {
            noResults.style.display = visible === 0 ? "block" : "none";
        }
    }

    function resetFilters() {
        if (searchInput) searchInput.value = "";
        if (ratingFilter) ratingFilter.value = "all";
        filterRatings();
    }

    if (searchInput) {
        searchInput.addEventListener("input", filterRatings);
    }

    if (ratingFilter) {
        ratingFilter.addEventListener("change", filterRatings);
    }

    if (resetButton) {
        resetButton.addEventListener("click", resetFilters);
    }
})();
</script>

</body>
</html>
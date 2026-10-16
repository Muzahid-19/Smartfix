
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.smartfix.modelcom.Staff"%>
<%@ page import="com.smartfix.modelcom.User"%>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null || admin.getRole() == null
            || !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Staff> staffList =
        (List<Staff>) request.getAttribute("staffList");

    int totalStaff = staffList == null ? 0 : staffList.size();
    String ctx = request.getContextPath();

    String adminName = admin.getName() == null
        || admin.getName().trim().isEmpty()
        ? "SmartFix Admin" : admin.getName();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#151b30">

<title>Manage Staff | SmartFix</title>

<style>
:root {
    --navy: #151b30;
    --navy-card: #252c40;
    --purple: #3930a8;
    --purple-hover: #30278f;
    --page: #f5f7fc;
    --white: #ffffff;
    --text: #172033;
    --muted: #718096;
    --border: #e5eaf2;
    --green: #15803d;
    --red: #dc2626;
    --radius: 15px;
    --shadow: 0 8px 28px rgba(15, 23, 42, .045);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html {
    scroll-behavior: smooth;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: var(--page);
    color: var(--text);
    min-height: 100vh;
    line-height: 1.5;
}

button, input {
    font: inherit;
}

a, button {
    -webkit-tap-highlight-color: transparent;
}

a:focus-visible,
button:focus-visible,
input:focus-visible {
    outline: 3px solid rgba(99, 102, 241, .35);
    outline-offset: 3px;
}

/* SIDEBAR */
.sidebar {
    position: fixed;
    top: 0;
    left: 0;
    bottom: 0;
    z-index: 1000;
    width: 300px;
    padding: 24px 21px;
    overflow-y: auto;
    background: var(--navy);
    color: white;
    transition: transform .25s ease;
}

.logo {
    padding: 0 14px;
    margin-bottom: 35px;
    font-size: 29px;
    line-height: 1.2;
    font-weight: 800;
    letter-spacing: -1.2px;
}

.logo span {
    color: #7c83ff;
}

.admin-box {
    padding: 20px 18px;
    margin-bottom: 28px;
    background: var(--navy-card);
    border: 1px solid rgba(255,255,255,.08);
    border-radius: 17px;
    overflow-wrap: anywhere;
}

.admin-avatar {
    display: grid;
    place-items: center;
    width: 52px;
    height: 52px;
    margin-bottom: 15px;
    border-radius: 16px;
    background: #4438ca;
    font-size: 25px;
}

.admin-box h3 {
    margin-bottom: 4px;
    font-size: 16px;
    font-weight: 700;
    color: #fff;
}

.admin-box p {
    font-size: 13px;
    color: #b7c3df;
}

.menu-heading {
    padding: 0 16px;
    margin: 25px 0 11px;
    color: #8797ba;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.2px;
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
    min-height: 48px;
    padding: 12px 15px;
    color: #d0d8e9;
    text-decoration: none;
    border-radius: 12px;
    font-size: 13px;
    font-weight: 600;
    transition: background .2s, color .2s;
}

.menu-icon {
    display: inline-flex;
    justify-content: center;
    width: 23px;
    flex-shrink: 0;
    font-size: 17px;
}

.menu a:hover,
.menu a.active {
    background: var(--purple);
    color: #fff;
}

.menu a.logout {
    margin-top: 12px;
    color: #fecaca;
}

.menu a.logout:hover {
    background: rgba(220, 38, 38, .17);
}

/* MOBILE OVERLAY */
.overlay {
    display: none;
    position: fixed;
    inset: 0;
    z-index: 900;
    background: rgba(15, 23, 42, .55);
}

.overlay.show {
    display: block;
}

/* MAIN */
.main {
    min-width: 0;
    margin-left: 300px;
    padding: 30px;
}

.mobile-topbar {
    display: none;
}

/* PAGE HEADER */
.header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 16px;
    margin-bottom: 25px;
}

.eyebrow {
    margin-bottom: 6px;
    color: #4f46e5;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.4px;
    text-transform: uppercase;
}

.header h1 {
    color: #111827;
    font-size: clamp(24px, 2.3vw, 30px);
    line-height: 1.25;
    letter-spacing: -.6px;
}

.header p {
    margin-top: 7px;
    color: var(--muted);
    font-size: 13px;
}

.dashboard-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    min-height: 42px;
    padding: 10px 15px;
    border: 1px solid var(--border);
    border-radius: 10px;
    background: #fff;
    color: #3730a3;
    text-decoration: none;
    font-size: 12px;
    font-weight: 700;
    white-space: nowrap;
    transition: .2s;
}

.dashboard-btn:hover {
    border-color: #c7d2fe;
    background: #eef2ff;
}

/* ALERTS */
.alert {
    padding: 13px 16px;
    margin-bottom: 18px;
    border-radius: 10px;
    font-size: 13px;
    border: 1px solid transparent;
}

.success {
    color: #166534;
    background: #dcfce7;
    border-color: #bbf7d0;
}

.error {
    color: #991b1b;
    background: #fee2e2;
    border-color: #fecaca;
}

/* STAT CARD */
.stat-card {
    display: flex;
    align-items: center;
    gap: 17px;
    padding: 21px;
    margin-bottom: 24px;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    background: #fff;
    box-shadow: var(--shadow);
}

.stat-icon {
    display: grid;
    place-items: center;
    width: 54px;
    height: 54px;
    flex-shrink: 0;
    border-radius: 15px;
    background: #eef2ff;
    font-size: 25px;
}

.stat-card h2 {
    color: #3730a3;
    font-size: 28px;
    line-height: 1.2;
}

.stat-card p {
    margin-top: 5px;
    color: var(--muted);
    font-size: 12px;
}

/* CONTENT */
.content {
    min-width: 0;
    padding: 23px;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    background: #fff;
    box-shadow: var(--shadow);
}

.content-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 18px;
}

.content-header h2 {
    font-size: 18px;
    color: #172033;
}

.count {
    display: inline-flex;
    align-items: center;
    min-height: 29px;
    padding: 6px 12px;
    border-radius: 20px;
    background: #eef2ff;
    color: #4338ca;
    font-size: 11px;
    font-weight: 800;
}

/* SEARCH */
.search-wrap {
    position: relative;
    margin-bottom: 19px;
}

.search-icon {
    position: absolute;
    left: 14px;
    top: 50%;
    transform: translateY(-50%);
    color: #94a3b8;
    pointer-events: none;
}

.search {
    width: 100%;
    min-height: 45px;
    padding: 12px 14px 12px 40px;
    border: 1px solid #dbe2ec;
    border-radius: 10px;
    outline: none;
    background: #fff;
    color: var(--text);
    font-size: 13px;
    transition: border-color .2s, box-shadow .2s;
}

.search:focus {
    border-color: #818cf8;
    box-shadow: 0 0 0 3px rgba(99, 102, 241, .10);
}

/* TABLE */
.table-wrapper {
    width: 100%;
    overflow-x: auto;
    border: 1px solid #edf0f5;
    border-radius: 11px;
    -webkit-overflow-scrolling: touch;
}

table {
    width: 100%;
    min-width: 680px;
    border-collapse: collapse;
    text-align: left;
}

thead {
    background: #f8fafc;
}

th {
    padding: 13px 15px;
    color: #64748b;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .7px;
    text-transform: uppercase;
    white-space: nowrap;
}

td {
    padding: 15px;
    border-top: 1px solid #edf1f6;
    color: #475569;
    font-size: 12px;
    vertical-align: middle;
}

tbody tr {
    transition: background .15s;
}

tbody tr:hover {
    background: #fafbff;
}

/* STAFF INFO */
.staff-info {
    display: flex;
    align-items: center;
    gap: 11px;
    min-width: 195px;
}

.avatar {
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    flex-shrink: 0;
    border-radius: 13px;
    background: #dcfce7;
    color: #15803d;
    font-size: 14px;
    font-weight: 800;
}

.staff-name {
    margin-bottom: 3px;
    color: #1e293b;
    font-size: 12px;
    font-weight: 750;
    overflow-wrap: anywhere;
}

.staff-email {
    color: #94a3b8;
    font-size: 11px;
    overflow-wrap: anywhere;
}

.specialization {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    background: #ecfdf5;
    color: #15803d;
    font-size: 10px;
    font-weight: 800;
    overflow-wrap: anywhere;
}

/* DELETE */
.delete-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 34px;
    padding: 8px 11px;
    border: 1px solid #fecaca;
    border-radius: 8px;
    background: #fff1f2;
    color: #dc2626;
    font-size: 11px;
    font-weight: 750;
    cursor: pointer;
    white-space: nowrap;
    transition: .2s;
}

.delete-btn:hover {
    background: #dc2626;
    color: #fff;
    border-color: #dc2626;
}

/* EMPTY / NO SEARCH RESULTS */
.empty {
    padding: 50px 18px;
    text-align: center;
}

.empty-icon {
    margin-bottom: 12px;
    font-size: 42px;
}

.empty h3 {
    margin-bottom: 7px;
    color: #334155;
    font-size: 17px;
}

.empty p {
    color: #94a3b8;
    font-size: 12px;
    line-height: 1.7;
}

/* RESPONSIVE */
@media (max-width: 1100px) {
    .sidebar {
        width: 260px;
    }

    .main {
        margin-left: 260px;
        padding: 24px;
    }

    .content {
        padding: 19px;
    }
}

@media (max-width: 760px) {
    .sidebar {
        width: min(300px, 86vw);
        transform: translateX(-105%);
        box-shadow: 15px 0 35px rgba(15, 23, 42, .16);
    }

    .sidebar.open {
        transform: translateX(0);
    }

    .main {
        margin-left: 0;
        padding: 16px;
    }

    .mobile-topbar {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        margin: -16px -16px 23px;
        padding: 12px 16px;
        border-bottom: 1px solid var(--border);
        background: #fff;
    }

    .mobile-brand {
        color: #151b30;
        font-size: 22px;
        font-weight: 800;
        letter-spacing: -.7px;
    }

    .mobile-brand span {
        color: #4f46e5;
    }

    .menu-toggle {
        display: inline-grid;
        place-items: center;
        width: 42px;
        height: 42px;
        border: 1px solid var(--border);
        border-radius: 10px;
        background: #fff;
        color: #1e293b;
        font-size: 21px;
        cursor: pointer;
    }

    .mobile-spacer {
        width: 42px;
    }

    .header {
        align-items: flex-start;
    }

    .content {
        padding: 17px;
    }

    .stat-card {
        padding: 17px;
    }
}

@media (max-width: 480px) {
    .main {
        padding: 12px;
    }

    .mobile-topbar {
        margin: -12px -12px 19px;
        padding: 10px 12px;
    }

    .header {
        gap: 13px;
    }

    .header h1 {
        font-size: 24px;
    }

    .header p {
        max-width: 300px;
        font-size: 12px;
        line-height: 1.7;
    }

    .dashboard-btn {
        width: 100%;
    }

    .stat-card {
        gap: 13px;
        margin-bottom: 17px;
    }

    .stat-icon {
        width: 46px;
        height: 46px;
        font-size: 21px;
    }

    .stat-card h2 {
        font-size: 25px;
    }

    .content {
        padding: 14px;
    }

    .content-header h2 {
        font-size: 16px;
    }

    .search {
        font-size: 12px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        scroll-behavior: auto !important;
        transition-duration: .01ms !important;
    }
}
</style>
</head>

<body>

<div class="overlay" id="overlay" aria-hidden="true"></div>

<!-- SIDEBAR -->
<aside class="sidebar" id="sidebar" aria-label="Admin navigation">

    <div class="logo">Smart<span>Fix</span></div>

    <div class="admin-box">
        <div class="admin-avatar" aria-hidden="true">👤</div>
        <h3><%= adminName %></h3>
        <p>Administrator</p>
    </div>

    <div class="menu-heading">MAIN MENU</div>

    <ul class="menu">
        <li>
            <a href="<%= ctx %>/admin/dashboard">
                <span class="menu-icon">⌂</span> Dashboard
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/complaints">
                <span class="menu-icon">▤</span> Complaints
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/users">
                <span class="menu-icon">♙</span> Users
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/staff" class="active">
                <span class="menu-icon">⚒</span> Staff
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/ratings">
                <span class="menu-icon">♧</span> Ratings
            </a>
        </li>
    </ul>

    <div class="menu-heading">ACCOUNT</div>

    <ul class="menu">
        <li>
            <a href="<%= ctx %>/admin/profile">
                <span class="menu-icon">⚙</span> My Profile
            </a>
        </li>

        <li>
            <a class="logout" href="<%= ctx %>/logout">
                <span class="menu-icon">↪</span> Logout
            </a>
        </li>
    </ul>
</aside>

<!-- MAIN CONTENT -->
<main class="main">

    <div class="mobile-topbar">
        <button type="button" class="menu-toggle" id="menuToggle"
                aria-label="Open navigation" aria-controls="sidebar"
                aria-expanded="false">☰</button>

        <div class="mobile-brand">Smart<span>Fix</span></div>

        <div class="mobile-spacer" aria-hidden="true"></div>
    </div>

    <!-- HEADER -->
    <header class="header">
        <div>
            <div class="eyebrow">Overview / Staff</div>
            <h1>Manage Staff</h1>
            <p>View and manage SmartFix service staff members.</p>
        </div>

        <a href="<%= ctx %>/admin/dashboard" class="dashboard-btn">
            ← Dashboard
        </a>
    </header>

    <!-- ALERTS -->
    <%
        String message = request.getParameter("message");
        String error = request.getParameter("error");

        if ("deleted".equals(message)) {
    %>
        <div class="alert success" role="status">
            ✓ Staff member deleted successfully.
        </div>
    <%
        }

        if ("deletefailed".equals(error)) {
    %>
        <div class="alert error" role="alert">
            Staff member could not be deleted. Please try again.
        </div>
    <%
        }

        if ("invalid".equals(error)) {
    %>
        <div class="alert error" role="alert">
            Invalid staff ID.
        </div>
    <%
        }
    %>

    <!-- STAT CARD -->
    <section class="stat-card" aria-label="Total staff">
        <div class="stat-icon" aria-hidden="true">👨‍🔧</div>
        <div>
            <h2><%= totalStaff %></h2>
            <p>Total Staff Members</p>
        </div>
    </section>

    <!-- STAFF LIST -->
    <section class="content">
        <div class="content-header">
            <h2>All Staff Members</h2>
            <span class="count" id="staffCount">
                <%= totalStaff %> Staff
            </span>
        </div>

        <div class="search-wrap">
            <span class="search-icon" aria-hidden="true">⌕</span>
            <input type="search" id="search" class="search"
                   aria-label="Search staff"
                   placeholder="Search name, email, phone or specialization...">
        </div>

        <% if (staffList != null && !staffList.isEmpty()) { %>

        <div class="table-wrapper">
            <table id="staffTable">
                <thead>
                    <tr>
                        <th>Staff Member</th>
                        <th>Phone</th>
                        <th>Specialization</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    for (Staff staff : staffList) {
                        String name = staff.getName() == null
                            ? "" : staff.getName();

                        String email = staff.getEmail() == null
                            ? "" : staff.getEmail();

                        String phone = staff.getPhone() == null
                            || staff.getPhone().trim().isEmpty()
                            ? "Not provided" : staff.getPhone().trim();

                        String specialization =
                            staff.getSpecialization() == null
                            || staff.getSpecialization().trim().isEmpty()
                            ? "General" : staff.getSpecialization().trim();

                        String firstLetter = name.trim().isEmpty()
                            ? "S"
                            : name.trim().substring(0, 1).toUpperCase();
                %>

                    <tr class="staff-row">
                        <td>
                            <div class="staff-info">
                                <div class="avatar"><%= firstLetter %></div>
                                <div>
                                    <div class="staff-name"><%= name %></div>
                                    <div class="staff-email"><%= email %></div>
                                </div>
                            </div>
                        </td>

                        <td><%= phone %></td>

                        <td>
                            <span class="specialization">
                                <%= specialization %>
                            </span>
                        </td>

                        <td>
                            <form method="post"
                                  action="<%= ctx %>/admin/delete-staff"
                                  onsubmit="return confirmDelete();">

                                <input type="hidden" name="staffId"
                                       value="<%= staff.getStaffId() %>">

                                <button type="submit" class="delete-btn">
                                    Delete
                                </button>
                            </form>
                        </td>
                    </tr>

                <% } %>
                </tbody>
            </table>
        </div>

        <div class="empty" id="noResults" hidden>
            <div class="empty-icon">🔎</div>
            <h3>No matching staff</h3>
            <p>Try searching with another name, email, phone number or specialization.</p>
        </div>

        <% } else { %>

        <div class="empty">
            <div class="empty-icon">👨‍🔧</div>
            <h3>No Staff Found</h3>
            <p>No staff records were returned from the database.</p>
        </div>

        <% } %>
    </section>

</main>

<script>
(function () {
    const sidebar = document.getElementById("sidebar");
    const toggle = document.getElementById("menuToggle");
    const overlay = document.getElementById("overlay");

    function openMenu() {
        sidebar.classList.add("open");
        overlay.classList.add("show");
        overlay.setAttribute("aria-hidden", "false");
        toggle.setAttribute("aria-expanded", "true");
        toggle.setAttribute("aria-label", "Close navigation");
        toggle.textContent = "✕";
        document.body.style.overflow = "hidden";
    }

    function closeMenu() {
        sidebar.classList.remove("open");
        overlay.classList.remove("show");
        overlay.setAttribute("aria-hidden", "true");
        toggle.setAttribute("aria-expanded", "false");
        toggle.setAttribute("aria-label", "Open navigation");
        toggle.textContent = "☰";
        document.body.style.overflow = "";
    }

    if (toggle && overlay) {
        toggle.addEventListener("click", function () {
            if (sidebar.classList.contains("open")) {
                closeMenu();
            } else {
                openMenu();
            }
        });

        overlay.addEventListener("click", closeMenu);

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") closeMenu();
        });

        sidebar.querySelectorAll("a").forEach(function (link) {
            link.addEventListener("click", closeMenu);
        });

        window.addEventListener("resize", function () {
            if (window.innerWidth > 760) closeMenu();
        });
    }

    const search = document.getElementById("search");
    const count = document.getElementById("staffCount");
    const rows = Array.from(document.querySelectorAll(".staff-row"));
    const noResults = document.getElementById("noResults");

    if (search && count) {
        search.addEventListener("input", function () {
            const value = this.value.toLowerCase().trim();
            let visible = 0;

            rows.forEach(function (row) {
                const matches = row.innerText.toLowerCase().includes(value);
                row.style.display = matches ? "" : "none";
                if (matches) visible++;
            });

            count.textContent = visible +
                (visible === 1 ? " Staff" : " Staff Members");

            if (noResults) {
                noResults.hidden = visible !== 0;
            }
        });
    }
})();

function confirmDelete() {
    return confirm(
        "Are you sure you want to delete this staff member? This action cannot be undone."
    );
}
</script>

</body>
</html>

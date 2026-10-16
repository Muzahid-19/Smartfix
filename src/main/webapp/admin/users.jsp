
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.smartfix.modelcom.User" %>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null || admin.getRole() == null
            || !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    int totalUsers = users == null ? 0 : users.size();

    String ctx = request.getContextPath();
    String adminName = admin.getName() == null
            || admin.getName().trim().isEmpty()
            ? "SmartFix Admin" : admin.getName().trim();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#151b30">
<title>Manage Users | SmartFix Admin</title>

<style>
:root {
    --sidebar: #151b30;
    --sidebar-card: #272d40;
    --purple: #4034b3;
    --purple-hover: #35299f;
    --page: #f5f7fc;
    --white: #ffffff;
    --text: #172033;
    --muted: #74819a;
    --border: #e5eaf2;
    --green: #15803d;
    --red: #dc2626;
    --shadow: 0 8px 28px rgba(25, 38, 70, .05);
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
    font-family: Inter, "Segoe UI", Arial, sans-serif;
    background: var(--page);
    color: var(--text);
    font-size: 14px;
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

/* ================= SIDEBAR ================= */

.sidebar {
    position: fixed;
    inset: 0 auto 0 0;
    z-index: 1000;
    display: flex;
    flex-direction: column;
    width: 300px;
    padding: 22px 20px;
    overflow-y: auto;
    background: var(--sidebar);
    color: #fff;
    transition: transform .25s ease;
}

.logo {
    padding: 0 15px;
    margin-bottom: 35px;
    font-size: 30px;
    line-height: 1.2;
    font-weight: 800;
    letter-spacing: -1.1px;
}

.logo span {
    color: #818cf8;
}

.admin-box {
    padding: 21px;
    margin-bottom: 29px;
    background: var(--sidebar-card);
    border: 1px solid rgba(255,255,255,.07);
    border-radius: 19px;
    overflow-wrap: anywhere;
}

.admin-avatar {
    display: grid;
    place-items: center;
    width: 53px;
    height: 53px;
    margin-bottom: 16px;
    border-radius: 16px;
    background: #4938d4;
    color: #fff;
    font-size: 24px;
}

.admin-box h3 {
    margin-bottom: 4px;
    font-size: 16px;
    font-weight: 750;
    color: #fff;
}

.admin-box p {
    font-size: 13px;
    color: #aebbd5;
}

.menu-heading {
    padding: 0 16px;
    margin-bottom: 11px;
    color: #8795b5;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.4px;
    text-transform: uppercase;
}

.menu {
    display: flex;
    flex-direction: column;
    gap: 7px;
    list-style: none;
}

.menu a {
    display: flex;
    align-items: center;
    gap: 14px;
    min-height: 50px;
    padding: 13px 17px;
    border: 1px solid transparent;
    border-radius: 13px;
    color: #cbd5e8;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    transition: background .2s, color .2s;
}

.menu-icon {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    width: 20px;
    flex-shrink: 0;
    font-size: 17px;
}

.menu a:hover {
    background: rgba(255,255,255,.07);
    color: #fff;
}

.menu a.active {
    background: var(--purple);
    color: #fff;
}

.menu a.active:hover {
    background: var(--purple-hover);
}

.account-heading {
    margin-top: 29px;
}

.logout-link {
    margin-top: 8px;
    color: #fecaca !important;
}

.logout-link:hover {
    background: rgba(239,68,68,.12) !important;
}

/* ================= MOBILE OVERLAY ================= */

.overlay {
    display: none;
    position: fixed;
    inset: 0;
    z-index: 900;
    background: rgba(15,23,42,.55);
}

.overlay.show {
    display: block;
}

/* ================= MAIN ================= */

.main {
    min-height: 100vh;
    margin-left: 300px;
    padding: 30px;
}

.mobile-topbar {
    display: none;
}

.header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 18px;
    margin-bottom: 27px;
}

.eyebrow {
    margin-bottom: 7px;
    color: #5145cd;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.4px;
    text-transform: uppercase;
}

.header h1 {
    margin-bottom: 7px;
    color: #111b31;
    font-size: 29px;
    line-height: 1.25;
    letter-spacing: -.7px;
}

.header p {
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
    color: #35415a;
    text-decoration: none;
    font-size: 12px;
    font-weight: 700;
    white-space: nowrap;
    transition: .2s;
}

.dashboard-btn:hover {
    border-color: #c7c4ff;
    color: var(--purple);
    background: #f8f7ff;
}

/* ================= ALERTS ================= */

.message {
    padding: 13px 16px;
    margin-bottom: 19px;
    border: 1px solid transparent;
    border-radius: 11px;
    font-size: 13px;
    font-weight: 600;
}

.success {
    color: #166534;
    background: #f0fdf4;
    border-color: #bbf7d0;
}

.error {
    color: #991b1b;
    background: #fef2f2;
    border-color: #fecaca;
}

/* ================= STAT CARD ================= */

.stats {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 17px;
    margin-bottom: 23px;
}

.stat-card {
    display: flex;
    align-items: center;
    gap: 16px;
    min-width: 0;
    padding: 21px;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 16px;
    box-shadow: var(--shadow);
}

.stat-icon {
    display: grid;
    place-items: center;
    width: 49px;
    height: 49px;
    flex-shrink: 0;
    border-radius: 14px;
    background: #eeecff;
    color: var(--purple);
    font-size: 23px;
}

.stat-card h2 {
    margin-bottom: 4px;
    color: #172033;
    font-size: 26px;
    line-height: 1.2;
}

.stat-card p {
    color: var(--muted);
    font-size: 12px;
}

/* ================= USERS PANEL ================= */

.container {
    min-width: 0;
    padding: 23px;
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 17px;
    box-shadow: var(--shadow);
}

.container-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 12px;
    margin-bottom: 19px;
}

.container-header h2 {
    font-size: 18px;
    font-weight: 750;
}

.container-header p {
    margin-top: 4px;
    color: var(--muted);
    font-size: 12px;
}

.user-count {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 31px;
    padding: 7px 12px;
    border-radius: 20px;
    background: #eeecff;
    color: var(--purple);
    font-size: 11px;
    font-weight: 800;
    white-space: nowrap;
}

/* ================= SEARCH ================= */

.search-row {
    display: flex;
    align-items: center;
    gap: 11px;
    margin-bottom: 19px;
}

.search-wrap {
    position: relative;
    flex: 1;
    min-width: 0;
}

.search-icon {
    position: absolute;
    top: 50%;
    left: 14px;
    color: #8995aa;
    font-size: 16px;
    transform: translateY(-50%);
    pointer-events: none;
}

.search {
    width: 100%;
    min-height: 44px;
    padding: 11px 14px 11px 41px;
    border: 1px solid #e0e6ef;
    border-radius: 10px;
    outline: none;
    background: #fff;
    color: var(--text);
    font-size: 12px;
    transition: border-color .2s, box-shadow .2s;
}

.search:focus {
    border-color: #8175ed;
    box-shadow: 0 0 0 3px rgba(79,70,229,.09);
}

.clear-btn {
    min-height: 42px;
    padding: 10px 13px;
    border: 1px solid var(--border);
    border-radius: 9px;
    background: #fff;
    color: #475569;
    cursor: pointer;
    font-size: 12px;
    font-weight: 700;
}

.clear-btn:hover {
    background: #f8fafc;
}

/* ================= TABLE ================= */

.table-container {
    width: 100%;
    overflow-x: auto;
    border: 1px solid #edf0f5;
    border-radius: 12px;
    -webkit-overflow-scrolling: touch;
}

table {
    width: 100%;
    min-width: 850px;
    border-collapse: collapse;
    text-align: left;
}

thead {
    background: #f8f9fd;
}

th {
    padding: 14px 16px;
    color: #7a879e;
    font-size: 10px;
    font-weight: 800;
    letter-spacing: .7px;
    text-transform: uppercase;
    white-space: nowrap;
}

td {
    padding: 15px 16px;
    border-top: 1px solid #edf0f5;
    color: #475569;
    font-size: 12px;
    vertical-align: middle;
    overflow-wrap: anywhere;
}

tbody tr {
    transition: background .15s;
}

tbody tr:hover {
    background: #fafaff;
}

.user {
    display: flex;
    align-items: center;
    gap: 11px;
    min-width: 185px;
}

.avatar {
    display: grid;
    place-items: center;
    width: 40px;
    height: 40px;
    flex-shrink: 0;
    border-radius: 13px;
    background: #eeecff;
    color: #4b3dc3;
    font-size: 14px;
    font-weight: 800;
}

.user-name {
    margin-bottom: 3px;
    color: #1e293b;
    font-size: 12px;
    font-weight: 750;
    overflow-wrap: anywhere;
}

.user-email {
    color: #8995aa;
    font-size: 10px;
    overflow-wrap: anywhere;
}

.room-number, .role {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 6px 9px;
    border-radius: 7px;
    font-size: 10px;
    font-weight: 750;
    white-space: nowrap;
}

.room-number {
    color: #166534;
    background: #f0fdf4;
}

.room-missing {
    color: #64748b;
    background: #f1f5f9;
    font-weight: 500;
}

.role {
    color: #4338ca;
    background: #eeecff;
}

.admin-role {
    color: #92400e;
    background: #fef3c7;
}

.delete-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 6px;
    min-height: 33px;
    padding: 8px 11px;
    border: 1px solid #fecaca;
    border-radius: 8px;
    background: #fff5f5;
    color: #dc2626;
    cursor: pointer;
    font-size: 11px;
    font-weight: 750;
    white-space: nowrap;
    transition: .2s;
}

.delete-btn:hover {
    color: #fff;
    background: #dc2626;
    border-color: #dc2626;
}

.current-user {
    color: #64748b;
    font-size: 10px;
    font-weight: 600;
    white-space: nowrap;
}

.no-results {
    display: none;
    padding: 28px 15px;
    color: #64748b;
    text-align: center;
    font-size: 13px;
}

/* ================= EMPTY STATE ================= */

.empty {
    padding: 48px 15px;
    text-align: center;
}

.empty-icon {
    display: grid;
    place-items: center;
    width: 65px;
    height: 65px;
    margin: 0 auto 15px;
    border-radius: 20px;
    background: #eeecff;
    color: var(--purple);
    font-size: 29px;
}

.empty h3 {
    margin-bottom: 7px;
    color: #334155;
    font-size: 17px;
}

.empty p {
    color: #8995aa;
    font-size: 12px;
}

/* ================= FOOTER ================= */

.table-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 10px;
    padding-top: 16px;
    color: #8995aa;
    font-size: 11px;
}

/* ================= TABLET ================= */

@media (max-width: 1150px) {
    .sidebar {
        width: 260px;
    }

    .main {
        margin-left: 260px;
        padding: 24px;
    }

    .stats {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .stats .stat-card:last-child {
        grid-column: 1 / -1;
    }
}

/* ================= MOBILE ================= */

@media (max-width: 760px) {
    .sidebar {
        width: min(300px, 86vw);
        transform: translateX(-105%);
        box-shadow: 15px 0 35px rgba(15,23,42,.18);
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
        padding: 13px 16px;
        border-bottom: 1px solid var(--border);
        background: #fff;
    }

    .mobile-brand {
        color: #151b30;
        font-size: 23px;
        font-weight: 800;
        letter-spacing: -.8px;
    }

    .mobile-brand span {
        color: #5b50d6;
    }

    .menu-toggle {
        display: inline-grid;
        place-items: center;
        width: 42px;
        height: 42px;
        border: 1px solid var(--border);
        border-radius: 10px;
        background: #fff;
        color: #27334b;
        cursor: pointer;
        font-size: 21px;
    }

    .topbar-space {
        width: 42px;
    }

    .header {
        align-items: flex-start;
        margin-bottom: 20px;
    }

    .header h1 {
        font-size: 25px;
    }

    .header p {
        max-width: 460px;
        line-height: 1.65;
    }

    .dashboard-btn {
        min-height: 39px;
    }

    .container {
        padding: 17px;
    }

    .stat-card {
        padding: 17px;
    }
}

/* ================= SMALL MOBILE ================= */

@media (max-width: 480px) {
    .main {
        padding: 12px;
    }

    .mobile-topbar {
        margin: -12px -12px 19px;
        padding: 11px 12px;
    }

    .mobile-brand {
        font-size: 20px;
    }

    .header {
        flex-direction: column;
        gap: 13px;
    }

    .header h1 {
        font-size: 23px;
    }

    .header p {
        font-size: 12px;
    }

    .dashboard-btn {
        width: 100%;
    }

    .stats {
        grid-template-columns: minmax(0, 1fr);
        gap: 12px;
    }

    .stats .stat-card:last-child {
        grid-column: auto;
    }

    .stat-card {
        padding: 16px;
    }

    .stat-card h2 {
        font-size: 24px;
    }

    .container {
        padding: 14px;
        border-radius: 13px;
    }

    .container-header {
        align-items: flex-start;
    }

    .container-header h2 {
        font-size: 16px;
    }

    .search-row {
        align-items: stretch;
        flex-direction: column;
    }

    .clear-btn {
        width: 100%;
    }

    .table-footer {
        align-items: flex-start;
        flex-direction: column;
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

    <div class="menu-heading">Main Menu</div>

    <ul class="menu">
        <li>
            <a href="<%= ctx %>/admin/dashboard">
                <span class="menu-icon">⌂</span>
                <span>Dashboard</span>
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/complaints">
                <span class="menu-icon">▤</span>
                <span>Complaints</span>
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/users" class="active"
               aria-current="page">
                <span class="menu-icon">♙</span>
                <span>Users</span>
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/staff">
                <span class="menu-icon">⚒</span>
                <span>Staff</span>
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/admin/ratings">
                <span class="menu-icon">♧</span>
                <span>Ratings</span>
            </a>
        </li>
    </ul>

    <div class="menu-heading account-heading">Account</div>

    <ul class="menu">
        <li>
            <a href="<%= ctx %>/admin/profile">
                <span class="menu-icon">⚙</span>
                <span>My Profile</span>
            </a>
        </li>

        <li>
            <a href="<%= ctx %>/logout" class="logout-link">
                <span class="menu-icon">↪</span>
                <span>Logout</span>
            </a>
        </li>
    </ul>

</aside>

<!-- MAIN CONTENT -->
<main class="main">

    <div class="mobile-topbar">
        <button type="button" class="menu-toggle" id="menuToggle"
                aria-label="Open navigation"
                aria-controls="sidebar" aria-expanded="false">☰</button>

        <div class="mobile-brand">Smart<span>Fix</span></div>

        <div class="topbar-space" aria-hidden="true"></div>
    </div>

    <!-- PAGE HEADER -->
    <header class="header">
        <div>
            <div class="eyebrow">Overview / Users</div>
            <h1>Manage Users</h1>
            <p>View, search and manage all registered SmartFix users.</p>
        </div>

        <a class="dashboard-btn" href="<%= ctx %>/admin/dashboard">
            <span aria-hidden="true">←</span>
            Back to Dashboard
        </a>
    </header>

    <!-- ALERTS -->
    <%
        String message = request.getParameter("message");
        String error = request.getParameter("error");

        if ("deleted".equals(message)) {
    %>
        <div class="message success" role="status">
            ✓ User deleted successfully.
        </div>
    <%
        }

        if ("self".equals(error)) {
    %>
        <div class="message error" role="alert">
            You cannot delete your own administrator account.
        </div>
    <%
        }

        if ("deletefailed".equals(error)) {
    %>
        <div class="message error" role="alert">
            The user could not be deleted. Please try again.
        </div>
    <%
        }
    %>

    <!-- STATISTICS -->
    <section class="stats" aria-label="User statistics">
        <div class="stat-card">
            <div class="stat-icon" aria-hidden="true">♙</div>
            <div>
                <h2><%= totalUsers %></h2>
                <p>Total Registered Users</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" aria-hidden="true">✓</div>
            <div>
                <h2 id="visibleCount"><%= totalUsers %></h2>
                <p>Users Matching Search</p>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon" aria-hidden="true">⌕</div>
            <div>
                <h2>Search</h2>
                <p>Find users by name or details</p>
            </div>
        </div>
    </section>

    <!-- USERS TABLE -->
    <section class="container">

        <div class="container-header">
            <div>
                <h2>All Users</h2>
                <p>Review user information and account roles.</p>
            </div>

            <span class="user-count" id="userCount">
                <%= totalUsers %> Users
            </span>
        </div>

        <!-- SEARCH -->
        <div class="search-row">
            <div class="search-wrap">
                <span class="search-icon" aria-hidden="true">⌕</span>
                <input
                    type="search"
                    id="search"
                    class="search"
                    placeholder="Search name, email, phone, room, address or role..."
                    aria-label="Search users">
            </div>

            <button type="button" class="clear-btn" id="clearSearch">
                Clear Search
            </button>
        </div>

        <% if (users != null && !users.isEmpty()) { %>

        <div class="table-container">
            <table id="usersTable">
                <thead>
                    <tr>
                        <th>User</th>
                        <th>Phone</th>
                        <th>Room Number</th>
                        <th>Address</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    for (User user : users) {
                        String name = user.getName() == null
                                ? "" : user.getName().trim();

                        String email = user.getEmail() == null
                                ? "" : user.getEmail().trim();

                        String phone = user.getPhone() == null
                                || user.getPhone().trim().isEmpty()
                                ? "Not provided" : user.getPhone().trim();

                        String roomNumber = user.getRoomNumber() == null
                                || user.getRoomNumber().trim().isEmpty()
                                ? "Not provided" : user.getRoomNumber().trim();

                        String address = user.getAddress() == null
                                || user.getAddress().trim().isEmpty()
                                ? "Not provided" : user.getAddress().trim();

                        String role = user.getRole() == null
                                || user.getRole().trim().isEmpty()
                                ? "USER" : user.getRole().trim();

                        String firstLetter = name.isEmpty()
                                ? "U" : name.substring(0, 1).toUpperCase();

                        boolean roomMissing = "Not provided".equals(roomNumber);
                        boolean isAdmin = "ADMIN".equalsIgnoreCase(role);
                        boolean isCurrentUser =
                                user.getUserId() == admin.getUserId();
                %>

                    <tr class="user-row">
                        <td>
                            <div class="user">
                                <div class="avatar">
                                    <%= firstLetter %>
                                </div>

                                <div>
                                    <div class="user-name"><%= name.isEmpty()
                                            ? "Unnamed User" : name %></div>
                                    <div class="user-email"><%= email.isEmpty()
                                            ? "No email available" : email %></div>
                                </div>
                            </div>
                        </td>

                        <td><%= phone %></td>

                        <td>
                            <span class="room-number <%= roomMissing
                                    ? "room-missing" : "" %>">
                                <%= roomNumber %>
                            </span>
                        </td>

                        <td><%= address %></td>

                        <td>
                            <span class="role <%= isAdmin
                                    ? "admin-role" : "" %>">
                                <%= role %>
                            </span>
                        </td>

                        <td>
                            <% if (isCurrentUser) { %>
                                <span class="current-user">
                                    🔒 Current Account
                                </span>
                            <% } else { %>
                                <form method="post"
                                      action="<%= ctx %>/admin/delete-user"
                                      onsubmit="return confirmDelete(this);">

                                    <input type="hidden" name="userId"
                                           value="<%= user.getUserId() %>">

                                    <button type="submit" class="delete-btn">
                                        🗑 Delete
                                    </button>
                                </form>
                            <% } %>
                        </td>
                    </tr>

                <% } %>
                </tbody>
            </table>
        </div>

        <div class="no-results" id="noResults" role="status">
            No users match your search. Try another name or clear the search.
        </div>

        <div class="table-footer">
            <span id="resultSummary">
                Showing <%= totalUsers %> users
            </span>
            <span>SmartFix Administration</span>
        </div>

        <% } else { %>

        <div class="empty">
            <div class="empty-icon" aria-hidden="true">♙</div>
            <h3>No Users Found</h3>
            <p>There are currently no users to display.</p>
        </div>

        <% } %>

    </section>
</main>

<script>
(function () {
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("overlay");
    const menuToggle = document.getElementById("menuToggle");

    function openMenu() {
        sidebar.classList.add("open");
        overlay.classList.add("show");
        overlay.setAttribute("aria-hidden", "false");
        menuToggle.setAttribute("aria-expanded", "true");
        menuToggle.setAttribute("aria-label", "Close navigation");
        menuToggle.textContent = "✕";
        document.body.style.overflow = "hidden";
    }

    function closeMenu() {
        sidebar.classList.remove("open");
        overlay.classList.remove("show");
        overlay.setAttribute("aria-hidden", "true");
        menuToggle.setAttribute("aria-expanded", "false");
        menuToggle.setAttribute("aria-label", "Open navigation");
        menuToggle.textContent = "☰";
        document.body.style.overflow = "";
    }

    menuToggle.addEventListener("click", function () {
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
})();

/* USER SEARCH */
(function () {
    const search = document.getElementById("search");
    const clearSearch = document.getElementById("clearSearch");
    const userCount = document.getElementById("userCount");
    const visibleCount = document.getElementById("visibleCount");
    const resultSummary = document.getElementById("resultSummary");
    const noResults = document.getElementById("noResults");
    const rows = Array.from(document.querySelectorAll(".user-row"));
    const total = rows.length;

    function filterUsers() {
        const query = search.value.toLowerCase().trim();
        let visible = 0;

        rows.forEach(function (row) {
            const matches = row.innerText.toLowerCase().includes(query);

            row.style.display = matches ? "" : "none";

            if (matches) visible++;
        });

        userCount.textContent =
            visible + (visible === 1 ? " User" : " Users");

        visibleCount.textContent = visible;

        resultSummary.textContent =
            "Showing " + visible + " of " + total + " users";

        noResults.style.display =
            total > 0 && visible === 0 ? "block" : "none";
    }

    search.addEventListener("input", filterUsers);

    clearSearch.addEventListener("click", function () {
        search.value = "";
        filterUsers();
        search.focus();
    });
})();

/* DELETE CONFIRMATION */
function confirmDelete(form) {
    const userId = form.querySelector('input[name="userId"]').value;

    return confirm(
        "Are you sure you want to delete this user?\n\n" +
        "User ID: " + userId +
        "\n\nThis action may not be reversible."
    );
}
</script>

</body>
</html>

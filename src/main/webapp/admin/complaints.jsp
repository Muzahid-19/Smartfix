
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.smartfix.modelcom.User" %>
<%@ page import="com.smartfix.modelcom.Staff" %>
<%@ page import="com.smartfix.modelcom.Complaint" %>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null || admin.getRole() == null
            || !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Complaint> complaints =
            (List<Complaint>) request.getAttribute("complaints");

    List<Staff> staffList =
            (List<Staff>) request.getAttribute("staffList");

    Map<Integer, String> roomNumbers =
            (Map<Integer, String>) request.getAttribute("roomNumbers");

    int totalComplaints = complaints == null ? 0 : complaints.size();
    int pendingCount = 0;
    int assignedCount = 0;
    int progressCount = 0;
    int resolvedCount = 0;

    if (complaints != null) {
        for (Complaint c : complaints) {
            String status = c.getStatus();

            if (status == null) status = "PENDING";

            if ("PENDING".equalsIgnoreCase(status)) {
                pendingCount++;
            } else if ("ASSIGNED".equalsIgnoreCase(status)) {
                assignedCount++;
            } else if ("IN PROGRESS".equalsIgnoreCase(status)) {
                progressCount++;
            } else if ("RESOLVED".equalsIgnoreCase(status)) {
                resolvedCount++;
            }
        }
    }

    String message = request.getParameter("message");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Manage Complaints | SmartFix Admin</title>

<style>
:root {
    --primary: #2563eb;
    --primary-dark: #1d4ed8;
    --sidebar: #101828;
    --sidebar-light: #1e293b;
    --bg: #f5f7fb;
    --surface: #ffffff;
    --text: #172033;
    --muted: #718096;
    --border: #e7ebf2;
    --green: #15803d;
    --red: #dc2626;
    --amber: #b45309;
    --purple: #7c3aed;
    --radius: 16px;
    --shadow: 0 6px 24px rgba(15, 23, 42, .045);
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Inter, "Segoe UI", Arial, sans-serif;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
}

body.menu-open {
    overflow: hidden;
}

a {
    color: inherit;
}

button, input, select {
    font: inherit;
}

button, a, select {
    -webkit-tap-highlight-color: transparent;
}

button:focus-visible,
a:focus-visible,
input:focus-visible,
select:focus-visible {
    outline: 3px solid rgba(37, 99, 235, .3);
    outline-offset: 2px;
}

/* Sidebar */

.sidebar {
    position: fixed;
    inset: 0 auto 0 0;
    width: 252px;
    background: var(--sidebar);
    color: #fff;
    padding: 25px 16px;
    display: flex;
    flex-direction: column;
    z-index: 1000;
    transition: transform .28s ease;
    overflow-y: auto;
}

.logo {
    font-size: 27px;
    font-weight: 800;
    letter-spacing: -.8px;
    padding: 0 14px 8px;
}

.logo span {
    color: #60a5fa;
}

.logo-subtitle {
    color: #98a5b9;
    font-size: 11px;
    padding: 0 15px 32px;
    letter-spacing: .5px;
}

.admin-label {
    color: #8190a6;
    font-size: 10px;
    font-weight: 700;
    letter-spacing: 1.6px;
    text-transform: uppercase;
    padding: 0 14px 12px;
}

.nav {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.nav a {
    text-decoration: none;
    color: #bdc7d7;
    display: flex;
    align-items: center;
    gap: 13px;
    padding: 12px 14px;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 500;
    transition: background .2s, color .2s;
}

.nav-icon {
    width: 22px;
    text-align: center;
    font-size: 17px;
}

.nav a:hover {
    color: #fff;
    background: rgba(255, 255, 255, .07);
}

.nav a.active {
    color: #fff;
    background: #2458d3;
    box-shadow: 0 5px 14px rgba(37, 99, 235, .2);
}

.nav .logout {
    margin-top: 22px;
    color: #fca5a5;
}

.sidebar-footer {
    margin-top: auto;
    padding: 24px 10px 0;
}

.admin-mini {
    display: flex;
    align-items: center;
    gap: 10px;
    border-top: 1px solid rgba(255,255,255,.1);
    padding-top: 18px;
}

.admin-avatar {
    width: 38px;
    height: 38px;
    display: grid;
    place-items: center;
    border-radius: 12px;
    background: #243e70;
    color: #dbeafe;
    font-weight: 800;
}

.admin-mini strong {
    display: block;
    font-size: 12px;
    margin-bottom: 4px;
}

.admin-mini small {
    color: #94a3b8;
    font-size: 11px;
}

/* Main layout */

.main {
    margin-left: 252px;
    padding: 30px 34px 40px;
    min-width: 0;
}

.mobile-topbar {
    display: none;
}

.page-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    margin-bottom: 27px;
}

.heading-left {
    display: flex;
    align-items: flex-start;
    gap: 13px;
}

.page-heading h1 {
    color: #152039;
    font-size: clamp(24px, 2vw, 30px);
    letter-spacing: -.8px;
    font-weight: 800;
    margin-bottom: 7px;
}

.page-heading p {
    color: var(--muted);
    font-size: 13px;
    line-height: 1.6;
}

.total-pill {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    white-space: nowrap;
    padding: 11px 16px;
    background: #eaf1ff;
    color: #1d4ed8;
    border: 1px solid #d7e4ff;
    border-radius: 12px;
    font-size: 12px;
    font-weight: 750;
}

.total-pill strong {
    font-size: 17px;
}

/* Alerts */

.alert {
    padding: 14px 17px;
    border-radius: 12px;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 13px;
    font-weight: 600;
}

.alert-success {
    background: #ecfdf3;
    color: #166534;
    border: 1px solid #bbf7d0;
}

.alert-error {
    background: #fff1f2;
    color: #be123c;
    border: 1px solid #fecdd3;
}

/* Summary cards */

.summary-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 16px;
    margin-bottom: 25px;
}

.summary-card {
    min-width: 0;
    background: var(--surface);
    padding: 20px;
    border: 1px solid var(--border);
    border-radius: var(--radius);
    box-shadow: var(--shadow);
}

.summary-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
    margin-bottom: 17px;
}

.summary-label {
    color: var(--muted);
    font-size: 12px;
    font-weight: 600;
}

.summary-icon {
    width: 39px;
    height: 39px;
    display: grid;
    place-items: center;
    border-radius: 12px;
    font-size: 19px;
}

.icon-blue { background: #eaf1ff; }
.icon-amber { background: #fff5dc; }
.icon-purple { background: #f0eaff; }
.icon-green { background: #e6f8ed; }

.summary-number {
    font-size: 30px;
    line-height: 1;
    font-weight: 800;
    letter-spacing: -1px;
    color: #172033;
}

.summary-caption {
    font-size: 11px;
    color: #94a3b8;
    margin-top: 9px;
}

/* General cards */

.card {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    box-shadow: var(--shadow);
    margin-bottom: 22px;
    min-width: 0;
}

.filter-card {
    padding: 23px;
}

.section-heading {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    margin-bottom: 18px;
}

.section-heading h2 {
    font-size: 16px;
    color: #18243a;
    font-weight: 750;
}

.section-heading p {
    font-size: 12px;
    color: var(--muted);
    margin-top: 5px;
}

.filters {
    display: grid;
    grid-template-columns: minmax(220px, 2fr) minmax(130px, .85fr)
        minmax(140px, .95fr) auto;
    gap: 12px;
    align-items: center;
}

.search-wrap {
    position: relative;
    min-width: 0;
}

.search-icon {
    position: absolute;
    left: 13px;
    top: 50%;
    transform: translateY(-50%);
    color: #94a3b8;
    font-size: 16px;
    pointer-events: none;
}

.search-box,
.filter-select {
    width: 100%;
    min-width: 0;
    height: 44px;
    padding: 0 13px;
    border: 1px solid #dfe5ee;
    border-radius: 10px;
    outline: none;
    background: #fff;
    color: #334155;
    font-size: 12px;
    transition: border-color .2s, box-shadow .2s;
}

.search-box {
    padding-left: 39px;
}

.search-box::placeholder {
    color: #9aa5b5;
}

.search-box:focus,
.filter-select:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, .09);
}

.reset-btn {
    height: 44px;
    padding: 0 17px;
    border: 1px solid #dfe5ee;
    border-radius: 10px;
    background: #f8fafc;
    color: #475569;
    font-size: 12px;
    font-weight: 700;
    cursor: pointer;
    transition: .2s;
}

.reset-btn:hover {
    background: #edf2f7;
    border-color: #cbd5e1;
}

/* Table */

.table-card {
    overflow: hidden;
}

.table-heading {
    padding: 22px 24px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 14px;
    border-bottom: 1px solid var(--border);
}

.table-heading h2 {
    font-size: 16px;
    color: #18243a;
    font-weight: 750;
}

.table-heading p {
    font-size: 12px;
    color: var(--muted);
    margin-top: 5px;
}

.visible-count {
    background: #f1f5f9;
    color: #475569;
    padding: 8px 12px;
    border-radius: 9px;
    white-space: nowrap;
    font-size: 11px;
    font-weight: 700;
}

.table-wrapper {
    width: 100%;
    overflow-x: auto;
    overscroll-behavior-x: contain;
    scrollbar-width: thin;
    scrollbar-color: #cbd5e1 #f8fafc;
}

table {
    width: 100%;
    min-width: 1150px;
    border-collapse: separate;
    border-spacing: 0;
}

thead th {
    background: #f8fafc;
    color: #718096;
    text-transform: uppercase;
    letter-spacing: .55px;
    font-size: 10px;
    font-weight: 800;
    padding: 15px 14px;
    text-align: left;
    border-bottom: 1px solid var(--border);
    white-space: nowrap;
}

tbody td {
    padding: 17px 14px;
    border-bottom: 1px solid #edf0f5;
    color: #475569;
    font-size: 12px;
    vertical-align: middle;
}

tbody tr:last-child td {
    border-bottom: none;
}

tbody tr {
    transition: background .18s;
}

tbody tr:hover {
    background: #f8fbff;
}

.complaint-title {
    color: #172033;
    font-size: 12px;
    font-weight: 750;
    line-height: 1.5;
    max-width: 210px;
    overflow-wrap: anywhere;
}

.complaint-id {
    font-size: 10px;
    color: #94a3b8;
    margin-top: 5px;
    font-weight: 600;
}

.user-id {
    color: #475569;
    font-weight: 650;
}

.room-number {
    display: inline-block;
    padding: 7px 9px;
    border-radius: 8px;
    background: #eff6ff;
    color: #1d4ed8;
    font-size: 11px;
    font-weight: 750;
    white-space: nowrap;
}

.category-text {
    color: #475569;
    font-weight: 600;
}

/* Badges */

.badge {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    padding: 7px 10px;
    border-radius: 30px;
    font-size: 10px;
    font-weight: 800;
    white-space: nowrap;
}

.badge-dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: currentColor;
}

.priority-high {
    background: #fff0f0;
    color: #dc2626;
}

.priority-medium {
    background: #fff7e5;
    color: #b45309;
}

.priority-low {
    background: #eaf8ef;
    color: #15803d;
}

.priority-default {
    background: #f1f5f9;
    color: #475569;
}

.status-pending {
    background: #fff7e5;
    color: #a16207;
}

.status-assigned {
    background: #eaf1ff;
    color: #1d4ed8;
}

.status-progress {
    background: #f1eaff;
    color: #7c3aed;
}

.status-resolved {
    background: #e6f8ed;
    color: #15803d;
}

.status-default {
    background: #f1f5f9;
    color: #475569;
}

/* Assignment */

.assign-box {
    min-width: 205px;
}

.assigned-staff {
    margin-bottom: 9px;
    padding: 8px 9px;
    border-radius: 8px;
    background: #f0fdf4;
    color: #166534;
    font-size: 11px;
    font-weight: 700;
    overflow-wrap: anywhere;
}

.assigned-label {
    font-size: 9px;
    color: #64856e;
    margin-bottom: 4px;
    text-transform: uppercase;
    letter-spacing: .5px;
}

.assign-form {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.staff-select {
    width: 100%;
    height: 36px;
    padding: 0 9px;
    border: 1px solid #dfe5ee;
    border-radius: 8px;
    background: white;
    color: #475569;
    font-size: 11px;
    outline: none;
}

.staff-select:focus {
    border-color: var(--primary);
}

.assign-btn {
    min-height: 35px;
    width: 100%;
    padding: 8px 12px;
    border: none;
    border-radius: 8px;
    background: var(--primary);
    color: white;
    font-size: 11px;
    font-weight: 750;
    cursor: pointer;
    transition: background .2s, transform .2s;
}

.assign-btn:hover {
    background: var(--primary-dark);
}

.assign-btn:active {
    transform: scale(.98);
}

.assign-btn:disabled {
    opacity: .6;
    cursor: not-allowed;
}

/* Actions */

.actions {
    min-width: 120px;
}

.view-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 7px;
    min-height: 36px;
    padding: 8px 12px;
    border-radius: 9px;
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #dbeafe;
    text-decoration: none;
    white-space: nowrap;
    font-size: 11px;
    font-weight: 750;
    transition: .2s;
}

.view-btn:hover {
    background: #dbeafe;
}

/* Empty state */

.empty-box {
    padding: 65px 20px;
    text-align: center;
}

.empty-icon {
    width: 70px;
    height: 70px;
    margin: 0 auto 18px;
    display: grid;
    place-items: center;
    border-radius: 22px;
    background: #f1f5f9;
    font-size: 30px;
}

.empty-box h3 {
    color: #253149;
    font-size: 17px;
    margin-bottom: 9px;
}

.empty-box p {
    color: #8a96a8;
    font-size: 12px;
    line-height: 1.7;
}

/* No filter results */

.no-results {
    display: none;
    text-align: center;
    padding: 28px 15px;
    color: #718096;
    font-size: 13px;
    border-top: 1px solid var(--border);
}

/* Mobile overlay and menu */

.sidebar-overlay {
    display: none;
}

.menu-toggle {
    display: none;
    width: 42px;
    height: 42px;
    border: 1px solid var(--border);
    background: white;
    border-radius: 11px;
    cursor: pointer;
    font-size: 20px;
    color: #1e293b;
    flex-shrink: 0;
}

@media (max-width: 1250px) {
    .main {
        padding: 26px 24px 35px;
    }

    .summary-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .filters {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .reset-btn {
        width: 100%;
    }
}

@media (max-width: 900px) {
    .sidebar {
        transform: translateX(-100%);
        width: 270px;
        box-shadow: none;
    }

    .sidebar.open {
        transform: translateX(0);
        box-shadow: 12px 0 45px rgba(15, 23, 42, .18);
    }

    .sidebar-overlay.show {
        display: block;
        position: fixed;
        inset: 0;
        background: rgba(15, 23, 42, .45);
        z-index: 900;
    }

    .main {
        margin-left: 0;
        padding: 20px 22px 32px;
    }

    .mobile-topbar {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 25px;
    }

    .mobile-brand {
        font-size: 20px;
        font-weight: 800;
        letter-spacing: -.5px;
    }

    .mobile-brand span {
        color: var(--primary);
    }

    .menu-toggle {
        display: grid;
        place-items: center;
    }

    .page-heading {
        margin-bottom: 22px;
    }
}

@media (max-width: 600px) {
    .main {
        padding: 15px 13px 25px;
    }

    .mobile-topbar {
        margin-bottom: 22px;
    }

    .page-heading {
        align-items: flex-start;
        flex-direction: column;
        gap: 13px;
    }

    .page-heading h1 {
        font-size: 25px;
    }

    .page-heading p {
        font-size: 12px;
    }

    .total-pill {
        padding: 9px 13px;
    }

    .summary-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 10px;
        margin-bottom: 17px;
    }

    .summary-card {
        padding: 15px 13px;
        border-radius: 13px;
    }

    .summary-top {
        margin-bottom: 13px;
        align-items: flex-start;
    }

    .summary-label {
        font-size: 11px;
        line-height: 1.5;
    }

    .summary-icon {
        width: 32px;
        height: 32px;
        font-size: 16px;
        border-radius: 10px;
        flex-shrink: 0;
    }

    .summary-number {
        font-size: 27px;
    }

    .summary-caption {
        font-size: 10px;
        line-height: 1.5;
    }

    .card {
        border-radius: 13px;
        margin-bottom: 16px;
    }

    .filter-card {
        padding: 17px 14px;
    }

    .section-heading {
        margin-bottom: 15px;
    }

    .section-heading h2,
    .table-heading h2 {
        font-size: 15px;
    }

    .filters {
        grid-template-columns: 1fr;
        gap: 10px;
    }

    .search-box,
    .filter-select,
    .reset-btn {
        height: 45px;
        font-size: 12px;
    }

    .table-heading {
        padding: 17px 14px;
        align-items: flex-start;
    }

    .table-heading p {
        max-width: 220px;
        line-height: 1.5;
    }

    .visible-count {
        font-size: 10px;
        padding: 7px 8px;
    }

    .empty-box {
        padding: 45px 16px;
    }

    .empty-icon {
        width: 58px;
        height: 58px;
        font-size: 25px;
        border-radius: 17px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        scroll-behavior: auto !important;
        transition-duration: .01ms !important;
        animation-duration: .01ms !important;
    }
}
</style>
</head>

<body>

<!-- Mobile sidebar backdrop -->
<div class="sidebar-overlay" id="sidebarOverlay"
     onclick="closeSidebar()"></div>

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">

    <div class="logo">Smart<span>Fix</span></div>
    <div class="logo-subtitle">SERVICE MANAGEMENT SYSTEM</div>

    <div class="admin-label">Workspace</div>

    <nav class="nav">
        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
            <span class="nav-icon">▦</span> Dashboard
        </a>

        <a class="active"
           href="<%= request.getContextPath() %>/admin/complaints"
           aria-current="page">
            <span class="nav-icon">▤</span> Complaints
        </a>

        <a href="<%= request.getContextPath() %>/admin/users">
            <span class="nav-icon">♙</span> Users
        </a>

        <a href="<%= request.getContextPath() %>/admin/staff">
            <span class="nav-icon">⚒</span> Staff
        </a>

        <a href="<%= request.getContextPath() %>/admin/ratings">
            <span class="nav-icon">☆</span> Ratings
        </a>

        <a href="<%= request.getContextPath() %>/admin/profile">
            <span class="nav-icon">⚙</span> Profile
        </a>

        <a class="logout"
           href="<%= request.getContextPath() %>/logout">
            <span class="nav-icon">↪</span> Logout
        </a>
    </nav>

    <div class="sidebar-footer">
        <div class="admin-mini">
            <div class="admin-avatar">A</div>
            <div>
                <strong>Administrator</strong>
                <small>Manage your workspace</small>
            </div>
        </div>
    </div>
</aside>

<!-- Main -->
<main class="main">

    <div class="mobile-topbar">
        <button type="button" class="menu-toggle"
                id="menuToggle"
                aria-label="Open navigation menu"
                aria-controls="sidebar"
                aria-expanded="false"
                onclick="toggleSidebar()">☰</button>
        <div class="mobile-brand">Smart<span>Fix</span></div>
    </div>

    <!-- Page heading -->
    <header class="page-heading">
        <div class="heading-left">
            <div>
                <h1>Manage Complaints</h1>
                <p>Review service requests, assign staff, and track resolutions.</p>
            </div>
        </div>

        <div class="total-pill">
            <span>All Complaints</span>
            <strong><%= totalComplaints %></strong>
        </div>
    </header>

    <!-- Feedback messages -->
    <% if ("assigned".equalsIgnoreCase(message)) { %>
        <div class="alert alert-success" role="status">
            <span>✓</span> Complaint assigned successfully.
        </div>
    <% } else if ("updated".equalsIgnoreCase(message)) { %>
        <div class="alert alert-success" role="status">
            <span>✓</span> Complaint updated successfully.
        </div>
    <% } %>

    <% if ("assignfailed".equalsIgnoreCase(error)) { %>
        <div class="alert alert-error" role="alert">
            <span>!</span> Complaint assignment failed. Please try again.
        </div>
    <% } else if ("invalid".equalsIgnoreCase(error)) { %>
        <div class="alert alert-error" role="alert">
            <span>!</span> Invalid complaint or staff information.
        </div>
    <% } %>

    <!-- Summary cards -->
    <section class="summary-grid" aria-label="Complaint summary">

        <div class="summary-card">
            <div class="summary-top">
                <span class="summary-label">Total Complaints</span>
                <span class="summary-icon icon-blue">▤</span>
            </div>
            <div class="summary-number"><%= totalComplaints %></div>
            <div class="summary-caption">All recorded requests</div>
        </div>

        <div class="summary-card">
            <div class="summary-top">
                <span class="summary-label">Pending</span>
                <span class="summary-icon icon-amber">◷</span>
            </div>
            <div class="summary-number"><%= pendingCount %></div>
            <div class="summary-caption">Waiting for assignment</div>
        </div>

        <div class="summary-card">
            <div class="summary-top">
                <span class="summary-label">In Progress</span>
                <span class="summary-icon icon-purple">↻</span>
            </div>
            <div class="summary-number"><%= progressCount %></div>
            <div class="summary-caption">Currently being handled</div>
        </div>

        <div class="summary-card">
            <div class="summary-top">
                <span class="summary-label">Resolved</span>
                <span class="summary-icon icon-green">✓</span>
            </div>
            <div class="summary-number"><%= resolvedCount %></div>
            <div class="summary-caption">Successfully completed</div>
        </div>

    </section>

    <!-- Search and filters -->
    <section class="card filter-card">
        <div class="section-heading">
            <div>
                <h2>Find a Complaint</h2>
                <p>Search and filter requests to find what you need.</p>
            </div>
        </div>

        <div class="filters">
            <div class="search-wrap">
                <span class="search-icon" aria-hidden="true">⌕</span>
                <input type="search"
                       id="searchInput"
                       class="search-box"
                       placeholder="Search title, ID, category, room..."
                       aria-label="Search complaints"
                       autocomplete="off">
            </div>

            <select id="priorityFilter" class="filter-select"
                    aria-label="Filter by priority">
                <option value="">All Priorities</option>
                <option value="HIGH">High Priority</option>
                <option value="MEDIUM">Medium Priority</option>
                <option value="LOW">Low Priority</option>
            </select>

            <select id="statusFilter" class="filter-select"
                    aria-label="Filter by status">
                <option value="">All Statuses</option>
                <option value="PENDING">Pending</option>
                <option value="ASSIGNED">Assigned</option>
                <option value="IN PROGRESS">In Progress</option>
                <option value="RESOLVED">Resolved</option>
            </select>

            <button type="button" class="reset-btn"
                    onclick="resetFilters()">Reset filters</button>
        </div>
    </section>

    <!-- Complaint list -->
    <section class="card table-card">

        <div class="table-heading">
            <div>
                <h2>Complaint List</h2>
                <p>View complaint details and manage staff assignments.</p>
            </div>

            <div class="visible-count" aria-live="polite">
                Showing <span id="visibleCount"><%= totalComplaints %></span>
            </div>
        </div>

        <% if (complaints == null || complaints.isEmpty()) { %>

            <div class="empty-box">
                <div class="empty-icon">📭</div>
                <h3>No complaints yet</h3>
                <p>New service requests will appear here when users submit them.</p>
            </div>

        <% } else { %>

            <div class="table-wrapper">
                <table id="complaintsTable">
                    <thead>
                        <tr>
                            <th>Complaint</th>
                            <th>User</th>
                            <th>Room</th>
                            <th>Category</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Assign Staff</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>
                    <% for (Complaint complaint : complaints) {

                        String complaintPriority = complaint.getPriority();
                        if (complaintPriority == null
                                || complaintPriority.trim().isEmpty()) {
                            complaintPriority = "LOW";
                        }
                        complaintPriority = complaintPriority.trim().toUpperCase();

                        String priorityClass = "default";
                        if ("HIGH".equals(complaintPriority)) {
                            priorityClass = "high";
                        } else if ("MEDIUM".equals(complaintPriority)) {
                            priorityClass = "medium";
                        } else if ("LOW".equals(complaintPriority)) {
                            priorityClass = "low";
                        }

                        String complaintStatus = complaint.getStatus();
                        if (complaintStatus == null
                                || complaintStatus.trim().isEmpty()) {
                            complaintStatus = "PENDING";
                        }
                        complaintStatus = complaintStatus.trim().toUpperCase();

                        String statusClass = "default";
                        if ("PENDING".equals(complaintStatus)) {
                            statusClass = "pending";
                        } else if ("ASSIGNED".equals(complaintStatus)) {
                            statusClass = "assigned";
                        } else if ("IN PROGRESS".equals(complaintStatus)) {
                            statusClass = "progress";
                        } else if ("RESOLVED".equals(complaintStatus)) {
                            statusClass = "resolved";
                        }

                        String roomNumber = "Not provided";
                        if (roomNumbers != null) {
                            String savedRoom =
                                roomNumbers.get(complaint.getComplaintId());

                            if (savedRoom != null
                                    && !savedRoom.trim().isEmpty()) {
                                roomNumber = savedRoom.trim();
                            }
                        }

                        String title = complaint.getTitle() == null
                                ? "Untitled Complaint" : complaint.getTitle();

                        String category = complaint.getCategory() == null
                                ? "Not specified" : complaint.getCategory();

                        String searchData =
                                complaint.getComplaintId() + " "
                                + title + " " + category + " "
                                + roomNumber + " "
                                + complaintPriority + " "
                                + complaintStatus;
                    %>

                        <tr class="complaint-row"
                            data-search="<%= searchData.replace("&", "&amp;")
                                .replace("\"", "&quot;")
                                .replace("<", "&lt;")
                                .replace(">", "&gt;") %>"
                            data-priority="<%= complaintPriority %>"
                            data-status="<%= complaintStatus %>">

                            <td>
                                <div class="complaint-title"><%= title %></div>
                                <div class="complaint-id">
                                    ID #<%= complaint.getComplaintId() %>
                                </div>
                            </td>

                            <td>
                                <span class="user-id">
                                    #<%= complaint.getUserId() %>
                                </span>
                            </td>

                            <td>
                                <span class="room-number"><%= roomNumber %></span>
                            </td>

                            <td>
                                <span class="category-text"><%= category %></span>
                            </td>

                            <td>
                                <span class="badge priority-<%= priorityClass %>">
                                    <span class="badge-dot"></span>
                                    <%= complaintPriority %>
                                </span>
                            </td>

                            <td>
                                <span class="badge status-<%= statusClass %>">
                                    <span class="badge-dot"></span>
                                    <%= complaintStatus %>
                                </span>
                            </td>

                            <td>
                                <%= complaint.getCreatedAt() == null
                                    ? "N/A" : complaint.getCreatedAt() %>
                            </td>

                            <td class="assign-box">

                                <% if (complaint.getStaffId() != null) { %>
                                    <div class="assigned-staff">
                                        <div class="assigned-label">Currently assigned</div>
                                        Staff #<%= complaint.getStaffId() %>
                                    </div>
                                <% } %>

                                <form class="assign-form"
                                      action="<%= request.getContextPath() %>/admin/assign-complaint"
                                      method="post">

                                    <input type="hidden" name="complaintId"
                                           value="<%= complaint.getComplaintId() %>">

                                    <select name="staffId"
                                            class="staff-select"
                                            aria-label="Select staff for complaint <%= complaint.getComplaintId() %>"
                                            required>

                                        <option value="">Select staff member</option>

                                        <% if (staffList != null && !staffList.isEmpty()) {
                                            for (Staff staff : staffList) {
                                        %>
                                            <option value="<%= staff.getStaffId() %>"
                                                <%= complaint.getStaffId() != null
                                                    && complaint.getStaffId().intValue()
                                                        == staff.getStaffId()
                                                    ? "selected" : "" %>>
                                                <%= staff.getName() %><%
                                                    if (staff.getSpecialization() != null
                                                            && !staff.getSpecialization()
                                                                .trim().isEmpty()) {
                                                %> - <%= staff.getSpecialization() %><%
                                                    }
                                                %>
                                            </option>
                                        <%  }
                                           } else { %>
                                            <option value="" disabled>No staff available</option>
                                        <% } %>
                                    </select>

                                    <button type="submit" class="assign-btn"
                                        <%= staffList == null || staffList.isEmpty()
                                            ? "disabled" : "" %>>
                                        <%= complaint.getStaffId() != null
                                            ? "Reassign Staff" : "Assign Staff" %>
                                    </button>
                                </form>
                            </td>

                            <td>
                                <div class="actions">
                                    <a class="view-btn"
                                       href="<%= request.getContextPath() %>/admin/complaint-details?id=<%= complaint.getComplaintId() %>">
                                        <span>↗</span> View Details
                                    </a>
                                </div>
                            </td>

                        </tr>

                    <% } %>
                    </tbody>
                </table>
            </div>

            <div class="no-results" id="noResults">
                No complaints match your search. Try changing your filters.
            </div>

        <% } %>

    </section>

</main>

<script>
const sidebar = document.getElementById("sidebar");
const overlay = document.getElementById("sidebarOverlay");
const menuToggle = document.getElementById("menuToggle");

function toggleSidebar() {
    const isOpen = sidebar.classList.contains("open");

    if (isOpen) {
        closeSidebar();
    } else {
        sidebar.classList.add("open");
        overlay.classList.add("show");
        document.body.classList.add("menu-open");
        menuToggle.setAttribute("aria-expanded", "true");
        menuToggle.setAttribute("aria-label", "Close navigation menu");
    }
}

function closeSidebar() {
    sidebar.classList.remove("open");
    overlay.classList.remove("show");
    document.body.classList.remove("menu-open");

    if (menuToggle) {
        menuToggle.setAttribute("aria-expanded", "false");
        menuToggle.setAttribute("aria-label", "Open navigation menu");
    }
}

document.addEventListener("keydown", function(event) {
    if (event.key === "Escape") {
        closeSidebar();
    }
});

window.addEventListener("resize", function() {
    if (window.innerWidth > 900) {
        closeSidebar();
    }
});

/* Complaint search and filters */
const searchInput = document.getElementById("searchInput");
const priorityFilter = document.getElementById("priorityFilter");
const statusFilter = document.getElementById("statusFilter");

function filterComplaints() {
    const searchText = searchInput.value.toLowerCase().trim();
    const selectedPriority = priorityFilter.value.toUpperCase();
    const selectedStatus = statusFilter.value.toUpperCase();

    const rows = document.querySelectorAll(".complaint-row");
    const visibleCount = document.getElementById("visibleCount");
    const noResults = document.getElementById("noResults");

    let visible = 0;

    rows.forEach(function(row) {
        const rowSearch = (row.dataset.search || "").toLowerCase();
        const rowPriority = (row.dataset.priority || "").toUpperCase();
        const rowStatus = (row.dataset.status || "").toUpperCase();

        const matchesSearch = rowSearch.includes(searchText);
        const matchesPriority =
            selectedPriority === "" || rowPriority === selectedPriority;
        const matchesStatus =
            selectedStatus === "" || rowStatus === selectedStatus;

        const matches =
            matchesSearch && matchesPriority && matchesStatus;

        row.style.display = matches ? "" : "none";

        if (matches) {
            visible++;
        }
    });

    visibleCount.textContent = visible;

    if (noResults) {
        noResults.style.display =
            rows.length > 0 && visible === 0 ? "block" : "none";
    }
}

function resetFilters() {
    searchInput.value = "";
    priorityFilter.value = "";
    statusFilter.value = "";
    filterComplaints();
}

searchInput.addEventListener("input", filterComplaints);
priorityFilter.addEventListener("change", filterComplaints);
statusFilter.addEventListener("change", filterComplaints);

/* Prevent accidental duplicate submissions */
document.querySelectorAll(".assign-form").forEach(function(form) {
    form.addEventListener("submit", function() {
        const button = form.querySelector(".assign-btn");

        if (form.dataset.submitting === "true") {
            return;
        }

        form.dataset.submitting = "true";

        if (button) {
            button.disabled = true;
            button.textContent = "Submitting...";
        }
    });
});
</script>

</body>
</html>

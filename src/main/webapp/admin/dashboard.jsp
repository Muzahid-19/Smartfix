
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.smartfix.modelcom.User"%>
<%@ page import="com.smartfix.modelcom.Complaint"%>
<%@ page import="java.util.List"%>

<%!
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);

        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
%>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null || admin.getRole() == null
            || !"ADMIN".equalsIgnoreCase(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String contextPath = request.getContextPath();

    String adminName = admin.getName() != null
            && !admin.getName().trim().isEmpty()
            ? admin.getName().trim() : "Admin";

    Integer totalComplaints =
            (Integer) request.getAttribute("totalComplaints");
    Integer pendingComplaints =
            (Integer) request.getAttribute("pendingComplaints");
    Integer resolvedComplaints =
            (Integer) request.getAttribute("resolvedComplaints");
    Integer totalUsers =
            (Integer) request.getAttribute("totalUsers");

    int total = totalComplaints != null ? totalComplaints : 0;
    int pending = pendingComplaints != null ? pendingComplaints : 0;
    int resolved = resolvedComplaints != null ? resolvedComplaints : 0;
    int users = totalUsers != null ? totalUsers : 0;

    List<Complaint> recentComplaints =
            (List<Complaint>) request.getAttribute("recentComplaints");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard | SmartFix</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --sidebar: #151b30;
    --sidebar-hover: #282f48;
    --primary: #4034b8;
    --primary-light: #eeeaff;
    --bg: #f3f5fb;
    --text: #17213b;
    --muted: #71809d;
    --border: #e2e8f3;
    --white: #ffffff;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: var(--bg);
    color: var(--text);
}

a {
    text-decoration: none;
}

.layout {
    min-height: 100vh;
}

.sidebar {
    width: 300px;
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    overflow-y: auto;
    padding: 24px 21px;
    background: var(--sidebar);
    color: white;
    z-index: 1000;
    transition: transform .25s ease;
}

.brand {
    display: flex;
    align-items: center;
    padding: 0 14px;
    margin-bottom: 42px;
    font-size: 29px;
    font-weight: 800;
    letter-spacing: -1px;
}

.brand span {
    color: #8177ff;
}

.admin-card {
    padding: 22px;
    background: rgba(255,255,255,.07);
    border: 1px solid rgba(255,255,255,.09);
    border-radius: 18px;
    margin-bottom: 33px;
}

.admin-avatar {
    width: 54px;
    height: 54px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 15px;
    background: var(--primary);
    font-size: 25px;
    margin-bottom: 18px;
}

.admin-card h3 {
    font-size: 17px;
    margin-bottom: 8px;
}

.admin-card p {
    color: #b9c4df;
    font-size: 14px;
}

.menu-title {
    color: #8392b4;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 1.3px;
    margin: 27px 16px 14px;
}

.menu a {
    min-height: 55px;
    display: flex;
    align-items: center;
    gap: 17px;
    padding: 15px 20px;
    margin-bottom: 7px;
    border-radius: 13px;
    color: #d6def2;
    font-size: 15px;
    font-weight: 600;
    transition: background .2s, color .2s, transform .2s;
}

.menu a:hover {
    background: var(--sidebar-hover);
    color: white;
    transform: translateX(3px);
}

.menu a.active {
    background: var(--primary);
    color: white;
}

.menu-icon {
    width: 22px;
    text-align: center;
    font-size: 19px;
    flex-shrink: 0;
}

.main {
    margin-left: 300px;
    padding: 30px;
    min-width: 0;
}

.mobile-topbar {
    display: none;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 20px;
}

.menu-toggle {
    border: 0;
    background: var(--primary);
    color: white;
    padding: 10px 14px;
    border-radius: 9px;
    font-size: 19px;
    cursor: pointer;
}

.welcome {
    padding: 33px;
    border-radius: 22px;
    background: linear-gradient(120deg, #ffffff, #eeedff);
    border: 1px solid var(--border);
    margin-bottom: 27px;
}

.eyebrow {
    color: #5749d4;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 1.8px;
    margin-bottom: 12px;
}

.welcome h1 {
    font-size: clamp(25px, 3vw, 35px);
    margin-bottom: 10px;
}

.welcome p {
    color: var(--muted);
    line-height: 1.7;
    font-size: 15px;
}

.stats {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 18px;
    margin-bottom: 30px;
}

.stat-card {
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 18px;
    padding: 23px;
    box-shadow: 0 5px 20px rgba(28, 39, 75, .035);
}

.stat-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    margin-bottom: 22px;
}

.stat-label {
    color: var(--muted);
    font-size: 13px;
    font-weight: 600;
}

.stat-icon {
    width: 43px;
    height: 43px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 13px;
    font-size: 21px;
}

.icon-purple { background: #eeebff; }
.icon-orange { background: #fff2df; }
.icon-green { background: #e2f8ed; }
.icon-blue { background: #e3efff; }

.stat-value {
    font-size: 34px;
    font-weight: 800;
    margin-bottom: 8px;
}

.stat-description {
    color: var(--muted);
    font-size: 12px;
}

.section-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 15px;
    margin-bottom: 18px;
}

.section-heading h2 {
    font-size: 21px;
}

.section-heading p {
    margin-top: 7px;
    color: var(--muted);
    font-size: 14px;
}

.btn {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
    border: 0;
    border-radius: 10px;
    padding: 12px 17px;
    background: var(--primary);
    color: white;
    font-weight: 700;
    font-size: 13px;
    cursor: pointer;
    transition: .2s;
}

.btn:hover {
    background: #31269c;
    transform: translateY(-1px);
}

.btn-light {
    color: var(--primary);
    background: var(--primary-light);
}

.btn-light:hover {
    background: #dfd9ff;
}

.panel {
    background: white;
    border: 1px solid var(--border);
    border-radius: 18px;
    padding: 24px;
    box-shadow: 0 5px 20px rgba(28, 39, 75, .035);
    margin-bottom: 25px;
}

.table-wrap {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 650px;
}

th {
    text-align: left;
    padding: 15px 13px;
    background: #f7f8fc;
    color: #65728e;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: .5px;
}

td {
    padding: 17px 13px;
    border-bottom: 1px solid #edf0f7;
    font-size: 13px;
    vertical-align: middle;
}

tr:last-child td {
    border-bottom: 0;
}

.status {
    display: inline-block;
    padding: 7px 10px;
    border-radius: 30px;
    font-size: 11px;
    font-weight: 700;
    background: #fff0d8;
    color: #a45b00;
}

.status.resolved {
    background: #dcf8e8;
    color: #147747;
}

.status.assigned {
    background: #e4efff;
    color: #2458aa;
}

.status.progress {
    background: #eee8ff;
    color: #6443bd;
}

.empty {
    padding: 35px 15px;
    text-align: center;
    color: var(--muted);
    font-size: 14px;
}

.quick-actions {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 16px;
}

.quick-action {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 19px;
    border: 1px solid var(--border);
    border-radius: 14px;
    color: var(--text);
    transition: .2s;
}

.quick-action:hover {
    border-color: #b9b0ff;
    background: #faf9ff;
    transform: translateY(-2px);
}

.quick-icon {
    width: 45px;
    height: 45px;
    border-radius: 13px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--primary-light);
    font-size: 21px;
    flex-shrink: 0;
}

.quick-action strong {
    display: block;
    font-size: 14px;
    margin-bottom: 5px;
}

.quick-action small {
    color: var(--muted);
    font-size: 12px;
}

.footer {
    padding: 10px 0 5px;
    text-align: center;
    color: var(--muted);
    font-size: 12px;
}

.overlay {
    display: none;
}

@media (max-width: 1200px) {
    .stats {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .quick-actions {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 850px) {
    .sidebar {
        transform: translateX(-100%);
        width: 285px;
    }

    body.menu-open .sidebar {
        transform: translateX(0);
    }

    .main {
        margin-left: 0;
        padding: 22px;
    }

    .mobile-topbar {
        display: flex;
    }

    body.menu-open .overlay {
        display: block;
        position: fixed;
        inset: 0;
        background: rgba(10, 15, 30, .45);
        z-index: 900;
    }
}

@media (max-width: 520px) {
    .main {
        padding: 14px;
    }

    .welcome {
        padding: 22px;
    }

    .stats {
        grid-template-columns: 1fr;
    }

    .panel {
        padding: 16px;
    }

    .section-heading {
        align-items: flex-start;
    }
}
</style>
</head>

<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand">Smart<span>Fix</span></div>

        <div class="admin-card">
            <div class="admin-avatar">👤</div>
            <h3>SmartFix Admin</h3>
            <p><%= escapeHtml(adminName) %> · Administrator</p>
        </div>

        <div class="menu-title">Main Menu</div>

        <nav class="menu">
            <a class="active" href="<%= contextPath %>/admin/dashboard">
                <span class="menu-icon">⌂</span>
                <span>Dashboard</span>
            </a>

            <a href="<%= contextPath %>/admin/complaints">
                <span class="menu-icon">▤</span>
                <span>Complaints</span>
            </a>

            <a href="<%= contextPath %>/admin/users">
                <span class="menu-icon">♟</span>
                <span>Users</span>
            </a>

            <a href="<%= contextPath %>/admin/staff">
                <span class="menu-icon">⚒</span>
                <span>Staff</span>
            </a>

            <a href="<%= contextPath %>/admin/notifications">
                <span class="menu-icon">♧</span>
                <span>Notifications</span>
            </a>

            <a href="<%= contextPath %>/admin/ratings">
                <span class="menu-icon">⭐</span>
                <span>Ratings &amp; Feedback</span>
            </a>
        </nav>

        <div class="menu-title">Account</div>

        <nav class="menu">
            <a href="<%= contextPath %>/admin/profile">
                <span class="menu-icon">⚙</span>
                <span>My Profile</span>
            </a>

            <a href="<%= contextPath %>/logout">
                <span class="menu-icon">⇥</span>
                <span>Logout</span>
            </a>
        </nav>
    </aside>

    <div class="overlay" id="overlay"></div>

    <main class="main">

        <div class="mobile-topbar">
            <strong>SmartFix Admin</strong>
            <button class="menu-toggle" id="menuToggle"
                    type="button" aria-label="Toggle navigation">☰</button>
        </div>

        <section class="welcome">
            <div class="eyebrow">OVERVIEW</div>
            <h1>Welcome back, <%= escapeHtml(adminName) %>!</h1>
            <p>
                Manage complaints, users, staff and service requests
                from your SmartFix administration dashboard.
            </p>
        </section>

        <section class="stats">
            <article class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Total Complaints</span>
                    <span class="stat-icon icon-purple">📋</span>
                </div>
                <div class="stat-value"><%= total %></div>
                <div class="stat-description">All submitted complaints</div>
            </article>

            <article class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Pending Complaints</span>
                    <span class="stat-icon icon-orange">⏳</span>
                </div>
                <div class="stat-value"><%= pending %></div>
                <div class="stat-description">Awaiting action</div>
            </article>

            <article class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Resolved Complaints</span>
                    <span class="stat-icon icon-green">✓</span>
                </div>
                <div class="stat-value"><%= resolved %></div>
                <div class="stat-description">Successfully completed</div>
            </article>

            <article class="stat-card">
                <div class="stat-top">
                    <span class="stat-label">Registered Users</span>
                    <span class="stat-icon icon-blue">👥</span>
                </div>
                <div class="stat-value"><%= users %></div>
                <div class="stat-description">SmartFix user accounts</div>
            </article>
        </section>

        <section>
            <div class="section-heading">
                <div>
                    <h2>Complaint Management</h2>
                    <p>Review requests and track service progress.</p>
                </div>

                <a class="btn" href="<%= contextPath %>/admin/complaints">
                    View All Complaints →
                </a>
            </div>

            <div class="panel">
                <div class="table-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>Complaint ID</th>
                                <th>Title</th>
                                <th>Category</th>
                                <th>Priority</th>
                                <th>Status</th>
                            </tr>
                        </thead>

                        <tbody>
                        <%
                            if (recentComplaints != null
                                    && !recentComplaints.isEmpty()) {

                                for (Complaint complaint : recentComplaints) {
                                    if (complaint == null) {
                                        continue;
                                    }

                                    String status = complaint.getStatus() != null
                                            ? complaint.getStatus() : "Pending";

                                    String normalizedStatus = status.trim()
                                            .replace(' ', '_').toUpperCase();

                                    String statusClass = "";

                                    if ("RESOLVED".equals(normalizedStatus)) {
                                        statusClass = "resolved";
                                    } else if ("ASSIGNED".equals(normalizedStatus)) {
                                        statusClass = "assigned";
                                    } else if ("IN_PROGRESS".equals(normalizedStatus)) {
                                        statusClass = "progress";
                                    }
                        %>
                            <tr>
                                <%-- Correct getter from Complaint.java --%>
                                <td>#<%= complaint.getComplaintId() %></td>

                                <td><%= escapeHtml(
                                        complaint.getTitle() != null
                                        ? complaint.getTitle() : "Untitled") %></td>

                                <td><%= escapeHtml(
                                        complaint.getCategory() != null
                                        ? complaint.getCategory() : "General") %></td>

                                <td><%= escapeHtml(
                                        complaint.getPriority() != null
                                        ? complaint.getPriority() : "Normal") %></td>

                                <td>
                                    <span class="status <%= statusClass %>">
                                        <%= escapeHtml(status) %>
                                    </span>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="5" class="empty">
                                    No recent complaints are available.
                                    <br><br>
                                    <a class="btn btn-light"
                                       href="<%= contextPath %>/admin/complaints">
                                        Open Complaints
                                    </a>
                                </td>
                            </tr>
                        <%
                            }
                        %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <section>
            <div class="section-heading">
                <div>
                    <h2>Quick Actions</h2>
                    <p>Open the section you need.</p>
                </div>
            </div>

            <div class="panel">
                <div class="quick-actions">

                    <a class="quick-action"
                       href="<%= contextPath %>/admin/complaints">
                        <span class="quick-icon">📋</span>
                        <span>
                            <strong>Manage Complaints</strong>
                            <small>Review and update requests</small>
                        </span>
                    </a>

                    <a class="quick-action"
                       href="<%= contextPath %>/admin/users">
                        <span class="quick-icon">👥</span>
                        <span>
                            <strong>Manage Users</strong>
                            <small>View registered accounts</small>
                        </span>
                    </a>

                    <a class="quick-action"
                       href="<%= contextPath %>/admin/ratings">
                        <span class="quick-icon">⭐</span>
                        <span>
                            <strong>Ratings &amp; Feedback</strong>
                            <small>Review customer satisfaction</small>
                        </span>
                    </a>

                </div>
            </div>
        </section>

        <footer class="footer">
            SmartFix Admin Panel · Manage services with confidence.
        </footer>

    </main>
</div>

<script>
const menuToggle = document.getElementById("menuToggle");
const overlay = document.getElementById("overlay");

if (menuToggle) {
    menuToggle.addEventListener("click", function () {
        document.body.classList.toggle("menu-open");
    });
}

if (overlay) {
    overlay.addEventListener("click", function () {
        document.body.classList.remove("menu-open");
    });
}

document.querySelectorAll(".sidebar .menu a").forEach(function (link) {
    link.addEventListener("click", function () {
        document.body.classList.remove("menu-open");
    });
});
</script>

</body>
</html>


<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.smartfix.modelcom.Staff" %>
<%@ page import="com.smartfix.modelcom.Complaint" %>

<%
    Staff staff = (Staff) session.getAttribute("staff");

    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Complaint> complaints =
        (List<Complaint>) request.getAttribute("complaints");

    Map<Integer, String> roomNumbers =
        (Map<Integer, String>) request.getAttribute("roomNumbers");

    int unreadCount = request.getAttribute("unreadCount") != null
        ? (Integer) request.getAttribute("unreadCount") : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Complaints - SmartFix</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    background: #f4f7fb;
    color: #1e293b;
    min-height: 100vh;
}

/* SIDEBAR */
.sidebar {
    position: fixed;
    left: 0;
    top: 0;
    width: 250px;
    height: 100vh;
    background: linear-gradient(180deg, #0f172a, #172554);
    color: white;
    padding: 25px 16px;
    z-index: 100;
}

.logo {
    font-size: 27px;
    font-weight: bold;
    padding: 0 14px 30px;
}

.logo span {
    color: #60a5fa;
}

.staff-label {
    padding: 0 14px 20px;
    color: #94a3b8;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.nav {
    display: flex;
    flex-direction: column;
    gap: 7px;
}

.nav a {
    text-decoration: none;
    color: #cbd5e1;
    padding: 13px 15px;
    border-radius: 11px;
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 14px;
    transition: .25s;
}

.nav a:hover,
.nav a.active {
    background: rgba(59, 130, 246, .18);
    color: white;
    transform: translateX(3px);
}

.logout {
    margin-top: 20px;
    color: #fca5a5 !important;
}

/* MAIN */
.main {
    margin-left: 250px;
    padding: 30px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 20px;
    margin-bottom: 25px;
    flex-wrap: wrap;
}

.topbar h1 {
    font-size: 28px;
    color: #0f172a;
    margin-bottom: 7px;
}

.topbar p {
    color: #64748b;
    font-size: 14px;
}

.staff-badge {
    background: #dbeafe;
    color: #1d4ed8;
    padding: 10px 17px;
    border-radius: 30px;
    font-size: 13px;
    font-weight: bold;
    white-space: nowrap;
}

/* WELCOME */
.welcome-card {
    background: linear-gradient(135deg, #2563eb, #1d4ed8);
    color: white;
    border-radius: 20px;
    padding: 25px;
    margin-bottom: 25px;
    box-shadow: 0 12px 30px rgba(37, 99, 235, .18);
}

.welcome-card h2 {
    font-size: 21px;
    margin-bottom: 7px;
}

.welcome-card p {
    color: #dbeafe;
    font-size: 14px;
}

/* FILTER */
.filter-card {
    background: white;
    border-radius: 18px;
    padding: 22px;
    margin-bottom: 25px;
    box-shadow: 0 8px 28px rgba(15, 23, 42, .06);
    border: 1px solid #edf1f6;
}

.filter-title {
    font-size: 17px;
    font-weight: bold;
    color: #0f172a;
    margin-bottom: 15px;
}

.filters {
    display: grid;
    grid-template-columns: 2fr 1fr 1fr auto;
    gap: 12px;
}

.search-input,
.filter-select {
    width: 100%;
    padding: 12px 14px;
    border: 1px solid #dbe2ea;
    border-radius: 10px;
    outline: none;
    background: white;
    font-size: 14px;
}

.search-input:focus,
.filter-select:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, .10);
}

.reset-btn {
    border: none;
    padding: 12px 18px;
    border-radius: 10px;
    background: #e2e8f0;
    color: #334155;
    font-weight: bold;
    cursor: pointer;
    transition: .25s;
}

.reset-btn:hover {
    background: #cbd5e1;
}

/* TABLE */
.table-card {
    background: white;
    border-radius: 18px;
    padding: 24px;
    box-shadow: 0 8px 28px rgba(15, 23, 42, .06);
    border: 1px solid #edf1f6;
}

.table-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
    flex-wrap: wrap;
}

.table-header h2 {
    font-size: 19px;
    color: #0f172a;
}

.visible-count {
    color: #64748b;
    font-size: 13px;
}

.table-wrapper {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 1200px;
    border-collapse: collapse;
}

thead {
    background: #f8fafc;
}

th {
    padding: 14px 12px;
    text-align: left;
    font-size: 11px;
    color: #64748b;
    text-transform: uppercase;
    letter-spacing: .5px;
    border-bottom: 1px solid #e2e8f0;
    white-space: nowrap;
}

td {
    padding: 16px 12px;
    font-size: 13px;
    border-bottom: 1px solid #edf2f7;
    vertical-align: middle;
}

tbody tr {
    transition: .2s;
}

tbody tr:hover {
    background: #f8fafc;
}

.complaint-title {
    font-weight: bold;
    color: #0f172a;
    max-width: 230px;
}

.complaint-id {
    color: #94a3b8;
    font-size: 11px;
    margin-top: 4px;
}

.room-number {
    display: inline-block;
    background: #eff6ff;
    color: #1d4ed8;
    padding: 7px 11px;
    border-radius: 8px;
    font-size: 12px;
    font-weight: bold;
    white-space: nowrap;
}

.description {
    color: #64748b;
    max-width: 230px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

/* BADGES */
.badge {
    display: inline-block;
    padding: 6px 11px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: bold;
    white-space: nowrap;
}

.priority-high {
    background: #fee2e2;
    color: #dc2626;
}

.priority-medium {
    background: #fef3c7;
    color: #d97706;
}

.priority-low {
    background: #dcfce7;
    color: #15803d;
}

.status-pending {
    background: #fef3c7;
    color: #a16207;
}

.status-assigned {
    background: #dbeafe;
    color: #2563eb;
}

.status-progress {
    background: #ede9fe;
    color: #7c3aed;
}

.status-resolved {
    background: #dcfce7;
    color: #15803d;
}

/* ACTION */
.view-btn {
    display: inline-block;
    padding: 9px 14px;
    border-radius: 9px;
    background: #eff6ff;
    color: #2563eb;
    text-decoration: none;
    font-size: 11px;
    font-weight: bold;
    transition: .25s;
    white-space: nowrap;
}

.view-btn:hover {
    background: #dbeafe;
    transform: translateY(-2px);
}

/* EMPTY */
.empty-box {
    text-align: center;
    padding: 70px 20px;
}

.empty-icon {
    font-size: 55px;
    margin-bottom: 15px;
}

.empty-box h3 {
    color: #334155;
    margin-bottom: 8px;
}

.empty-box p {
    color: #94a3b8;
    font-size: 14px;
}

/* RESPONSIVE */
@media (max-width: 1100px) {
    .sidebar {
        width: 210px;
    }

    .main {
        margin-left: 210px;
        padding: 22px;
    }

    .filters {
        grid-template-columns: 1fr 1fr;
    }
}

@media (max-width: 750px) {
    .sidebar {
        position: relative;
        width: 100%;
        height: auto;
    }

    .main {
        margin-left: 0;
        padding: 18px;
    }

    .topbar {
        flex-direction: column;
        align-items: flex-start;
    }

    .filters {
        grid-template-columns: 1fr;
    }
}
</style>
</head>

<body>

<!-- SIDEBAR -->
<aside class="sidebar">

    <div class="logo">Smart<span>Fix</span></div>

    <div class="staff-label">Staff Panel</div>

    <nav class="nav">

        <a href="<%= request.getContextPath() %>/staff/dashboard">
            📊 Dashboard
        </a>

        <a class="active"
           href="<%= request.getContextPath() %>/staff/complaints">
            📋 My Complaints
        </a>

        <a href="<%= request.getContextPath() %>/notifications">
            🔔 Notifications
            <% if (unreadCount > 0) { %>
                (<%= unreadCount %>)
            <% } %>
        </a>

        <a href="<%= request.getContextPath() %>/staff/profile">
            👤 My Profile
        </a>

        <a href="<%= request.getContextPath() %>/logout" class="logout">
            🚪 Logout
        </a>

    </nav>
</aside>

<!-- MAIN -->
<main class="main">

    <div class="topbar">
        <div>
            <h1>My Assigned Complaints</h1>
            <p>Manage and resolve complaints assigned to you.</p>
        </div>

        <div class="staff-badge">
            🛠️ <%= staff.getName() %>
        </div>
    </div>

    <div class="welcome-card">
        <h2>Welcome, <%= staff.getName() %> 👋</h2>
        <p>
            Here you can view the complaints assigned to you,
            track their status and update their progress.
        </p>
    </div>

    <!-- FILTER -->
    <div class="filter-card">

        <div class="filter-title">🔍 Search &amp; Filter</div>

        <div class="filters">

            <input type="text"
                   id="searchInput"
                   class="search-input"
                   placeholder="Search complaint..."
                   onkeyup="filterComplaints()">

            <select id="priorityFilter"
                    class="filter-select"
                    onchange="filterComplaints()">
                <option value="">All Priorities</option>
                <option value="HIGH">High</option>
                <option value="MEDIUM">Medium</option>
                <option value="LOW">Low</option>
            </select>

            <select id="statusFilter"
                    class="filter-select"
                    onchange="filterComplaints()">
                <option value="">All Status</option>
                <option value="PENDING">Pending</option>
                <option value="ASSIGNED">Assigned</option>
                <option value="IN PROGRESS">In Progress</option>
                <option value="RESOLVED">Resolved</option>
            </select>

            <button type="button"
                    class="reset-btn"
                    onclick="resetFilters()">
                Reset
            </button>

        </div>
    </div>

    <!-- COMPLAINT TABLE -->
    <div class="table-card">

        <div class="table-header">
            <h2>📋 Assigned Complaints</h2>

            <div class="visible-count">
                Showing <span id="visibleCount"><%= complaints == null ? 0 : complaints.size() %></span>
                complaints
            </div>
        </div>

        <% if (complaints == null || complaints.isEmpty()) { %>

            <div class="empty-box">
                <div class="empty-icon">📭</div>
                <h3>No Complaints Assigned</h3>
                <p>You currently don't have any complaints assigned to you.</p>
            </div>

        <% } else { %>

            <div class="table-wrapper">

                <table id="complaintsTable">

                    <thead>
                        <tr>
                            <th>Complaint</th>
                            <th>Room Number</th>
                            <th>Category</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Created</th>
                            <th>Action</th>
                        </tr>
                    </thead>

                    <tbody>

                    <% for (Complaint complaint : complaints) {

                        String priority = complaint.getPriority();
                        if (priority == null || priority.trim().isEmpty()) {
                            priority = "LOW";
                        } else {
                            priority = priority.trim();
                        }

                        String status = complaint.getStatus();
                        if (status == null || status.trim().isEmpty()) {
                            status = "ASSIGNED";
                        } else {
                            status = status.trim();
                        }

                        String priorityClass = "priority-low";
                        if ("HIGH".equalsIgnoreCase(priority)) {
                            priorityClass = "priority-high";
                        } else if ("MEDIUM".equalsIgnoreCase(priority)) {
                            priorityClass = "priority-medium";
                        }

                        String statusClass = "status-assigned";
                        if ("IN PROGRESS".equalsIgnoreCase(status)
                                || "IN_PROGRESS".equalsIgnoreCase(status)) {
                            statusClass = "status-progress";
                        } else if ("RESOLVED".equalsIgnoreCase(status)) {
                            statusClass = "status-resolved";
                        } else if ("PENDING".equalsIgnoreCase(status)) {
                            statusClass = "status-pending";
                        }

                        String roomNumber = "Not provided";
                        if (roomNumbers != null) {
                            String value = roomNumbers.get(complaint.getComplaintId());
                            if (value != null && !value.trim().isEmpty()) {
                                roomNumber = value.trim();
                            }
                        }

                        String searchText =
                            (complaint.getComplaintId() + " " +
                             (complaint.getTitle() == null ? "" : complaint.getTitle()) + " " +
                             (complaint.getCategory() == null ? "" : complaint.getCategory()) + " " +
                             (complaint.getDescription() == null ? "" : complaint.getDescription()) + " " +
                             roomNumber).toLowerCase();

                    %>

                        <tr class="complaint-row"
                            data-search="<%= searchText.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") %>"
                            data-priority="<%= priority.toUpperCase() %>"
                            data-status="<%= status.toUpperCase() %>">

                            <td>
                                <div class="complaint-title">
                                    <%= complaint.getTitle() == null
                                        ? "Untitled Complaint" : complaint.getTitle() %>
                                </div>

                                <div class="complaint-id">
                                    Complaint #<%= complaint.getComplaintId() %>
                                </div>
                            </td>

                            <td>
                                <span class="room-number"><%= roomNumber %></span>
                            </td>

                            <td>
                                <%= complaint.getCategory() == null
                                    ? "Not specified" : complaint.getCategory() %>
                            </td>

                            <td>
                                <span class="badge <%= priorityClass %>">
                                    <%= priority %>
                                </span>
                            </td>

                            <td>
                                <span class="badge <%= statusClass %>">
                                    <%= status %>
                                </span>
                            </td>

                            <td>
                                <%= complaint.getCreatedAt() == null
                                    ? "N/A" : complaint.getCreatedAt() %>
                            </td>

                            <td>
                                <a class="view-btn"
                                   href="<%= request.getContextPath() %>/staff/complaint-details?id=<%= complaint.getComplaintId() %>">
                                    👁 View &amp; Manage
                                </a>
                            </td>

                        </tr>

                    <% } %>

                    </tbody>
                </table>

            </div>

        <% } %>

    </div>

</main>

<script>
function filterComplaints() {

    const search = document.getElementById("searchInput")
        .value.toLowerCase().trim();

    const priority = document.getElementById("priorityFilter")
        .value.toUpperCase();

    const status = document.getElementById("statusFilter")
        .value.toUpperCase();

    const rows = document.querySelectorAll(".complaint-row");
    let visible = 0;

    rows.forEach(function(row) {

        const searchText = row.getAttribute("data-search").toLowerCase();
        const rowPriority = row.getAttribute("data-priority").toUpperCase();
        const rowStatus = row.getAttribute("data-status").toUpperCase();

        const searchMatch = search === "" || searchText.includes(search);
        const priorityMatch = priority === "" || rowPriority === priority;
        const statusMatch = status === "" ||
            rowStatus.replace("_", " ") === status.replace("_", " ");

        if (searchMatch && priorityMatch && statusMatch) {
            row.style.display = "";
            visible++;
        } else {
            row.style.display = "none";
        }
    });

    document.getElementById("visibleCount").textContent = visible;
}

function resetFilters() {
    document.getElementById("searchInput").value = "";
    document.getElementById("priorityFilter").value = "";
    document.getElementById("statusFilter").value = "";
    filterComplaints();
}
</script>

</body>
</html>

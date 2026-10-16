
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.smartfix.modelcom.Staff" %>
<%@ page import="com.smartfix.modelcom.Complaint" %>

<%
    // Always load the dashboard through the servlet first.
    if (request.getAttribute("total") == null
            || request.getAttribute("complaints") == null) {
        response.sendRedirect(
            request.getContextPath() + "/staff/dashboard"
        );
        return;
    }

    Staff staff = (Staff) session.getAttribute("staff");

    if (staff == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    List<Complaint> complaints =
        (List<Complaint>) request.getAttribute("complaints");

    Map<Integer, String> roomNumbers =
        (Map<Integer, String>) request.getAttribute("roomNumbers");

    Integer totalValue = (Integer) request.getAttribute("total");
    Integer assignedValue = (Integer) request.getAttribute("assigned");
    Integer inProgressValue = (Integer) request.getAttribute("inProgress");
    Integer resolvedValue = (Integer) request.getAttribute("resolved");
    Integer pendingValue = (Integer) request.getAttribute("pending");
    Integer unreadValue = (Integer) request.getAttribute("unreadCount");

    int total = totalValue != null ? totalValue : 0;
    int assigned = assignedValue != null ? assignedValue : 0;
    int inProgress = inProgressValue != null ? inProgressValue : 0;
    int resolved = resolvedValue != null ? resolvedValue : 0;
    int pending = pendingValue != null ? pendingValue : 0;
    int unreadCount = unreadValue != null ? unreadValue : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SmartFix - Staff Dashboard</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, Helvetica, sans-serif;
}

body {
    background: #f4f7fb;
    color: #263238;
}

.sidebar {
    width: 250px;
    height: 100vh;
    background: #172337;
    color: #fff;
    position: fixed;
    top: 0;
    left: 0;
    padding: 25px 18px;
}

.logo {
    font-size: 25px;
    font-weight: bold;
    margin-bottom: 8px;
}

.sidebar-subtitle {
    color: #aebbd0;
    font-size: 13px;
    margin-bottom: 35px;
}

.nav-links {
    list-style: none;
}

.nav-links li {
    margin-bottom: 10px;
}

.nav-links a {
    display: block;
    padding: 13px 15px;
    border-radius: 8px;
    color: #dce4f0;
    text-decoration: none;
    font-size: 15px;
    transition: background 0.2s ease;
}

.nav-links a:hover,
.nav-links a.active {
    background: #2864dc;
    color: #fff;
}

.main-content {
    margin-left: 250px;
    padding: 30px;
}

.topbar {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 28px;
    flex-wrap: wrap;
}

.page-title {
    font-size: 28px;
    color: #172337;
    margin-bottom: 7px;
}

.welcome-text {
    color: #718096;
    font-size: 14px;
}

.staff-info {
    background: #fff;
    padding: 12px 18px;
    border-radius: 10px;
    box-shadow: 0 3px 12px rgba(0,0,0,.05);
    font-size: 14px;
}

.staff-info strong {
    color: #2864dc;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(5, minmax(130px, 1fr));
    gap: 18px;
    margin-bottom: 30px;
}

.stat-card {
    background: #fff;
    padding: 22px;
    border-radius: 12px;
    box-shadow: 0 4px 14px rgba(0,0,0,.04);
    border-left: 4px solid #2864dc;
}

.stat-card.assigned { border-left-color: #f59e0b; }
.stat-card.progress { border-left-color: #6366f1; }
.stat-card.resolved { border-left-color: #16a34a; }
.stat-card.pending { border-left-color: #ef4444; }

.stat-number {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: 8px;
    color: #172337;
}

.stat-label {
    color: #718096;
    font-size: 13px;
}

.content-card {
    background: #fff;
    border-radius: 12px;
    padding: 24px;
    box-shadow: 0 4px 14px rgba(0,0,0,.04);
}

.section-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    flex-wrap: wrap;
    margin-bottom: 20px;
}

.section-heading h2 {
    font-size: 20px;
    color: #172337;
}

.view-all {
    color: #2864dc;
    text-decoration: none;
    font-weight: bold;
    font-size: 14px;
}

.view-all:hover {
    text-decoration: underline;
}

.table-container {
    width: 100%;
    overflow-x: auto;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 1000px;
}

thead { background: #f5f7fb; }

th {
    padding: 15px 12px;
    text-align: left;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: .4px;
    color: #64748b;
    white-space: nowrap;
}

td {
    padding: 16px 12px;
    border-bottom: 1px solid #edf0f5;
    font-size: 13px;
    color: #334155;
    vertical-align: middle;
}

tbody tr:hover { background: #fafcff; }

.complaint-id {
    font-weight: bold;
    color: #2864dc;
}

.room-number {
    display: inline-block;
    background: #edf4ff;
    color: #2454a6;
    padding: 6px 10px;
    border-radius: 6px;
    font-weight: bold;
    white-space: nowrap;
}

.status {
    display: inline-block;
    padding: 6px 10px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: bold;
    white-space: nowrap;
}

.status-pending { background: #fee2e2; color: #b91c1c; }
.status-assigned { background: #fef3c7; color: #92400e; }
.status-progress { background: #e0e7ff; color: #3730a3; }
.status-resolved { background: #dcfce7; color: #166534; }
.status-default { background: #e2e8f0; color: #475569; }

.priority {
    font-weight: bold;
    font-size: 12px;
}

.priority-high { color: #dc2626; }
.priority-medium { color: #d97706; }
.priority-low { color: #16a34a; }

.action-btn {
    display: inline-block;
    background: #2864dc;
    color: #fff;
    padding: 8px 12px;
    text-decoration: none;
    border-radius: 6px;
    font-size: 12px;
    font-weight: bold;
    white-space: nowrap;
}

.action-btn:hover { background: #1d4fb5; }

.empty-state {
    text-align: center;
    padding: 35px 15px;
    color: #718096;
}

.empty-state h3 {
    margin-bottom: 8px;
    color: #334155;
}

.notification-badge {
    display: inline-block;
    background: #ef4444;
    color: #fff;
    border-radius: 12px;
    padding: 2px 7px;
    font-size: 11px;
    margin-left: 5px;
}

@media (max-width: 1200px) {
    .stats-grid {
        grid-template-columns: repeat(3, minmax(130px, 1fr));
    }
}

@media (max-width: 768px) {
    .sidebar { width: 200px; }
    .main-content { margin-left: 200px; padding: 20px; }
    .stats-grid { grid-template-columns: repeat(2, minmax(120px, 1fr)); }
    .page-title { font-size: 23px; }
}

@media (max-width: 520px) {
    .sidebar {
        position: static;
        width: 100%;
        height: auto;
    }

    .main-content {
        margin-left: 0;
        padding: 15px;
    }

    .stats-grid {
        grid-template-columns: 1fr 1fr;
        gap: 10px;
    }

    .stat-card { padding: 15px; }
    .content-card { padding: 15px; }
}
</style>
</head>

<body>

<aside class="sidebar">
    <div class="logo">SmartFix</div>
    <div class="sidebar-subtitle">Staff Management Portal</div>

    <ul class="nav-links">
        <li>
            <a href="<%= request.getContextPath() %>/staff/dashboard"
               class="active">Dashboard</a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/staff/complaints">
                My Complaints
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/notifications">
                Notifications
                <% if (unreadCount > 0) { %>
                    <span class="notification-badge"><%= unreadCount %></span>
                <% } %>
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/staff/profile">
                My Profile
            </a>
        </li>
        <li>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </li>
    </ul>
</aside>

<main class="main-content">

    <div class="topbar">
        <div>
            <h1 class="page-title">Staff Dashboard</h1>
            <p class="welcome-text">
                Welcome back! Here's an overview of your assigned complaints.
            </p>
        </div>

        <div class="staff-info">
            Staff: <strong><%= staff.getName() %></strong>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number"><%= total %></div>
            <div class="stat-label">Total Complaints</div>
        </div>

        <div class="stat-card assigned">
            <div class="stat-number"><%= assigned %></div>
            <div class="stat-label">Assigned</div>
        </div>

        <div class="stat-card progress">
            <div class="stat-number"><%= inProgress %></div>
            <div class="stat-label">In Progress</div>
        </div>

        <div class="stat-card resolved">
            <div class="stat-number"><%= resolved %></div>
            <div class="stat-label">Resolved</div>
        </div>

        <div class="stat-card pending">
            <div class="stat-number"><%= pending %></div>
            <div class="stat-label">Pending</div>
        </div>
    </div>

    <section class="content-card">
        <div class="section-heading">
            <h2>Recent Complaints</h2>
            <a class="view-all"
               href="<%= request.getContextPath() %>/staff/complaints">
                View All Complaints &rarr;
            </a>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Room Number</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                <%
                    if (complaints != null && !complaints.isEmpty()) {
                        int displayCount = Math.min(complaints.size(), 5);

                        for (int i = 0; i < displayCount; i++) {
                            Complaint complaint = complaints.get(i);

                            String status = complaint.getStatus() == null
                                ? "" : complaint.getStatus().trim();

                            String normalizedStatus = status.toUpperCase()
                                .replace('_', ' ')
                                .replace('-', ' ')
                                .replaceAll("\\s+", " ");

                            String statusClass = "status-default";

                            if ("PENDING".equals(normalizedStatus)) {
                                statusClass = "status-pending";
                            } else if ("ASSIGNED".equals(normalizedStatus)) {
                                statusClass = "status-assigned";
                            } else if ("IN PROGRESS".equals(normalizedStatus)) {
                                statusClass = "status-progress";
                            } else if ("RESOLVED".equals(normalizedStatus)) {
                                statusClass = "status-resolved";
                            }

                            String priority = complaint.getPriority() == null
                                ? "" : complaint.getPriority().trim();

                            String priorityClass = "";

                            if ("HIGH".equalsIgnoreCase(priority)) {
                                priorityClass = "priority-high";
                            } else if ("MEDIUM".equalsIgnoreCase(priority)) {
                                priorityClass = "priority-medium";
                            } else if ("LOW".equalsIgnoreCase(priority)) {
                                priorityClass = "priority-low";
                            }

                            String roomNumber = "Not provided";

                            if (roomNumbers != null) {
                                String value = roomNumbers.get(
                                    complaint.getComplaintId()
                                );

                                if (value != null && !value.trim().isEmpty()) {
                                    roomNumber = value.trim();
                                }
                            }
                %>
                    <tr>
                        <td class="complaint-id">
                            #<%= complaint.getComplaintId() %>
                        </td>
                        <td>
                            <%= complaint.getTitle() != null
                                ? complaint.getTitle() : "Untitled" %>
                        </td>
                        <td>
                            <span class="room-number"><%= roomNumber %></span>
                        </td>
                        <td>
                            <%= complaint.getCategory() != null
                                ? complaint.getCategory() : "N/A" %>
                        </td>
                        <td>
                            <span class="priority <%= priorityClass %>">
                                <%= priority.isEmpty() ? "N/A" : priority %>
                            </span>
                        </td>
                        <td>
                            <span class="status <%= statusClass %>">
                                <%= normalizedStatus.isEmpty()
                                    ? "UNKNOWN" : normalizedStatus %>
                            </span>
                        </td>
                        <td>
                            <a class="action-btn"
                               href="<%= request.getContextPath() %>/staff/complaint-details?id=<%= complaint.getComplaintId() %>">
                                View Details
                            </a>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">
                                <h3>No Complaints Found</h3>
                                <p>You currently have no assigned complaints.</p>
                            </div>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </section>

</main>

</body>
</html>

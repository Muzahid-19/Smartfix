
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.smartfix.modelcom.Complaint" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Complaint> complaints =
        (List<Complaint>) request.getAttribute("complaints");

    String contextPath = request.getContextPath();

    String successMessage =
        (String) session.getAttribute("successMessage");

    String errorMessage =
        (String) session.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>SmartFix - My Complaints</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f5f7fb;
            color: #1e293b;
            font-family: Arial, Helvetica, sans-serif;
        }

        .page {
            min-height: 100vh;
            padding: 24px 18px 35px;
        }

        .topbar,
        .page-heading,
        .content {
            max-width: 1150px;
            margin-left: auto;
            margin-right: auto;
        }

        .topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 30px;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 11px;
        }

        .brand-icon {
            width: 43px;
            height: 43px;
            display: grid;
            place-items: center;
            border-radius: 11px;
            background: #2563eb;
            color: #fff;
            font-size: 22px;
            font-weight: bold;
        }

        .brand h1 {
            margin: 0;
            font-size: 22px;
        }

        .brand p {
            margin: 4px 0 0;
            color: #64748b;
            font-size: 12px;
        }

        .back-link {
            color: #2563eb;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .page-heading {
            margin-bottom: 23px;
        }

        .page-heading h2 {
            margin: 0 0 8px;
            font-size: 27px;
        }

        .page-heading p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
        }

        .toolbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 18px;
        }

        .toolbar h3 {
            margin: 0 0 5px;
            font-size: 18px;
        }

        .toolbar p {
            margin: 0;
            color: #64748b;
            font-size: 13px;
        }

        .btn {
            display: inline-flex;
            justify-content: center;
            align-items: center;
            gap: 7px;
            min-height: 41px;
            padding: 10px 15px;
            border-radius: 8px;
            text-decoration: none;
            font-family: inherit;
            font-size: 13px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.2s, border-color 0.2s;
        }

        .primary-btn {
            color: white;
            background: #2563eb;
            border: 1px solid #2563eb;
        }

        .primary-btn:hover {
            background: #1d4ed8;
        }

        .secondary-btn {
            color: #334155;
            background: white;
            border: 1px solid #cbd5e1;
        }

        .secondary-btn:hover {
            background: #f8fafc;
        }

        .message {
            padding: 12px 15px;
            border-radius: 8px;
            margin-bottom: 17px;
            font-size: 13px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .success-message {
            color: #047857;
            background: #ecfdf5;
            border: 1px solid #a7f3d0;
        }

        .error-message {
            color: #b91c1c;
            background: #fef2f2;
            border: 1px solid #fecaca;
        }

        .complaints-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.04);
        }

        .table-scroll {
            width: 100%;
            overflow-x: auto;
        }

        .complaints-table {
            width: 100%;
            min-width: 850px;
            border-collapse: collapse;
        }

        .complaints-table th {
            padding: 14px 15px;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            text-align: left;
            color: #64748b;
            font-size: 11px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.3px;
            white-space: nowrap;
        }

        .complaints-table td {
            padding: 15px;
            border-bottom: 1px solid #edf2f7;
            font-size: 13px;
            vertical-align: middle;
        }

        .complaints-table tbody tr:last-child td {
            border-bottom: none;
        }

        .complaints-table tbody tr:hover {
            background: #f8fbff;
        }

        .complaint-id {
            display: inline-block;
            padding: 5px 8px;
            border-radius: 6px;
            background: #eff6ff;
            color: #1d4ed8;
            font-weight: bold;
            white-space: nowrap;
        }

        .complaint-title {
            max-width: 230px;
            color: #1e293b;
            font-weight: bold;
            overflow-wrap: anywhere;
        }

        .category-badge {
            display: inline-block;
            padding: 5px 8px;
            border-radius: 6px;
            background: #f1f5f9;
            color: #475569;
            font-size: 11px;
        }

        .status-badge,
        .priority-badge {
            display: inline-block;
            padding: 6px 9px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            white-space: nowrap;
        }

        .status-pending {
            background: #fff7ed;
            color: #c2410c;
        }

        .status-assigned {
            background: #eff6ff;
            color: #1d4ed8;
        }

        .status-progress {
            background: #f5f3ff;
            color: #6d28d9;
        }

        .status-resolved {
            background: #ecfdf5;
            color: #047857;
        }

        .status-other {
            background: #f1f5f9;
            color: #475569;
        }

        .priority-high {
            background: #fef2f2;
            color: #b91c1c;
        }

        .priority-medium {
            background: #fff7ed;
            color: #c2410c;
        }

        .priority-low {
            background: #ecfdf5;
            color: #047857;
        }

        .date-text {
            color: #64748b;
            font-size: 12px;
            white-space: nowrap;
        }

        .actions {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 7px;
        }

        .view-btn {
            padding: 7px 11px;
            border: 1px solid #bfdbfe;
            border-radius: 7px;
            background: #eff6ff;
            color: #1d4ed8;
            font-size: 12px;
            font-weight: bold;
            text-decoration: none;
        }

        .view-btn:hover {
            background: #dbeafe;
        }

        .delete-btn {
            padding: 7px 11px;
            border: 1px solid #fecaca;
            border-radius: 7px;
            background: white;
            color: #b91c1c;
            font-family: inherit;
            font-size: 12px;
            font-weight: bold;
            cursor: pointer;
        }

        .delete-btn:hover {
            background: #fef2f2;
        }

        .empty-state {
            padding: 55px 20px;
            text-align: center;
        }

        .empty-icon {
            width: 58px;
            height: 58px;
            margin: 0 auto 16px;
            display: grid;
            place-items: center;
            border-radius: 14px;
            background: #eff6ff;
            color: #2563eb;
            font-size: 25px;
            font-weight: bold;
        }

        .empty-state h3 {
            margin: 0 0 8px;
            font-size: 19px;
        }

        .empty-state p {
            max-width: 380px;
            margin: 0 auto 20px;
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
        }

        .footer-link {
            margin-top: 22px;
            text-align: center;
        }

        .footer-link a {
            color: #2563eb;
            font-size: 13px;
            text-decoration: none;
        }

        .footer-link a:hover {
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .page {
                padding: 18px 12px 28px;
            }

            .brand h1 {
                font-size: 20px;
            }

            .brand p {
                max-width: 200px;
                font-size: 11px;
                line-height: 1.4;
            }

            .page-heading h2 {
                font-size: 23px;
            }

            .toolbar {
                align-items: stretch;
                flex-direction: column;
            }

            .toolbar .btn {
                width: 100%;
            }

            .empty-state {
                padding: 40px 15px;
            }
        }
    </style>
</head>

<body>
<div class="page">

    <header class="topbar">
        <div class="brand">
            <div class="brand-icon">S</div>
            <div>
                <h1>SmartFix</h1>
                <p>Complaint &amp; Service Management System</p>
            </div>
        </div>

        <a class="back-link"
           href="<%= contextPath %>/user/dashboard.jsp">
            ← Dashboard
        </a>
    </header>

    <section class="page-heading">
        <h2>My Complaints</h2>
        <p>
            View your submitted complaints and check their latest status.
        </p>
    </section>

    <main class="content">

        <div class="toolbar">
            <div>
                <h3>Complaint History</h3>
                <p>Review your service requests and their progress.</p>
            </div>

            <a class="btn primary-btn"
               href="<%= contextPath %>/user/raise-complaint.jsp">
                + Raise Complaint
            </a>
        </div>

        <% if (successMessage != null) { %>
            <div class="message success-message" role="status">
                <%= successMessage %>
            </div>
        <%
            session.removeAttribute("successMessage");
        } %>

        <% if (errorMessage != null) { %>
            <div class="message error-message" role="alert">
                <%= errorMessage %>
            </div>
        <%
            session.removeAttribute("errorMessage");
        } %>

        <section class="complaints-card">

            <% if (complaints == null || complaints.isEmpty()) { %>

                <div class="empty-state">
                    <div class="empty-icon">!</div>
                    <h3>No Complaints Yet</h3>
                    <p>
                        You haven't submitted any complaints.
                        When you report a problem, it will appear here.
                    </p>

                    <a class="btn primary-btn"
                       href="<%= contextPath %>/user/raise-complaint.jsp">
                        Raise Your First Complaint
                    </a>
                </div>

            <% } else { %>

                <div class="table-scroll">
                    <table class="complaints-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Complaint</th>
                                <th>Category</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Created Date</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                        <% for (Complaint complaint : complaints) {

                            String rawStatus = complaint.getStatus() == null
                                ? "" : complaint.getStatus().trim();

                            String normalizedStatus = rawStatus
                                .replace('_', ' ')
                                .replace('-', ' ')
                                .replaceAll("\\s+", " ")
                                .toUpperCase(java.util.Locale.ROOT);

                            String statusClass = "status-other";

                            if ("PENDING".equals(normalizedStatus)) {
                                statusClass = "status-pending";
                            } else if ("ASSIGNED".equals(normalizedStatus)) {
                                statusClass = "status-assigned";
                            } else if ("IN PROGRESS".equals(normalizedStatus)) {
                                statusClass = "status-progress";
                            } else if ("RESOLVED".equals(normalizedStatus)) {
                                statusClass = "status-resolved";
                            }

                            String rawPriority = complaint.getPriority() == null
                                ? "" : complaint.getPriority().trim();

                            String normalizedPriority =
                                rawPriority.toUpperCase(java.util.Locale.ROOT);

                            String priorityClass = "";

                            if ("HIGH".equals(normalizedPriority)) {
                                priorityClass = "priority-high";
                            } else if ("MEDIUM".equals(normalizedPriority)) {
                                priorityClass = "priority-medium";
                            } else if ("LOW".equals(normalizedPriority)) {
                                priorityClass = "priority-low";
                            }
                        %>

                            <tr>
                                <td>
                                    <span class="complaint-id">
                                        #<%= complaint.getComplaintId() %>
                                    </span>
                                </td>

                                <td>
                                    <div class="complaint-title">
                                        <%= complaint.getTitle() == null
                                            ? "Untitled complaint"
                                            : complaint.getTitle() %>
                                    </div>
                                </td>

                                <td>
                                    <span class="category-badge">
                                        <%= complaint.getCategory() == null
                                            ? "Not specified"
                                            : complaint.getCategory() %>
                                    </span>
                                </td>

                                <td>
                                    <span class="priority-badge <%= priorityClass %>">
                                        <%= rawPriority.isEmpty()
                                            ? "Not set" : rawPriority %>
                                    </span>
                                </td>

                                <td>
                                    <span class="status-badge <%= statusClass %>">
                                        <%= rawStatus.isEmpty()
                                            ? "Unknown" : rawStatus %>
                                    </span>
                                </td>

                                <td>
                                    <span class="date-text">
                                        <%= complaint.getCreatedAt() == null
                                            ? "—" : complaint.getCreatedAt() %>
                                    </span>
                                </td>

                                <td>
                                    <div class="actions">

                                        <a class="view-btn"
                                           href="<%= contextPath %>/user/complaint-details?id=<%= complaint.getComplaintId() %>">
                                            View
                                        </a>

                                        <% if ("PENDING".equals(normalizedStatus)) { %>

                                            <form method="post"
                                                  action="<%= contextPath %>/user/delete-complaint"
                                                  style="margin:0"
                                                  onsubmit="return confirmDelete();">

                                                <input type="hidden"
                                                       name="complaintId"
                                                       value="<%= complaint.getComplaintId() %>">

                                                <button type="submit" class="delete-btn">
                                                    Delete
                                                </button>
                                            </form>

                                        <% } %>
                                    </div>
                                </td>
                            </tr>

                        <% } %>
                        </tbody>
                    </table>
                </div>

            <% } %>
        </section>

        <div class="footer-link">
            <a href="<%= contextPath %>/user/dashboard.jsp">
                ← Back to Dashboard
            </a>
        </div>

    </main>
</div>

<script>
    function confirmDelete() {
        return confirm(
            "Are you sure you want to delete this complaint? " +
            "This action cannot be undone."
        );
    }
</script>

</body>
</html>

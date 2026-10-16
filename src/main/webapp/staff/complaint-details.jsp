
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.smartfix.modelcom.Complaint" %>
<%@ page import="com.smartfix.modelcom.Comment" %>
<%@ page import="com.smartfix.modelcom.ComplaintHistory" %>
<%@ page import="com.smartfix.modelcom.Staff" %>
<%@ page import="com.smartfix.modelcom.User" %>

<%
    Staff staff = (Staff) session.getAttribute("staff");

    if (staff == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Complaint complaint =
        (Complaint) request.getAttribute("complaint");

    List<Comment> comments =
        (List<Comment>) request.getAttribute("comments");

    List<ComplaintHistory> history =
        (List<ComplaintHistory>) request.getAttribute("history");

    if (complaint == null) {
        response.sendRedirect(
            request.getContextPath() + "/staff/complaints"
        );
        return;
    }

    // Complaint owner's details sent by the servlet
    User complaintUser =
        (User) request.getAttribute("complaintUser");

    String roomNumber = "Not provided";

    if (complaintUser != null
            && complaintUser.getRoomNumber() != null
            && !complaintUser.getRoomNumber().trim().isEmpty()) {
        roomNumber = complaintUser.getRoomNumber().trim();
    }

    String success = request.getParameter("success");
    String commentMessage = request.getParameter("comment");
    String error = request.getParameter("error");

    String priority = complaint.getPriority() == null
        ? "N/A" : complaint.getPriority();

    String priorityClass = "low";

    if ("HIGH".equalsIgnoreCase(priority)) {
        priorityClass = "high";
    } else if ("MEDIUM".equalsIgnoreCase(priority)) {
        priorityClass = "medium";
    }

    String status = complaint.getStatus() == null
        ? "UNKNOWN" : complaint.getStatus();

    String statusClass = "pending";

    if ("ASSIGNED".equalsIgnoreCase(status)) {
        statusClass = "assigned";
    } else if ("IN PROGRESS".equalsIgnoreCase(status)
            || "IN_PROGRESS".equalsIgnoreCase(status)) {
        statusClass = "progress";
    } else if ("RESOLVED".equalsIgnoreCase(status)) {
        statusClass = "resolved";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Details | SmartFix</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f7fb;
            color: #1f2937;
        }

        .layout {
            display: flex;
            min-height: 100vh;
        }

        .sidebar {
            width: 250px;
            background: #111827;
            color: white;
            padding: 25px 18px;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 35px;
        }

        .logo span {
            color: #38bdf8;
        }

        .menu {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .menu a {
            text-decoration: none;
            color: #d1d5db;
            padding: 13px 15px;
            border-radius: 10px;
            transition: 0.3s;
            display: block;
        }

        .menu a:hover,
        .menu a.active {
            background: #2563eb;
            color: white;
            transform: translateX(4px);
        }

        .logout {
            position: absolute;
            bottom: 25px;
            left: 18px;
            right: 18px;
        }

        .logout a {
            background: #dc2626;
            color: white;
            text-align: center;
            padding: 12px;
            border-radius: 9px;
            text-decoration: none;
            display: block;
            transition: 0.3s;
        }

        .logout a:hover {
            background: #b91c1c;
        }

        .main {
            margin-left: 250px;
            width: calc(100% - 250px);
            padding: 30px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            margin-bottom: 25px;
        }

        .topbar h1 {
            font-size: 28px;
        }

        .staff-name {
            background: white;
            padding: 10px 18px;
            border-radius: 10px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.07);
            font-weight: bold;
        }

        .alert {
            padding: 14px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            font-weight: 600;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }

        .card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.07);
        }

        .card h2 {
            margin-bottom: 20px;
            font-size: 21px;
        }

        .details-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .detail {
            background: #f8fafc;
            padding: 15px;
            border-radius: 10px;
            overflow-wrap: anywhere;
        }

        .detail label {
            display: block;
            font-size: 13px;
            color: #6b7280;
            margin-bottom: 6px;
        }

        .detail strong {
            font-size: 15px;
        }

        .room-value {
            display: inline-block;
            color: #1d4ed8;
            background: #dbeafe;
            padding: 5px 10px;
            border-radius: 7px;
        }

        .description {
            margin-top: 18px;
            background: #f8fafc;
            padding: 18px;
            border-radius: 10px;
        }

        .description h3 {
            margin-bottom: 10px;
            font-size: 15px;
        }

        .description p {
            line-height: 1.7;
            color: #4b5563;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        .badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .pending {
            background: #fef3c7;
            color: #92400e;
        }

        .assigned {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .progress {
            background: #ede9fe;
            color: #6d28d9;
        }

        .resolved {
            background: #dcfce7;
            color: #166534;
        }

        .high {
            background: #fee2e2;
            color: #b91c1c;
        }

        .medium {
            background: #fef3c7;
            color: #92400e;
        }

        .low {
            background: #dcfce7;
            color: #166534;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
        }

        select,
        textarea {
            width: 100%;
            padding: 13px;
            border: 1px solid #d1d5db;
            border-radius: 9px;
            font-size: 14px;
            outline: none;
        }

        select:focus,
        textarea:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
        }

        textarea {
            resize: vertical;
            min-height: 110px;
        }

        .btn {
            border: none;
            background: #2563eb;
            color: white;
            padding: 12px 22px;
            border-radius: 9px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.3s;
        }

        .btn:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
        }

        .comment-btn {
            background: #059669;
        }

        .comment-btn:hover {
            background: #047857;
        }

        .comment {
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 16px;
            margin-bottom: 12px;
            background: #fafafa;
        }

        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        .comment-author {
            font-weight: bold;
            color: #2563eb;
        }

        .comment-date {
            font-size: 12px;
            color: #6b7280;
        }

        .comment-text {
            color: #374151;
            line-height: 1.6;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        .comment-info {
            margin-top: 8px;
            font-size: 12px;
            color: #9ca3af;
        }

        .no-comments {
            padding: 25px;
            text-align: center;
            background: #f9fafb;
            border-radius: 10px;
            color: #6b7280;
        }

        .comment-count {
            background: #eef6ff;
            color: #1d4ed8;
            padding: 10px 14px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 14px;
            font-weight: bold;
        }

        .history-item {
            border-left: 4px solid #2563eb;
            padding: 12px 16px;
            margin-bottom: 12px;
            background: #f8fafc;
            border-radius: 0 10px 10px 0;
        }

        .history-status {
            font-weight: bold;
        }

        .history-date {
            font-size: 12px;
            color: #6b7280;
            margin-top: 5px;
        }

        .complaint-image {
            margin-top: 20px;
        }

        .complaint-image img {
            max-width: 450px;
            width: 100%;
            border-radius: 12px;
            border: 1px solid #ddd;
        }

        .back-btn {
            display: inline-block;
            text-decoration: none;
            color: #2563eb;
            margin-bottom: 20px;
            font-weight: bold;
        }

        .back-btn:hover {
            text-decoration: underline;
        }

        @media (max-width: 800px) {
            .sidebar {
                width: 210px;
            }

            .main {
                margin-left: 210px;
                width: calc(100% - 210px);
                padding: 20px;
            }

            .details-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 600px) {
            .sidebar {
                position: relative;
                width: 100%;
                height: auto;
            }

            .layout {
                display: block;
            }

            .logout {
                position: relative;
                left: auto;
                right: auto;
                bottom: auto;
                margin-top: 20px;
            }

            .main {
                margin-left: 0;
                width: 100%;
            }

            .topbar {
                display: block;
            }

            .staff-name {
                margin-top: 10px;
            }

            .comment-header {
                display: block;
            }

            .comment-date {
                display: block;
                margin-top: 5px;
            }
        }
    </style>
</head>

<body>
<div class="layout">

    <aside class="sidebar">
        <div class="logo">Smart<span>Fix</span></div>

        <div class="menu">
            <a href="<%= request.getContextPath() %>/staff/dashboard">
                🏠 Dashboard
            </a>

            <a href="<%= request.getContextPath() %>/staff/complaints"
               class="active">
                📋 My Complaints
            </a>
        </div>

        <div class="logout">
            <a href="<%= request.getContextPath() %>/logout">
                🚪 Logout
            </a>
        </div>
    </aside>

    <main class="main">

        <div class="topbar">
            <h1>Complaint Details</h1>

            <div class="staff-name">
                👨‍🔧 <%= staff.getName() %>
            </div>
        </div>

        <% if ("updated".equals(success)) { %>
            <div class="alert success">
                Complaint updated successfully.
            </div>
        <% } %>

        <% if ("success".equals(commentMessage)) { %>
            <div class="alert success">
                Comment added successfully.
            </div>
        <% } %>

        <% if ("failed".equals(commentMessage)) { %>
            <div class="alert error">
                Failed to add comment.
            </div>
        <% } %>

        <% if ("empty".equals(error)) { %>
            <div class="alert error">
                Please enter a comment.
            </div>
        <% } %>

        <a class="back-btn"
           href="<%= request.getContextPath() %>/staff/complaints">
            ← Back to My Complaints
        </a>

        <!-- COMPLAINT INFORMATION -->
        <div class="card">
            <h2>Complaint Information</h2>

            <div class="details-grid">

                <div class="detail">
                    <label>Complaint ID</label>
                    <strong>#<%= complaint.getComplaintId() %></strong>
                </div>

                <div class="detail">
                    <label>Title</label>
                    <strong><%= complaint.getTitle() == null
                        ? "Untitled" : complaint.getTitle() %></strong>
                </div>

                <!-- NEW ROOM NUMBER FIELD -->
                <div class="detail">
                    <label>Room Number</label>
                    <strong class="room-value"><%= roomNumber %></strong>
                </div>

                <div class="detail">
                    <label>Category</label>
                    <strong><%= complaint.getCategory() == null
                        ? "Not specified" : complaint.getCategory() %></strong>
                </div>

                <div class="detail">
                    <label>Priority</label>
                    <span class="badge <%= priorityClass %>">
                        <%= priority %>
                    </span>
                </div>

                <div class="detail">
                    <label>Status</label>
                    <span class="badge <%= statusClass %>">
                        <%= status %>
                    </span>
                </div>

                <div class="detail">
                    <label>Created At</label>
                    <strong><%= complaint.getCreatedAt() == null
                        ? "N/A" : complaint.getCreatedAt() %></strong>
                </div>
            </div>

            <div class="description">
                <h3>Description</h3>
                <p><%= complaint.getDescription() == null
                    ? "No description provided."
                    : complaint.getDescription() %></p>
            </div>

            <% if (complaint.getImagePath() != null
                    && !complaint.getImagePath().trim().isEmpty()) { %>
                <div class="complaint-image">
                    <h3>Complaint Image</h3>
                    <br>
                    <img
                        src="<%= request.getContextPath() %>/<%= complaint.getImagePath() %>"
                        alt="Complaint Image">
                </div>
            <% } %>
        </div>

        <!-- MANAGE COMPLAINT -->
        <div class="card">
            <h2>⚙ Manage Complaint</h2>

            <form method="post"
                  action="<%= request.getContextPath() %>/staff/update-complaint">

                <input type="hidden"
                       name="complaintId"
                       value="<%= complaint.getComplaintId() %>">

                <div class="form-group">
                    <label for="status">Status</label>

                    <select id="status" name="status">
                        <option value="ASSIGNED"
                            <%= "ASSIGNED".equalsIgnoreCase(status)
                                ? "selected" : "" %>>
                            Assigned
                        </option>

                        <option value="IN PROGRESS"
                            <%= "IN PROGRESS".equalsIgnoreCase(status)
                                || "IN_PROGRESS".equalsIgnoreCase(status)
                                ? "selected" : "" %>>
                            In Progress
                        </option>

                        <option value="RESOLVED"
                            <%= "RESOLVED".equalsIgnoreCase(status)
                                ? "selected" : "" %>>
                            Resolved
                        </option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="resolutionNotes">Resolution Notes</label>

                    <textarea id="resolutionNotes"
                              name="resolutionNotes"
                              placeholder="Enter resolution details..."><%= complaint.getResolutionNotes() == null
                                ? "" : complaint.getResolutionNotes() %></textarea>
                </div>

                <button type="submit" class="btn">
                    Update Complaint
                </button>
            </form>
        </div>

        <!-- ADD COMMENT -->
        <div class="card">
            <h2>💬 Add Comment</h2>

            <form method="post"
                  action="<%= request.getContextPath() %>/staff/add-comment">

                <input type="hidden"
                       name="complaintId"
                       value="<%= complaint.getComplaintId() %>">

                <div class="form-group">
                    <label for="commentText">Your Comment</label>

                    <textarea id="commentText"
                              name="commentText"
                              placeholder="Write your comment here..."
                              required></textarea>
                </div>

                <button type="submit" class="btn comment-btn">
                    💬 Post Comment
                </button>
            </form>
        </div>

        <!-- PREVIOUS COMMENTS -->
        <div class="card">
            <h2>💬 Previous Comments</h2>

            <div class="comment-count">
                Comments loaded:
                <%= comments == null ? 0 : comments.size() %>
            </div>

            <% if (comments == null || comments.isEmpty()) { %>
                <div class="no-comments">No comments yet.</div>
            <% } else { %>
                <% for (Comment comment : comments) { %>
                    <div class="comment">
                        <div class="comment-header">
                            <span class="comment-author">💬 Comment</span>
                            <span class="comment-date">
                                <%= comment.getCreatedAt() == null
                                    ? "N/A" : comment.getCreatedAt() %>
                            </span>
                        </div>

                        <div class="comment-text"><%= comment.getCommentText() == null
                            ? "" : comment.getCommentText() %></div>

                        <div class="comment-info">
                            Comment ID: <%= comment.getCommentId() %>
                            &nbsp; | &nbsp;
                            User ID: <%= comment.getUserId() %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <!-- COMPLAINT HISTORY -->
        <div class="card">
            <h2>📜 Complaint History</h2>

            <% if (history == null || history.isEmpty()) { %>
                <div class="no-comments">No history available.</div>
            <% } else { %>
                <% for (ComplaintHistory h : history) { %>
                    <div class="history-item">
                        <div class="history-status">
                            <%= h.getOldStatus() == null
                                ? "Created" : h.getOldStatus() %>
                            →
                            <%= h.getNewStatus() == null
                                ? "Unknown" : h.getNewStatus() %>
                        </div>

                        <% if (h.getRemarks() != null
                                && !h.getRemarks().trim().isEmpty()) { %>
                            <div style="margin-top:7px;">
                                <%= h.getRemarks() %>
                            </div>
                        <% } %>

                        <div class="history-date">
                            <%= h.getChangedAt() == null
                                ? "N/A" : h.getChangedAt() %>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

    </main>
</div>
</body>
</html>

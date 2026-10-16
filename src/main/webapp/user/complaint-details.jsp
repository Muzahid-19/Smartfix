
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.smartfix.modelcom.Complaint" %>
<%@ page import="com.smartfix.modelcom.ComplaintHistory" %>
<%@ page import="com.smartfix.modelcom.Comment" %>
<%@ page import="com.smartfix.modelcom.Rating" %>

<%!
    public String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);
        text = text.replace("&", "&amp;");
        text = text.replace("<", "&lt;");
        text = text.replace(">", "&gt;");
        text = text.replace("\"", "&quot;");
        text = text.replace("'", "&#x27;");

        return text;
    }
%>

<%
Complaint complaint =
    (Complaint) request.getAttribute("complaint");

List<ComplaintHistory> historyList =
    (List<ComplaintHistory>) request.getAttribute("historyList");

List<Comment> commentList =
    (List<Comment>) request.getAttribute("commentList");

Rating rating =
    (Rating) request.getAttribute("rating");

String roomNumber =
    (String) request.getAttribute("roomNumber");

if (roomNumber == null || roomNumber.trim().isEmpty()) {
    roomNumber = "Not provided";
}

String status = "";

if (complaint != null && complaint.getStatus() != null) {
    status = complaint.getStatus().trim();
}

String normalizedStatus = status
    .replace('_', ' ')
    .replace('-', ' ')
    .replaceAll("\\s+", " ")
    .toUpperCase();

boolean isResolved = "RESOLVED".equals(normalizedStatus);

String statusClass = "status-unknown";

if ("PENDING".equals(normalizedStatus)) {
    statusClass = "status-pending";
} else if ("ASSIGNED".equals(normalizedStatus)) {
    statusClass = "status-assigned";
} else if ("IN PROGRESS".equals(normalizedStatus)) {
    statusClass = "status-progress";
} else if (isResolved) {
    statusClass = "status-resolved";
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>SmartFix | Complaint Details</title>

<style>
* {
    box-sizing: border-box;
}

:root {
    --primary: #2563eb;
    --primary-dark: #1d4ed8;
    --text: #111827;
    --muted: #6b7280;
    --border: #e5e7eb;
    --background: #f8fafc;
    --white: #ffffff;
}

body {
    margin: 0;
    font-family: Arial, Helvetica, sans-serif;
    background: var(--background);
    color: var(--text);
    line-height: 1.6;
    font-size: 14px;
}

a {
    color: var(--primary);
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

/* Header */

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 16px;
    padding: 18px max(4%, calc((100% - 1100px) / 2));
    background: var(--white);
    border-bottom: 1px solid var(--border);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
}

.logo {
    font-size: 24px;
    font-weight: 700;
    letter-spacing: -0.5px;
    color: var(--primary);
}

.back-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 9px 14px;
    border: 1px solid var(--border);
    border-radius: 7px;
    background: var(--white);
    color: #374151;
    font-size: 13px;
    font-weight: 600;
    text-decoration: none;
    transition: background 0.2s, border-color 0.2s;
}

.back-btn:hover {
    background: #f3f4f6;
    border-color: #cbd5e1;
    text-decoration: none;
}

/* Main content */

.container {
    width: 92%;
    max-width: 1000px;
    margin: 30px auto 50px;
}

.page-heading {
    margin-bottom: 22px;
}

.page-heading h1 {
    margin: 0 0 5px;
    font-size: 27px;
    color: var(--text);
}

.page-heading p {
    margin: 0;
    color: var(--muted);
    font-size: 14px;
}

.card {
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 10px;
    padding: 24px;
    margin-bottom: 20px;
    box-shadow: 0 2px 6px rgba(15, 23, 42, 0.025);
}

.card h2 {
    margin: 0 0 20px;
    padding-bottom: 13px;
    border-bottom: 1px solid #edf0f4;
    color: var(--text);
    font-size: 18px;
    font-weight: 700;
}

/* Complaint information */

.details-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 14px;
}

.detail-box {
    min-width: 0;
    padding: 14px 16px;
    border: 1px solid #edf0f4;
    border-radius: 8px;
    background: #fafbfc;
    overflow-wrap: anywhere;
}

.detail-box strong {
    display: block;
    margin-bottom: 5px;
    color: var(--muted);
    font-size: 12px;
    font-weight: 600;
}

.detail-box span {
    color: #1f2937;
    font-size: 14px;
    font-weight: 600;
}

.room-number-box {
    background: #f5f7ff;
    border-color: #e0e7ff;
}

.room-number-box strong {
    color: #4f46e5;
}

/* Status badges */

.status {
    display: inline-block;
    padding: 5px 10px;
    border-radius: 5px;
    font-size: 11px !important;
    font-weight: 700;
    letter-spacing: 0.3px;
}

.status-pending {
    background: #fef3c7;
    color: #92400e !important;
}

.status-assigned {
    background: #dbeafe;
    color: #1e40af !important;
}

.status-progress {
    background: #ede9fe;
    color: #6d28d9 !important;
}

.status-resolved {
    background: #dcfce7;
    color: #166534 !important;
}

.status-unknown {
    background: #e5e7eb;
    color: #374151 !important;
}

/* Description */

.description {
    padding: 16px;
    border: 1px solid #edf0f4;
    border-radius: 8px;
    background: #fafbfc;
    color: #374151;
    line-height: 1.8;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}

/* Complaint image */

.complaint-image-wrapper {
    margin-top: 5px;
    text-align: center;
}

.complaint-image {
    display: block;
    max-width: 100%;
    max-height: 420px;
    margin: auto;
    object-fit: contain;
    border: 1px solid var(--border);
    border-radius: 8px;
    background: #fafafa;
}

.image-caption {
    margin-top: 10px;
    color: var(--muted);
    font-size: 12px;
}

.no-image {
    padding: 22px;
    border: 1px dashed #cbd5e1;
    border-radius: 8px;
    background: #fafbfc;
    color: var(--muted);
    text-align: center;
}

/* Complaint history */

.history-item {
    padding: 16px;
    margin-bottom: 12px;
    border: 1px solid var(--border);
    border-left: 3px solid var(--primary);
    border-radius: 7px;
    background: #ffffff;
    overflow-wrap: anywhere;
}

.history-item:last-child {
    margin-bottom: 0;
}

.history-item h4 {
    margin: 0 0 8px;
    color: #1f2937;
    font-size: 14px;
}

.history-item p {
    margin: 5px 0;
    color: #4b5563;
    font-size: 13px;
}

/* Comments */

.comment {
    padding: 16px 0;
    border-bottom: 1px solid #edf0f4;
    overflow-wrap: anywhere;
}

.comment:first-child {
    padding-top: 0;
}

.comment:last-child {
    padding-bottom: 0;
    border-bottom: 0;
}

.comment-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    flex-wrap: wrap;
    gap: 8px;
    margin-bottom: 8px;
}

.comment-user {
    color: var(--primary);
    font-weight: 700;
    font-size: 13px;
}

.comment-date {
    color: #9ca3af;
    font-size: 12px;
}

.comment-text {
    color: #374151;
    line-height: 1.7;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}

/* Rating */

.rating-card {
    border-color: #dbeafe;
}

.rating-card > p {
    color: #4b5563;
}

.rating-form {
    margin-top: 18px;
}

.rating-stars {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin: 12px 0 22px;
}

.rating-option {
    position: relative;
}

.rating-option input {
    position: absolute;
    width: 1px;
    height: 1px;
    opacity: 0;
}

.rating-option label {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 42px;
    height: 42px;
    border: 1px solid #d1d5db;
    border-radius: 7px;
    background: white;
    color: #374151;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    transition: 0.2s;
}

.rating-option label:hover {
    border-color: var(--primary);
    color: var(--primary);
}

.rating-option input:checked + label {
    background: var(--primary);
    border-color: var(--primary);
    color: white;
}

.rating-option input:focus-visible + label {
    outline: 3px solid #bfdbfe;
    outline-offset: 2px;
}

textarea {
    display: block;
    width: 100%;
    min-height: 110px;
    margin-top: 8px;
    padding: 12px 14px;
    border: 1px solid #d1d5db;
    border-radius: 7px;
    background: white;
    color: var(--text);
    font: inherit;
    resize: vertical;
    outline: none;
}

textarea:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.submit-btn {
    display: inline-block;
    margin-top: 16px;
    padding: 11px 18px;
    border: 0;
    border-radius: 7px;
    background: var(--primary);
    color: white;
    font-size: 13px;
    font-weight: 700;
    cursor: pointer;
    transition: background 0.2s;
}

.submit-btn:hover {
    background: var(--primary-dark);
}

.existing-rating {
    padding: 18px;
    border: 1px solid #d1fae5;
    border-radius: 8px;
    background: #f0fdf4;
}

.rating-number {
    margin-bottom: 8px;
    color: #166534;
    font-size: 23px;
    font-weight: 700;
}

.feedback-text {
    color: #374151;
    white-space: pre-wrap;
    overflow-wrap: anywhere;
}

.info-message {
    padding: 16px;
    border: 1px solid #fed7aa;
    border-radius: 8px;
    background: #fff7ed;
    color: #9a3412;
    font-size: 13px;
}

.empty-message {
    padding: 15px;
    border-radius: 7px;
    background: #f8fafc;
    color: var(--muted);
    font-size: 13px;
}

/* Mobile responsive layout */

@media (max-width: 650px) {
    .header {
        padding: 14px 4%;
        flex-wrap: wrap;
    }

    .logo {
        font-size: 22px;
    }

    .container {
        width: 94%;
        margin: 20px auto 35px;
    }

    .page-heading h1 {
        font-size: 23px;
    }

    .card {
        padding: 18px;
        margin-bottom: 15px;
    }

    .card h2 {
        font-size: 17px;
    }

    .details-grid {
        grid-template-columns: 1fr;
        gap: 10px;
    }

    .detail-box {
        padding: 12px 14px;
    }

    .comment-header {
        align-items: flex-start;
        flex-direction: column;
    }

    .back-btn {
        padding: 8px 10px;
        font-size: 12px;
    }

    .complaint-image {
        max-height: 300px;
    }
}
</style>
</head>

<body>

<header class="header">
    <div class="logo">SmartFix</div>

    <a class="back-btn"
       href="<%= request.getContextPath() %>/myComplaints">
        &larr; Back to My Complaints
    </a>
</header>

<main class="container">

<%
if (complaint != null) {
%>

    <div class="page-heading">
        <h1>Complaint Details</h1>
        <p>View your complaint information and follow its progress.</p>
    </div>

    <!-- COMPLAINT INFORMATION -->

    <section class="card">
        <h2>Complaint Information</h2>

        <div class="details-grid">

            <div class="detail-box">
                <strong>Complaint ID</strong>
                <span>#<%= complaint.getComplaintId() %></span>
            </div>

            <div class="detail-box">
                <strong>Title</strong>
                <span><%= escapeHtml(
                    complaint.getTitle() == null
                    ? "Not provided" : complaint.getTitle()) %></span>
            </div>

            <div class="detail-box">
                <strong>Category</strong>
                <span><%= escapeHtml(
                    complaint.getCategory() == null
                    ? "Not specified" : complaint.getCategory()) %></span>
            </div>

            <div class="detail-box">
                <strong>Priority</strong>
                <span><%= escapeHtml(
                    complaint.getPriority() == null
                    ? "Not specified" : complaint.getPriority()) %></span>
            </div>

            <div class="detail-box">
                <strong>Status</strong>
                <span class="status <%= statusClass %>">
                    <%= escapeHtml(
                        normalizedStatus.isEmpty()
                        ? "Unknown" : normalizedStatus) %>
                </span>
            </div>

            <div class="detail-box">
                <strong>Created Date</strong>
                <span><%= escapeHtml(
                    complaint.getCreatedAt() == null
                    ? "N/A" : complaint.getCreatedAt()) %></span>
            </div>

            <div class="detail-box room-number-box">
                <strong>Room Number</strong>
                <span><%= escapeHtml(roomNumber) %></span>
            </div>

        </div>
    </section>

    <!-- DESCRIPTION -->

    <section class="card">
        <h2>Description</h2>

        <div class="description"><%= escapeHtml(
            complaint.getDescription() == null
            ? "No description provided."
            : complaint.getDescription()) %></div>
    </section>

    <!-- COMPLAINT IMAGE -->

    <section class="card">
        <h2>Complaint Image</h2>

        <%
        String imagePath = complaint.getImagePath();

        if (imagePath != null && !imagePath.trim().isEmpty()) {
            imagePath = imagePath.trim().replace('\\', '/');

            while (imagePath.startsWith("/")) {
                imagePath = imagePath.substring(1);
            }

            boolean validImagePath =
                !imagePath.contains("..")
                && !imagePath.contains("?")
                && !imagePath.contains("#")
                && !imagePath.contains("\"")
                && !imagePath.contains("'")
                && !imagePath.contains("<")
                && !imagePath.contains(">");

            if (validImagePath) {
        %>

            <div class="complaint-image-wrapper">
                <img
                    class="complaint-image"
                    src="<%= request.getContextPath() %>/<%= escapeHtml(imagePath) %>"
                    alt="Uploaded complaint image">

                <p class="image-caption">
                    Image uploaded with this complaint
                </p>
            </div>

        <%
            } else {
        %>

            <p class="no-image">The saved image path is invalid.</p>

        <%
            }
        } else {
        %>

            <p class="no-image">
                No image was uploaded for this complaint.
            </p>

        <%
        }
        %>
    </section>

    <!-- COMPLAINT HISTORY -->

    <section class="card">
        <h2>Complaint History</h2>

        <%
        if (historyList != null && !historyList.isEmpty()) {
            for (ComplaintHistory history : historyList) {
        %>

            <div class="history-item">
                <h4>
                    <%= escapeHtml(
                        history.getOldStatus() == null
                        ? "-" : history.getOldStatus()) %>

                    &rarr;

                    <%= escapeHtml(
                        history.getNewStatus() == null
                        ? "-" : history.getNewStatus()) %>
                </h4>

                <p>
                    <strong>Remarks:</strong>
                    <%= escapeHtml(
                        history.getRemarks() == null
                        || history.getRemarks().trim().isEmpty()
                        ? "-" : history.getRemarks()) %>
                </p>

                <p>
                    <strong>Changed At:</strong>
                    <%= escapeHtml(
                        history.getChangedAt() == null
                        ? "N/A" : history.getChangedAt()) %>
                </p>
            </div>

        <%
            }
        } else {
        %>

            <p class="empty-message">
                No status history available yet.
            </p>

        <%
        }
        %>
    </section>

    <!-- COMMENTS AND REPLIES -->

    <section class="card">
        <h2>Comments &amp; Replies</h2>

        <%
        if (commentList != null && !commentList.isEmpty()) {
            for (Comment comment : commentList) {
        %>

            <div class="comment">
                <div class="comment-header">
                    <span class="comment-user">User / Staff</span>

                    <span class="comment-date">
                        <%= escapeHtml(
                            comment.getCreatedAt() == null
                            ? "" : comment.getCreatedAt()) %>
                    </span>
                </div>

                <div class="comment-text"><%= escapeHtml(
                    comment.getCommentText() == null
                    ? "" : comment.getCommentText()) %></div>
            </div>

        <%
            }
        } else {
        %>

            <p class="empty-message">
                No comments or replies yet.
            </p>

        <%
        }
        %>
    </section>

    <!-- RATING AND FEEDBACK -->

    <section class="card rating-card">
        <h2>Rating &amp; Feedback</h2>

        <%
        if (isResolved && rating == null) {
        %>

            <p>
                Your complaint has been resolved.
                Please rate the service and share your experience.
            </p>

            <form
                method="post"
                action="<%= request.getContextPath() %>/user/add-rating"
                class="rating-form">

                <input
                    type="hidden"
                    name="complaintId"
                    value="<%= complaint.getComplaintId() %>">

                <h3>Select a rating</h3>

                <div class="rating-stars">

                    <%
                    for (int i = 1; i <= 5; i++) {
                    %>

                        <div class="rating-option">
                            <input
                                type="radio"
                                id="rating<%= i %>"
                                name="rating"
                                value="<%= i %>"
                                <%= i == 5 ? "required" : "" %>>

                            <label for="rating<%= i %>">
                                <%= i %>
                            </label>
                        </div>

                    <%
                    }
                    %>

                </div>

                <label for="feedback">
                    <strong>Your feedback</strong>
                </label>

                <textarea
                    id="feedback"
                    name="feedback"
                    maxlength="2000"
                    placeholder="Tell us about your experience..."
                    required></textarea>

                <button type="submit" class="submit-btn">
                    Submit Feedback
                </button>

            </form>

        <%
        } else if (isResolved && rating != null) {
        %>

            <div class="existing-rating">
                <div class="rating-number">
                    Rating: <%= rating.getRating() %> / 5
                </div>

                <p><strong>Your feedback</strong></p>

                <p class="feedback-text"><%= escapeHtml(
                    rating.getFeedback() != null
                    && !rating.getFeedback().trim().isEmpty()
                    ? rating.getFeedback()
                    : "No feedback provided.") %></p>
            </div>

        <%
        } else {
        %>

            <div class="info-message">
                Rating and feedback will become available after your
                complaint is marked as <strong>RESOLVED</strong>.

                <br><br>

                Current status:
                <strong><%= escapeHtml(
                    normalizedStatus.isEmpty()
                    ? "Unknown" : normalizedStatus) %></strong>
            </div>

        <%
        }
        %>
    </section>

<%
} else {
%>

    <section class="card">
        <h2>Complaint Not Found</h2>

        <p>
            We could not find this complaint. It may have been removed
            or the link may be invalid.
        </p>

        <p style="margin-top: 15px;">
            <a href="<%= request.getContextPath() %>/myComplaints">
                Return to My Complaints
            </a>
        </p>
    </section>

<%
}
%>

</main>

</body>
</html>

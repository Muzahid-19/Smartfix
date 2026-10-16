
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.smartfix.modelcom.User" %>
<%@ page import="com.smartfix.modelcom.Staff" %>
<%@ page import="com.smartfix.modelcom.Complaint" %>
<%@ page import="com.smartfix.modelcom.Comment" %>
<%@ page import="com.smartfix.modelcom.ComplaintHistory" %>
<%@ page import="com.smartfix.modelcom.Rating" %>

<%
    User admin = (User) session.getAttribute("user");

    if (admin == null || admin.getRole() == null
            || !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String ctx = request.getContextPath();

    Complaint complaint = (Complaint) request.getAttribute("complaint");
    List<Comment> commentList =
        (List<Comment>) request.getAttribute("commentList");
    List<ComplaintHistory> historyList =
        (List<ComplaintHistory>) request.getAttribute("historyList");
    Rating rating = (Rating) request.getAttribute("rating");
    User complaintUser = (User) request.getAttribute("complaintUser");
    Staff complaintStaff = (Staff) request.getAttribute("complaintStaff");

    if (complaint == null) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Complaint Not Found | SmartFix</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:"Segoe UI",Arial,sans-serif;background:#f5f7fc;
min-height:100vh;display:grid;place-items:center;padding:20px;color:#172033}
.error-card{max-width:440px;width:100%;background:white;border:1px solid #e5eaf2;
border-radius:18px;padding:32px;text-align:center}
.error-card h2{font-size:22px;margin-bottom:10px}
.error-card p{font-size:14px;color:#7888a5;line-height:1.7;margin-bottom:22px}
.btn{display:inline-block;padding:12px 18px;background:#3930ad;color:white;
border-radius:10px;text-decoration:none;font-size:13px;font-weight:700}
</style>
</head>
<body>
<div class="error-card">
    <h2>Complaint Not Found</h2>
    <p>The requested complaint could not be found. Please return to the complaints list.</p>
    <a class="btn" href="<%= ctx %>/admin/complaints">Back to Complaints</a>
</div>
</body>
</html>
<%
        return;
    }

    String priority = complaint.getPriority();
    if (priority == null || priority.trim().isEmpty()) priority = "LOW";

    String status = complaint.getStatus();
    if (status == null || status.trim().isEmpty()) status = "PENDING";

    String priorityClass = "low";
    if ("HIGH".equalsIgnoreCase(priority)) priorityClass = "high";
    else if ("MEDIUM".equalsIgnoreCase(priority)) priorityClass = "medium";

    String statusClass = "pending";
    if ("ASSIGNED".equalsIgnoreCase(status)) statusClass = "assigned";
    else if ("IN PROGRESS".equalsIgnoreCase(status)) statusClass = "progress";
    else if ("RESOLVED".equalsIgnoreCase(status)) statusClass = "resolved";

    String title = complaint.getTitle() == null
        ? "Untitled Complaint" : complaint.getTitle();

    String description = complaint.getDescription() == null
        || complaint.getDescription().trim().isEmpty()
        ? "No description provided." : complaint.getDescription();
%>


<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="theme-color" content="#151b30">
<title>Complaint Details | SmartFix</title>

<style>
:root{
    --navy:#151b30;
    --navy-card:#252c40;
    --purple:#3930ad;
    --purple-light:#4936d5;
    --page:#f5f7fc;
    --text:#172033;
    --muted:#7888a5;
    --border:#e5eaf2;
    --white:#fff;
}
*{box-sizing:border-box;margin:0;padding:0}
body{
    font-family:"Segoe UI",Arial,sans-serif;
    background:var(--page);
    color:var(--text);
    min-height:100vh;
    font-size:14px;
    line-height:1.5;
}
a{color:inherit;text-decoration:none}
button,input,select,textarea{font:inherit}
button:focus-visible,a:focus-visible,select:focus-visible,
textarea:focus-visible{outline:3px solid #a5b4fc;outline-offset:3px}

/* SIDEBAR — matching the screenshot */
.sidebar{
    position:fixed;
    inset:0 auto 0 0;
    width:300px;
    padding:0 21px 24px;
    overflow-y:auto;
    background:var(--navy);
    color:white;
    z-index:1000;
    transition:transform .25s ease;
}
.logo{
    padding:0 15px;
    margin:0 0 42px;
    font-size:27px;
    font-weight:800;
    line-height:1.3;
    letter-spacing:-1px;
}
.logo span{color:#7777ff}
.admin-card{
    padding:21px;
    margin-bottom:30px;
    background:var(--navy-card);
    border:1px solid #353d52;
    border-radius:18px;
}
.admin-avatar{
    width:54px;height:54px;
    display:flex;align-items:center;justify-content:center;
    margin-bottom:17px;
    border-radius:17px;
    background:var(--purple-light);
    font-size:25px;
}
.admin-name{font-size:18px;font-weight:700;margin-bottom:5px}
.admin-role{font-size:14px;color:#b4c2dc}
.nav-label{
    padding:0 16px 12px;
    color:#8292b3;
    font-size:12px;
    font-weight:800;
    letter-spacing:1.2px;
    text-transform:uppercase;
}
.nav{display:flex;flex-direction:column;gap:6px}
.nav a{
    display:flex;align-items:center;gap:19px;
    min-height:62px;
    padding:15px 21px;
    border-radius:14px;
    color:#d0d8ea;
    font-size:15px;
    font-weight:600;
    transition:background .2s,color .2s;
}
.nav a:hover,.nav a.active{background:var(--purple);color:white}
.nav-icon{width:19px;flex-shrink:0;text-align:center;font-size:18px}
.nav-section{margin-top:30px}
.nav a.logout{margin-top:12px;color:#fecaca}
.nav a.logout:hover{background:#492333}

/* MOBILE NAVIGATION */
.overlay{
    display:none;
    position:fixed;
    inset:0;
    background:rgba(15,23,42,.55);
    z-index:900;
}
.mobile-topbar{display:none}

/* MAIN CONTENT */
.main{
    min-width:0;
    margin-left:300px;
    padding:30px;
}
.page-header{
    display:flex;
    align-items:center;
    justify-content:space-between;
    flex-wrap:wrap;
    gap:16px;
    margin-bottom:24px;
}
.eyebrow{
    margin-bottom:7px;
    color:#5146dc;
    font-size:12px;
    font-weight:800;
    letter-spacing:1.5px;
    text-transform:uppercase;
}
.page-header h1{
    margin-bottom:8px;
    font-size:30px;
    line-height:1.25;
    font-weight:750;
    letter-spacing:-.5px;
}
.page-header p{font-size:14px;color:var(--muted);line-height:1.7}
.back-btn{
    display:inline-flex;align-items:center;justify-content:center;gap:8px;
    min-height:42px;padding:10px 15px;
    background:white;border:1px solid var(--border);
    border-radius:10px;color:#35425b;
    font-size:13px;font-weight:700;
}
.back-btn:hover{background:#f8f7ff;border-color:#d4d0ff}

/* CARDS */
.card{
    min-width:0;
    padding:23px;
    margin-bottom:22px;
    background:white;
    border:1px solid var(--border);
    border-radius:17px;
    box-shadow:0 5px 22px rgba(15,23,42,.035);
}
.card-title{
    display:flex;align-items:center;gap:10px;
    margin-bottom:19px;
    color:#172033;
    font-size:17px;
    font-weight:750;
}
.title-icon{
    display:inline-flex;align-items:center;justify-content:center;
    width:34px;height:34px;flex-shrink:0;
    border-radius:10px;background:#eeebff;color:#5146dc;
    font-size:17px;
}
.complaint-heading{
    display:flex;align-items:flex-start;justify-content:space-between;
    gap:18px;flex-wrap:wrap;
}
.complaint-title{
    margin-bottom:6px;
    font-size:23px;
    line-height:1.4;
    font-weight:750;
    overflow-wrap:anywhere;
}
.complaint-id{font-size:12px;color:var(--muted)}
.badges{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.badge{
    display:inline-flex;align-items:center;justify-content:center;
    padding:6px 10px;
    border-radius:30px;
    font-size:10px;font-weight:800;
    letter-spacing:.35px;
}
.priority-high{background:#fee2e2;color:#b91c1c}
.priority-medium{background:#fef3c7;color:#92400e}
.priority-low{background:#dcfce7;color:#166534}
.status-pending{background:#fff2d8;color:#a66b00}
.status-assigned{background:#e4efff;color:#245dc5}
.status-progress{background:#eee9ff;color:#6841cb}
.status-resolved{background:#def8e9;color:#16834c}

/* CONTENT GRID */
.content-grid{
    display:grid;
    grid-template-columns:minmax(0,1.5fr) minmax(270px,1fr);
    align-items:start;
    gap:22px;
}
.column{min-width:0}
.info-grid{
    display:grid;
    grid-template-columns:repeat(2,minmax(0,1fr));
    gap:12px;
}
.info-item{
    min-width:0;
    padding:14px;
    background:#f8f9fd;
    border:1px solid #edf0f6;
    border-radius:12px;
}
.info-label{
    margin-bottom:6px;
    color:#8290a8;
    font-size:10px;
    font-weight:800;
    letter-spacing:.7px;
    text-transform:uppercase;
}
.info-value{
    color:#27334a;
    font-size:13px;
    font-weight:650;
    overflow-wrap:anywhere;
    word-break:break-word;
}
.section-label{margin-top:20px}
.description{
    padding:15px;
    background:#f8f9fd;
    border:1px solid #edf0f6;
    border-radius:12px;
    color:#526078;
    font-size:13px;
    line-height:1.8;
    white-space:pre-wrap;
    overflow-wrap:anywhere;
}
.complaint-image{margin-top:20px}
.complaint-image img{
    display:block;
    width:100%;
    max-width:520px;
    max-height:360px;
    object-fit:contain;
    object-position:left center;
    background:#f8f9fd;
    border:1px solid var(--border);
    border-radius:12px;
}
.resolution{
    padding:15px;
    background:#effcf4;
    border:1px solid #c5f0d4;
    border-radius:12px;
    color:#166534;
    font-size:13px;
    line-height:1.8;
    white-space:pre-wrap;
    overflow-wrap:anywhere;
}

/* FORM */
.form-group{margin-bottom:16px}
.form-group label{
    display:block;margin-bottom:7px;
    color:#35425b;font-size:13px;font-weight:700;
}
select,textarea{
    display:block;width:100%;
    padding:11px 12px;
    border:1px solid #d8e0eb;
    border-radius:10px;
    background:white;color:#27334a;
    font-size:13px;
}
select{min-height:44px}
textarea{min-height:115px;resize:vertical;line-height:1.7}
select:focus,textarea:focus{
    outline:none;border-color:#8b80f8;
    box-shadow:0 0 0 3px rgba(81,70,220,.10);
}
.btn-primary{
    display:flex;align-items:center;justify-content:center;gap:8px;
    width:100%;min-height:45px;
    padding:12px 16px;
    border:0;border-radius:10px;
    background:var(--purple);color:white;
    font-size:13px;font-weight:750;
    cursor:pointer;transition:background .2s;
}
.btn-primary:hover{background:#2d258e}

/* COMMENTS AND HISTORY */
.comment,.timeline-item{
    padding:14px;
    margin-bottom:12px;
    background:#f8f9fd;
    border:1px solid #edf0f6;
    border-radius:12px;
}
.comment:last-child,.timeline-item:last-child{margin-bottom:0}
.comment-header{
    display:flex;align-items:flex-start;justify-content:space-between;
    flex-wrap:wrap;gap:6px 12px;margin-bottom:8px;
}
.comment-user{font-size:13px;font-weight:750}
.comment-date{font-size:11px;color:#94a0b4;overflow-wrap:anywhere}
.comment-text{
    color:#526078;font-size:13px;line-height:1.7;
    white-space:pre-wrap;overflow-wrap:anywhere;
}
.timeline-item{border-left:4px solid #5146dc}
.timeline-status{font-size:13px;font-weight:750;margin-bottom:6px;overflow-wrap:anywhere}
.timeline-meta{font-size:11px;color:#8290a8;line-height:1.7;margin-bottom:7px}
.timeline-remarks{font-size:13px;color:#526078;line-height:1.7;white-space:pre-wrap}
.no-data{
    padding:23px 12px;
    border:1px dashed #d8dfeb;
    border-radius:11px;
    color:#8995a8;
    font-size:12px;
    line-height:1.7;
    text-align:center;
}
.staff-details{display:grid;gap:12px}
.rating-card{
    background:linear-gradient(145deg,#fffaf1,#fff);
    border-color:#fed7aa;
}
.stars{margin-bottom:7px;font-size:25px;letter-spacing:2px}
.star-filled{color:#f59e0b}
.star-empty{color:#d1d5db}
.rating-number{font-size:17px;font-weight:800;color:#92400e;margin-bottom:13px}
.feedback{
    padding:13px;background:white;border:1px solid #fde68a;
    border-radius:10px;color:#57534e;font-size:13px;
    line-height:1.7;white-space:pre-wrap;overflow-wrap:anywhere;
}
.rated-at{margin-top:15px}

/* RESPONSIVE */
@media(max-width:1200px){
    .content-grid{grid-template-columns:minmax(0,1fr)}
    .right-column{
        display:grid;
        grid-template-columns:repeat(2,minmax(0,1fr));
        gap:0 18px;
        align-items:start;
    }
}
@media(max-width:760px){
    .sidebar{
        width:min(285px,84vw);
        padding:22px 16px;
        transform:translateX(-105%);
        box-shadow:15px 0 35px rgba(15,23,42,.16);
    }
    .sidebar.open{transform:translateX(0)}
    .overlay.show{display:block}
    .main{margin-left:0;padding:16px}
    .mobile-topbar{
        display:flex;align-items:center;justify-content:space-between;gap:12px;
        margin:-16px -16px 22px;padding:12px 16px;
        background:white;border-bottom:1px solid var(--border);
    }
    .mobile-brand{font-size:22px;font-weight:800;letter-spacing:-.5px}
    .mobile-brand span{color:#7777ff}
    .mobile-menu{
        display:inline-flex;align-items:center;justify-content:center;
        width:43px;height:43px;border:1px solid var(--border);
        border-radius:10px;background:white;font-size:20px;cursor:pointer;
    }
    .page-header h1{font-size:25px}
    .page-header{margin-bottom:18px}
    .card{padding:18px;margin-bottom:16px}
    .complaint-title{font-size:20px}
    .right-column{display:block}
}
@media(max-width:430px){
    .main{padding:12px}
    .mobile-topbar{margin:-12px -12px 18px;padding:11px 12px}
    .page-header h1{font-size:23px}
    .card{padding:15px}
    .info-grid{grid-template-columns:minmax(0,1fr)}
    .back-btn{width:100%}
    .complaint-heading{flex-direction:column}
}
@media(prefers-reduced-motion:reduce){
    *,*::before,*::after{scroll-behavior:auto!important;transition:none!important}
}
</style>
</head>

<body>

<div class="overlay" id="overlay"></div>

<!-- SIDEBAR -->
<aside class="sidebar" id="sidebar" aria-label="Admin navigation">
    <div class="logo">Smart<span>Fix</span></div>

    <div class="admin-card">
        <div class="admin-avatar">👤</div>
        <div class="admin-name">SmartFix Admin</div>
        <div class="admin-role">Administrator</div>
    </div>

    <div class="nav-label">Main Menu</div>

    <nav class="nav">
        <a href="<%= ctx %>/admin/dashboard">
            <span class="nav-icon">⌂</span>Dashboard
        </a>
        <a class="active" href="<%= ctx %>/admin/complaints">
            <span class="nav-icon">▤</span>Complaints
        </a>
        <a href="<%= ctx %>/admin/users">
            <span class="nav-icon">♙</span>Users
        </a>
        <a href="<%= ctx %>/admin/staff">
            <span class="nav-icon">⚒</span>Staff
        </a>
        <a href="<%= ctx %>/notifications">
            <span class="nav-icon">♧</span>Notifications
        </a>
    </nav>

    <div class="nav-label nav-section">Account</div>

    <nav class="nav">
        <a href="<%= ctx %>/admin/profile">
            <span class="nav-icon">⚙</span>My Profile
        </a>
        <a class="logout" href="<%= ctx %>/logout">
            <span class="nav-icon">↪</span>Logout
        </a>
    </nav>
</aside>

<!-- MAIN -->
<main class="main">

    <div class="mobile-topbar">
        <button class="mobile-menu" id="menuButton" type="button"
                aria-label="Open navigation" aria-expanded="false">☰</button>
        <div class="mobile-brand">Smart<span>Fix</span></div>
        <div style="width:43px"></div>
    </div>

    <header class="page-header">
        <div>
            <div class="eyebrow">Complaint Management</div>
            <h1>Complaint Details</h1>
            <p>Review complaint information, monitor progress and manage updates.</p>
        </div>
        <a class="back-btn" href="<%= ctx %>/admin/complaints">
            ← Back to Complaints
        </a>
    </header>

    <!-- COMPLAINT SUMMARY -->
    <section class="card">
        <div class="complaint-heading">
            <div>
                <div class="complaint-title"><%= title %></div>
                <div class="complaint-id">
                    Complaint ID: #<%= complaint.getComplaintId() %>
                </div>
            </div>

            <div class="badges">
                <span class="badge priority-<%= priorityClass %>">
                    <%= priority %> PRIORITY
                </span>
                <span class="badge status-<%= statusClass %>">
                    <%= status %>
                </span>
            </div>
        </div>
    </section>

    <div class="content-grid">

        <!-- LEFT COLUMN -->
        <div class="column">

            <!-- Complaint information -->
            <section class="card">
                <h2 class="card-title">
                    <span class="title-icon">▤</span>
                    Complaint Information
                </h2>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Category</div>
                        <div class="info-value">
                            <%= complaint.getCategory() == null
                                || complaint.getCategory().trim().isEmpty()
                                ? "Not specified" : complaint.getCategory() %>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Priority</div>
                        <div class="info-value"><%= priority %></div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Current Status</div>
                        <div class="info-value"><%= status %></div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Created At</div>
                        <div class="info-value">
                            <%= complaint.getCreatedAt() == null
                                ? "Not available" : complaint.getCreatedAt() %>
                        </div>
                    </div>
                </div>

                <div class="info-label section-label">Description</div>
                <div class="description"><%= description %></div>

                <% if (complaint.getImagePath() != null
                    && !complaint.getImagePath().trim().isEmpty()) { %>
                    <div class="complaint-image">
                        <div class="info-label">Attached Image</div>
                        <a href="<%= ctx %>/<%= complaint.getImagePath() %>"
                           target="_blank" rel="noopener noreferrer">
                            <img src="<%= ctx %>/<%= complaint.getImagePath() %>"
                                 alt="Complaint attachment" loading="lazy">
                        </a>
                    </div>
                <% } %>
            </section>

            <!-- Resolution notes -->
            <% if (complaint.getResolutionNotes() != null
                && !complaint.getResolutionNotes().trim().isEmpty()) { %>
                <section class="card">
                    <h2 class="card-title">
                        <span class="title-icon">✓</span>Resolution Notes
                    </h2>
                    <div class="resolution"><%= complaint.getResolutionNotes() %></div>

                    <% if (complaint.getResolvedAt() != null) { %>
                        <div class="rated-at">
                            <div class="info-label">Resolved At</div>
                            <div class="info-value"><%= complaint.getResolvedAt() %></div>
                        </div>
                    <% } %>
                </section>
            <% } %>

            <!-- Comments -->
            <section class="card">
                <h2 class="card-title">
                    <span class="title-icon">☷</span>Comments
                </h2>

                <% if (commentList != null && !commentList.isEmpty()) {
                    for (Comment comment : commentList) { %>
                        <article class="comment">
                            <div class="comment-header">
                                <span class="comment-user">
                                    User #<%= comment.getUserId() %>
                                </span>
                                <span class="comment-date">
                                    <%= comment.getCreatedAt() == null
                                        ? "Date unavailable" : comment.getCreatedAt() %>
                                </span>
                            </div>
                            <div class="comment-text"><%= comment.getCommentText() == null
                                ? "" : comment.getCommentText() %></div>
                        </article>
                    <% }
                } else { %>
                    <div class="no-data">No comments available for this complaint.</div>
                <% } %>
            </section>

            <!-- History -->
            <section class="card">
                <h2 class="card-title">
                    <span class="title-icon">◷</span>Complaint History
                </h2>

                <% if (historyList != null && !historyList.isEmpty()) {
                    for (ComplaintHistory history : historyList) { %>
                        <article class="timeline-item">
                            <div class="timeline-status">
                                <% if (history.getOldStatus() != null
                                    && !history.getOldStatus().trim().isEmpty()) { %>
                                    <%= history.getOldStatus() %>
                                    &rarr;
                                    <%= history.getNewStatus() == null
                                        ? "Unknown" : history.getNewStatus() %>
                                <% } else { %>
                                    <%= history.getNewStatus() == null
                                        ? "Status updated" : history.getNewStatus() %>
                                <% } %>
                            </div>

                            <div class="timeline-meta">
                                Changed by: <%= history.getChangedBy() %>
                                &nbsp; · &nbsp;
                                <%= history.getChangedAt() == null
                                    ? "Date unavailable" : history.getChangedAt() %>
                            </div>

                            <% if (history.getRemarks() != null
                                && !history.getRemarks().trim().isEmpty()) { %>
                                <div class="timeline-remarks"><%= history.getRemarks() %></div>
                            <% } %>
                        </article>
                    <% }
                } else { %>
                    <div class="no-data">No complaint history available.</div>
                <% } %>
            </section>
        </div>

        <!-- RIGHT COLUMN -->
        <div class="column right-column">

            <!-- User details -->
            <section class="card">
                <h2 class="card-title">
                    <span class="title-icon">♙</span>Complaint User
                </h2>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">User ID</div>
                        <div class="info-value">#<%= complaint.getUserId() %></div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">User Name</div>
                        <div class="info-value">
                            <%= complaintUser != null
                                && complaintUser.getName() != null
                                && !complaintUser.getName().trim().isEmpty()
                                ? complaintUser.getName()
                                : "User #" + complaint.getUserId() %>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Email</div>
                        <div class="info-value">
                            <%= complaintUser != null
                                && complaintUser.getEmail() != null
                                && !complaintUser.getEmail().trim().isEmpty()
                                ? complaintUser.getEmail() : "Not available" %>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Phone</div>
                        <div class="info-value">
                            <%= complaintUser != null
                                && complaintUser.getPhone() != null
                                && !complaintUser.getPhone().trim().isEmpty()
                                ? complaintUser.getPhone() : "Not available" %>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Room Number</div>
                        <div class="info-value">
                            <%= complaintUser != null
                                && complaintUser.getRoomNumber() != null
                                && !complaintUser.getRoomNumber().trim().isEmpty()
                                ? complaintUser.getRoomNumber() : "Not provided" %>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Assigned staff -->
            <section class="card">
                <h2 class="card-title">
                    <span class="title-icon">⚒</span>Assigned Staff
                </h2>

                <% if (complaint.getStaffId() != null) { %>
                    <div class="staff-details">
                        <div class="info-item">
                            <div class="info-label">Staff ID</div>
                            <div class="info-value">#<%= complaint.getStaffId() %></div>
                        </div>

                        <% if (complaintStaff != null) { %>
                            <div class="info-item">
                                <div class="info-label">Staff Name</div>
                                <div class="info-value">
                                    <%= complaintStaff.getName() == null
                                        ? "Not available" : complaintStaff.getName() %>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-label">Specialization</div>
                                <div class="info-value">
                                    <%= complaintStaff.getSpecialization() == null
                                        ? "Not specified"
                                        : complaintStaff.getSpecialization() %>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="no-data">Staff details are not available.</div>
                        <% } %>
                    </div>
                <% } else { %>
                    <div class="no-data">No staff assigned yet.</div>
                <% } %>
            </section>

            <!-- Update form -->
            <section class="card">
                <h2 class="card-title">
                    <span class="title-icon">↻</span>Update Complaint
                </h2>

                <form action="<%= ctx %>/admin/update-complaint" method="post">
                    <input type="hidden" name="complaintId"
                           value="<%= complaint.getComplaintId() %>">

                    <div class="form-group">
                        <label for="priority">Priority</label>
                        <select id="priority" name="priority" required>
                            <option value="LOW"
                                <%= "LOW".equalsIgnoreCase(priority) ? "selected" : "" %>>
                                Low
                            </option>
                            <option value="MEDIUM"
                                <%= "MEDIUM".equalsIgnoreCase(priority) ? "selected" : "" %>>
                                Medium
                            </option>
                            <option value="HIGH"
                                <%= "HIGH".equalsIgnoreCase(priority) ? "selected" : "" %>>
                                High
                            </option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="status">Complaint Status</label>
                        <select id="status" name="status" required>
                            <option value="PENDING"
                                <%= "PENDING".equalsIgnoreCase(status) ? "selected" : "" %>>
                                Pending
                            </option>
                            <option value="ASSIGNED"
                                <%= "ASSIGNED".equalsIgnoreCase(status) ? "selected" : "" %>>
                                Assigned
                            </option>
                            <option value="IN PROGRESS"
                                <%= "IN PROGRESS".equalsIgnoreCase(status) ? "selected" : "" %>>
                                In Progress
                            </option>
                            <option value="RESOLVED"
                                <%= "RESOLVED".equalsIgnoreCase(status) ? "selected" : "" %>>
                                Resolved
                            </option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="resolutionNotes">Resolution Notes</label>
                        <textarea id="resolutionNotes" name="resolutionNotes"
                            placeholder="Describe the fix or resolution..."><%= complaint.getResolutionNotes() == null
                                ? "" : complaint.getResolutionNotes() %></textarea>
                    </div>

                    <button type="submit" class="btn-primary">
                        Save Complaint Updates
                    </button>
                </form>
            </section>

            <!-- Rating -->
            <section class="card rating-card">
                <h2 class="card-title">
                    <span class="title-icon">★</span>User Rating
                </h2>

                <% if (rating != null) { %>
                    <div class="stars"
                         aria-label="Rating <%= rating.getRating() %> out of 5">
                        <% for (int i = 1; i <= 5; i++) {
                            if (i <= rating.getRating()) { %>
                                <span class="star-filled">★</span>
                            <% } else { %>
                                <span class="star-empty">★</span>
                            <% }
                        } %>
                    </div>

                    <div class="rating-number"><%= rating.getRating() %> / 5</div>

                    <div class="feedback">
                        <strong>Feedback</strong><br><br><%= rating.getFeedback() != null
                            && !rating.getFeedback().trim().isEmpty()
                            ? rating.getFeedback()
                            : "No written feedback provided." %>
                    </div>

                    <div class="rated-at">
                        <div class="info-label">Rated At</div>
                        <div class="info-value">
                            <%= rating.getCreatedAt() == null
                                ? "Not available" : rating.getCreatedAt() %>
                        </div>
                    </div>
                <% } else { %>
                    <div class="no-data">No rating submitted yet.</div>
                <% } %>
            </section>

        </div>
    </div>
</main>

<script>
(function () {
    const sidebar = document.getElementById("sidebar");
    const overlay = document.getElementById("overlay");
    const menuButton = document.getElementById("menuButton");

    function openMenu() {
        sidebar.classList.add("open");
        overlay.classList.add("show");
        menuButton.textContent = "✕";
        menuButton.setAttribute("aria-expanded", "true");
        document.body.style.overflow = "hidden";
    }

    function closeMenu() {
        sidebar.classList.remove("open");
        overlay.classList.remove("show");
        menuButton.textContent = "☰";
        menuButton.setAttribute("aria-expanded", "false");
        document.body.style.overflow = "";
    }

    menuButton.addEventListener("click", function () {
        sidebar.classList.contains("open") ? closeMenu() : openMenu();
    });

    overlay.addEventListener("click", closeMenu);

    sidebar.querySelectorAll("a").forEach(function (link) {
        link.addEventListener("click", closeMenu);
    });

    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape") closeMenu();
    });

    window.addEventListener("resize", function () {
        if (window.innerWidth > 760) closeMenu();
    });
})();
</script>

</body>
</html>

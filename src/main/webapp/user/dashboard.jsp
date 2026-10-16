<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.smartfix.modelcom.User" %>
<%@ page import="java.util.Locale" %>

<%!
    // Escape dynamic text before displaying it in HTML.
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
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String message = request.getParameter("message");

    int unreadCount = 0;

    try {
        com.smartfix.service.NotificationService notificationService =
            new com.smartfix.service.impl.NotificationServiceImpl();

        String userRole = user.getRole();

        if (userRole == null || userRole.trim().isEmpty()) {
            userRole = "USER";
        } else {
            userRole = userRole.trim().toUpperCase(Locale.ROOT);
        }

        unreadCount =
            notificationService.getUnreadNotificationCount(
                user.getUserId(),
                userRole
            );

    } catch (Exception e) {
        unreadCount = 0;
        application.log("Unable to load SmartFix notification count.", e);
    }

    if (unreadCount < 0) {
        unreadCount = 0;
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>SmartFix - User Dashboard</title>

    <link rel="stylesheet"
          href="<%= contextPath %>/css/style.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            color: #1e293b;
            background: #f5f7fb;
            font-family: Arial, Helvetica, sans-serif;
            line-height: 1.5;
        }

        .dashboard-page {
            width: 100%;
            max-width: 1440px;
            min-height: 100vh;
            margin: 0 auto;
            padding: 20px 24px 36px;
        }

        /* Welcome section */

        .dashboard-header {
            background: linear-gradient(120deg, #1e40af, #2563eb);
            color: #ffffff;
            padding: 26px 30px;
            border-radius: 16px;
            margin-bottom: 22px;
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.12);
        }

        .dashboard-brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 18px;
        }

        .dashboard-logo {
            width: 46px;
            height: 46px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 12px;
            font-size: 23px;
            font-weight: 700;
        }

        .dashboard-brand h1 {
            margin: 0;
            font-size: 25px;
            line-height: 1.3;
        }

        .dashboard-brand p {
            margin: 4px 0 0;
            font-size: 13px;
            opacity: 0.9;
        }

        .welcome-title {
            font-size: 25px;
            line-height: 1.4;
            margin: 0 0 8px;
            overflow-wrap: anywhere;
        }

        .welcome-text {
            font-size: 14px;
            color: #eff6ff;
            max-width: 650px;
            line-height: 1.7;
            margin: 0;
        }

        /* Success message */

        .success-message {
            margin: 0 0 20px;
            padding: 12px 16px;
            border: 1px solid #bbf7d0;
            border-radius: 10px;
            background: #f0fdf4;
            color: #166534;
            font-size: 14px;
            overflow-wrap: anywhere;
        }

        /* Action cards */

        .dashboard-actions {
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 22px;
        }

        .action-card {
            display: block;
            position: relative;
            min-width: 0;
            padding: 20px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            text-decoration: none;
            color: #1e293b;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.035);
            transition: border-color 0.2s ease,
                        box-shadow 0.2s ease;
        }

        .action-card:hover {
            border-color: #93c5fd;
            box-shadow: 0 6px 18px rgba(37, 99, 235, 0.09);
        }

        .action-card:focus-visible {
            outline: 3px solid #93c5fd;
            outline-offset: 3px;
        }

        .action-icon {
            width: 42px;
            height: 42px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 11px;
            background: #eff6ff;
            color: #2563eb;
            font-size: 19px;
            font-weight: 700;
            margin-bottom: 13px;
        }

        .action-card h3 {
            font-size: 15px;
            line-height: 1.4;
            margin: 0 0 7px;
            color: #1e293b;
        }

        .action-card p {
            font-size: 13px;
            color: #64748b;
            line-height: 1.55;
            margin: 0;
        }

        .logout-card {
            background: #fffafa;
        }

        .logout-card .action-icon {
            background: #fef2f2;
            color: #dc2626;
        }

        .notification-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            min-width: 23px;
            height: 23px;
            padding: 0 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #dc2626;
            color: #ffffff;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
        }

        /* Main panels */

        .dashboard-grid {
            display: grid;
            grid-template-columns: minmax(0, 1.2fr) minmax(0, 0.8fr);
            gap: 20px;
            align-items: start;
        }

        .dashboard-card {
            min-width: 0;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            padding: 23px;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.035);
        }

        .card-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }

        .card-heading h2 {
            margin: 0;
            font-size: 19px;
            color: #1e293b;
        }

        .card-heading span {
            font-size: 12px;
            color: #64748b;
            text-align: right;
        }

        /* Profile information */

        .profile-item {
            display: flex;
            align-items: center;
            padding: 13px 0;
            border-bottom: 1px solid #edf0f5;
        }

        .profile-item:last-child {
            border-bottom: none;
        }

        .profile-icon {
            width: 38px;
            height: 38px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #eff6ff;
            color: #2563eb;
            border-radius: 10px;
            margin-right: 13px;
            font-size: 13px;
            font-weight: 700;
        }

        .profile-info {
            flex: 1;
            min-width: 0;
        }

        .profile-info small {
            display: block;
            color: #64748b;
            font-size: 12px;
            margin-bottom: 4px;
        }

        .profile-info strong {
            display: block;
            color: #334155;
            font-size: 14px;
            line-height: 1.5;
            overflow-wrap: anywhere;
            font-weight: 600;
        }

        /* Quick guide */

        .quick-info {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .info-box {
            padding: 15px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
        }

        .info-box h3 {
            font-size: 14px;
            color: #334155;
            margin: 0 0 6px;
        }

        .info-box p {
            font-size: 13px;
            color: #64748b;
            line-height: 1.6;
            margin: 0;
        }

        /* Tablet */

        @media (max-width: 1100px) {
            .dashboard-actions {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 800px) {
            .dashboard-actions {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Mobile */

        @media (max-width: 520px) {
            .dashboard-page {
                padding: 12px 12px 24px;
            }

            .dashboard-header {
                padding: 22px 18px;
                border-radius: 14px;
            }

            .dashboard-brand h1 {
                font-size: 23px;
            }

            .dashboard-brand p {
                font-size: 12px;
            }

            .welcome-title {
                font-size: 22px;
            }

            .welcome-text {
                font-size: 13px;
            }

            .dashboard-actions {
                grid-template-columns: 1fr;
                gap: 12px;
            }

            .action-card {
                padding: 17px;
            }

            .dashboard-card {
                padding: 18px;
            }

            .card-heading h2 {
                font-size: 17px;
            }

            .card-heading span {
                font-size: 11px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                animation-duration: 0.01ms !important;
                transition-duration: 0.01ms !important;
                scroll-behavior: auto !important;
            }
        }
    </style>
</head>

<body>

<div class="container dashboard-page">

    <!-- HEADER -->

    <header class="dashboard-header">

        <div class="dashboard-brand">

            <div class="dashboard-logo">S</div>

            <div>
                <h1>SmartFix</h1>
                <p>Complaint &amp; Service Management System</p>
            </div>

        </div>

        <h2 class="welcome-title">
            Welcome, <%= escapeHtml(user.getName()) %> 👋
        </h2>

        <p class="welcome-text">
            Manage your complaints, track service progress,
            receive service updates, and keep your profile
            information up to date from one place.
        </p>

    </header>

    <!-- SUCCESS MESSAGE -->

    <%
        if (message != null && !message.trim().isEmpty()) {
    %>
        <div class="success-message" role="status">
            <%= escapeHtml(message) %>
        </div>
    <%
        }
    %>

    <!-- ACTION CARDS -->

    <section class="dashboard-actions" aria-label="Dashboard actions">

        <a href="<%= contextPath %>/user/raise-complaint.jsp"
           class="action-card">

            <div class="action-icon" aria-hidden="true">+</div>

            <h3>Raise Complaint</h3>

            <p>Report a new problem or service issue.</p>

        </a>

        <a href="<%= contextPath %>/myComplaints"
           class="action-card">

            <div class="action-icon" aria-hidden="true">✓</div>

            <h3>My Complaints</h3>

            <p>View and track all your submitted complaints.</p>

        </a>

        <a href="<%= contextPath %>/notifications"
           class="action-card">

            <%
                if (unreadCount > 0) {
            %>
                <span class="notification-badge"
                      aria-label="<%= unreadCount %> unread notifications">
                    <%= unreadCount > 99 ? "99+" : unreadCount %>
                </span>
            <%
                }
            %>

            <div class="action-icon" aria-hidden="true">🔔</div>

            <h3>Notifications</h3>

            <p>
                <%
                    if (unreadCount > 0) {
                %>
                    You have
                    <strong><%= unreadCount %></strong>
                    unread notification<%= unreadCount == 1 ? "" : "s" %>.
                <%
                    } else {
                %>
                    View your latest SmartFix service updates.
                <%
                    }
                %>
            </p>

        </a>

        <a href="<%= contextPath %>/user/profile.jsp"
           class="action-card">

            <div class="action-icon" aria-hidden="true">👤</div>

            <h3>My Profile</h3>

            <p>View your personal account information.</p>

        </a>

        <a href="<%= contextPath %>/logout"
           class="action-card logout-card">

            <div class="action-icon" aria-hidden="true">↪</div>

            <h3>Logout</h3>

            <p>Securely sign out from your SmartFix account.</p>

        </a>

    </section>

    <!-- MAIN CONTENT -->

    <main class="dashboard-grid">

        <!-- USER INFORMATION -->

        <section class="dashboard-card">

            <div class="card-heading">
                <h2>My Information</h2>
                <span>Account Details</span>
            </div>

            <div class="profile-item">

                <div class="profile-icon" aria-hidden="true">ID</div>

                <div class="profile-info">
                    <small>User ID</small>
                    <strong><%= user.getUserId() %></strong>
                </div>

            </div>

            <div class="profile-item">

                <div class="profile-icon" aria-hidden="true">N</div>

                <div class="profile-info">
                    <small>Full Name</small>
                    <strong><%= escapeHtml(user.getName()) %></strong>
                </div>

            </div>

            <div class="profile-item">

                <div class="profile-icon" aria-hidden="true">@</div>

                <div class="profile-info">
                    <small>Email Address</small>
                    <strong><%= escapeHtml(user.getEmail()) %></strong>
                </div>

            </div>

            <div class="profile-item">

                <div class="profile-icon" aria-hidden="true">P</div>

                <div class="profile-info">
                    <small>Phone Number</small>
                    <strong><%= escapeHtml(user.getPhone()) %></strong>
                </div>

            </div>

            <div class="profile-item">

                <div class="profile-icon" aria-hidden="true">A</div>

                <div class="profile-info">
                    <small>Address</small>
                    <strong><%= escapeHtml(user.getAddress()) %></strong>
                </div>

            </div>

        </section>

        <!-- QUICK GUIDE -->

        <section class="dashboard-card">

            <div class="card-heading">
                <h2>SmartFix</h2>
                <span>Quick Guide</span>
            </div>

            <div class="quick-info">

                <div class="info-box">
                    <h3>Raise an Issue</h3>
                    <p>
                        Submit your complaint with a title,
                        description, category and priority.
                    </p>
                </div>

                <div class="info-box">
                    <h3>Track Progress</h3>
                    <p>
                        Check your complaints and monitor
                        their current status.
                    </p>
                </div>

                <div class="info-box">
                    <h3>Service Updates</h3>
                    <p>
                        Your complaint can move through
                        Pending, Assigned, In Progress and
                        Resolved stages.
                    </p>
                </div>

                <div class="info-box">
                    <h3>Notifications</h3>
                    <p>
                        SmartFix will notify you when your
                        complaint is assigned, updated or resolved.
                    </p>
                </div>

            </div>

        </section>

    </main>

</div>

</body>
</html>
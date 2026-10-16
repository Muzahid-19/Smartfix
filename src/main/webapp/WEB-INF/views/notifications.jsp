<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>

<%@ page import="com.smartfix.modelcom.Notification" %>
<%@ page import="com.smartfix.modelcom.User" %>
<%@ page import="com.smartfix.modelcom.Staff" %>

<%
    // =====================================================
    // GET DATA FROM SERVLET
    // =====================================================

    List<Notification> notifications =
            (List<Notification>) request.getAttribute("notifications");

    Integer unreadCountObj =
            (Integer) request.getAttribute("unreadCount");

    int unreadCount =
            unreadCountObj != null
            ? unreadCountObj
            : 0;

    String recipientRole =
            (String) request.getAttribute("recipientRole");

    if (recipientRole == null) {
        recipientRole = "";
    }

    recipientRole = recipientRole.trim().toUpperCase();


    // =====================================================
    // CHECK LOGIN
    // =====================================================

    User user =
            (User) session.getAttribute("user");

    Staff staff =
            (Staff) session.getAttribute("staff");

    if (user == null && staff == null) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp"
        );

        return;
    }


    // =====================================================
    // DASHBOARD URL
    // =====================================================

    String dashboardUrl =
            request.getContextPath() + "/login.jsp";

    if ("ADMIN".equalsIgnoreCase(recipientRole)) {

        dashboardUrl =
                request.getContextPath()
                + "/admin/dashboard";

    } else if ("STAFF".equalsIgnoreCase(recipientRole)) {

        dashboardUrl =
                request.getContextPath()
                + "/staff/dashboard";

    } else if ("USER".equalsIgnoreCase(recipientRole)) {

        dashboardUrl =
                request.getContextPath()
                + "/user/dashboard.jsp";
    }
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Notifications - SmartFix</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">


    <style>

        .notification-page {
            width: 92%;
            max-width: 1000px;
            margin: 40px auto;
        }


        /* ==============================
           HEADER
           ============================== */

        .notification-page-header {

            background:
                linear-gradient(
                    135deg,
                    #1e3a8a,
                    #2563eb,
                    #0ea5e9
                );

            color: white;

            padding: 28px 30px;

            border-radius: 18px;

            margin-bottom: 22px;

            display: flex;

            align-items: center;

            justify-content: space-between;

            gap: 20px;

            box-shadow:
                0 12px 30px
                rgba(30, 58, 138, 0.20);
        }


        .notification-page-header h1 {

            margin: 0 0 5px 0;

            font-size: 28px;
        }


        .notification-page-header p {

            margin: 0;

            color: #dbeafe;

            font-size: 14px;
        }


        .notification-header-actions {

            display: flex;

            align-items: center;

            gap: 10px;

            flex-wrap: wrap;
        }


        /* ==============================
           DASHBOARD BUTTON
           ============================== */

        .notification-dashboard-btn {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            padding: 10px 16px;

            background: white;

            color: #1e3a8a;

            border-radius: 9px;

            text-decoration: none;

            font-size: 13px;

            font-weight: 700;

            transition: all 0.25s ease;
        }


        .notification-dashboard-btn:hover {

            transform: translateY(-2px);

            box-shadow:
                0 6px 15px
                rgba(0, 0, 0, 0.15);
        }


        /* ==============================
           MARK ALL BUTTON
           ============================== */

        .mark-all-btn {

            border: none;

            padding: 10px 16px;

            background: #0f172a;

            color: white;

            border-radius: 9px;

            cursor: pointer;

            font-size: 13px;

            font-weight: 700;

            transition: all 0.25s ease;
        }


        .mark-all-btn:hover {

            background: #020617;

            transform: translateY(-2px);
        }


        /* ==============================
           SUMMARY
           ============================== */

        .notification-summary {

            display: grid;

            grid-template-columns:
                repeat(2, 1fr);

            gap: 15px;

            margin-bottom: 22px;
        }


        .notification-summary-card {

            background: white;

            padding: 20px;

            border-radius: 14px;

            border: 1px solid #e2e8f0;

            box-shadow:
                0 5px 18px
                rgba(15, 23, 42, 0.05);
        }


        .notification-summary-card span {

            display: block;

            color: #64748b;

            font-size: 13px;

            margin-bottom: 5px;
        }


        .notification-summary-card strong {

            font-size: 25px;

            color: #1e3a8a;
        }


        /* ==============================
           NOTIFICATION LIST
           ============================== */

        .notification-list {

            display: flex;

            flex-direction: column;

            gap: 14px;
        }


        .notification-item {

            display: flex;

            align-items: flex-start;

            gap: 15px;

            padding: 20px;

            background: white;

            border: 1px solid #e2e8f0;

            border-radius: 15px;

            box-shadow:
                0 5px 18px
                rgba(15, 23, 42, 0.05);

            transition:
                transform 0.25s ease,
                box-shadow 0.25s ease,
                border-color 0.25s ease;
        }


        .notification-item:hover {

            transform: translateY(-3px);

            border-color: #bfdbfe;

            box-shadow:
                0 10px 25px
                rgba(37, 99, 235, 0.10);
        }


        /* ==============================
           UNREAD NOTIFICATION
           ============================== */

        .notification-item.unread {

            border-left: 4px solid #2563eb;

            background:
                linear-gradient(
                    135deg,
                    #eff6ff,
                    #ffffff
                );
        }


        .notification-icon {

            width: 45px;

            height: 45px;

            min-width: 45px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 12px;

            background: #dbeafe;

            font-size: 20px;
        }


        .notification-content {

            flex: 1;
        }


        .notification-message {

            color: #1e293b;

            font-size: 14px;

            font-weight: 600;

            margin-bottom: 5px;
        }


        .notification-time {

            color: #94a3b8;

            font-size: 12px;
        }


        /* ==============================
           ACTIONS
           ============================== */

        .notification-actions {

            display: flex;

            align-items: center;

            justify-content: flex-end;

            gap: 7px;

            flex-wrap: wrap;
        }


        /* ==============================
           STATUS
           ============================== */

        .notification-status {

            padding: 5px 9px;

            border-radius: 20px;

            font-size: 10px;

            font-weight: 700;

            white-space: nowrap;
        }


        .notification-status.unread {

            background: #dbeafe;

            color: #1d4ed8;
        }


        .notification-status.read {

            background: #f1f5f9;

            color: #64748b;
        }


        /* ==============================
           MARK AS READ BUTTON
           ============================== */

        .notification-read-btn {

            border: none;

            background: #eff6ff;

            color: #2563eb;

            padding: 7px 11px;

            border-radius: 8px;

            cursor: pointer;

            font-size: 11px;

            font-weight: 700;

            transition: all 0.2s ease;
        }


        .notification-read-btn:hover {

            background: #dbeafe;

            transform: translateY(-1px);
        }


        /* ==============================
           COMPLAINT BUTTON
           ============================== */

        .notification-complaint-link {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            text-decoration: none;

            background: #2563eb;

            color: white;

            padding: 7px 11px;

            border-radius: 8px;

            font-size: 11px;

            font-weight: 700;

            transition: all 0.2s ease;
        }


        .notification-complaint-link:hover {

            background: #1d4ed8;

            transform: translateY(-1px);
        }


        /* ==============================
           NO NOTIFICATIONS
           ============================== */

        .no-notifications {

            text-align: center;

            padding: 65px 20px;

            background: white;

            border: 1px solid #e2e8f0;

            border-radius: 16px;

            color: #64748b;

            box-shadow:
                0 5px 18px
                rgba(15, 23, 42, 0.05);
        }


        .no-notifications-icon {

            font-size: 48px;

            margin-bottom: 12px;
        }


        .no-notifications h3 {

            color: #334155;

            margin-bottom: 5px;
        }


        .no-notifications p {

            font-size: 13px;
        }


        /* ==============================
           MOBILE
           ============================== */

        @media (max-width: 700px) {

            .notification-page {

                width: 94%;

                margin: 25px auto;
            }


            .notification-page-header {

                flex-direction: column;

                align-items: flex-start;

                padding: 22px;
            }


            .notification-header-actions {

                width: 100%;
            }


            .notification-dashboard-btn,
            .mark-all-btn {

                flex: 1;
            }


            .notification-summary {

                grid-template-columns: 1fr;
            }


            .notification-item {

                flex-direction: column;
            }


            .notification-actions {

                width: 100%;

                justify-content: flex-start;
            }

        }

    </style>

</head>


<body>


<div class="notification-page">


    <!-- =================================================
         HEADER
         ================================================= -->

    <div class="notification-page-header">


        <div>

            <h1>🔔 Notifications</h1>

            <p>
                Stay updated with your SmartFix activities.
            </p>

        </div>


        <div class="notification-header-actions">


            <!-- DASHBOARD -->

            <a href="<%= dashboardUrl %>"
               class="notification-dashboard-btn">

                ← Dashboard

            </a>


            <!-- MARK ALL AS READ -->

            <%
                if (notifications != null &&
                    !notifications.isEmpty() &&
                    unreadCount > 0) {
            %>

                <form
                    action="<%= request.getContextPath() %>/notifications"
                    method="post"
                    style="margin:0;">

                    <!-- IMPORTANT:
                         NotificationServlet expects
                         markAllRead
                    -->

                    <input type="hidden"
                           name="action"
                           value="markAllRead">


                    <button type="submit"
                            class="mark-all-btn">

                        ✓ Mark All as Read

                    </button>

                </form>

            <%
                }
            %>

        </div>

    </div>



    <!-- =================================================
         SUMMARY
         ================================================= -->

    <div class="notification-summary">


        <div class="notification-summary-card">

            <span>
                Total Notifications
            </span>

            <strong>

                <%= notifications != null
                    ? notifications.size()
                    : 0 %>

            </strong>

        </div>


        <div class="notification-summary-card">

            <span>
                Unread Notifications
            </span>

            <strong>

                <%= unreadCount %>

            </strong>

        </div>


    </div>



    <!-- =================================================
         NOTIFICATION LIST
         ================================================= -->

    <%
        if (notifications == null ||
            notifications.isEmpty()) {
    %>


        <div class="no-notifications">


            <div class="no-notifications-icon">

                🔕

            </div>


            <h3>
                No Notifications
            </h3>


            <p>
                You don't have any notifications right now.
            </p>


        </div>


    <%
        } else {
    %>


        <div class="notification-list">


            <%
                for (Notification notification
                        : notifications) {


                    boolean unread =
                            !notification.isRead();
            %>


                <div class="notification-item
                    <%= unread ? "unread" : "" %>">


                    <!-- ICON -->

                    <div class="notification-icon">

                        <%= unread ? "🔔" : "✓" %>

                    </div>



                    <!-- MESSAGE -->

                    <div class="notification-content">


                        <div class="notification-message">

                            <%= notification.getMessage() %>

                        </div>


                        <div class="notification-time">

                            <%= notification.getCreatedAt() != null
                                ? notification.getCreatedAt()
                                : "" %>

                        </div>


                    </div>



                    <!-- ACTIONS -->

                    <div class="notification-actions">


                        <!-- VIEW COMPLAINT -->

                        <%
                            if (notification.getComplaintId()
                                    != null) {


                                int complaintId =
                                        notification.getComplaintId();


                                if ("ADMIN".equalsIgnoreCase(
                                        recipientRole)) {
                        %>


                            <a
                                class="notification-complaint-link"
                                href="<%= request.getContextPath() %>/admin/complaint-details?id=<%= complaintId %>">

                                View Complaint

                            </a>


                        <%
                                } else if ("STAFF".equalsIgnoreCase(
                                        recipientRole)) {
                        %>


                            <a
                                class="notification-complaint-link"
                                href="<%= request.getContextPath() %>/staff/complaint-details?id=<%= complaintId %>">

                                View Complaint

                            </a>


                        <%
                                }
                            }
                        %>



                        <!-- =================================
                             MARK SINGLE NOTIFICATION AS READ
                             ================================= -->

                        <%
                            if (unread) {
                        %>


                            <form
                                action="<%= request.getContextPath() %>/notifications"
                                method="post"
                                style="margin:0;">


                                <!-- IMPORTANT:
                                     NotificationServlet expects
                                     markRead
                                -->

                                <input type="hidden"
                                       name="action"
                                       value="markRead">


                                <!-- Notification ID -->

                                <input type="hidden"
                                       name="notificationId"
                                       value="<%= notification.getNotificationId() %>">


                                <button
                                    type="submit"
                                    class="notification-read-btn">

                                    Mark as Read

                                </button>


                            </form>


                        <%
                            }
                        %>



                        <!-- STATUS -->

                        <span
                            class="notification-status
                            <%= unread
                                ? "unread"
                                : "read" %>">


                            <%= unread
                                ? "UNREAD"
                                : "READ" %>


                        </span>


                    </div>


                </div>


            <%
                }
            %>


        </div>


    <%
        }
    %>


</div>


</body>

</html>
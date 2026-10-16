<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.smartfix.modelcom.Staff"%>

<%
    Staff staff = (Staff) request.getAttribute("staff");

    if (staff == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String name = staff.getName();
    String email = staff.getEmail();
    String phone = staff.getPhone();
    String specialization = staff.getSpecialization();

    if (name == null || name.trim().isEmpty()) {
        name = "Staff";
    }

    if (email == null || email.trim().isEmpty()) {
        email = "Not available";
    }

    if (phone == null || phone.trim().isEmpty()) {
        phone = "Not available";
    }

    if (specialization == null || specialization.trim().isEmpty()) {
        specialization = "Not specified";
    }

    String firstLetter =
        name.substring(0, 1).toUpperCase();

    String passwordChanged =
        request.getParameter("passwordChanged");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Staff Profile - SmartFix</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #1e293b;
        }

        /* ================= SIDEBAR ================= */

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 250px;
            height: 100vh;
            background: #0f172a;
            padding: 25px 18px;
            color: white;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
            font-weight: bold;
            padding: 10px;
            margin-bottom: 30px;
        }

        .logo-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #2563eb;
        }

        .menu-title {
            color: #94a3b8;
            font-size: 12px;
            text-transform: uppercase;
            margin: 0 12px 12px;
        }

        .menu a {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 13px 14px;
            margin-bottom: 6px;
            border-radius: 10px;
            color: #cbd5e1;
            text-decoration: none;
            transition: 0.3s;
        }

        .menu a:hover {
            background: #334155;
            color: white;
        }

        .menu a.active {
            background: #2563eb;
            color: white;
        }

        /* ================= MAIN ================= */

        .main {
            margin-left: 250px;
            min-height: 100vh;
        }

        /* ================= TOPBAR ================= */

        .topbar {
            height: 75px;
            background: white;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 35px;
        }

        .topbar h1 {
            font-size: 24px;
            color: #0f172a;
        }

        .topbar p {
            margin-top: 5px;
            color: #64748b;
            font-size: 13px;
        }

        .top-user {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .small-avatar {
            width: 42px;
            height: 42px;
            border-radius: 50%;
            background: #2563eb;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 18px;
        }

        /* ================= CONTENT ================= */

        .content {
            padding: 35px;
        }

        .profile-wrapper {
            max-width: 950px;
            margin: auto;
        }

        /* ================= PROFILE HEADER ================= */

        .profile-header {
            background: linear-gradient(
                135deg,
                #2563eb,
                #4f46e5
            );

            color: white;

            border-radius: 20px;

            padding: 35px;

            display: flex;

            align-items: center;

            gap: 25px;

            margin-bottom: 25px;

            box-shadow:
                0 12px 30px
                rgba(37, 99, 235, 0.2);
        }

        .big-avatar {
            width: 90px;
            height: 90px;

            min-width: 90px;

            border-radius: 50%;

            background:
                rgba(255, 255, 255, 0.2);

            border:
                3px solid
                rgba(255, 255, 255, 0.5);

            display: flex;

            align-items: center;

            justify-content: center;

            font-size: 38px;

            font-weight: bold;
        }

        .profile-header h2 {
            font-size: 28px;
            margin-bottom: 8px;
        }

        .profile-header p {
            color: #dbeafe;
        }

        .badge {
            display: inline-block;

            margin-top: 12px;

            padding: 7px 14px;

            border-radius: 20px;

            background:
                rgba(255, 255, 255, 0.2);

            font-size: 12px;

            font-weight: bold;
        }

        /* ================= SUCCESS MESSAGE ================= */

        .success-message {
            margin-bottom: 20px;

            padding: 14px 18px;

            border-radius: 12px;

            background: #ecfdf5;

            color: #047857;

            border: 1px solid #a7f3d0;

            font-size: 14px;

            font-weight: 600;

            animation: successSlide 0.4s ease;
        }

        @keyframes successSlide {

            from {
                opacity: 0;
                transform: translateY(-8px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* ================= CARD ================= */

        .card {
            background: white;

            border-radius: 18px;

            padding: 30px;

            border: 1px solid #e2e8f0;

            box-shadow:
                0 5px 18px
                rgba(15, 23, 42, 0.06);
        }

        .card h3 {
            font-size: 20px;

            margin-bottom: 25px;

            padding-bottom: 18px;

            border-bottom:
                1px solid #e2e8f0;
        }

        /* ================= DETAILS ================= */

        .details {
            display: grid;

            grid-template-columns: 1fr 1fr;

            gap: 20px;
        }

        .detail {
            background: #f8fafc;

            border: 1px solid #e2e8f0;

            border-radius: 14px;

            padding: 20px;

            transition: 0.3s;
        }

        .detail:hover {
            transform: translateY(-3px);

            border-color: #93c5fd;

            box-shadow:
                0 8px 18px
                rgba(37, 99, 235, 0.08);
        }

        .label {
            color: #64748b;

            font-size: 12px;

            text-transform: uppercase;

            margin-bottom: 8px;
        }

        .value {
            color: #0f172a;

            font-size: 15px;

            font-weight: 600;

            word-break: break-word;
        }

        /* ================= ACTIONS ================= */

        .actions {
            margin-top: 25px;

            display: flex;

            gap: 12px;

            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;

            padding: 12px 20px;

            border-radius: 10px;

            text-decoration: none;

            font-weight: bold;

            font-size: 14px;

            transition: 0.3s;
        }

        /* ================= DASHBOARD ================= */

        .btn-primary {
            background: #2563eb;

            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;

            transform: translateY(-2px);
        }

        /* ================= EDIT PROFILE ================= */

        .btn-edit {
            background: #16a34a;

            color: white;
        }

        .btn-edit:hover {
            background: #15803d;

            transform: translateY(-2px);
        }

        /* ================= CHANGE PASSWORD ================= */

        .btn-password {
            background: linear-gradient(
                135deg,
                #7c3aed,
                #9333ea
            );

            color: white;

            border: 1px solid #7c3aed;

            box-shadow:
                0 6px 15px
                rgba(124, 58, 237, 0.20);
        }

        .btn-password:hover {
            background: linear-gradient(
                135deg,
                #6d28d9,
                #7e22ce
            );

            color: white;

            transform: translateY(-2px);

            box-shadow:
                0 10px 22px
                rgba(124, 58, 237, 0.30);
        }

        /* ================= LOGOUT ================= */

        .btn-danger {
            background: #fee2e2;

            color: #dc2626;
        }

        .btn-danger:hover {
            background: #fecaca;

            transform: translateY(-2px);
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 700px) {

            .sidebar {
                position: relative;

                width: 100%;

                height: auto;
            }

            .main {
                margin-left: 0;
            }

            .details {
                grid-template-columns: 1fr;
            }

            .profile-header {
                flex-direction: column;

                text-align: center;
            }

            .content {
                padding: 20px;
            }

            .topbar {
                padding: 0 20px;
            }

            .top-user strong {
                display: none;
            }

            .actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;

                text-align: center;
            }
        }

    </style>

</head>

<body>


    <!-- ================= SIDEBAR ================= -->

    <div class="sidebar">

        <div class="logo">

            <div class="logo-icon">
                🛠️
            </div>

            SmartFix

        </div>


        <div class="menu-title">
            Staff Menu
        </div>


        <div class="menu">

            <a href="<%= request.getContextPath() %>/staff/dashboard.jsp">

                📊 Dashboard

            </a>


            <a href="<%= request.getContextPath() %>/staff/complaints">

                📋 My Complaints

            </a>


            <a class="active"
               href="<%= request.getContextPath() %>/staff/profile">

                👤 Profile

            </a>

        </div>

    </div>


    <!-- ================= MAIN ================= -->

    <div class="main">


        <!-- ================= TOPBAR ================= -->

        <div class="topbar">

            <div>

                <h1>
                    Staff Profile
                </h1>

                <p>
                    View your SmartFix staff information
                </p>

            </div>


            <div class="top-user">

                <div class="small-avatar">

                    <%= firstLetter %>

                </div>


                <strong>

                    <%= name %>

                </strong>

            </div>

        </div>


        <!-- ================= CONTENT ================= -->

        <div class="content">

            <div class="profile-wrapper">


                <!-- ================= SUCCESS MESSAGE ================= -->

                <% if ("true".equals(passwordChanged)) { %>

                    <div class="success-message">

                        ✅ Password changed successfully.
                        Your new password will be used
                        the next time you log in.

                    </div>

                <% } %>


                <!-- ================= PROFILE HEADER ================= -->

                <div class="profile-header">

                    <div class="big-avatar">

                        <%= firstLetter %>

                    </div>


                    <div>

                        <h2>

                            <%= name %>

                        </h2>


                        <p>

                            <%= email %>

                        </p>


                        <span class="badge">

                            🔧 STAFF MEMBER

                        </span>

                    </div>

                </div>


                <!-- ================= DETAILS CARD ================= -->

                <div class="card">

                    <h3>

                        👤 Staff Information

                    </h3>


                    <div class="details">


                        <!-- STAFF ID -->

                        <div class="detail">

                            <div class="label">

                                Staff ID

                            </div>

                            <div class="value">

                                #<%= staff.getStaffId() %>

                            </div>

                        </div>


                        <!-- FULL NAME -->

                        <div class="detail">

                            <div class="label">

                                Full Name

                            </div>

                            <div class="value">

                                👤 <%= name %>

                            </div>

                        </div>


                        <!-- EMAIL -->

                        <div class="detail">

                            <div class="label">

                                Email

                            </div>

                            <div class="value">

                                📧 <%= email %>

                            </div>

                        </div>


                        <!-- PHONE -->

                        <div class="detail">

                            <div class="label">

                                Phone

                            </div>

                            <div class="value">

                                📱 <%= phone %>

                            </div>

                        </div>


                        <!-- SPECIALIZATION -->

                        <div class="detail">

                            <div class="label">

                                Specialization

                            </div>

                            <div class="value">

                                🛠️ <%= specialization %>

                            </div>

                        </div>


                        <!-- ROLE -->

                        <div class="detail">

                            <div class="label">

                                Role

                            </div>

                            <div class="value">

                                👨‍🔧 STAFF

                            </div>

                        </div>


                    </div>


                    <!-- ================= BUTTONS ================= -->

                    <div class="actions">


                        <!-- EDIT PROFILE -->

                        <a
                            class="btn btn-edit"
                            href="<%= request.getContextPath() %>/staff/edit-profile">

                            ✏️ Edit Profile

                        </a>


                        <!-- CHANGE PASSWORD -->

                        <a
                            class="btn btn-password"
                            href="<%= request.getContextPath() %>/staff/change-password">

                            🔐 Change Password

                        </a>


                        <!-- DASHBOARD -->

                        <a
                            class="btn btn-primary"
                            href="<%= request.getContextPath() %>/staff/dashboard.jsp">

                            ← Back to Dashboard

                        </a>


                        <!-- LOGOUT -->

                        <a
                            class="btn btn-danger"
                            href="<%= request.getContextPath() %>/logout">

                            🚪 Logout

                        </a>


                    </div>

                </div>

            </div>

        </div>

    </div>

</body>

</html>
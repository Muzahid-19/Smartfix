<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.smartfix.modelcom.Staff" %>

<%
    Staff staff = (Staff) request.getAttribute("staff");

    if (staff == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Edit Staff Profile - SmartFix</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, Helvetica, sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(
                135deg,
                #eef4ff,
                #f8fbff
            );
            color: #1e293b;
        }

        .navbar {
            height: 70px;
            background: #ffffff;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 7%;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.08);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            color: #2563eb;
            text-decoration: none;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .nav-btn {
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 9px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
        }

        .profile-btn {
            background: #eff6ff;
            color: #2563eb;
            border: 1px solid #bfdbfe;
        }

        .profile-btn:hover {
            background: #2563eb;
            color: white;
            transform: translateY(-2px);
        }

        .dashboard-btn {
            background: #f8fafc;
            color: #475569;
            border: 1px solid #e2e8f0;
        }

        .dashboard-btn:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
        }

        .page-container {
            width: 90%;
            max-width: 900px;
            margin: 45px auto;
        }

        .page-heading {
            text-align: center;
            margin-bottom: 30px;
        }

        .page-heading h1 {
            font-size: 32px;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .page-heading p {
            color: #64748b;
            font-size: 15px;
        }

        .profile-card {
            background: #ffffff;
            border-radius: 18px;
            padding: 35px;
            box-shadow:
                0 10px 35px rgba(15, 23, 42, 0.08);
            border: 1px solid #e2e8f0;
        }

        .profile-top {
            display: flex;
            align-items: center;
            gap: 18px;
            padding-bottom: 25px;
            margin-bottom: 28px;
            border-bottom: 1px solid #e2e8f0;
        }

        .profile-icon {
            width: 65px;
            height: 65px;
            border-radius: 50%;
            background: linear-gradient(
                135deg,
                #2563eb,
                #4f46e5
            );
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 27px;
            font-weight: bold;
            box-shadow:
                0 6px 18px rgba(37, 99, 235, 0.25);
        }

        .profile-info h2 {
            color: #0f172a;
            margin-bottom: 5px;
            font-size: 21px;
        }

        .profile-info p {
            color: #64748b;
            font-size: 14px;
        }

        .error-message {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 13px 16px;
            border-radius: 10px;
            margin-bottom: 22px;
            font-size: 14px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 22px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        label {
            font-size: 14px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        input {
            width: 100%;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            padding: 13px 14px;
            font-size: 14px;
            color: #1e293b;
            outline: none;
            transition: 0.3s;
            background: #ffffff;
        }

        input:focus {
            border-color: #2563eb;
            box-shadow:
                0 0 0 3px rgba(37, 99, 235, 0.10);
        }

        input:hover {
            border-color: #94a3b8;
        }

        .readonly-input {
            background: #f8fafc;
            color: #64748b;
        }

        .field-note {
            font-size: 12px;
            color: #94a3b8;
            margin-top: 6px;
        }

        .button-area {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 30px;
            padding-top: 25px;
            border-top: 1px solid #e2e8f0;
        }

        .btn {
            text-decoration: none;
            border: none;
            cursor: pointer;
            padding: 12px 22px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 125px;
        }

        .cancel-btn {
            background: #f1f5f9;
            color: #475569;
            border: 1px solid #cbd5e1;
        }

        .cancel-btn:hover {
            background: #e2e8f0;
            transform: translateY(-2px);
        }

        .save-btn {
            background: linear-gradient(
                135deg,
                #2563eb,
                #4f46e5
            );
            color: white;
            box-shadow:
                0 5px 15px rgba(37, 99, 235, 0.25);
        }

        .save-btn:hover {
            transform: translateY(-2px);
            box-shadow:
                0 8px 20px rgba(37, 99, 235, 0.35);
        }

        .save-btn:active,
        .cancel-btn:active {
            transform: scale(0.98);
        }

        .footer-note {
            text-align: center;
            color: #94a3b8;
            font-size: 12px;
            margin-top: 25px;
        }

        @media (max-width: 700px) {

            .navbar {
                padding: 0 4%;
            }

            .logo {
                font-size: 21px;
            }

            .nav-right {
                gap: 6px;
            }

            .nav-btn {
                padding: 8px 11px;
                font-size: 12px;
            }

            .page-container {
                width: 94%;
                margin: 30px auto;
            }

            .profile-card {
                padding: 22px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .button-area {
                flex-direction: column-reverse;
            }

            .btn {
                width: 100%;
            }
        }

    </style>

</head>

<body>

    <nav class="navbar">

        <a
            href="<%= request.getContextPath() %>/staff/dashboard.jsp"
            class="logo">
            SmartFix
        </a>

        <div class="nav-right">

            <!-- IMPORTANT: servlet URL -->
            <a
                href="<%= request.getContextPath() %>/staff/profile"
                class="nav-btn profile-btn">
                👤 Profile
            </a>

            <a
                href="<%= request.getContextPath() %>/staff/dashboard.jsp"
                class="nav-btn dashboard-btn">
                Dashboard
            </a>

        </div>

    </nav>


    <div class="page-container">

        <div class="page-heading">

            <h1>
                Edit Staff Profile
            </h1>

            <p>
                Update your SmartFix staff information
            </p>

        </div>


        <div class="profile-card">

            <div class="profile-top">

                <div class="profile-icon">

                    <%
                        String staffName = staff.getName();

                        if (staffName != null &&
                            !staffName.trim().isEmpty()) {

                            out.print(
                                staffName
                                    .trim()
                                    .substring(0, 1)
                                    .toUpperCase()
                            );

                        } else {

                            out.print("S");

                        }
                    %>

                </div>

                <div class="profile-info">

                    <h2>
                        Edit your staff information
                    </h2>

                    <p>
                        Keep your staff profile details up to date.
                    </p>

                </div>

            </div>


            <% if (error != null &&
                   !error.trim().isEmpty()) { %>

                <div class="error-message">
                    ⚠️ <%= error %>
                </div>

            <% } %>


            <form
                action="<%= request.getContextPath() %>/staff/edit-profile"
                method="post">

                <div class="form-grid">

                    <div class="form-group">

                        <label for="name">
                            Full Name *
                        </label>

                        <input
                            type="text"
                            id="name"
                            name="name"
                            value="<%= staff.getName() != null
                                ? staff.getName()
                                : "" %>"
                            placeholder="Enter your full name"
                            required>

                    </div>


                    <div class="form-group">

                        <label for="email">
                            Email Address *
                        </label>

                        <input
                            type="email"
                            id="email"
                            name="email"
                            value="<%= staff.getEmail() != null
                                ? staff.getEmail()
                                : "" %>"
                            placeholder="Enter your email"
                            required>

                    </div>


                    <div class="form-group">

                        <label for="phone">
                            Phone Number
                        </label>

                        <input
                            type="text"
                            id="phone"
                            name="phone"
                            value="<%= staff.getPhone() != null
                                ? staff.getPhone()
                                : "" %>"
                            placeholder="Enter your phone number">

                    </div>


                    <div class="form-group">

                        <label for="specialization">
                            Specialization
                        </label>

                        <input
                            type="text"
                            id="specialization"
                            name="specialization"
                            value="<%= staff.getSpecialization() != null
                                ? staff.getSpecialization()
                                : "" %>"
                            placeholder="Example: Electrical">

                    </div>


                    <div class="form-group">

                        <label for="staffId">
                            Staff ID
                        </label>

                        <input
                            type="text"
                            id="staffId"
                            value="<%= staff.getStaffId() %>"
                            class="readonly-input"
                            readonly>

                        <div class="field-note">
                            Staff ID cannot be changed.
                        </div>

                    </div>


                    <div class="form-group">

                        <label for="role">
                            Account Role
                        </label>

                        <input
                            type="text"
                            id="role"
                            value="STAFF"
                            class="readonly-input"
                            readonly>

                        <div class="field-note">
                            Account role cannot be changed.
                        </div>

                    </div>

                </div>


                <div class="button-area">

                    <!-- IMPORTANT: servlet URL -->
                    <a
                        href="<%= request.getContextPath() %>/staff/profile"
                        class="btn cancel-btn">
                        ✕ Cancel
                    </a>

                    <button
                        type="submit"
                        class="btn save-btn">
                        💾 Save Changes
                    </button>

                </div>

            </form>

        </div>


        <div class="footer-note">
            SmartFix Complaint & Service Management System
        </div>

    </div>

</body>

</html>
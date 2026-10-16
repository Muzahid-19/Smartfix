
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.smartfix.modelcom.User"%>

<%!
    public String escapeHtml(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
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

    String userName = user.getName() != null
            && !user.getName().trim().isEmpty()
            ? user.getName().trim() : "User";

    String userEmail = user.getEmail() != null
            && !user.getEmail().trim().isEmpty()
            ? user.getEmail().trim() : "Not provided";

    String userPhone = user.getPhone() != null
            && !user.getPhone().trim().isEmpty()
            ? user.getPhone().trim() : "Not provided";

    String userAddress = user.getAddress() != null
            && !user.getAddress().trim().isEmpty()
            ? user.getAddress().trim() : "Not provided";

    String userRoomNumber = user.getRoomNumber() != null
            && !user.getRoomNumber().trim().isEmpty()
            ? user.getRoomNumber().trim() : "Not provided";

    String userRole = user.getRole() != null
            && !user.getRole().trim().isEmpty()
            ? user.getRole().trim() : "USER";

    String firstLetter = userName.substring(0, 1).toUpperCase();
    String passwordChanged = request.getParameter("passwordChanged");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>SmartFix | My Profile</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <style>
        :root {
            --blue: #2563eb;
            --blue-dark: #1749a8;
            --green: #078657;
            --text: #172033;
            --muted: #64748b;
            --border: #e4e9f1;
            --page: #f5f6f8;
            --white: #ffffff;
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            background: var(--page);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        a {
            -webkit-tap-highlight-color: transparent;
        }

        .profile-page {
            min-height: 100vh;
            padding: 24px 26px 45px;
        }

        .profile-container {
            width: 100%;
            max-width: 1500px;
            margin: 0 auto;
        }

        /* ================= PROFILE BANNER ================= */

        .profile-banner {
            min-height: 190px;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            padding: 35px 38px;
            color: white;
            border-radius: 16px 16px 0 0;
            background: linear-gradient(
                112deg,
                #315eac 0%,
                #8aa9d8 37%,
                #c5bafa 68%,
                #ffc978 100%
            );
        }

        .profile-banner::before {
            content: "";
            position: absolute;
            width: 75%;
            height: 250px;
            top: -145px;
            left: 15%;
            border-radius: 50%;
            background: rgba(255,255,255,.22);
            transform: rotate(-8deg);
            pointer-events: none;
        }

        .profile-banner::after {
            content: "";
            position: absolute;
            width: 420px;
            height: 230px;
            right: -80px;
            bottom: -175px;
            border-radius: 50%;
            background: rgba(255,255,255,.24);
            transform: rotate(-20deg);
            pointer-events: none;
        }

        .banner-decoration {
            position: absolute;
            right: 23%;
            top: 22px;
            width: 95px;
            height: 95px;
            opacity: .4;
            background-image: radial-gradient(
                rgba(255,255,255,.95) 3px,
                transparent 3px
            );
            background-size: 22px 22px;
            pointer-events: none;
        }

        .banner-content {
            position: relative;
            z-index: 2;
            max-width: 850px;
            min-width: 0;
        }

        .banner-eyebrow {
            margin: 0 0 8px;
            color: rgba(255,255,255,.92);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .banner-title {
            margin: 0;
            color: #fff;
            font-size: clamp(25px, 3vw, 35px);
            font-weight: 750;
            letter-spacing: -.8px;
            line-height: 1.3;
            overflow-wrap: anywhere;
            text-shadow: 0 2px 8px rgba(25,47,91,.12);
        }

        .banner-subtitle {
            margin: 9px 0 0;
            color: rgba(255,255,255,.95);
            font-size: 14px;
            line-height: 1.6;
        }

        .banner-role {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            margin-top: 15px;
            padding: 7px 12px;
            border: 1px solid rgba(255,255,255,.45);
            border-radius: 30px;
            background: rgba(255,255,255,.16);
            color: white;
            font-size: 11px;
            font-weight: 750;
            text-transform: uppercase;
            letter-spacing: .5px;
        }

        .banner-role-dot {
            width: 7px;
            height: 7px;
            border-radius: 50%;
            background: #d1fae5;
        }

        /* ================= NAVIGATION ================= */

        .profile-nav {
            display: flex;
            align-items: stretch;
            gap: 5px;
            padding: 0 20px;
            min-height: 65px;
            overflow-x: auto;
            overscroll-behavior-x: contain;
            background: white;
            border: 1px solid var(--border);
            border-top: none;
            border-radius: 0 0 16px 16px;
            box-shadow: 0 3px 10px rgba(15,23,42,.025);
            -webkit-overflow-scrolling: touch;
            scrollbar-width: thin;
        }

        .nav-link {
            display: inline-flex;
            flex-shrink: 0;
            align-items: center;
            justify-content: center;
            gap: 9px;
            padding: 0 16px;
            color: #64748b;
            border-bottom: 3px solid transparent;
            text-decoration: none;
            white-space: nowrap;
            font-size: 13px;
            font-weight: 650;
            transition: .2s ease;
        }

        .nav-link:hover {
            color: var(--blue);
            background: #fbfdff;
        }

        .nav-link.active {
            color: #111827;
            border-bottom-color: var(--blue);
        }

        .nav-icon {
            font-size: 17px;
            color: var(--blue);
        }

        /* ================= SUCCESS MESSAGE ================= */

        .success-message {
            display: flex;
            align-items: flex-start;
            gap: 11px;
            margin-top: 20px;
            padding: 15px 17px;
            border: 1px solid #a7f3d0;
            border-radius: 12px;
            background: #ecfdf5;
            color: #047857;
            font-size: 13px;
            line-height: 1.6;
        }

        .success-check {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            background: #d1fae5;
            font-weight: 800;
        }

        /* ================= MAIN LAYOUT ================= */

        .profile-content {
            display: grid;
            grid-template-columns: 330px minmax(0, 1fr);
            gap: 20px;
            align-items: start;
            margin-top: 20px;
        }

        .sidebar,
        .main-column {
            min-width: 0;
        }

        .side-card,
        .information-card {
            min-width: 0;
            background: white;
            border: 1px solid var(--border);
            border-radius: 17px;
            box-shadow: 0 3px 12px rgba(15,23,42,.025);
        }

        .side-card {
            padding: 24px;
        }

        /* ================= ACCOUNT SUMMARY ================= */

        .account-card {
            text-align: center;
        }

        .avatar {
            display: grid;
            place-items: center;
            width: 84px;
            height: 84px;
            margin: 0 auto 14px;
            border: 4px solid #e5efff;
            border-radius: 50%;
            background: linear-gradient(135deg, #dbeafe, #bcd6ff);
            color: #1d4ed8;
            font-size: 31px;
            font-weight: 800;
        }

        .account-name {
            margin: 0;
            font-size: 19px;
            line-height: 1.45;
            overflow-wrap: anywhere;
        }

        .account-email {
            margin: 7px 0 14px;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.7;
            overflow-wrap: anywhere;
            word-break: break-word;
        }

        .verified-badge {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 7px 12px;
            border-radius: 20px;
            background: #e8f7ef;
            color: #07804f;
            font-size: 11px;
            font-weight: 750;
        }

        .account-divider {
            height: 1px;
            margin: 20px 0;
            background: var(--border);
        }

        .account-meta {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            text-align: left;
            font-size: 12px;
        }

        .account-meta-label {
            color: var(--muted);
        }

        .account-meta-value {
            max-width: 60%;
            text-align: right;
            font-weight: 750;
            overflow-wrap: anywhere;
        }

        .account-note {
            margin: 17px 0 0;
            padding: 12px;
            border-radius: 10px;
            background: #f7f9fc;
            color: #64748b;
            font-size: 12px;
            line-height: 1.7;
            text-align: left;
        }

        /* ================= INFORMATION CARD ================= */

        .information-card {
            padding: 27px;
        }

        .section-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding-bottom: 19px;
            margin-bottom: 23px;
            border-bottom: 1px solid var(--border);
        }

        .section-heading h2 {
            margin: 0;
            font-size: 20px;
            font-weight: 750;
            letter-spacing: -.35px;
        }

        .section-heading p {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.6;
        }

        .section-tag {
            flex-shrink: 0;
            padding: 7px 10px;
            border-radius: 7px;
            background: #f1f5f9;
            color: #64748b;
            font-size: 10px;
            font-weight: 750;
            text-transform: uppercase;
            letter-spacing: .4px;
        }

        /* ================= PROFILE FIELDS ================= */

        .field-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 21px 18px;
        }

        .field {
            min-width: 0;
        }

        .field-label {
            display: block;
            margin-bottom: 9px;
            color: #334155;
            font-size: 13px;
            font-weight: 650;
        }

        .field-box {
            display: flex;
            align-items: center;
            gap: 10px;
            width: 100%;
            min-height: 49px;
            padding: 12px 13px;
            border: 1px solid #d6dce6;
            border-radius: 8px;
            background: #f7f8fa;
            color: #2563a8;
            font-size: 13px;
            line-height: 1.6;
            overflow-wrap: anywhere;
            word-break: break-word;
            transition: border-color .2s ease;
        }

        .field-box:hover {
            border-color: #b9cbed;
        }

        .field-icon {
            flex-shrink: 0;
            color: #64748b;
            font-size: 15px;
        }

        .field-value {
            min-width: 0;
            overflow-wrap: anywhere;
            word-break: break-word;
        }

        .field.full-width {
            grid-column: 1 / -1;
        }

        .field-box.address-box {
            min-height: 76px;
            align-items: flex-start;
        }

        /* ================= BOTTOM BUTTONS ================= */

        .bottom-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 11px;
            padding-top: 23px;
            margin-top: 27px;
            border-top: 1px solid var(--border);
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 44px;
            padding: 11px 16px;
            border: 1px solid transparent;
            border-radius: 9px;
            text-align: center;
            text-decoration: none;
            font-family: inherit;
            font-size: 12px;
            font-weight: 750;
            line-height: 1.4;
            transition: background .2s ease, transform .2s ease;
        }

        .button:hover {
            transform: translateY(-1px);
        }

        .button-primary {
            background: var(--blue);
            color: white;
            box-shadow: 0 4px 10px rgba(37,99,235,.13);
        }

        .button-primary:hover {
            background: var(--blue-dark);
            color: white;
        }

        .button-secondary {
            border-color: #dbe3ef;
            background: white;
            color: #334155;
        }

        .button-secondary:hover {
            border-color: #b9cbed;
            background: #f8fbff;
            color: var(--blue);
        }

        .button:focus-visible,
        .nav-link:focus-visible {
            outline: 3px solid rgba(37,99,235,.3);
            outline-offset: 3px;
        }

        .page-footer {
            padding-top: 24px;
            color: #94a3b8;
            font-size: 11px;
            text-align: center;
            line-height: 1.7;
        }

        /* ================= TABLET ================= */

        @media (max-width: 1000px) {
            .profile-content {
                grid-template-columns: 270px minmax(0, 1fr);
                gap: 15px;
            }

            .information-card {
                padding: 22px 18px;
            }

            .field-grid {
                grid-template-columns: 1fr;
                gap: 17px;
            }

            .field.full-width {
                grid-column: auto;
            }

            .profile-nav {
                padding: 0 10px;
            }

            .nav-link {
                padding: 0 12px;
            }
        }

        /* ================= MOBILE ================= */

        @media (max-width: 650px) {
            .profile-page {
                padding: 10px 10px 25px;
            }

            .profile-banner {
                min-height: 155px;
                padding: 23px 18px;
                border-radius: 13px 13px 0 0;
            }

            .banner-title {
                font-size: clamp(22px, 6vw, 28px);
                line-height: 1.3;
            }

            .banner-subtitle {
                max-width: 330px;
                font-size: 12px;
                line-height: 1.6;
            }

            .banner-eyebrow {
                font-size: 10px;
            }

            .profile-nav {
                min-height: 56px;
                gap: 0;
                padding: 0 5px;
                overflow-x: auto;
                overscroll-behavior-x: contain;
                -webkit-overflow-scrolling: touch;
                border-radius: 0 0 13px 13px;
            }

            .nav-link {
                min-height: 56px;
                padding: 0 12px;
                font-size: 12px;
            }

            .profile-content {
                grid-template-columns: minmax(0, 1fr);
                gap: 14px;
                margin-top: 14px;
            }

            .sidebar,
            .main-column {
                width: 100%;
                min-width: 0;
            }

            .side-card {
                padding: 21px 17px;
            }

            .information-card {
                width: 100%;
                padding: 21px 16px;
                border-radius: 14px;
            }

            .section-heading {
                align-items: flex-start;
                gap: 10px;
                padding-bottom: 17px;
                margin-bottom: 19px;
            }

            .section-heading h2 {
                font-size: 18px;
            }

            .section-heading p {
                font-size: 12px;
            }

            .section-tag {
                font-size: 9px;
                white-space: nowrap;
            }

            .field-grid {
                grid-template-columns: minmax(0, 1fr);
                gap: 17px;
            }

            .field {
                width: 100%;
                min-width: 0;
            }

            .field-box {
                width: 100%;
                min-height: 47px;
                padding: 11px 12px;
                font-size: 13px;
                overflow-wrap: anywhere;
                word-break: break-word;
            }

            .bottom-actions {
                display: flex;
                flex-direction: column;
                gap: 10px;
                margin-top: 23px;
                padding-top: 19px;
            }

            .bottom-actions .button {
                display: flex;
                width: 100%;
                min-height: 46px;
                padding: 12px 15px;
                justify-content: center;
            }

            .page-footer {
                padding: 20px 8px 0;
                font-size: 10px;
            }
        }

        /* ================= SMALL MOBILE ================= */

        @media (max-width: 380px) {
            .profile-page {
                padding-right: 7px;
                padding-left: 7px;
            }

            .profile-banner {
                padding: 20px 14px;
            }

            .banner-title {
                font-size: 22px;
            }

            .banner-role {
                font-size: 10px;
            }

            .nav-link {
                padding: 0 10px;
                gap: 6px;
                font-size: 11px;
            }

            .information-card {
                padding: 18px 12px;
            }

            .section-heading {
                flex-direction: column;
            }

            .section-tag {
                align-self: flex-start;
            }

            .field-label {
                font-size: 12px;
            }

            .field-box {
                font-size: 12px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                animation-duration: .01ms !important;
                transition-duration: .01ms !important;
            }
        }
    </style>
</head>

<body>

<main class="profile-page">
    <div class="profile-container">

        <!-- TOP BANNER -->
        <header class="profile-banner">
            <div class="banner-decoration"></div>

            <div class="banner-content">
                <p class="banner-eyebrow">SmartFix account</p>

                <h1 class="banner-title">
                    Hello, <%= escapeHtml(userName) %>
                </h1>

                <p class="banner-subtitle">
                    Manage your profile and account information in one place.
                </p>

                <span class="banner-role">
                    <span class="banner-role-dot"></span>
                    <%= escapeHtml(userRole) %> ACCOUNT
                </span>
            </div>
        </header>

        <!-- NAVIGATION -->
        <nav class="profile-nav" aria-label="Profile navigation">

            <a class="nav-link active"
               href="<%= request.getContextPath() %>/user/profile.jsp"
               aria-current="page">
                <span class="nav-icon" aria-hidden="true">♙</span>
                Personal Info
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/user/dashboard.jsp">
                <span class="nav-icon" aria-hidden="true">⌂</span>
                Dashboard
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/user/edit-profile">
                <span class="nav-icon" aria-hidden="true">✎</span>
                Edit Profile
            </a>

            <a class="nav-link"
               href="<%= request.getContextPath() %>/user/change-password">
                <span class="nav-icon" aria-hidden="true">♙</span>
                Security
            </a>

        </nav>

        <!-- SUCCESS MESSAGE -->
        <% if ("true".equals(passwordChanged)) { %>
            <div class="success-message" role="status" aria-live="polite">
                <span class="success-check" aria-hidden="true">✓</span>
                <div>
                    <strong>Password changed successfully.</strong><br>
                    Your new password will be used the next time you log in.
                </div>
            </div>
        <% } %>

        <div class="profile-content">

            <!-- LEFT COLUMN: ACCOUNT SUMMARY ONLY -->
            <aside class="sidebar">
                <section class="side-card account-card">

                    <div class="avatar" aria-hidden="true">
                        <%= escapeHtml(firstLetter) %>
                    </div>

                    <h2 class="account-name">
                        <%= escapeHtml(userName) %>
                    </h2>

                    <p class="account-email">
                        <%= escapeHtml(userEmail) %>
                    </p>

                    <span class="verified-badge">
                        <span aria-hidden="true">✓</span>
                        SmartFix Account
                    </span>

                    <div class="account-divider"></div>

                    <div class="account-meta">
                        <span class="account-meta-label">Account ID</span>
                        <span class="account-meta-value">
                            #<%= user.getUserId() %>
                        </span>
                    </div>

                    <p class="account-note">
                        Keep your contact information up to date so you can
                        receive important service and complaint updates.
                    </p>

                </section>
            </aside>

            <!-- RIGHT COLUMN: PERSONAL INFORMATION -->
            <section class="main-column">
                <div class="information-card">

                    <div class="section-heading">
                        <div>
                            <h2>About You</h2>
                            <p>
                                Your personal and contact information.
                            </p>
                        </div>

                        <span class="section-tag">Personal Info</span>
                    </div>

                    <div class="field-grid">

                        <!-- NAME -->
                        <div class="field">
                            <span class="field-label">Full Name</span>
                            <div class="field-box">
                                <span class="field-value">
                                    <%= escapeHtml(userName) %>
                                </span>
                            </div>
                        </div>

                        <!-- ROLE -->
                        <div class="field">
                            <span class="field-label">Account Role</span>
                            <div class="field-box">
                                <span class="field-value">
                                    <%= escapeHtml(userRole) %>
                                </span>
                            </div>
                        </div>

                        <!-- EMAIL -->
                        <div class="field">
                            <span class="field-label">Email Address</span>
                            <div class="field-box">
                                <span class="field-icon" aria-hidden="true">✉</span>
                                <span class="field-value">
                                    <%= escapeHtml(userEmail) %>
                                </span>
                            </div>
                        </div>

                        <!-- PHONE -->
                        <div class="field">
                            <span class="field-label">Mobile Number</span>
                            <div class="field-box">
                                <span class="field-icon" aria-hidden="true">☎</span>
                                <span class="field-value">
                                    <%= escapeHtml(userPhone) %>
                                </span>
                            </div>
                        </div>

                        <!-- ROOM -->
                        <div class="field">
                            <span class="field-label">Room Number</span>
                            <div class="field-box">
                                <span class="field-icon" aria-hidden="true">⌂</span>
                                <span class="field-value">
                                    <%= escapeHtml(userRoomNumber) %>
                                </span>
                            </div>
                        </div>

                        <!-- ADDRESS -->
                        <div class="field">
                            <span class="field-label">Address</span>
                            <div class="field-box address-box">
                                <span class="field-icon" aria-hidden="true">⌖</span>
                                <span class="field-value">
                                    <%= escapeHtml(userAddress) %>
                                </span>
                            </div>
                        </div>

                    </div>

                    <!-- PROFILE ACTIONS -->
                    <div class="bottom-actions">

                        <a class="button button-primary"
                           href="<%= request.getContextPath() %>/user/edit-profile">
                            <span aria-hidden="true">✎</span>
                            Edit Profile
                        </a>

                        <a class="button button-secondary"
                           href="<%= request.getContextPath() %>/user/change-password">
                            <span aria-hidden="true">♙</span>
                            Change Password
                        </a>

                        <a class="button button-secondary"
                           href="<%= request.getContextPath() %>/user/dashboard.jsp">
                            <span aria-hidden="true">←</span>
                            Back to Dashboard
                        </a>

                    </div>

                </div>
            </section>

        </div>

        <footer class="page-footer">
            SmartFix &mdash; Complaint &amp; Service Management System
        </footer>

    </div>
</main>

</body>
</html>

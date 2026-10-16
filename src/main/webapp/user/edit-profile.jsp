
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.smartfix.modelcom.User" %>

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
    User user = (User) request.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String error = (String) request.getAttribute("error");

    String userName = user.getName() != null
            ? user.getName() : "";

    String displayName = userName.trim().isEmpty()
            ? "User" : userName.trim();

    String userEmail = user.getEmail() != null
            ? user.getEmail() : "";

    String userPhone = user.getPhone() != null
            ? user.getPhone() : "";

    String userAddress = user.getAddress() != null
            ? user.getAddress() : "";

    String userRoomNumber = user.getRoomNumber() != null
            ? user.getRoomNumber() : "";

    String userRole = user.getRole() != null
            ? user.getRole() : "USER";

    String firstLetter = displayName.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>SmartFix | Edit Profile</title>

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --text: #172033;
            --muted: #64748b;
            --border: #e2e8f0;
            --page: #f4f6f9;
            --white: #ffffff;
            --danger: #b91c1c;
        }

        * {
            box-sizing: border-box;
        }

        html {
            min-height: 100%;
            scroll-behavior: smooth;
        }

        body {
            margin: 0;
            min-height: 100vh;
            width: 100%;
            overflow-x: hidden;
            background: var(--page);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
            -webkit-font-smoothing: antialiased;
        }

        a, button, input, textarea {
            -webkit-tap-highlight-color: transparent;
        }

        a {
            text-decoration: none;
        }

        /* ================= PAGE ================= */

        .page-container {
            width: 100%;
            max-width: 1500px;
            margin: 0 auto;
            padding: 24px 26px 40px;
        }

        /* ================= HEADER BANNER ================= */

        .profile-banner {
            position: relative;
            isolation: isolate;
            overflow: hidden;
            display: flex;
            align-items: center;
            min-height: 190px;
            padding: 32px 38px;
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
            z-index: -1;
            width: 65%;
            height: 250px;
            top: -155px;
            left: 20%;
            border-radius: 50%;
            background: rgba(255,255,255,.20);
            transform: rotate(-10deg);
        }

        .profile-banner::after {
            content: "";
            position: absolute;
            z-index: -1;
            width: 330px;
            height: 200px;
            right: -70px;
            bottom: -160px;
            border-radius: 50%;
            background: rgba(255,255,255,.25);
        }

        .banner-content {
            min-width: 0;
            max-width: 100%;
        }

        .banner-eyebrow {
            margin: 0 0 8px;
            color: rgba(255,255,255,.92);
            font-size: 11px;
            font-weight: 750;
            letter-spacing: 1.5px;
            text-transform: uppercase;
        }

        .banner-title {
            margin: 0;
            color: white;
            font-size: clamp(26px, 3vw, 35px);
            line-height: 1.3;
            letter-spacing: -.5px;
            overflow-wrap: anywhere;
        }

        .banner-subtitle {
            margin: 9px 0 0;
            color: rgba(255,255,255,.96);
            font-size: 14px;
            line-height: 1.7;
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 14px;
            padding: 7px 12px;
            border: 1px solid rgba(255,255,255,.4);
            border-radius: 30px;
            background: rgba(255,255,255,.16);
            color: white;
            font-size: 10px;
            font-weight: 750;
            letter-spacing: .5px;
        }

        .role-dot {
            width: 7px;
            height: 7px;
            flex-shrink: 0;
            border-radius: 50%;
            background: #d1fae5;
        }

        /* ================= NAVIGATION ================= */

        .profile-nav {
            display: flex;
            align-items: stretch;
            min-height: 63px;
            max-width: 100%;
            gap: 5px;
            padding: 0 20px;
            overflow-x: auto;
            background: white;
            border: 1px solid var(--border);
            border-top: none;
            border-radius: 0 0 15px 15px;
            box-shadow: 0 3px 10px rgba(15,23,42,.025);
            overscroll-behavior-x: contain;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: thin;
        }

        .nav-link {
            display: inline-flex;
            flex-shrink: 0;
            align-items: center;
            justify-content: center;
            gap: 9px;
            min-height: 60px;
            padding: 0 15px;
            color: #64748b;
            border-bottom: 3px solid transparent;
            font-size: 13px;
            font-weight: 650;
            white-space: nowrap;
            transition: .2s ease;
        }

        .nav-link:hover {
            color: var(--primary);
            background: #fbfdff;
        }

        .nav-link.active {
            color: #111827;
            border-bottom-color: var(--primary);
        }

        .nav-icon {
            color: var(--primary);
            font-size: 17px;
        }

        /* ================= PAGE HEADING ================= */

        .page-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin: 23px 0 17px;
        }

        .page-heading h2 {
            margin: 0;
            color: #172033;
            font-size: 21px;
            letter-spacing: -.3px;
        }

        .page-heading p {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 13px;
            line-height: 1.6;
        }

        .heading-tag {
            flex-shrink: 0;
            padding: 8px 11px;
            border-radius: 8px;
            background: #eaf2ff;
            color: #2459b9;
            font-size: 11px;
            font-weight: 750;
        }

        /* ================= FORM CARD ================= */

        .profile-card {
            width: 100%;
            min-width: 0;
            padding: 28px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 3px 12px rgba(15,23,42,.025);
        }

        .profile-top {
            display: flex;
            align-items: center;
            gap: 17px;
            width: 100%;
            min-width: 0;
            padding-bottom: 23px;
            margin-bottom: 25px;
            border-bottom: 1px solid var(--border);
        }

        .avatar {
            display: grid;
            place-items: center;
            flex-shrink: 0;
            width: 66px;
            height: 66px;
            border: 4px solid #e7efff;
            border-radius: 50%;
            background: linear-gradient(135deg, #dbeafe, #a8c8ff);
            color: #1d4ed8;
            font-size: 25px;
            font-weight: 800;
        }

        .profile-info {
            min-width: 0;
        }

        .profile-info h3 {
            margin: 0;
            color: #172033;
            font-size: 18px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .profile-info p {
            margin: 5px 0 0;
            color: var(--muted);
            font-size: 12px;
            line-height: 1.6;
        }

        /* ================= ERROR ================= */

        .error-message {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 22px;
            padding: 14px 15px;
            border: 1px solid #fecaca;
            border-radius: 10px;
            background: #fef2f2;
            color: var(--danger);
            font-size: 13px;
            line-height: 1.6;
            overflow-wrap: anywhere;
        }

        /* ================= FORM LAYOUT ================= */

        .edit-form {
            width: 100%;
            min-width: 0;
        }

        .form-section-title {
            margin: 0 0 20px;
            color: #1e293b;
            font-size: 15px;
            font-weight: 750;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            width: 100%;
            min-width: 0;
            gap: 22px 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            width: 100%;
            min-width: 0;
        }

        .form-group.full {
            grid-column: 1 / -1;
        }

        .form-group label {
            margin-bottom: 9px;
            color: #334155;
            font-size: 13px;
            font-weight: 650;
        }

        .required {
            color: #dc2626;
        }

        /* ================= INPUTS ================= */

        .form-group input,
        .form-group textarea {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            min-height: 48px;
            margin: 0;
            padding: 12px 14px;
            border: 1px solid #d5dce7;
            border-radius: 8px;
            outline: none;
            background: white;
            color: #1e293b;
            font-family: inherit;
            font-size: 14px;
            line-height: 1.6;
            transition: border-color .2s ease, box-shadow .2s ease;
        }

        .form-group input:hover,
        .form-group textarea:hover {
            border-color: #aab8cd;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37,99,235,.10);
        }

        /* Placeholder is shown only when the input is empty */
        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #8491a5;
            opacity: 1;
            font-size: 14px;
        }

        .form-group input[readonly] {
            background: #f5f7fa;
            color: #64748b;
            cursor: not-allowed;
        }

        .form-group textarea {
            min-height: 110px;
            resize: vertical;
        }

        /* Prevent old decorative icons from overlapping text */
        .input-wrap {
            position: relative;
            width: 100%;
            max-width: 100%;
            min-width: 0;
        }

        .input-icon {
            display: none !important;
        }

        .field-note {
            margin-top: 6px;
            color: #8491a5;
            font-size: 11px;
            line-height: 1.6;
        }

        /* ================= FORM FOOTER ================= */

        .form-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            flex-wrap: wrap;
            margin-top: 29px;
            padding-top: 23px;
            border-top: 1px solid var(--border);
        }

        .privacy-note {
            max-width: 360px;
            margin: 0;
            color: #7b8799;
            font-size: 11px;
            line-height: 1.7;
        }

        .button-area {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 10px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-height: 44px;
            padding: 11px 17px;
            border: 1px solid transparent;
            border-radius: 8px;
            font-family: inherit;
            font-size: 12px;
            font-weight: 750;
            text-align: center;
            cursor: pointer;
            transition: background .2s ease, transform .2s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .cancel-btn {
            border-color: #dbe2ec;
            background: white;
            color: #475569;
        }

        .cancel-btn:hover {
            background: #f8fafc;
            border-color: #b9c6d8;
        }

        .save-btn {
            border: none;
            background: linear-gradient(135deg, #2563eb, #4f46e5);
            color: white;
            box-shadow: 0 4px 12px rgba(37,99,235,.18);
        }

        .save-btn:hover {
            background: linear-gradient(135deg, #1d4ed8, #4338ca);
        }

        .btn:focus-visible,
        .nav-link:focus-visible {
            outline: 3px solid rgba(37,99,235,.28);
            outline-offset: 3px;
        }

        .footer-note {
            padding: 23px 8px 0;
            color: #94a3b8;
            font-size: 11px;
            line-height: 1.7;
            text-align: center;
        }

        /* ================= TABLET ================= */

        @media (max-width: 850px) {
            .page-container {
                padding: 16px;
            }

            .profile-card {
                padding: 22px;
            }

            .form-grid {
                gap: 18px 14px;
            }

            .form-footer {
                align-items: flex-start;
                flex-direction: column;
            }

            .privacy-note {
                max-width: 100%;
            }

            .button-area {
                width: 100%;
                justify-content: flex-end;
            }
        }

        /* ================= MOBILE ================= */

        @media (max-width: 600px) {
            .page-container {
                padding: 10px 10px 24px;
            }

            .profile-banner {
                min-height: 150px;
                padding: 22px 17px;
                border-radius: 12px 12px 0 0;
            }

            .banner-title {
                font-size: clamp(23px, 6vw, 29px);
            }

            .banner-subtitle {
                max-width: 330px;
                font-size: 12px;
            }

            .profile-nav {
                min-height: 55px;
                padding: 0 5px;
                gap: 0;
                border-radius: 0 0 12px 12px;
            }

            .nav-link {
                min-height: 54px;
                padding: 0 12px;
                font-size: 12px;
            }

            .page-heading {
                align-items: flex-start;
                flex-direction: column;
                gap: 11px;
                margin: 20px 0 14px;
            }

            .page-heading h2 {
                font-size: 20px;
            }

            .profile-card {
                padding: 20px 16px;
                border-radius: 13px;
            }

            .profile-top {
                gap: 13px;
                padding-bottom: 19px;
                margin-bottom: 22px;
            }

            .avatar {
                width: 56px;
                height: 56px;
                font-size: 22px;
            }

            .profile-info h3 {
                font-size: 16px;
            }

            .form-section-title {
                margin-bottom: 17px;
            }

            .form-grid {
                grid-template-columns: minmax(0, 1fr);
                gap: 18px;
            }

            .form-group,
            .form-group.full {
                grid-column: 1 / -1;
                width: 100%;
            }

            /* 16px avoids automatic zoom on many mobile browsers */
            .form-group input,
            .form-group textarea {
                min-height: 47px;
                padding: 12px;
                font-size: 16px;
            }

            .form-group input::placeholder,
            .form-group textarea::placeholder {
                font-size: 14px;
            }

            .form-group textarea {
                min-height: 105px;
            }

            .form-footer {
                gap: 16px;
                margin-top: 23px;
                padding-top: 19px;
            }

            .button-area {
                display: flex;
                flex-direction: column-reverse;
                width: 100%;
                gap: 10px;
            }

            .button-area .btn {
                width: 100%;
                min-height: 47px;
            }

            .footer-note {
                padding-top: 19px;
                font-size: 10px;
            }
        }

        /* ================= SMALL MOBILE ================= */

        @media (max-width: 360px) {
            .page-container {
                padding: 7px;
            }

            .profile-banner {
                padding: 20px 14px;
            }

            .profile-card {
                padding: 18px 12px;
            }

            .profile-top {
                align-items: flex-start;
                gap: 11px;
            }

            .avatar {
                width: 48px;
                height: 48px;
                font-size: 20px;
            }

            .profile-info h3 {
                font-size: 15px;
            }

            .nav-link {
                gap: 6px;
                padding: 0 10px;
                font-size: 11px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *,
            *::before,
            *::after {
                scroll-behavior: auto !important;
                transition-duration: .01ms !important;
            }
        }
    </style>
</head>

<body>

<main class="page-container">

    <!-- HEADER BANNER -->
    <header class="profile-banner">
        <div class="banner-content">
            <p class="banner-eyebrow">SmartFix Account</p>

            <h1 class="banner-title">Edit Your Profile</h1>

            <p class="banner-subtitle">
                Keep your personal and contact information up to date.
            </p>

            <span class="role-badge">
                <span class="role-dot"></span>
                <%= escapeHtml(userRole) %> ACCOUNT
            </span>
        </div>
    </header>

    <!-- NAVIGATION -->
    <nav class="profile-nav" aria-label="Account navigation">

        <a class="nav-link"
           href="<%= request.getContextPath() %>/user/profile.jsp">
            <span class="nav-icon" aria-hidden="true">♙</span>
            Personal Info
        </a>

        <a class="nav-link active"
           href="<%= request.getContextPath() %>/user/edit-profile"
           aria-current="page">
            <span class="nav-icon" aria-hidden="true">✎</span>
            Edit Profile
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/user/dashboard.jsp">
            <span class="nav-icon" aria-hidden="true">⌂</span>
            Dashboard
        </a>

        <a class="nav-link"
           href="<%= request.getContextPath() %>/user/change-password">
            <span class="nav-icon" aria-hidden="true">♙</span>
            Security
        </a>

    </nav>

    <!-- PAGE HEADING -->
    <div class="page-heading">
        <div>
            <h2>Personal Information</h2>
            <p>Update the details associated with your SmartFix account.</p>
        </div>

        <span class="heading-tag">✦ Account Settings</span>
    </div>

    <!-- FORM CARD -->
    <section class="profile-card">

        <div class="profile-top">
            <div class="avatar" aria-hidden="true">
                <%= escapeHtml(firstLetter) %>
            </div>

            <div class="profile-info">
                <h3><%= escapeHtml(displayName) %></h3>
                <p>Make changes to your personal information below.</p>
            </div>
        </div>

        <!-- ERROR MESSAGE -->
        <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="error-message" role="alert">
                <span aria-hidden="true">⚠</span>
                <span><%= escapeHtml(error) %></span>
            </div>
        <% } %>

        <!-- EDIT PROFILE FORM -->
        <form
            class="edit-form"
            action="<%= request.getContextPath() %>/user/edit-profile"
            method="post">

            <h3 class="form-section-title">About You</h3>

            <div class="form-grid">

                <!-- FULL NAME -->
                <div class="form-group">
                    <label for="name">
                        Full Name <span class="required">*</span>
                    </label>

                    <input
                        type="text"
                        id="name"
                        name="name"
                        value="<%= escapeHtml(userName) %>"
                        placeholder="Enter your full name"
                        maxlength="100"
                        autocomplete="name"
                        required>
                </div>

                <!-- EMAIL -->
                <div class="form-group">
                    <label for="email">
                        Email Address <span class="required">*</span>
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        value="<%= escapeHtml(userEmail) %>"
                        placeholder="Enter your email address"
                        maxlength="150"
                        autocomplete="email"
                        required>
                </div>

                <!-- PHONE -->
                <div class="form-group">
                    <label for="phone">Mobile Number</label>

                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        value="<%= escapeHtml(userPhone) %>"
                        placeholder="Enter your mobile number"
                        maxlength="20"
                        autocomplete="tel">

                    <span class="field-note">
                        Use a number where you can receive service updates.
                    </span>
                </div>

                <!-- ROLE -->
                <div class="form-group">
                    <label for="role">Account Role</label>

                    <input
                        type="text"
                        id="role"
                        value="<%= escapeHtml(userRole) %>"
                        readonly
                        aria-describedby="role-note">

                    <span class="field-note" id="role-note">
                        Your account role cannot be changed here.
                    </span>
                </div>

                <!-- ROOM NUMBER -->
                <div class="form-group">
                    <label for="roomNumber">Room Number</label>

                    <input
                        type="text"
                        id="roomNumber"
                        name="roomNumber"
                        value="<%= escapeHtml(userRoomNumber) %>"
                        placeholder="Enter your room number"
                        maxlength="20"
                        autocomplete="off">

                    <span class="field-note">
                        For your apartment, hostel, or office, if applicable.
                    </span>
                </div>

                <!-- ADDRESS -->
                <div class="form-group full">
                    <label for="address">Address</label>

                    <textarea
                        id="address"
                        name="address"
                        maxlength="500"
                        autocomplete="street-address"
                        placeholder="Enter your complete address"><%= escapeHtml(userAddress) %></textarea>

                    <span class="field-note">
                        Add your location details to help with service requests.
                    </span>
                </div>

            </div>

            <!-- FORM ACTIONS -->
            <div class="form-footer">

                <p class="privacy-note">
                    Your profile information helps SmartFix manage your account
                    and communicate updates about your service requests.
                </p>

                <div class="button-area">

                    <a
                        href="<%= request.getContextPath() %>/user/profile.jsp"
                        class="btn cancel-btn">
                        <span aria-hidden="true">✕</span>
                        Cancel
                    </a>

                    <button type="submit" class="btn save-btn">
                        <span aria-hidden="true">✓</span>
                        Save Changes
                    </button>

                </div>
            </div>

        </form>

    </section>

    <footer class="footer-note">
        SmartFix &mdash; Complaint &amp; Service Management System
    </footer>

</main>

</body>
</html>

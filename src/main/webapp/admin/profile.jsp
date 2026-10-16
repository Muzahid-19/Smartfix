
<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.smartfix.modelcom.User"%>

<%
    User admin = (User) request.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/profile"
        );
        return;
    }

    String name = admin.getName() != null
        ? admin.getName() : "Administrator";

    String email = admin.getEmail() != null
        ? admin.getEmail() : "Not available";

    String phone = admin.getPhone() != null
        ? admin.getPhone() : "Not available";

    String address = admin.getAddress() != null
        ? admin.getAddress() : "Not available";

    String role = admin.getRole() != null
        ? admin.getRole() : "ADMIN";

    String firstLetter = !name.trim().isEmpty()
        ? name.trim().substring(0, 1).toUpperCase()
        : "A";

    String passwordChanged =
        request.getParameter("passwordChanged");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>SmartFix | My Profile</title>

<style>
:root {
    --primary: #2563eb;
    --primary-dark: #1d4ed8;
    --text: #172554;
    --muted: #64748b;
    --border: #e2e8f0;
    --background: #f4f6fa;
    --white: #fff;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    background: var(--background);
    color: var(--text);
    line-height: 1.5;
}

a {
    -webkit-tap-highlight-color: transparent;
}

.page {
    width: min(1500px, 100%);
    margin: 0 auto;
    padding: 20px 30px 35px;
}

/* HERO */

.hero {
    position: relative;
    isolation: isolate;
    overflow: hidden;
    min-height: 235px;
    padding: 38px 44px;
    border-radius: 20px 20px 0 0;
    color: white;
    background: linear-gradient(
        115deg,
        #3565ad 0%,
        #8baee1 35%,
        #c8baf3 68%,
        #ffd08c 100%
    );
}

.hero::before,
.hero::after {
    content: "";
    position: absolute;
    z-index: -1;
    pointer-events: none;
    border-radius: 50%;
}

.hero::before {
    width: 75%;
    height: 280px;
    right: -5%;
    top: -170px;
    background: rgba(255,255,255,.20);
    transform: rotate(-10deg);
}

.hero::after {
    width: 320px;
    height: 150px;
    right: -30px;
    bottom: -95px;
    background: rgba(255,255,255,.22);
}

.eyebrow {
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 1.5px;
    text-transform: uppercase;
    margin-bottom: 12px;
}

.hero h1 {
    font-size: clamp(27px, 3vw, 39px);
    line-height: 1.2;
    overflow-wrap: anywhere;
}

.hero p {
    margin-top: 12px;
    font-size: 15px;
    color: #fff;
}

.account-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-top: 18px;
    padding: 9px 15px;
    border: 1px solid rgba(255,255,255,.45);
    border-radius: 25px;
    background: rgba(255,255,255,.15);
    font-size: 12px;
    font-weight: 700;
}

.status-dot {
    width: 8px;
    height: 8px;
    background: #bbf7d0;
    border-radius: 50%;
}

/* NAVIGATION */

.tabs {
    display: flex;
    align-items: stretch;
    gap: 4px;
    min-height: 75px;
    padding: 0 24px;
    background: white;
    border: 1px solid var(--border);
    border-top: 0;
    border-radius: 0 0 20px 20px;
    box-shadow: 0 5px 16px rgba(15,23,42,.03);
    overflow-x: auto;
}

.tab {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    flex: 0 0 auto;
    padding: 20px 18px;
    color: var(--muted);
    text-decoration: none;
    font-size: 14px;
    font-weight: 700;
    border-bottom: 3px solid transparent;
    transition: background .2s, color .2s;
}

.tab:hover {
    color: var(--primary);
    background: #f8faff;
}

.tab.active {
    color: var(--text);
    border-bottom-color: var(--primary);
}

.tab-icon {
    color: var(--primary);
    font-size: 17px;
}

/* MESSAGES */

.message {
    padding: 14px 17px;
    margin-top: 22px;
    border-radius: 12px;
    font-size: 14px;
}

.success {
    color: #166534;
    background: #dcfce7;
    border: 1px solid #bbf7d0;
}

/* PROFILE LAYOUT */

.profile-layout {
    display: grid;
    grid-template-columns: minmax(260px, 350px) minmax(0, 1fr);
    gap: 22px;
    align-items: start;
    margin-top: 24px;
}

.panel {
    min-width: 0;
    background: var(--white);
    border: 1px solid var(--border);
    border-radius: 20px;
    box-shadow: 0 5px 20px rgba(15,23,42,.035);
}

/* LEFT PROFILE CARD */

.profile-summary {
    padding: 28px;
    text-align: center;
}

.avatar {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 96px;
    height: 96px;
    margin: 0 auto 16px;
    border-radius: 50%;
    color: #1d4ed8;
    background: linear-gradient(135deg, #dbeafe, #bfdbfe);
    border: 5px solid #eff6ff;
    font-size: 36px;
    font-weight: 800;
}

.profile-summary h2 {
    font-size: 22px;
    overflow-wrap: anywhere;
}

.profile-email {
    margin-top: 7px;
    color: var(--muted);
    font-size: 13px;
    overflow-wrap: anywhere;
}

.verified {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    margin-top: 18px;
    padding: 9px 14px;
    border-radius: 25px;
    color: #047857;
    background: #e7f8ef;
    font-size: 12px;
    font-weight: 700;
}

.summary-divider {
    height: 1px;
    margin: 23px 0;
    background: var(--border);
}

.account-id {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    text-align: left;
    font-size: 13px;
}

.account-id span {
    color: var(--muted);
}

.account-id strong {
    overflow-wrap: anywhere;
}

.help-note {
    margin-top: 20px;
    padding: 15px;
    border-radius: 13px;
    background: #f5f8fc;
    color: var(--muted);
    text-align: left;
    font-size: 13px;
}

/* RIGHT INFORMATION CARD */

.profile-details {
    padding: 28px 30px;
}

.section-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    padding-bottom: 22px;
    margin-bottom: 25px;
    border-bottom: 1px solid var(--border);
}

.section-heading h2 {
    color: #0f172a;
    font-size: 23px;
}

.section-heading p {
    margin-top: 5px;
    color: var(--muted);
    font-size: 13px;
}

.section-tag {
    flex: 0 0 auto;
    padding: 8px 12px;
    border-radius: 8px;
    background: #f1f5f9;
    color: #475569;
    font-size: 11px;
    font-weight: 800;
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 22px 20px;
}

.detail {
    min-width: 0;
}

.detail label {
    display: block;
    margin-bottom: 9px;
    color: #334155;
    font-size: 13px;
    font-weight: 700;
}

.detail-value {
    display: flex;
    align-items: center;
    gap: 10px;
    min-height: 56px;
    padding: 14px 15px;
    border: 1px solid #d7e0ed;
    border-radius: 10px;
    background: #f7f8fa;
    color: #2456a6;
    font-size: 13px;
    overflow-wrap: anywhere;
    word-break: break-word;
}

.detail-icon {
    flex: 0 0 auto;
    color: #64748b;
}

.detail.full-width {
    grid-column: 1 / -1;
}

/* ACTIONS */

.actions {
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    margin-top: 26px;
    padding-top: 22px;
    border-top: 1px solid var(--border);
}

.btn {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
    min-height: 44px;
    padding: 11px 16px;
    border: 1px solid transparent;
    border-radius: 10px;
    text-decoration: none;
    font-size: 13px;
    font-weight: 700;
    transition: background .2s, transform .2s;
}

.btn:hover {
    transform: translateY(-1px);
}

.btn-primary {
    background: var(--primary);
    color: white;
}

.btn-primary:hover {
    background: var(--primary-dark);
}

.btn-purple {
    background: #7c3aed;
    color: white;
}

.btn-purple:hover {
    background: #6d28d9;
}

.btn-secondary {
    color: #334155;
    background: #f1f5f9;
    border-color: #e2e8f0;
}

.btn-secondary:hover {
    background: #e2e8f0;
}

/* RESPONSIVE */

@media (max-width: 1000px) {
    .page {
        padding: 16px;
    }

    .profile-layout {
        grid-template-columns: minmax(220px, 280px) minmax(0, 1fr);
        gap: 16px;
    }

    .profile-summary {
        padding: 22px 18px;
    }

    .profile-details {
        padding: 24px 20px;
    }

    .details-grid {
        gap: 18px 14px;
    }
}

@media (max-width: 760px) {
    .page {
        padding: 12px;
    }

    .hero {
        min-height: auto;
        padding: 28px 24px;
        border-radius: 16px 16px 0 0;
    }

    .tabs {
        min-height: 62px;
        padding: 0 10px;
        border-radius: 0 0 16px 16px;
    }

    .tab {
        padding: 17px 13px;
        font-size: 13px;
    }

    .profile-layout {
        grid-template-columns: 1fr;
        margin-top: 16px;
    }

    .profile-summary {
        padding: 25px;
    }

    .profile-details {
        padding: 24px;
    }

    .details-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }
}

@media (max-width: 480px) {
    .hero {
        padding: 24px 18px;
    }

    .hero h1 {
        font-size: 27px;
    }

    .hero p {
        font-size: 13px;
    }

    .tabs {
        padding: 0 5px;
    }

    .tab {
        gap: 7px;
        padding: 15px 11px;
        font-size: 12px;
    }

    .profile-details {
        padding: 20px 16px;
    }

    .section-heading {
        align-items: flex-start;
    }

    .section-heading h2 {
        font-size: 20px;
    }

    .section-tag {
        font-size: 9px;
        padding: 7px 8px;
    }

    .details-grid {
        grid-template-columns: 1fr;
        gap: 16px;
    }

    .detail.full-width {
        grid-column: auto;
    }

    .actions {
        flex-direction: column;
    }

    .btn {
        width: 100%;
    }
}

@media (prefers-reduced-motion: reduce) {
    *,
    *::before,
    *::after {
        scroll-behavior: auto !important;
        transition: none !important;
    }
}
</style>
</head>

<body>

<div class="page">

    <!-- PROFILE BANNER -->

    <header class="hero">
        <div class="eyebrow">SmartFix Account</div>

        <h1>Hello, <%= name %></h1>

        <p>Manage your profile and account information in one place.</p>

        <div class="account-badge">
            <span class="status-dot"></span>
            <%= role %> ACCOUNT
        </div>
    </header>

    <!-- PROFILE NAVIGATION -->

    <nav class="tabs" aria-label="Account navigation">

        <a class="tab active"
           href="<%= request.getContextPath() %>/admin/profile"
           aria-current="page">
            <span class="tab-icon">♟</span>
            Personal Info
        </a>

        <a class="tab"
           href="<%= request.getContextPath() %>/admin/dashboard">
            <span class="tab-icon">⌂</span>
            Dashboard
        </a>

        <a class="tab"
           href="<%= request.getContextPath() %>/admin/edit-profile">
            <span class="tab-icon">✎</span>
            Edit Profile
        </a>

        <a class="tab"
           href="<%= request.getContextPath() %>/admin/change-password">
            <span class="tab-icon">♙</span>
            Security
        </a>

    </nav>

    <% if ("true".equals(passwordChanged)) { %>
        <div class="message success" role="status">
            ✓ Password changed successfully.
        </div>
    <% } %>

    <!-- PROFILE CONTENT -->

    <main class="profile-layout">

        <!-- LEFT SUMMARY -->

        <aside class="panel profile-summary">

            <div class="avatar" aria-hidden="true">
                <%= firstLetter %>
            </div>

            <h2><%= name %></h2>

            <p class="profile-email"><%= email %></p>

            <div class="verified">
                ✓ SmartFix Account
            </div>

            <div class="summary-divider"></div>

            <div class="account-id">
                <span>Account ID</span>
                <strong>
                    <%= admin.getUserId() %>
                </strong>
            </div>

            <div class="help-note">
                Keep your contact information up to date so you can
                receive important service and complaint updates.
            </div>

        </aside>

        <!-- RIGHT PERSONAL INFORMATION -->

        <section class="panel profile-details">

            <div class="section-heading">
                <div>
                    <h2>About You</h2>
                    <p>Your personal and contact information.</p>
                </div>

                <span class="section-tag">PERSONAL INFO</span>
            </div>

            <div class="details-grid">

                <div class="detail">
                    <label>Full Name</label>
                    <div class="detail-value">
                        <span class="detail-icon">♟</span>
                        <%= name %>
                    </div>
                </div>

                <div class="detail">
                    <label>Account Role</label>
                    <div class="detail-value">
                        <span class="detail-icon">🛡</span>
                        <%= role %>
                    </div>
                </div>

                <div class="detail">
                    <label>Email Address</label>
                    <div class="detail-value">
                        <span class="detail-icon">✉</span>
                        <%= email %>
                    </div>
                </div>

                <div class="detail">
                    <label>Mobile Number</label>
                    <div class="detail-value">
                        <span class="detail-icon">☎</span>
                        <%= phone %>
                    </div>
                </div>

                <div class="detail full-width">
                    <label>Address</label>
                    <div class="detail-value">
                        <span class="detail-icon">⌖</span>
                        <%= address %>
                    </div>
                </div>

            </div>

            <div class="actions">

                <a class="btn btn-primary"
                   href="<%= request.getContextPath() %>/admin/edit-profile">
                    ✎ Edit Profile
                </a>

                <a class="btn btn-purple"
                   href="<%= request.getContextPath() %>/admin/change-password">
                    🔐 Change Password
                </a>

                <a class="btn btn-secondary"
                   href="<%= request.getContextPath() %>/admin/dashboard">
                    ← Dashboard
                </a>

                <a class="btn btn-secondary"
                   href="<%= request.getContextPath() %>/logout">
                    ↪ Logout
                </a>

            </div>

        </section>

    </main>

</div>

</body>
</html>

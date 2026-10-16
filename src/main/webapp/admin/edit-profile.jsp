
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.smartfix.modelcom.User"%>

<%
    User admin = (User) request.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin/profile");
        return;
    }

    String name = admin.getName() != null ? admin.getName() : "";
    String email = admin.getEmail() != null ? admin.getEmail() : "";
    String phone = admin.getPhone() != null ? admin.getPhone() : "";
    String address = admin.getAddress() != null ? admin.getAddress() : "";
    String role = admin.getRole() != null ? admin.getRole() : "ADMIN";

    String error = (String) request.getAttribute("error");
    String firstLetter = !name.trim().isEmpty()
            ? name.trim().substring(0, 1).toUpperCase()
            : "A";

    String cp = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Admin Account - SmartFix</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #f3f6fb;
    color: #14213d;
    padding: 30px;
}

.page-container {
    width: 100%;
    max-width: 1700px;
    margin: 0 auto;
}

/* Account banner */
.account-banner {
    min-height: 230px;
    padding: 38px 42px;
    border-radius: 20px 20px 0 0;
    color: white;
    background:
        radial-gradient(ellipse at 70% -35%, rgba(255,255,255,.35) 0 35%, transparent 35.2%),
        radial-gradient(ellipse at 98% 120%, rgba(255,255,255,.25) 0 15%, transparent 15.2%),
        linear-gradient(110deg, #3766b1 0%, #a8b5ef 52%, #ffd092 100%);
    overflow: hidden;
}

.eyebrow {
    font-size: 13px;
    font-weight: 800;
    letter-spacing: 1.3px;
    text-transform: uppercase;
    margin-bottom: 18px;
}

.account-banner h1 {
    font-size: clamp(28px, 3vw, 40px);
    margin-bottom: 12px;
}

.account-banner p {
    font-size: 16px;
    line-height: 1.6;
}

.account-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-top: 17px;
    padding: 10px 16px;
    border: 1px solid rgba(255,255,255,.45);
    background: rgba(255,255,255,.15);
    border-radius: 30px;
    font-size: 12px;
    font-weight: 700;
}

.account-badge span {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #b7f7d4;
}

/* Navigation tabs */
.account-nav {
    display: flex;
    align-items: stretch;
    gap: 0;
    min-height: 76px;
    background: white;
    border: 1px solid #e0e7f1;
    border-top: none;
    border-radius: 0 0 20px 20px;
    padding: 0 24px;
    box-shadow: 0 5px 18px rgba(15,23,42,.03);
    margin-bottom: 30px;
    overflow-x: auto;
}

.account-nav a {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 0 22px;
    white-space: nowrap;
    text-decoration: none;
    color: #536783;
    font-size: 14px;
    font-weight: 700;
    border-bottom: 3px solid transparent;
    transition: .2s ease;
}

.account-nav a .nav-icon {
    color: #3168ff;
    font-size: 17px;
}

.account-nav a:hover {
    color: #0f172a;
    background: #f8faff;
}

.account-nav a.active {
    color: #0f172a;
    border-bottom-color: #3168ff;
}

/* Section heading */
.section-heading {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    margin-bottom: 20px;
}

.section-heading h2 {
    font-size: 22px;
    margin-bottom: 10px;
}

.section-heading p {
    color: #718096;
    font-size: 14px;
    line-height: 1.5;
}

.section-label {
    padding: 10px 14px;
    border-radius: 10px;
    background: #eaf1ff;
    color: #245bd8;
    font-size: 12px;
    font-weight: 700;
    white-space: nowrap;
}

/* Main profile card */
.profile-card {
    background: white;
    border: 1px solid #e0e7f1;
    border-radius: 18px;
    padding: 32px;
    box-shadow: 0 5px 20px rgba(15,23,42,.035);
}

.profile-intro {
    display: flex;
    align-items: center;
    gap: 20px;
    padding-bottom: 26px;
    margin-bottom: 28px;
    border-bottom: 1px solid #e1e8f2;
}

.avatar {
    width: 72px;
    height: 72px;
    min-width: 72px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: linear-gradient(135deg, #dceaff, #a9caff);
    border: 5px solid #e9f1ff;
    color: #215ce0;
    font-size: 28px;
    font-weight: 800;
}

.profile-intro h3 {
    font-size: 20px;
    margin-bottom: 8px;
}

.profile-intro p {
    color: #718096;
    font-size: 14px;
    line-height: 1.6;
}

.form-title {
    font-size: 17px;
    margin-bottom: 26px;
}

/* Form fields */
.form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 24px 22px;
}

.form-group {
    display: flex;
    flex-direction: column;
    min-width: 0;
}

.form-group.full {
    grid-column: 1 / -1;
}

.form-group label {
    font-size: 14px;
    font-weight: 700;
    margin-bottom: 10px;
    color: #25364e;
}

.required {
    color: #e53935;
}

.form-group input,
.form-group textarea {
    width: 100%;
    min-height: 54px;
    border: 1px solid #d4deeb;
    border-radius: 10px;
    padding: 14px 16px;
    font-family: inherit;
    font-size: 14px;
    color: #245ba7;
    background: #fff;
    outline: none;
    transition: border-color .2s, box-shadow .2s;
}

.form-group input:focus,
.form-group textarea:focus {
    border-color: #4b7df2;
    box-shadow: 0 0 0 3px rgba(49,104,255,.11);
}

.form-group textarea {
    min-height: 110px;
    resize: vertical;
    line-height: 1.6;
}

.form-group input[readonly] {
    background: #f4f6f9;
    color: #718096;
    cursor: not-allowed;
}

.helper-text {
    margin-top: 8px;
    color: #7b8798;
    font-size: 12px;
    line-height: 1.5;
}

/* Error message */
.error-message {
    padding: 14px 16px;
    margin-bottom: 24px;
    color: #a61b1b;
    background: #fff1f1;
    border: 1px solid #fecaca;
    border-radius: 10px;
    font-size: 14px;
}

/* Form actions */
.form-actions {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 12px;
    padding-top: 26px;
    margin-top: 28px;
    border-top: 1px solid #e1e8f2;
}

.btn {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
    min-height: 46px;
    padding: 12px 20px;
    border: none;
    border-radius: 10px;
    text-decoration: none;
    font-size: 14px;
    font-weight: 700;
    font-family: inherit;
    cursor: pointer;
    transition: .2s ease;
}

.btn-primary {
    color: white;
    background: #3168f5;
}

.btn-primary:hover {
    background: #2454d8;
    transform: translateY(-1px);
    box-shadow: 0 7px 16px rgba(49,104,245,.2);
}

.btn-secondary {
    color: #42526b;
    background: #edf1f7;
}

.btn-secondary:hover {
    background: #dfe6f0;
}

@media (max-width: 800px) {
    body {
        padding: 16px;
    }

    .account-banner {
        padding: 28px 24px;
    }

    .account-nav {
        padding: 0 8px;
    }

    .account-nav a {
        padding: 0 15px;
    }

    .profile-card {
        padding: 24px;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .form-group.full {
        grid-column: auto;
    }
}

@media (max-width: 520px) {
    body {
        padding: 10px;
    }

    .account-banner {
        min-height: auto;
        padding: 25px 20px;
    }

    .account-banner h1 {
        font-size: 28px;
    }

    .account-nav {
        min-height: 64px;
    }

    .account-nav a {
        padding: 0 13px;
        font-size: 13px;
    }

    .section-heading {
        align-items: flex-start;
        flex-direction: column;
    }

    .profile-card {
        padding: 19px;
    }

    .profile-intro {
        align-items: flex-start;
        gap: 14px;
    }

    .avatar {
        width: 58px;
        height: 58px;
        min-width: 58px;
        font-size: 23px;
    }

    .form-actions {
        flex-direction: column;
        align-items: stretch;
    }

    .form-actions .btn {
        width: 100%;
    }
}
</style>
</head>

<body>
<div class="page-container">

    <!-- ADMIN ACCOUNT BANNER -->
    <header class="account-banner">
        <div class="eyebrow">SmartFix Admin Account</div>
        <h1>Edit Your Admin Profile</h1>
        <p>Manage your administrator details and account information.</p>
        <div class="account-badge">
            <span></span>
            ADMIN ACCOUNT
        </div>
    </header>

    <!-- ACCOUNT NAVIGATION -->
    <nav class="account-nav">
        <a href="<%= cp %>/admin/profile">
            <span class="nav-icon">♟</span>
            Personal Info
        </a>

        <a class="active" href="<%= cp %>/admin/edit-profile">
            <span class="nav-icon">✎</span>
            Edit Profile
        </a>

        <a href="<%= cp %>/admin/dashboard">
            <span class="nav-icon">⌂</span>
            Dashboard
        </a>

        <a href="<%= cp %>/admin/change-password">
            <span class="nav-icon">♙</span>
            Security
        </a>
    </nav>

    <!-- SECTION HEADING -->
    <div class="section-heading">
        <div>
            <h2>Admin Personal Information</h2>
            <p>Update the details associated with your SmartFix administrator account.</p>
        </div>
        <span class="section-label">✦ ADMIN ACCOUNT SETTINGS</span>
    </div>

    <!-- EDIT PROFILE CARD -->
    <section class="profile-card">

        <div class="profile-intro">
            <div class="avatar"><%= firstLetter %></div>
            <div>
                <h3><%= name %></h3>
                <p>Make changes to your administrator information below.</p>
            </div>
        </div>

        <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="error-message">
                ⚠️ <%= error %>
            </div>
        <% } %>

        <h3 class="form-title">About You</h3>

        <form action="<%= cp %>/admin/edit-profile" method="post">
            <div class="form-grid">

                <div class="form-group">
                    <label for="name">Full Name <span class="required">*</span></label>
                    <input
                        type="text"
                        id="name"
                        name="name"
                        value="<%= name %>"
                        maxlength="100"
                        autocomplete="name"
                        required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        value="<%= email %>"
                        maxlength="150"
                        autocomplete="email"
                        required>
                </div>

                <div class="form-group">
                    <label for="phone">Mobile Number</label>
                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        value="<%= phone %>"
                        maxlength="20"
                        autocomplete="tel">
                </div>

                <div class="form-group">
                    <label for="role">Account Role</label>
                    <input
                        type="text"
                        id="role"
                        value="<%= role %>"
                        readonly>
                    <span class="helper-text">
                        Administrator roles cannot be changed here.
                    </span>
                </div>

                <div class="form-group full">
                    <label for="address">Address</label>
                    <textarea
                        id="address"
                        name="address"
                        maxlength="500"
                        autocomplete="street-address"
                        placeholder="Enter your address"><%= address %></textarea>
                </div>

            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-primary">
                    ✓ Save Changes
                </button>

                <a class="btn btn-secondary" href="<%= cp %>/admin/profile">
                    ✕ Cancel
                </a>

                <a class="btn btn-secondary" href="<%= cp %>/admin/dashboard">
                    ← Back to Dashboard
                </a>
            </div>
        </form>

    </section>
</div>
</body>
</html>

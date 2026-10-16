<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    Boolean passwordResetVerified =
            (Boolean) session.getAttribute("passwordResetVerified");

    if (passwordResetVerified == null || !passwordResetVerified) {

        response.sendRedirect(
            request.getContextPath()
            + "/forgot-password.jsp?error=Please verify OTP first."
        );

        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>SmartFix - Reset Password</title>

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/style.css">

<style>

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f4f7fb;
}

.reset-page {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.reset-box {
    width: 420px;
    background: white;
    padding: 35px;
    border-radius: 15px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.reset-logo {
    text-align: center;
    margin-bottom: 25px;
}

.reset-logo-icon {
    width: 55px;
    height: 55px;
    background: #2563eb;
    color: white;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 10px;
    font-size: 28px;
    font-weight: bold;
}

.reset-logo h1 {
    margin: 5px 0;
    color: #1e293b;
}

.reset-logo p {
    margin: 0;
    color: #64748b;
    font-size: 14px;
}

.reset-heading {
    text-align: center;
    margin-bottom: 25px;
}

.reset-heading h2 {
    margin-bottom: 8px;
    color: #1e293b;
}

.reset-heading p {
    margin: 0;
    color: #64748b;
    font-size: 14px;
}

.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: #334155;
}

.form-control {
    width: 100%;
    box-sizing: border-box;
    padding: 12px 14px;
    border: 1px solid #cbd5e1;
    border-radius: 8px;
    font-size: 15px;
    outline: none;
}

.form-control:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.reset-btn {
    width: 100%;
    padding: 13px;
    border: none;
    border-radius: 8px;
    background: #2563eb;
    color: white;
    font-size: 16px;
    font-weight: 600;
    cursor: pointer;
    transition: 0.3s;
}

.reset-btn:hover {
    background: #1d4ed8;
}

.back-login {
    text-align: center;
    margin-top: 20px;
}

.back-login a {
    color: #2563eb;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
}

.back-login a:hover {
    text-decoration: underline;
}

.error-message {
    background: #fee2e2;
    color: #b91c1c;
    padding: 10px;
    border-radius: 6px;
    margin-bottom: 15px;
    text-align: center;
    font-size: 14px;
}

</style>

</head>

<body>

<div class="reset-page">

    <div class="reset-box">

        <!-- Logo -->

        <div class="reset-logo">

            <div class="reset-logo-icon">
                S
            </div>

            <h1>SmartFix</h1>

            <p>
                Complaint & Service Management System
            </p>

        </div>


        <!-- Heading -->

        <div class="reset-heading">

            <h2>Reset Password</h2>

            <p>
                Enter your new password below.
            </p>

        </div>


        <!-- Error Message -->

        <%
            String error = request.getParameter("error");

            if (error != null) {
        %>

            <div class="error-message">
                <%= error %>
            </div>

        <%
            }
        %>


        <!-- Reset Password Form -->

        <form action="<%= request.getContextPath() %>/reset-password"
              method="post">

            <!-- New Password -->

            <div class="form-group">

                <label>
                    New Password
                </label>

                <input
                    type="password"
                    name="password"
                    class="form-control"
                    placeholder="Enter new password"
                    autocomplete="new-password"
                    required>

            </div>


            <!-- Confirm Password -->

            <div class="form-group">

                <label>
                    Confirm New Password
                </label>

                <input
                    type="password"
                    name="confirmPassword"
                    class="form-control"
                    placeholder="Confirm new password"
                    autocomplete="new-password"
                    required>

            </div>


            <!-- Button -->

            <button
                type="submit"
                class="reset-btn">

                Reset Password

            </button>

        </form>


        <!-- Back to Login -->

        <div class="back-login">

            <a href="<%= request.getContextPath() %>/login.jsp">
                ← Back to Login
            </a>

        </div>

    </div>

</div>

</body>

</html>
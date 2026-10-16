<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>SmartFix - Forgot Password</title>

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/style.css">

<style>

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f4f7fb;
}

.forgot-page {
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.forgot-box {
    width: 420px;
    background: white;
    padding: 35px;
    border-radius: 15px;
    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.12);
}

.forgot-logo {
    text-align: center;
    margin-bottom: 25px;
}

.forgot-logo-icon {
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

.forgot-logo h1 {
    margin: 5px 0;
    color: #1e293b;
}

.forgot-logo p {
    margin: 0;
    color: #64748b;
    font-size: 14px;
}

.forgot-heading {
    text-align: center;
    margin-bottom: 25px;
}

.forgot-heading h2 {
    margin-bottom: 8px;
    color: #1e293b;
}

.forgot-heading p {
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

.continue-btn {
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

.continue-btn:hover {
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

</style>

</head>

<body>

<div class="forgot-page">

    <div class="forgot-box">

        <!-- Logo -->
        <div class="forgot-logo">

            <div class="forgot-logo-icon">
                S
            </div>

            <h1>SmartFix</h1>

            <p>
                Complaint & Service Management System
            </p>

        </div>


        <!-- Heading -->
        <div class="forgot-heading">

            <h2>Forgot Password?</h2>

            <p>
                Enter your registered email address
                to continue.
            </p>

        </div>


        <!-- Email Form -->
        <form action="<%= request.getContextPath() %>/forgot-password"
              method="post">

            <div class="form-group">

                <label>
                    Email Address
                </label>

                <input
                    type="email"
                    name="email"
                    class="form-control"
                    placeholder="Enter your registered email"
                    autocomplete="email"
                    required>

            </div>


            <button type="submit"
                    class="continue-btn">

                Continue

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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%!
    private String escapeLogin(String value) {
        if (value == null) return "";
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");

    if (error == null) error = request.getParameter("error");
    if (message == null) message = request.getParameter("message");

    if (error == null) error = "";
    if (message == null) message = "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>SmartFix | Login</title>

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/style.css">

<style>
* {
    box-sizing: border-box;
}

body {
    margin: 0;
    font-family: "Segoe UI", Arial, sans-serif;
    color: #172554;
    background: #f0f6ff;
}

.login-page {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 24px;
    background:
        radial-gradient(circle at 8% 8%, #d7e8ff 0, transparent 34%),
        radial-gradient(circle at 92% 90%, #d9f0ff 0, transparent 32%),
        #f4f7fc;
}

.login-box {
    width: 100%;
    max-width: 430px;
    padding: 36px;
    background: #fff;
    border: 1px solid #e2eaf6;
    border-radius: 22px;
    box-shadow: 0 20px 55px rgba(30, 64, 175, .10);
    animation: appear .45s ease;
}

.login-logo {
    text-align: center;
    margin-bottom: 27px;
}

.login-logo-icon {
    width: 58px;
    height: 58px;
    margin: 0 auto 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 17px;
    color: #fff;
    font-size: 28px;
    font-weight: 800;
    background: linear-gradient(135deg, #1e40af, #2563eb, #0ea5e9);
    box-shadow: 0 8px 20px rgba(37, 99, 235, .23);
}

.login-logo h1 {
    margin: 0 0 6px;
    font-size: 30px;
    letter-spacing: -.8px;
    color: #102754;
}

.login-logo h1 span {
    color: #2563eb;
}

.login-logo p {
    margin: 0;
    color: #7184a5;
    font-size: 12px;
    line-height: 1.6;
}

.login-heading {
    text-align: center;
    margin-bottom: 24px;
}

.login-heading h2 {
    margin: 0 0 7px;
    font-size: 24px;
    color: #172554;
}

.login-heading p {
    margin: 0;
    color: #718096;
    font-size: 13px;
}

.login-message {
    position: relative;
    padding: 12px 14px;
    margin-bottom: 16px;
    border-radius: 10px;
    font-size: 13px;
    line-height: 1.5;
    overflow-wrap: anywhere;
}

.error {
    color: #b91c1c;
    background: #fff1f2;
    border: 1px solid #fecdd3;
}

.success {
    color: #166534;
    background: #f0fdf4;
    border: 1px solid #bbf7d0;
}

.login-message[hidden] {
    display: none;
}

.form-group {
    margin-bottom: 17px;
}

.form-group label {
    display: block;
    margin-bottom: 7px;
    color: #334155;
    font-size: 13px;
    font-weight: 700;
}

.form-control {
    width: 100%;
    min-height: 46px;
    padding: 12px 14px;
    border: 1px solid #d6e1f0;
    border-radius: 10px;
    background: #fff;
    color: #172554;
    font-family: inherit;
    font-size: 14px;
    outline: none;
    transition: border-color .2s, box-shadow .2s;
}

.form-control::placeholder {
    color: #9aabc3;
}

.form-control:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(37, 99, 235, .11);
}

.password-wrap {
    position: relative;
}

.password-wrap .form-control {
    padding-right: 65px;
}

.show-password {
    position: absolute;
    top: 50%;
    right: 9px;
    transform: translateY(-50%);
    padding: 6px 8px;
    border: 0;
    border-radius: 6px;
    background: #eff6ff;
    color: #2563eb;
    font-size: 12px;
    font-weight: 700;
    cursor: pointer;
}

.login-btn {
    width: 100%;
    min-height: 47px;
    margin-top: 3px;
    padding: 12px 16px;
    border: 0;
    border-radius: 10px;
    background: linear-gradient(110deg, #1e40af, #2563eb, #0891e8);
    color: #fff;
    font-family: inherit;
    font-size: 15px;
    font-weight: 700;
    cursor: pointer;
    box-shadow: 0 7px 18px rgba(37, 99, 235, .20);
    transition: transform .2s, box-shadow .2s;
}

.login-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 10px 24px rgba(37, 99, 235, .28);
}

.forgot-password {
    text-align: right;
    margin-top: 16px;
    font-size: 13px;
}

.forgot-password a,
.register-section a {
    color: #2563eb;
    text-decoration: none;
    font-weight: 700;
}

.forgot-password a:hover,
.register-section a:hover {
    text-decoration: underline;
}

.register-section {
    margin-top: 23px;
    padding-top: 19px;
    border-top: 1px solid #e7edf6;
    text-align: center;
    color: #718096;
    font-size: 13px;
    line-height: 1.7;
}

.register-section a {
    margin-left: 4px;
}

button:focus-visible,
a:focus-visible,
input:focus-visible {
    outline: 3px solid #93c5fd;
    outline-offset: 3px;
}

@keyframes appear {
    from {
        opacity: 0;
        transform: translateY(12px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@media (max-width: 480px) {
    .login-page {
        padding: 14px;
    }

    .login-box {
        padding: 27px 21px;
        border-radius: 18px;
    }

    .login-logo {
        margin-bottom: 23px;
    }

    .login-logo h1 {
        font-size: 27px;
    }

    .login-heading h2 {
        font-size: 22px;
    }

    .form-control {
        min-height: 46px;
        font-size: 16px;
    }
}

@media (max-height: 650px) and (min-width: 481px) {
    .login-page {
        padding-top: 12px;
        padding-bottom: 12px;
    }

    .login-box {
        padding: 22px 30px;
    }

    .login-logo {
        margin-bottom: 17px;
    }

    .login-logo-icon {
        width: 45px;
        height: 45px;
        margin-bottom: 7px;
        font-size: 23px;
    }

    .login-logo h1 {
        font-size: 26px;
    }

    .login-heading {
        margin-bottom: 17px;
    }

    .form-group {
        margin-bottom: 12px;
    }

    .register-section {
        margin-top: 16px;
        padding-top: 13px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation: none !important;
        transition: none !important;
    }
}
</style>
</head>

<body>

<main class="login-page">
    <section class="login-box">

        <div class="login-logo">
            <div class="login-logo-icon" aria-hidden="true">S</div>

            <h1>Smart<span>Fix</span></h1>

            <p>Complaint &amp; Service Management System</p>
        </div>

        <div class="login-heading">
            <h2>Welcome Back</h2>
            <p>Login to manage your complaints</p>
        </div>

        <% if (!error.trim().isEmpty()) { %>
            <div class="login-message error" id="errorMessage" role="alert">
                <%= escapeLogin(error) %>
            </div>
        <% } %>

        <% if (!message.trim().isEmpty()) { %>
            <div class="login-message success" id="successMessage" role="status">
                <%= escapeLogin(message) %>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login"
              method="post">

            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control"
                       placeholder="Enter your email"
                       autocomplete="username"
                       maxlength="150"
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>

                <div class="password-wrap">
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="Enter your password"
                           autocomplete="current-password"
                           required>

                    <button type="button"
                            class="show-password"
                            id="togglePassword"
                            aria-controls="password"
                            aria-pressed="false">
                        Show
                    </button>
                </div>
            </div>

            <button type="submit" class="login-btn">
                Login to SmartFix &#8594;
            </button>
        </form>

        <div class="forgot-password">
            <a href="<%= request.getContextPath() %>/forgot-password.jsp">
                Forgot Password?
            </a>
        </div>

        <div class="register-section">
            Don't have an account?
            <a href="<%= request.getContextPath() %>/register.jsp">
                Create Account
            </a>
        </div>

    </section>
</main>

<script>
const passwordInput = document.getElementById("password");
const toggleButton = document.getElementById("togglePassword");

toggleButton.addEventListener("click", function () {
    const show = passwordInput.type === "password";

    passwordInput.type = show ? "text" : "password";
    toggleButton.textContent = show ? "Hide" : "Show";
    toggleButton.setAttribute("aria-pressed", String(show));
});
</script>

</body>
</html>

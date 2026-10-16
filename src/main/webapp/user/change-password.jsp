
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Change Password | SmartFix</title>

    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --text: #172033;
            --muted: #64748b;
            --border: #dbe3ef;
            --background: #f4f7fc;
            --danger: #b91c1c;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            min-height: 100dvh;
            padding: 24px 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            background:
                radial-gradient(ellipse at top left, #e1ebff 0, transparent 42%),
                radial-gradient(ellipse at bottom right, #e0f2fe 0, transparent 40%),
                var(--background);
            color: var(--text);
            font-family: "Segoe UI", Arial, sans-serif;
        }

        button, input, a {
            font: inherit;
        }

        .page-container {
            width: 100%;
            max-width: 470px;
            margin: auto;
            animation: appear 0.35s ease-out;
        }

        .brand {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            color: var(--primary);
            font-size: 25px;
            font-weight: 800;
            letter-spacing: -0.7px;
        }

        .brand-mark {
            display: grid;
            place-items: center;
            width: 40px;
            height: 40px;
            border-radius: 12px;
            color: white;
            background: linear-gradient(135deg, #2563eb, #4f46e5);
            box-shadow: 0 5px 12px rgba(37, 99, 235, 0.2);
            font-size: 21px;
        }

        .password-card {
            padding: 34px;
            background: #fff;
            border: 1px solid #e5eaf2;
            border-radius: 22px;
            box-shadow: 0 18px 55px rgba(30, 50, 90, 0.09);
        }

        .security-icon {
            display: grid;
            place-items: center;
            width: 62px;
            height: 62px;
            margin: 0 auto 18px;
            border-radius: 18px;
            background: #eff6ff;
            border: 1px solid #dbeafe;
            font-size: 29px;
        }

        h1 {
            text-align: center;
            font-size: clamp(24px, 5vw, 29px);
            letter-spacing: -0.7px;
            line-height: 1.3;
            margin-bottom: 9px;
        }

        .subtitle {
            text-align: center;
            color: var(--muted);
            font-size: 14px;
            line-height: 1.6;
            margin: 0 auto 25px;
            max-width: 310px;
        }

        .security-note {
            display: flex;
            gap: 10px;
            align-items: flex-start;
            padding: 12px 13px;
            margin-bottom: 22px;
            border: 1px solid #dbeafe;
            border-radius: 12px;
            background: #f5f9ff;
            color: #34517b;
            font-size: 12px;
            line-height: 1.6;
        }

        .security-note span {
            flex-shrink: 0;
            font-size: 16px;
        }

        .error-message {
            display: flex;
            align-items: flex-start;
            gap: 9px;
            padding: 13px 14px;
            margin-bottom: 20px;
            border: 1px solid #fecaca;
            border-radius: 11px;
            background: #fef2f2;
            color: var(--danger);
            font-size: 13px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .form-group {
            margin-bottom: 19px;
        }

        .label-row {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 8px;
            margin-bottom: 8px;
        }

        label {
            display: block;
            color: #29364b;
            font-size: 13px;
            font-weight: 700;
        }

        .required {
            color: #dc2626;
        }

        .password-box {
            position: relative;
        }

        .password-box input {
            display: block;
            width: 100%;
            min-width: 0;
            min-height: 49px;
            padding: 13px 51px 13px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 11px;
            outline: none;
            background: #fff;
            color: #172033;
            font-size: 14px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .password-box input::placeholder {
            color: #8996a9;
            opacity: 1;
        }

        .password-box input:hover {
            border-color: #94a3b8;
        }

        .password-box input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .password-box input.invalid {
            border-color: #dc2626;
            box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.08);
        }

        .eye-btn {
            position: absolute;
            top: 50%;
            right: 6px;
            transform: translateY(-50%);
            display: grid;
            place-items: center;
            width: 38px;
            height: 38px;
            border: none;
            border-radius: 8px;
            background: transparent;
            color: #64748b;
            cursor: pointer;
            font-size: 18px;
            transition: background 0.2s, color 0.2s;
        }

        .eye-btn:hover {
            background: #eff6ff;
            color: var(--primary);
        }

        .eye-btn:focus-visible,
        .btn:focus-visible {
            outline: 3px solid rgba(37, 99, 235, 0.35);
            outline-offset: 3px;
        }

        .field-hint {
            margin-top: 7px;
            color: #718096;
            font-size: 12px;
            line-height: 1.5;
        }

        .match-message {
            display: none;
            margin-top: 7px;
            font-size: 12px;
            line-height: 1.4;
        }

        .match-message.success {
            display: block;
            color: #15803d;
        }

        .match-message.error {
            display: block;
            color: #b91c1c;
        }

        .password-rules {
            display: flex;
            align-items: center;
            gap: 7px;
            margin-top: 8px;
            color: #718096;
            font-size: 12px;
        }

        .rule-dot {
            width: 7px;
            height: 7px;
            flex-shrink: 0;
            border-radius: 50%;
            background: #cbd5e1;
        }

        .password-rules.valid {
            color: #15803d;
        }

        .password-rules.valid .rule-dot {
            background: #16a34a;
        }

        .button-row {
            display: grid;
            grid-template-columns: 0.85fr 1.4fr;
            gap: 11px;
            margin-top: 27px;
        }

        .btn {
            min-height: 48px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 15px;
            border: 1px solid transparent;
            border-radius: 11px;
            text-decoration: none;
            text-align: center;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s, background 0.2s, box-shadow 0.2s;
        }

        .btn:active {
            transform: scale(0.98);
        }

        .btn-cancel {
            border-color: #dbe3ef;
            background: #fff;
            color: #475569;
        }

        .btn-cancel:hover {
            background: #f8fafc;
            border-color: #cbd5e1;
        }

        .btn-submit {
            background: linear-gradient(135deg, #2563eb, #4f46e5);
            color: white;
            box-shadow: 0 5px 13px rgba(37, 99, 235, 0.2);
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #1d4ed8, #4338ca);
            box-shadow: 0 8px 18px rgba(37, 99, 235, 0.25);
            transform: translateY(-1px);
        }

        .btn-submit:disabled {
            opacity: 0.7;
            cursor: not-allowed;
            transform: none;
        }

        .footer {
            text-align: center;
            margin-top: 18px;
            color: #7b8798;
            font-size: 12px;
            line-height: 1.6;
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

        @media (max-width: 520px) {
            body {
                align-items: flex-start;
                padding: 20px 13px;
            }

            .brand {
                margin-bottom: 16px;
                font-size: 23px;
            }

            .password-card {
                padding: 25px 20px;
                border-radius: 18px;
            }

            .security-icon {
                width: 56px;
                height: 56px;
                margin-bottom: 15px;
            }

            .subtitle {
                margin-bottom: 22px;
                font-size: 13px;
            }

            .button-row {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .btn {
                width: 100%;
                min-height: 47px;
            }
        }

        @media (max-width: 350px) {
            body {
                padding: 14px 9px;
            }

            .password-card {
                padding: 22px 15px;
            }

            .password-box input {
                font-size: 13px;
                padding-left: 11px;
            }

            h1 {
                font-size: 23px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: 0.01ms !important;
                transition-duration: 0.01ms !important;
                scroll-behavior: auto !important;
            }
        }
    </style>
</head>

<body>
    <main class="page-container">

        <div class="brand" aria-label="SmartFix">
            <div class="brand-mark" aria-hidden="true">S</div>
            <span>SmartFix</span>
        </div>

        <section class="password-card" aria-labelledby="page-title">

            <div class="security-icon" aria-hidden="true">🔐</div>

            <h1 id="page-title">Change Password</h1>

            <p class="subtitle">
                Update your password to help keep your SmartFix account secure.
            </p>

            <div class="security-note">
                <span aria-hidden="true">🛡️</span>
                <p>
                    Choose a password you don't use on other websites.
                    Never share your password with anyone.
                </p>
            </div>

            <% if (error != null && !error.trim().isEmpty()) { %>
                <div class="error-message" role="alert">
                    <span aria-hidden="true">⚠</span>
                    <span><%= error %></span>
                </div>
            <% } %>

            <form
                id="changePasswordForm"
                action="<%= request.getContextPath() %>/user/change-password"
                method="post"
                onsubmit="return validatePasswords()">

                <div class="form-group">
                    <div class="label-row">
                        <label for="currentPassword">
                            Current Password <span class="required">*</span>
                        </label>
                    </div>

                    <div class="password-box">
                        <input
                            type="password"
                            id="currentPassword"
                            name="currentPassword"
                            placeholder="Enter your current password"
                            autocomplete="current-password"
                            required>

                        <button
                            type="button"
                            class="eye-btn"
                            aria-label="Show current password"
                            aria-pressed="false"
                            onclick="togglePassword('currentPassword', this)">&#128065;</button>
                    </div>
                </div>

                <div class="form-group">
                    <div class="label-row">
                        <label for="newPassword">
                            New Password <span class="required">*</span>
                        </label>
                    </div>

                    <div class="password-box">
                        <input
                            type="password"
                            id="newPassword"
                            name="newPassword"
                            placeholder="Create a new password"
                            minlength="6"
                            autocomplete="new-password"
                            aria-describedby="passwordHint passwordRule"
                            required>

                        <button
                            type="button"
                            class="eye-btn"
                            aria-label="Show new password"
                            aria-pressed="false"
                            onclick="togglePassword('newPassword', this)">&#128065;</button>
                    </div>

                    <p class="field-hint" id="passwordHint">
                        Use at least 6 characters.
                    </p>

                    <div class="password-rules" id="passwordRule">
                        <span class="rule-dot" aria-hidden="true"></span>
                        <span>At least 6 characters</span>
                    </div>
                </div>

                <div class="form-group">
                    <div class="label-row">
                        <label for="confirmPassword">
                            Confirm New Password <span class="required">*</span>
                        </label>
                    </div>

                    <div class="password-box">
                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            placeholder="Enter your new password again"
                            minlength="6"
                            autocomplete="new-password"
                            aria-describedby="matchMessage"
                            required>

                        <button
                            type="button"
                            class="eye-btn"
                            aria-label="Show confirmation password"
                            aria-pressed="false"
                            onclick="togglePassword('confirmPassword', this)">&#128065;</button>
                    </div>

                    <p class="match-message" id="matchMessage" aria-live="polite"></p>
                </div>

                <div class="button-row">
                    <a
                        href="<%= request.getContextPath() %>/user/profile.jsp"
                        class="btn btn-cancel">
                        Cancel
                    </a>

                    <button type="submit" class="btn btn-submit" id="submitButton">
                        <span aria-hidden="true">✓</span>
                        Change Password
                    </button>
                </div>
            </form>
        </section>

        <footer class="footer">
            SmartFix Complaint &amp; Service Management System
        </footer>
    </main>

    <script>
        function togglePassword(inputId, button) {
            const input = document.getElementById(inputId);
            const isHidden = input.type === "password";

            input.type = isHidden ? "text" : "password";
            button.setAttribute("aria-pressed", String(isHidden));
            button.setAttribute(
                "aria-label",
                (isHidden ? "Hide " : "Show ") +
                (inputId === "currentPassword"
                    ? "current password"
                    : inputId === "newPassword"
                        ? "new password"
                        : "confirmation password")
            );
        }

        const newPassword = document.getElementById("newPassword");
        const confirmPassword = document.getElementById("confirmPassword");
        const matchMessage = document.getElementById("matchMessage");
        const passwordRule = document.getElementById("passwordRule");

        function updatePasswordFeedback() {
            const meetsLength = newPassword.value.length >= 6;

            passwordRule.classList.toggle("valid", meetsLength);

            if (confirmPassword.value.length === 0) {
                matchMessage.textContent = "";
                matchMessage.className = "match-message";
                confirmPassword.classList.remove("invalid");
                return;
            }

            const matches = newPassword.value === confirmPassword.value;

            matchMessage.textContent = matches
                ? "✓ Passwords match."
                : "Passwords do not match yet.";

            matchMessage.className = matches
                ? "match-message success"
                : "match-message error";

            confirmPassword.classList.toggle("invalid", !matches);
        }

        newPassword.addEventListener("input", updatePasswordFeedback);
        confirmPassword.addEventListener("input", updatePasswordFeedback);

        function validatePasswords() {
            const currentPassword =
                document.getElementById("currentPassword").value;

            if (!currentPassword.trim()) {
                alert("Please enter your current password.");
                document.getElementById("currentPassword").focus();
                return false;
            }

            if (newPassword.value.length < 6) {
                alert("Your new password must contain at least 6 characters.");
                newPassword.focus();
                return false;
            }

            if (newPassword.value === currentPassword) {
                alert("Your new password must be different from your current password.");
                newPassword.focus();
                return false;
            }

            if (newPassword.value !== confirmPassword.value) {
                alert("Your new password and confirmation do not match.");
                confirmPassword.focus();
                return false;
            }

            return true;
        }
    </script>
</body>
</html>

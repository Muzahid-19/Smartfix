
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Change Password - SmartFix</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background:
        radial-gradient(circle at top left, #e7efff, transparent 35%),
        #f4f7fc;
    color: #14213d;
    min-height: 100vh;
    padding: 22px 16px 35px;
}

/* LOGO */

.logo {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 11px;
    margin: 0 auto 25px;
}

.logo-icon {
    width: 44px;
    height: 44px;
    border-radius: 14px;
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    font-weight: 800;
    box-shadow: 0 6px 15px rgba(37, 99, 235, 0.2);
}

.logo-text {
    font-size: 28px;
    font-weight: 800;
    color: #2563eb;
    letter-spacing: -1px;
}

/* MAIN CARD */

.password-container {
    width: 100%;
    max-width: 490px;
    margin: 0 auto;
    padding: 28px 32px;
    background: #ffffff;
    border: 1px solid #e4eaf4;
    border-radius: 23px;
    box-shadow: 0 16px 45px rgba(30, 64, 175, 0.08);
}

/* HEADER */

.lock-icon {
    width: 64px;
    height: 64px;
    margin: 0 auto 19px;
    border-radius: 21px;
    background: #eff6ff;
    border: 1px solid #dbeafe;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 30px;
}

h1 {
    text-align: center;
    font-size: 29px;
    letter-spacing: -0.8px;
    margin-bottom: 11px;
    color: #111827;
}

.subtitle {
    text-align: center;
    color: #64748b;
    font-size: 14px;
    line-height: 1.65;
    margin: 0 auto 23px;
    max-width: 360px;
}

/* SECURITY NOTICE */

.security-notice {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 13px 14px;
    margin-bottom: 23px;
    background: #f4f8ff;
    border: 1px solid #d7e6ff;
    border-radius: 13px;
    color: #365985;
    font-size: 13px;
    line-height: 1.6;
}

.notice-icon {
    font-size: 17px;
    flex-shrink: 0;
    margin-top: 1px;
}

/* MESSAGES */

.message {
    padding: 11px 13px;
    border-radius: 9px;
    margin-bottom: 18px;
    font-size: 13px;
    line-height: 1.5;
}

.error {
    color: #991b1b;
    background: #fef2f2;
    border: 1px solid #fecaca;
}

.success {
    color: #166534;
    background: #f0fdf4;
    border: 1px solid #bbf7d0;
}

/* FORM */

.form-group {
    margin-bottom: 19px;
}

label {
    display: block;
    margin-bottom: 8px;
    color: #172554;
    font-size: 13px;
    font-weight: 700;
}

.required {
    color: #dc2626;
}

.password-input {
    position: relative;
}

input[type="password"],
input[type="text"] {
    display: block;
    width: 100%;
    height: 47px;
    padding: 0 44px 0 14px;
    border: 1px solid #cbd8ea;
    border-radius: 12px;
    background: #ffffff;
    color: #1e293b;
    font-family: inherit;
    font-size: 14px;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
}

input::placeholder {
    color: #94a3b8;
}

input:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.12);
}

.toggle-password {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    width: 27px;
    height: 27px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: transparent;
    border: none;
    color: #64748b;
    cursor: pointer;
    font-size: 16px;
}

.toggle-password:hover {
    color: #2563eb;
}

.helper-text {
    margin-top: 7px;
    color: #64748b;
    font-size: 12px;
    line-height: 1.5;
}

/* PASSWORD REQUIREMENTS */

.requirements {
    margin-top: 9px;
    display: flex;
    align-items: center;
    gap: 8px;
    font-size: 12px;
    color: #64748b;
}

.requirement-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #cbd5e1;
    flex-shrink: 0;
}

.requirements.valid {
    color: #15803d;
}

.requirements.valid .requirement-dot {
    background: #22c55e;
}

/* BUTTONS */

.actions {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-top: 24px;
}

.btn {
    min-height: 45px;
    width: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 8px;
    border: none;
    border-radius: 11px;
    text-decoration: none;
    font-family: inherit;
    font-size: 14px;
    font-weight: 700;
    cursor: pointer;
    transition: 0.2s;
}

.btn-primary {
    background: linear-gradient(135deg, #2563eb, #4f46e5);
    color: white;
    box-shadow: 0 5px 12px rgba(37, 99, 235, 0.16);
}

.btn-primary:hover {
    transform: translateY(-1px);
    box-shadow: 0 8px 17px rgba(37, 99, 235, 0.23);
}

.btn-secondary {
    background: #f1f5f9;
    color: #475569;
    border: 1px solid #e2e8f0;
}

.btn-secondary:hover {
    background: #e2e8f0;
}

/* FOOTER */

.footer-text {
    text-align: center;
    margin-top: 20px;
    color: #94a3b8;
    font-size: 12px;
}

/* RESPONSIVE */

@media (max-width: 520px) {
    body {
        padding: 16px 10px 25px;
    }

    .logo {
        margin-bottom: 19px;
    }

    .logo-icon {
        width: 40px;
        height: 40px;
    }

    .logo-text {
        font-size: 25px;
    }

    .password-container {
        max-width: 100%;
        padding: 24px 19px;
        border-radius: 18px;
    }

    h1 {
        font-size: 25px;
    }

    .subtitle {
        font-size: 13px;
    }

    .security-notice {
        font-size: 12px;
    }
}
</style>
</head>

<body>

    <div class="logo">
        <div class="logo-icon">S</div>
        <div class="logo-text">SmartFix</div>
    </div>

    <main class="password-container">

        <div class="lock-icon">🔐</div>

        <h1>Change Password</h1>

        <p class="subtitle">
            Update your password to help keep your SmartFix
            account secure.
        </p>

        <div class="security-notice">
            <span class="notice-icon">🛡️</span>
            <span>
                Choose a password you don't use on other websites.
                Never share your password with anyone.
            </span>
        </div>

        <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="message error">
                ⚠️ <%= error %>
            </div>
        <% } %>

        <% if (success != null && !success.trim().isEmpty()) { %>
            <div class="message success">
                ✅ <%= success %>
            </div>
        <% } %>

        <form
            action="<%= request.getContextPath() %>/admin/change-password"
            method="post"
            id="passwordForm">

            <div class="form-group">
                <label for="currentPassword">
                    Current Password <span class="required">*</span>
                </label>

                <div class="password-input">
                    <input
                        type="password"
                        id="currentPassword"
                        name="currentPassword"
                        placeholder="Enter your current password"
                        autocomplete="current-password"
                        required>

                    <button
                        type="button"
                        class="toggle-password"
                        onclick="togglePassword('currentPassword', this)"
                        aria-label="Show current password">◎</button>
                </div>
            </div>

            <div class="form-group">
                <label for="newPassword">
                    New Password <span class="required">*</span>
                </label>

                <div class="password-input">
                    <input
                        type="password"
                        id="newPassword"
                        name="newPassword"
                        placeholder="Create a new password"
                        autocomplete="new-password"
                        minlength="6"
                        required>
                    
                    <button
                        type="button"
                        class="toggle-password"
                        onclick="togglePassword('newPassword', this)"
                        aria-label="Show new password">◎</button>
                </div>

                <p class="helper-text">
                    Use at least 6 characters.
                </p>

                <div class="requirements" id="lengthRequirement">
                    <span class="requirement-dot"></span>
                    <span>At least 6 characters</span>
                </div>

                <div class="requirements" id="matchRequirement">
                    <span class="requirement-dot"></span>
                    <span>Passwords must match</span>
                </div>
            </div>

            <div class="form-group">
                <label for="confirmPassword">
                    Confirm New Password <span class="required">*</span>
                </label>

                <div class="password-input">
                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Enter your new password again"
                        autocomplete="new-password"
                        minlength="6"
                        required>

                    <button
                        type="button"
                        class="toggle-password"
                        onclick="togglePassword('confirmPassword', this)"
                        aria-label="Show confirm password">◎</button>
                </div>
            </div>

            <div class="actions">
                <button type="submit" class="btn btn-primary">
                    🔐 Update Password
                </button>

                <a
                    class="btn btn-secondary"
                    href="<%= request.getContextPath() %>/admin/profile">
                    ← Back to Profile
                </a>
            </div>
        </form>

        <div class="footer-text">
            © SmartFix — Secure Account Management
        </div>

    </main>

<script>
function togglePassword(inputId, button) {
    const input = document.getElementById(inputId);

    if (input.type === "password") {
        input.type = "text";
        button.textContent = "◉";
        button.setAttribute("aria-label", "Hide password");
    } else {
        input.type = "password";
        button.textContent = "◎";
        button.setAttribute("aria-label", "Show password");
    }
}

const newPassword = document.getElementById("newPassword");
const confirmPassword = document.getElementById("confirmPassword");
const lengthRequirement = document.getElementById("lengthRequirement");
const matchRequirement = document.getElementById("matchRequirement");

function validatePasswordFields() {
    const lengthValid = newPassword.value.length >= 6;
    const matchValid =
        confirmPassword.value.length > 0 &&
        newPassword.value === confirmPassword.value;

    lengthRequirement.classList.toggle("valid", lengthValid);
    matchRequirement.classList.toggle("valid", matchValid);

    confirmPassword.setCustomValidity(
        confirmPassword.value.length > 0 && !matchValid
            ? "New password and confirmation do not match."
            : ""
    );
}

newPassword.addEventListener("input", validatePasswordFields);
confirmPassword.addEventListener("input", validatePasswordFields);

document.getElementById("passwordForm").addEventListener("submit", function(event) {
    validatePasswordFields();

    if (newPassword.value.length < 6) {
        event.preventDefault();
        newPassword.setCustomValidity(
            "Password must contain at least 6 characters."
        );
        newPassword.reportValidity();
        newPassword.setCustomValidity("");
        return;
    }

    if (newPassword.value !== confirmPassword.value) {
        event.preventDefault();
        confirmPassword.reportValidity();
    }
});
</script>

</body>
</html>

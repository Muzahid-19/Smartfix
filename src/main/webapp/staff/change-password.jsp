<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Change Password - SmartFix</title>

    <style>

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            min-height: 100vh;

            display: flex;

            align-items: center;

            justify-content: center;

            padding: 20px;

            font-family:
                Arial,
                sans-serif;

            background:
                linear-gradient(
                    135deg,
                    #eef2ff,
                    #f8fafc,
                    #e0f2fe
                );
        }

        .password-container {
            width: 100%;
            max-width: 480px;

            animation:
                slideUp 0.6s ease;
        }

        .password-card {
            background: white;

            padding: 38px;

            border-radius: 22px;

            border:
                1px solid #e5e7eb;

            box-shadow:
                0 20px 50px
                rgba(15, 23, 42, 0.15);
        }

        .icon {
            width: 70px;
            height: 70px;

            margin:
                0 auto 20px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            background: #ede9fe;

            font-size: 32px;
        }

        h1 {
            text-align: center;

            color: #111827;

            margin-bottom: 8px;

            font-size: 28px;
        }

        .subtitle {
            text-align: center;

            color: #6b7280;

            font-size: 14px;

            margin-bottom: 28px;
        }

        .error-message {
            background: #fef2f2;

            color: #b91c1c;

            border:
                1px solid #fecaca;

            padding: 12px 15px;

            border-radius: 10px;

            margin-bottom: 20px;

            font-size: 14px;

            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;

            color: #374151;

            font-weight: 600;

            margin-bottom: 8px;

            font-size: 14px;
        }

        .password-box {
            position: relative;
        }

        input {
            width: 100%;

            padding:
                13px 48px 13px 14px;

            border:
                1px solid #d1d5db;

            border-radius: 11px;

            font-size: 15px;

            outline: none;

            transition: 0.3s;
        }

        input:focus {
            border-color: #7c3aed;

            box-shadow:
                0 0 0 3px
                rgba(124, 58, 237, 0.12);
        }

        .eye-btn {
            position: absolute;

            right: 12px;

            top: 50%;

            transform:
                translateY(-50%);

            border: none;

            background: transparent;

            cursor: pointer;

            font-size: 19px;

            color: #6b7280;
        }

        .eye-btn:hover {
            color: #7c3aed;
        }

        .password-hint {
            margin-top: 7px;

            color: #6b7280;

            font-size: 12px;
        }

        .button-row {
            display: flex;

            gap: 12px;

            margin-top: 28px;
        }

        .btn {
            flex: 1;

            padding: 13px;

            border-radius: 11px;

            text-decoration: none;

            text-align: center;

            font-weight: 600;

            cursor: pointer;

            transition: 0.3s;

            border: none;

            font-size: 15px;
        }

        .btn-submit {
            color: white;

            background:
                linear-gradient(
                    135deg,
                    #7c3aed,
                    #9333ea
                );

            box-shadow:
                0 8px 20px
                rgba(124, 58, 237, 0.25);
        }

        .btn-submit:hover {
            transform:
                translateY(-2px);

            box-shadow:
                0 12px 25px
                rgba(124, 58, 237, 0.35);
        }

        .btn-cancel {
            color: #374151;

            background: #f3f4f6;
        }

        .btn-cancel:hover {
            background: #e5e7eb;

            transform:
                translateY(-2px);
        }

        @keyframes slideUp {

            from {
                opacity: 0;

                transform:
                    translateY(30px);
            }

            to {
                opacity: 1;

                transform:
                    translateY(0);
            }
        }

        @media (max-width: 500px) {

            .password-card {
                padding: 25px 20px;
            }

            .button-row {
                flex-direction: column;
            }

            h1 {
                font-size: 24px;
            }
        }

    </style>

</head>

<body>


<div class="password-container">


    <div class="password-card">


        <div class="icon">

            🔐

        </div>


        <h1>

            Change Password

        </h1>


        <p class="subtitle">

            Keep your SmartFix staff account secure

        </p>


        <% if (error != null && !error.isEmpty()) { %>

            <div class="error-message">

                ❌ <%= error %>

            </div>

        <% } %>


        <form
            action="<%= request.getContextPath() %>/staff/change-password"
            method="post"
            onsubmit="return validatePasswords()">


            <!-- CURRENT PASSWORD -->

            <div class="form-group">

                <label for="currentPassword">

                    Current Password

                </label>


                <div class="password-box">

                    <input
                        type="password"
                        id="currentPassword"
                        name="currentPassword"
                        placeholder="Enter current password"
                        required>


                    <button
                        type="button"
                        class="eye-btn"
                        onclick="togglePassword(
                            'currentPassword',
                            this
                        )">

                        👁

                    </button>

                </div>

            </div>


            <!-- NEW PASSWORD -->

            <div class="form-group">

                <label for="newPassword">

                    New Password

                </label>


                <div class="password-box">

                    <input
                        type="password"
                        id="newPassword"
                        name="newPassword"
                        placeholder="Enter new password"
                        minlength="6"
                        required>


                    <button
                        type="button"
                        class="eye-btn"
                        onclick="togglePassword(
                            'newPassword',
                            this
                        )">

                        👁

                    </button>

                </div>


                <div class="password-hint">

                    Password must contain at least 6 characters.

                </div>

            </div>


            <!-- CONFIRM PASSWORD -->

            <div class="form-group">

                <label for="confirmPassword">

                    Confirm New Password

                </label>


                <div class="password-box">

                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        placeholder="Re-enter new password"
                        minlength="6"
                        required>


                    <button
                        type="button"
                        class="eye-btn"
                        onclick="togglePassword(
                            'confirmPassword',
                            this
                        )">

                        👁

                    </button>

                </div>

            </div>


            <!-- BUTTONS -->

            <div class="button-row">


                <a
                    href="<%= request.getContextPath() %>/staff/profile"
                    class="btn btn-cancel">

                    Cancel

                </a>


                <button
                    type="submit"
                    class="btn btn-submit">

                    Change Password

                </button>


            </div>


        </form>


    </div>

</div>


<script>

    function togglePassword(inputId, button) {

        const input =
            document.getElementById(inputId);

        if (input.type === "password") {

            input.type = "text";

            button.textContent = "🙈";

        } else {

            input.type = "password";

            button.textContent = "👁";
        }
    }


    function validatePasswords() {

        const newPassword =
            document.getElementById(
                "newPassword"
            ).value;

        const confirmPassword =
            document.getElementById(
                "confirmPassword"
            ).value;


        if (newPassword.length < 6) {

            alert(
                "New password must contain at least 6 characters."
            );

            return false;
        }


        if (newPassword !== confirmPassword) {

            alert(
                "New password and confirm password do not match."
            );

            return false;
        }


        return true;
    }

</script>


</body>

</html>
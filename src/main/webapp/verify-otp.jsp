<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>SmartFix - Verify OTP</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #eef4ff, #f8fafc);
        }

        .otp-page {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            box-sizing: border-box;
        }

        .otp-card {
            width: 420px;
            background: #ffffff;
            padding: 40px;
            border-radius: 16px;
            box-sizing: border-box;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.10);
        }

        .otp-logo {
            text-align: center;
            margin-bottom: 25px;
        }

        .otp-logo-icon {
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
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.25);
        }

        .otp-logo h1 {
            margin: 5px 0;
            color: #1e293b;
            font-size: 26px;
        }

        .otp-logo p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
        }

        .otp-heading {
            text-align: center;
            margin-bottom: 20px;
        }

        .otp-heading h2 {
            margin: 0 0 10px;
            color: #1e293b;
            font-size: 24px;
        }

        .otp-heading p {
            margin: 0;
            color: #64748b;
            font-size: 14px;
            line-height: 1.6;
        }

        /* OTP Timer */

        .otp-timer {
            text-align: center;
            margin-bottom: 12px;
            padding: 10px;
            background: #eff6ff;
            border: 1px solid #dbeafe;
            border-radius: 8px;
            color: #475569;
            font-size: 14px;
            font-weight: 600;
        }

        .otp-timer span {
            color: #2563eb;
            font-weight: 700;
        }

        .otp-timer.expired {
            background: #fee2e2;
            border-color: #fecaca;
            color: #b91c1c;
        }

        .otp-timer.expired span {
            color: #b91c1c;
        }

        /* Resend Timer */

        .resend-timer {
            text-align: center;
            margin-bottom: 20px;
            color: #64748b;
            font-size: 13px;
        }

        .resend-timer span {
            color: #2563eb;
            font-weight: 700;
        }

        /* Messages */

        .error-message {
            background: #fee2e2;
            color: #b91c1c;
            padding: 12px 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            border: 1px solid #fecaca;
        }

        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 12px 14px;
            border-radius: 8px;
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            border: 1px solid #bbf7d0;
        }

        /* Form */

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #334155;
            font-weight: 600;
            font-size: 14px;
        }

        .otp-input {
            width: 100%;
            box-sizing: border-box;
            padding: 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 20px;
            text-align: center;
            letter-spacing: 6px;
            outline: none;
            transition: 0.3s;
        }

        .otp-input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .otp-input::placeholder {
            font-size: 14px;
            letter-spacing: normal;
            color: #94a3b8;
        }

        /* Verify Button */

        .otp-btn {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 8px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
        }

        .otp-btn:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(37, 99, 235, 0.25);
        }

        /* Resend */

        .resend-section {
            text-align: center;
            margin-top: 22px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
        }

        .resend-section p {
            margin: 0 0 8px;
            color: #64748b;
            font-size: 14px;
        }

        .resend-btn {
            border: none;
            background: transparent;
            color: #2563eb;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            padding: 0;
            transition: 0.3s;
        }

        .resend-btn:hover {
            color: #1d4ed8;
            text-decoration: underline;
        }

        .resend-btn:disabled {
            color: #94a3b8;
            cursor: not-allowed;
            text-decoration: none;
        }

        /* Back Link */

        .back-link {
            text-align: center;
            margin-top: 18px;
        }

        .back-link a {
            color: #64748b;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .back-link a:hover {
            color: #2563eb;
            text-decoration: underline;
        }

        @media (max-width: 500px) {

            .otp-page {
                padding: 15px;
            }

            .otp-card {
                width: 100%;
                padding: 30px 22px;
                border-radius: 12px;
            }

            .otp-logo h1 {
                font-size: 24px;
            }

            .otp-heading h2 {
                font-size: 22px;
            }
        }

    </style>

</head>

<body>

<div class="otp-page">

    <div class="otp-card">

        <!-- SmartFix Logo -->

        <div class="otp-logo">

            <div class="otp-logo-icon">
                S
            </div>

            <h1>
                SmartFix
            </h1>

            <p>
                Complaint & Service Management System
            </p>

        </div>


        <!-- Heading -->

        <div class="otp-heading">

            <h2>
                Verify OTP
            </h2>

            <p>
                Enter the 6-digit OTP sent to your email address.
            </p>

        </div>


        <!-- OTP Expiry Timer -->

        <div class="otp-timer"
             id="otpTimerContainer">

            OTP expires in:

            <span id="otpTimer">
                10:00
            </span>

        </div>


        <!-- Resend Cooldown Timer -->

        <div class="resend-timer"
             id="resendTimerContainer">

            You can resend OTP in

            <span id="resendTimer">
                60
            </span>

            seconds.

        </div>


        <!-- Success Message -->

        <%
            String message =
                request.getParameter("message");

            if (message != null) {
        %>

            <div class="success-message">

                <%= message %>

            </div>

        <%
            }
        %>


        <!-- Error Message -->

        <%
            String error =
                request.getParameter("error");

            if (error != null) {
        %>

            <div class="error-message">

                <%= error %>

            </div>

        <%
            }
        %>


        <!-- OTP Form -->

        <form action="<%= request.getContextPath() %>/verify-otp"
              method="post">

            <div class="form-group">

                <label for="otp">
                    Enter OTP
                </label>

                <input
                    type="text"
                    id="otp"
                    name="otp"
                    class="otp-input"
                    placeholder="Enter 6-digit OTP"
                    maxlength="6"
                    inputmode="numeric"
                    autocomplete="one-time-code"
                    pattern="[0-9]{6}"
                    required>

            </div>


            <!-- Verify Button -->

            <button
                type="submit"
                class="otp-btn">

                Verify OTP

            </button>

        </form>


        <!-- Resend OTP -->

        <div class="resend-section">

            <p>
                Didn't receive the OTP?
            </p>

            <form action="<%= request.getContextPath() %>/resend-otp"
                  method="post">

                <button
                    type="submit"
                    id="resendBtn"
                    class="resend-btn"
                    disabled>

                    Resend OTP

                </button>

            </form>

        </div>


        <!-- Back Link -->

        <div class="back-link">

            <a href="<%= request.getContextPath() %>/forgot-password.jsp">

                ← Back to Forgot Password

            </a>

        </div>

    </div>

</div>


<script>

    /* =========================================
       OTP EXPIRY TIME
    ========================================= */

    const otpExpiryTime =

        <%= session.getAttribute("otpExpiresAt") != null
            ? session.getAttribute("otpExpiresAt")
            : 0 %>;


    /* =========================================
       RESEND COOLDOWN
    ========================================= */

    const lastResendTime =

        <%= session.getAttribute("lastResendTime") != null
            ? session.getAttribute("lastResendTime")
            : 0 %>;


    const currentServerTime =
        new Date().getTime();


    const otpTimer =
        document.getElementById("otpTimer");


    const otpTimerContainer =
        document.getElementById(
            "otpTimerContainer"
        );


    const resendTimer =
        document.getElementById("resendTimer");


    const resendTimerContainer =
        document.getElementById(
            "resendTimerContainer"
        );


    const resendBtn =
        document.getElementById(
            "resendBtn"
        );


    /* =========================================
       OTP EXPIRY COUNTDOWN
    ========================================= */

    function updateOTPCountdown() {

        const now =
            new Date().getTime();

        const remaining =
            otpExpiryTime - now;


        if (remaining <= 0) {

            otpTimer.textContent =
                "Expired";

            otpTimerContainer.classList.add(
                "expired"
            );

            return false;
        }


        const totalSeconds =
            Math.floor(
                remaining / 1000
            );


        const minutes =
            Math.floor(
                totalSeconds / 60
            );


        const seconds =
            totalSeconds % 60;


        otpTimer.textContent =

            String(minutes).padStart(2, "0")
            + ":"
            + String(seconds).padStart(2, "0");


        return true;
    }


    /* =========================================
       RESEND COUNTDOWN
    ========================================= */

    function updateResendCountdown() {

        const now =
            new Date().getTime();


        /*
         * If there was no previous resend,
         * allow resend immediately.
         */

        if (lastResendTime === 0) {

            resendTimerContainer.style.display =
                "none";

            resendBtn.disabled = false;

            return false;
        }


        const cooldownEnd =
            lastResendTime + (60 * 1000);


        const remaining =
            cooldownEnd - now;


        /* Cooldown finished */

        if (remaining <= 0) {

            resendTimerContainer.style.display =
                "none";

            resendBtn.disabled = false;

            resendBtn.textContent =
                "Resend OTP";

            return false;
        }


        const seconds =
            Math.ceil(
                remaining / 1000
            );


        resendTimer.textContent =
            seconds;


        resendTimerContainer.style.display =
            "block";


        resendBtn.disabled = true;


        resendBtn.textContent =
            "Resend OTP";


        return true;
    }


    /* =========================================
       INITIAL UPDATE
    ========================================= */

    updateOTPCountdown();

    updateResendCountdown();


    /* =========================================
       RUN EVERY SECOND
    ========================================= */

    const countdownInterval =

        setInterval(function() {

            const otpActive =
                updateOTPCountdown();


            const resendActive =
                updateResendCountdown();


            /*
             * Stop timer when both
             * countdowns are finished.
             */

            if (!otpActive && !resendActive) {

                clearInterval(
                    countdownInterval
                );
            }

        }, 1000);

</script>


</body>

</html>
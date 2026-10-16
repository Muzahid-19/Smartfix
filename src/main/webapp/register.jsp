
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = (String) request.getAttribute("error");
    if (error == null || error.trim().isEmpty()) {
        error = request.getParameter("error");
    }
    if (error == null) error = "";
%>

<%!
    private String escapeRegister(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SmartFix | Register</title>

<style>
:root {
    --blue: #1769f5;
    --navy: #102754;
    --muted: #7184a5;
    --line: #d8e4f5;
}

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html, body {
    min-height: 100%;
}

body {
    font-family: "Segoe UI", Arial, sans-serif;
    color: var(--navy);
    background: #edf5ff;
}

/* HEADER */

header {
    height: 66px;
    padding: 0 5.5%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    background: rgba(255,255,255,.96);
    border-bottom: 1px solid #dce9fb;
}

.brand {
    font-size: 27px;
    font-weight: 800;
    letter-spacing: -.8px;
    color: var(--navy);
    text-decoration: none;
}

.brand span {
    color: var(--blue);
}

.header-right {
    display: flex;
    align-items: center;
    gap: 15px;
    color: #5e7191;
    font-size: 13px;
}

.login-link {
    text-decoration: none;
    color: var(--blue);
    border: 1px solid #b9d2ff;
    border-radius: 30px;
    padding: 9px 20px;
    font-weight: 700;
}

/* MAIN: TWO COLUMNS */

main {
    min-height: calc(100vh - 66px);
    display: grid;
    grid-template-columns: minmax(290px, .78fr) minmax(0, 1.22fr);
    gap: clamp(20px, 3vw, 48px);
    align-items: center;
    padding: 22px 5.5%;
    background:
        radial-gradient(ellipse at 0% 0%, #d4e8ff 0, transparent 38%),
        linear-gradient(125deg, #f1f7ff, #e6f2ff);
}

/* LEFT PANEL */

.intro {
    min-width: 0;
    max-width: 440px;
}

.eyebrow {
    display: inline-block;
    padding: 7px 12px;
    margin-bottom: 17px;
    border-radius: 20px;
    background: #d8eaff;
    color: var(--blue);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.4px;
}

.intro h1 {
    font-size: clamp(34px, 3.5vw, 49px);
    line-height: 1.08;
    letter-spacing: -1.6px;
    margin-bottom: 16px;
}

.intro h1 span {
    color: var(--blue);
}

.intro > p {
    max-width: 390px;
    color: #657b9e;
    font-size: 14px;
    line-height: 1.75;
}

.benefits {
    display: grid;
    gap: 17px;
    margin-top: 25px;
}

.benefit {
    display: flex;
    align-items: center;
    gap: 13px;
}

.benefit-icon {
    width: 43px;
    height: 43px;
    flex-shrink: 0;
    display: grid;
    place-items: center;
    border-radius: 14px;
    background: #d8eaff;
    color: var(--blue);
    font-size: 20px;
    font-weight: 800;
}

.benefit:nth-child(2) .benefit-icon {
    color: #079c70;
    background: #d5f7e9;
}

.benefit:nth-child(3) .benefit-icon {
    color: #7845ed;
    background: #e9e0ff;
}

.benefit h3 {
    font-size: 13px;
    margin-bottom: 4px;
}

.benefit p {
    color: #7184a5;
    font-size: 12px;
}

/* RIGHT: FORM CARD */

.card {
    min-width: 0;
    width: 100%;
    max-width: 760px;
    justify-self: end;
    padding: clamp(22px, 2.5vw, 32px);
    background: rgba(255,255,255,.97);
    border: 1px solid #e1eafb;
    border-radius: 20px;
    box-shadow: 0 16px 50px rgba(47, 91, 157, .10);
}

.card-heading {
    text-align: center;
    margin-bottom: 19px;
}

.avatar {
    width: 47px;
    height: 47px;
    display: grid;
    place-items: center;
    margin: 0 auto 10px;
    border-radius: 50%;
    background: #e1edff;
    color: var(--blue);
    font-size: 23px;
}

.card-heading h2 {
    font-size: clamp(23px, 2.3vw, 30px);
    letter-spacing: -.7px;
    margin-bottom: 6px;
}

.card-heading p {
    color: var(--muted);
    font-size: 13px;
}

.error {
    position: relative;
    padding: 10px 36px 10px 12px;
    margin-bottom: 14px;
    border: 1px solid #ffc6cd;
    border-radius: 9px;
    color: #bd263b;
    background: #fff1f2;
    font-size: 12px;
    line-height: 1.5;
    overflow-wrap: anywhere;
}

.error[hidden] {
    display: none;
}

.dismiss {
    position: absolute;
    right: 8px;
    top: 5px;
    border: 0;
    background: transparent;
    color: inherit;
    font-size: 20px;
    cursor: pointer;
}

/* INPUT GRID */

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 15px 17px;
}

.field {
    min-width: 0;
}

.field.full {
    grid-column: 1 / -1;
}

label {
    display: block;
    margin-bottom: 6px;
    color: #20365c;
    font-size: 12px;
    font-weight: 700;
}

.required {
    color: #e33c50;
}

input, textarea {
    width: 100%;
    min-width: 0;
    display: block;
    border: 1px solid #d3e0f2;
    border-radius: 9px;
    padding: 11px 12px;
    background: #fff;
    color: #152849;
    font-family: inherit;
    font-size: 13px;
    outline: none;
    transition: border-color .2s, box-shadow .2s;
}

input {
    height: 43px;
}

textarea {
    height: 61px;
    resize: vertical;
}

input::placeholder, textarea::placeholder {
    color: #96a7c1;
}

input:focus, textarea:focus {
    border-color: var(--blue);
    box-shadow: 0 0 0 3px rgba(23,105,245,.10);
}

.password-wrap {
    position: relative;
}

.password-wrap input {
    padding-right: 65px;
}

.show-password {
    position: absolute;
    right: 7px;
    top: 50%;
    transform: translateY(-50%);
    border: none;
    background: #edf4ff;
    color: var(--blue);
    border-radius: 6px;
    padding: 5px 8px;
    font-size: 11px;
    font-weight: 700;
    cursor: pointer;
}

.hint {
    margin-top: 4px;
    color: #8395b2;
    font-size: 10px;
}

/* BUTTON + FOOTER */

.submit {
    width: 100%;
    height: 45px;
    margin-top: 17px;
    border: 0;
    border-radius: 9px;
    color: white;
    background: linear-gradient(100deg, #2454ec, #079af2);
    font-size: 14px;
    font-family: inherit;
    font-weight: 750;
    cursor: pointer;
    transition: filter .2s, transform .2s;
}

.submit:hover {
    filter: brightness(.96);
    transform: translateY(-1px);
}

.login-note {
    margin-top: 15px;
    color: #7184a5;
    font-size: 12px;
    text-align: center;
}

.login-note a {
    color: var(--blue);
    font-weight: 700;
    text-decoration: none;
}

/* SHORT DESKTOP SCREENS */

@media (min-width: 761px) and (max-height: 800px) {
    header {
        height: 56px;
    }

    main {
        min-height: calc(100vh - 56px);
        padding-top: 12px;
        padding-bottom: 12px;
        gap: 25px;
    }

    .intro h1 {
        font-size: clamp(31px, 3vw, 40px);
        margin-bottom: 10px;
    }

    .intro > p {
        font-size: 13px;
        line-height: 1.55;
    }

    .benefits {
        gap: 12px;
        margin-top: 19px;
    }

    .benefit-icon {
        width: 37px;
        height: 37px;
    }

    .card {
        padding: 19px 25px;
    }

    .card-heading {
        margin-bottom: 13px;
    }

    .avatar {
        width: 39px;
        height: 39px;
        margin-bottom: 7px;
    }

    .card-heading h2 {
        font-size: 24px;
    }

    .form-grid {
        gap: 11px 15px;
    }

    input {
        height: 39px;
        padding: 9px 11px;
    }

    textarea {
        height: 51px;
        padding: 9px 11px;
    }

    .submit {
        height: 41px;
        margin-top: 12px;
    }

    .login-note {
        margin-top: 11px;
    }
}

/* TABLET */

@media (max-width: 900px) {
    main {
        grid-template-columns: minmax(0, .72fr) minmax(0, 1.28fr);
        padding-left: 3%;
        padding-right: 3%;
        gap: 18px;
    }

    .intro h1 {
        font-size: 34px;
    }

    .card {
        padding: 20px;
    }

    .benefits {
        gap: 12px;
    }
}

/* MOBILE: STACK AND ALLOW NATURAL SCROLLING */

@media (max-width: 760px) {
    header {
        height: 60px;
        padding: 0 16px;
    }

    .brand {
        font-size: 23px;
    }

    .header-right > span {
        display: none;
    }

    .login-link {
        padding: 8px 14px;
    }

    main {
        min-height: calc(100vh - 60px);
        display: flex;
        flex-direction: column;
        align-items: stretch;
        padding: 20px 14px 28px;
        gap: 20px;
    }

    .intro {
        max-width: 650px;
        width: 100%;
        margin: 0 auto;
    }

    .eyebrow {
        margin-bottom: 10px;
    }

    .intro h1 {
        font-size: clamp(30px, 6vw, 40px);
        margin-bottom: 9px;
    }

    .intro > p {
        max-width: 600px;
        font-size: 13px;
    }

    .benefits {
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 8px;
        margin-top: 15px;
    }

    .benefit {
        align-items: flex-start;
        gap: 7px;
        padding: 10px;
        border: 1px solid #e0eaf8;
        border-radius: 11px;
        background: rgba(255,255,255,.7);
    }

    .benefit-icon {
        width: 32px;
        height: 32px;
        border-radius: 9px;
        font-size: 15px;
    }

    .benefit h3 {
        font-size: 11px;
    }

    .benefit p {
        font-size: 10px;
        line-height: 1.4;
    }

    .card {
        width: 100%;
        max-width: 600px;
        margin: 0 auto;
        padding: 22px 18px;
    }

    .form-grid {
        gap: 14px 12px;
    }
}

/* SMALL PHONES */

@media (max-width: 430px) {
    .brand {
        font-size: 21px;
    }

    main {
        padding: 17px 11px 24px;
    }

    .benefits {
        grid-template-columns: 1fr;
    }

    .benefit {
        align-items: center;
        padding: 8px 10px;
    }

    .card {
        padding: 20px 15px;
        border-radius: 15px;
    }

    .form-grid {
        grid-template-columns: minmax(0, 1fr);
        gap: 13px;
    }

    .field.full {
        grid-column: auto;
    }

    input {
        height: 44px;
        font-size: 16px;
    }

    textarea {
        height: 65px;
        font-size: 16px;
    }

    .card-heading p {
        line-height: 1.5;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        transition: none !important;
    }
}
</style>
</head>

<body>

<header>
    <a class="brand"
       href="<%= request.getContextPath() %>/login.jsp">
        Smart<span>Fix</span>
    </a>

    <div class="header-right">
        <span>Already have an account?</span>
        <a class="login-link"
           href="<%= request.getContextPath() %>/login.jsp">
            Login &#8594;
        </a>
    </div>
</header>

<main>

    <section class="intro">
        <div class="eyebrow">WELCOME TO SMARTFIX</div>

        <h1>Better Services,<br><span>Happier You.</span></h1>

        <p>
            Create your account to report issues, follow service requests,
            and stay updated on the progress — all in one place.
        </p>

        <div class="benefits">
            <div class="benefit">
                <div class="benefit-icon">&#9889;</div>
                <div>
                    <h3>Fast &amp; Easy</h3>
                    <p>Report issues in minutes</p>
                </div>
            </div>

            <div class="benefit">
                <div class="benefit-icon">&#10003;</div>
                <div>
                    <h3>Track Progress</h3>
                    <p>Stay updated on requests</p>
                </div>
            </div>

            <div class="benefit">
                <div class="benefit-icon">&#9829;</div>
                <div>
                    <h3>Trusted by Many</h3>
                    <p>Students, tenants &amp; staff</p>
                </div>
            </div>
        </div>
    </section>

    <section class="card">
        <div class="card-heading">
            <div class="avatar">&#128100;</div>
            <h2>Create Your Account</h2>
            <p>Fill in your details to get started with SmartFix.</p>
        </div>

        <% if (!error.trim().isEmpty()) { %>
        <div class="error" id="registerError" role="alert">
            <%= escapeRegister(error) %>
            <button type="button"
                    class="dismiss"
                    aria-label="Dismiss error"
                    onclick="document.getElementById('registerError').hidden=true">
                &times;
            </button>
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/register"
              method="post">

            <div class="form-grid">

                <div class="field">
                    <label for="name">Full Name <span class="required">*</span></label>
                    <input type="text" id="name" name="name"
                           placeholder="Enter your full name"
                           autocomplete="name" maxlength="100" required>
                </div>

                <div class="field">
                    <label for="email">Email Address <span class="required">*</span></label>
                    <input type="email" id="email" name="email"
                           placeholder="you@example.com"
                           autocomplete="email" maxlength="150" required>
                </div>

                <div class="field">
                    <label for="phone">Phone Number</label>
                    <input type="tel" id="phone" name="phone"
                           placeholder="Enter phone number"
                           autocomplete="tel" maxlength="20">
                </div>

                <div class="field">
                    <label for="roomNumber">Room Number</label>
                    <input type="text" id="roomNumber" name="roomNumber"
                           placeholder="e.g. A-204" maxlength="30">
                </div>

                <div class="field full">
                    <label for="password">Password <span class="required">*</span></label>
                    <div class="password-wrap">
                        <input type="password" id="password" name="password"
                               placeholder="Create a password"
                               class="password-input"
                               autocomplete="new-password"
                               minlength="8" required>
                        <button type="button"
                                class="show-password"
                                id="togglePassword"
                                aria-pressed="false">Show</button>
                    </div>
                    <p class="hint">Use at least 8 characters.</p>
                </div>

                <div class="field full">
                    <label for="address">Address <span class="required">*</span></label>
                    <textarea id="address" name="address"
                              placeholder="Enter your address"
                              autocomplete="street-address"
                              maxlength="500" required></textarea>
                </div>

            </div>

            <button class="submit" type="submit">Create Account &#8594;</button>
        </form>

        <p class="login-note">
            Already registered?
            <a href="<%= request.getContextPath() %>/login.jsp">Sign in here</a>
        </p>
    </section>

</main>

<script>
const password = document.getElementById("password");
const toggle = document.getElementById("togglePassword");

toggle.addEventListener("click", function () {
    const reveal = password.type === "password";
    password.type = reveal ? "text" : "password";
    toggle.textContent = reveal ? "Hide" : "Show";
    toggle.setAttribute("aria-pressed", String(reveal));
});
</script>

</body>
</html>

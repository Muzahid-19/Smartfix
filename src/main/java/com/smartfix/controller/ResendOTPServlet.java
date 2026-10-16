package com.smartfix.controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Timestamp;

import com.smartfix.dao.PasswordResetOTPDAO;
import com.smartfix.dao.impl.PasswordResetOTPDAOImpl;
import com.smartfix.modelcom.PasswordResetOTP;
import com.smartfix.utli.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/resend-otp")
public class ResendOTPServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PasswordResetOTPDAO otpDAO;

    // Resend allowed once every 60 seconds
    private static final long RESEND_COOLDOWN = 60 * 1000;


    @Override
    public void init() throws ServletException {

        otpDAO = new PasswordResetOTPDAOImpl();
    }


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {


        /* =========================
           GET SESSION
        ========================= */

        HttpSession session =
                request.getSession(false);


        if (session == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/forgot-password.jsp"
                + "?error=Please start the password reset process again."
            );

            return;
        }


        /* =========================
           GET EMAIL
        ========================= */

        String email =
                (String) session.getAttribute(
                    "forgotPasswordEmail"
                );


        String accountType =
                (String) session.getAttribute(
                    "forgotPasswordAccountType"
                );


        if (email == null
                || email.trim().isEmpty()
                || accountType == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/forgot-password.jsp"
                + "?error=Session expired. Please try again."
            );

            return;
        }


        /* =========================
           CHECK COOLDOWN
        ========================= */

        Long lastResendTime =
                (Long) session.getAttribute(
                    "lastResendTime"
                );


        long currentTime =
                System.currentTimeMillis();


        if (lastResendTime != null) {

            long timePassed =
                    currentTime - lastResendTime;


            if (timePassed < RESEND_COOLDOWN) {

                long remainingSeconds =
                        (RESEND_COOLDOWN - timePassed)
                        / 1000;


                response.sendRedirect(
                    request.getContextPath()
                    + "/verify-otp.jsp"
                    + "?error=Please wait "
                    + remainingSeconds
                    + " seconds before requesting a new OTP."
                );

                return;
            }
        }


        /* =========================
           GENERATE NEW OTP
        ========================= */

        SecureRandom random =
                new SecureRandom();


        String otp =
                String.format(
                    "%06d",
                    random.nextInt(1_000_000)
                );


        /* =========================
           OTP EXPIRES IN 10 MINUTES
        ========================= */

        Timestamp expiresAt =
                new Timestamp(
                    currentTime
                    + (10 * 60 * 1000)
                );


        /* =========================
           DELETE OLD OTP
        ========================= */

        otpDAO.deleteOTPByEmail(email);


        /* =========================
           CREATE NEW OTP
        ========================= */

        PasswordResetOTP passwordResetOTP =
                new PasswordResetOTP(
                    email,
                    otp,
                    accountType,
                    expiresAt
                );


        /* =========================
           SAVE NEW OTP
        ========================= */

        boolean otpSaved =
                otpDAO.saveOTP(passwordResetOTP);


        if (!otpSaved) {

            response.sendRedirect(
                request.getContextPath()
                + "/verify-otp.jsp"
                + "?error=Unable to generate new OTP. Please try again."
            );

            return;
        }


        /* =========================
           SEND EMAIL
        ========================= */

        boolean emailSent =
                EmailUtil.sendOTP(
                    email,
                    otp
                );


        if (!emailSent) {

            otpDAO.deleteOTPByEmail(email);

            response.sendRedirect(
                request.getContextPath()
                + "/verify-otp.jsp"
                + "?error=Unable to send OTP. Please try again."
            );

            return;
        }


        /* =========================
           UPDATE SESSION
        ========================= */

        session.setAttribute(
            "otpSent",
            true
        );


        session.setAttribute(
            "passwordResetVerified",
            false
        );


        session.setAttribute(
            "otpExpiresAt",
            expiresAt.getTime()
        );


        // Store time of successful resend
        session.setAttribute(
            "lastResendTime",
            currentTime
        );


        /* =========================
           REDIRECT
        ========================= */

        response.sendRedirect(
            request.getContextPath()
            + "/verify-otp.jsp"
            + "?message=New OTP sent successfully."
        );
    }
}
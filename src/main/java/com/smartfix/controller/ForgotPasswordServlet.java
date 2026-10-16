package com.smartfix.controller;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Timestamp;

import com.smartfix.dao.PasswordResetOTPDAO;
import com.smartfix.dao.StaffDAO;
import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.PasswordResetOTPDAOImpl;
import com.smartfix.dao.impl.StaffDAOImpl;
import com.smartfix.dao.impl.UserDAOImpl;
import com.smartfix.modelcom.PasswordResetOTP;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;
import com.smartfix.utli.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO;
    private StaffDAO staffDAO;
    private PasswordResetOTPDAO otpDAO;

    @Override
    public void init() throws ServletException {

        userDAO = new UserDAOImpl();

        staffDAO = new StaffDAOImpl();

        otpDAO = new PasswordResetOTPDAOImpl();
    }


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {


        String email = request.getParameter("email");


        /* =========================
           CHECK EMAIL
        ========================= */

        if (email == null || email.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath()
                + "/forgot-password.jsp?error=Please enter your email address."
            );

            return;
        }


        email = email.trim();


        /* =========================
           FIND ACCOUNT
        ========================= */

        User user = userDAO.getUserByEmail(email);

        String accountType = null;


        if (user != null) {

            accountType = "USER";

        } else {

            Staff staff = staffDAO.getStaffByEmail(email);

            if (staff != null) {

                accountType = "STAFF";
            }
        }


        /* =========================
           EMAIL NOT FOUND
        ========================= */

        if (accountType == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/forgot-password.jsp?error=Email address not found."
            );

            return;
        }


        /* =========================
           GENERATE OTP
        ========================= */

        SecureRandom random =
            new SecureRandom();


        String otp =
            String.format(
                "%06d",
                random.nextInt(1_000_000)
            );


        /* =========================
           OTP EXPIRY
           10 MINUTES
        ========================= */

        Timestamp expiresAt =
            new Timestamp(
                System.currentTimeMillis()
                + (10 * 60 * 1000)
            );


        /* =========================
           DELETE OLD OTP
        ========================= */

        otpDAO.deleteOTPByEmail(email);


        /* =========================
           CREATE OTP OBJECT
        ========================= */

        PasswordResetOTP passwordResetOTP =
            new PasswordResetOTP(
                email,
                otp,
                accountType,
                expiresAt
            );


        /* =========================
           SAVE OTP
        ========================= */

        boolean otpSaved =
            otpDAO.saveOTP(passwordResetOTP);


        if (!otpSaved) {

            response.sendRedirect(
                request.getContextPath()
                + "/forgot-password.jsp?error=Unable to generate OTP. Please try again."
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
                + "/forgot-password.jsp?error=Unable to send OTP. Please try again."
            );

            return;
        }


        /* =========================
           SESSION
        ========================= */

        HttpSession session =
            request.getSession();


        session.setAttribute(
            "forgotPasswordEmail",
            email
        );


        session.setAttribute(
            "forgotPasswordAccountType",
            accountType
        );


        session.setAttribute(
            "otpSent",
            true
        );


        session.setAttribute(
            "passwordResetVerified",
            false
        );


        /*
         * Store OTP expiry time
         * for the countdown timer.
         */
        session.setAttribute(
            "otpExpiresAt",
            expiresAt.getTime()
        );


        /* =========================
           GO TO VERIFY PAGE
        ========================= */

        response.sendRedirect(
            request.getContextPath()
            + "/verify-otp.jsp"
        );
    }
}
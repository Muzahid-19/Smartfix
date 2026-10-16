
package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.dao.PasswordResetOTPDAO;
import com.smartfix.dao.impl.PasswordResetOTPDAOImpl;
import com.smartfix.modelcom.PasswordResetOTP;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/verify-otp")
public class VerifyOTPServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PasswordResetOTPDAO otpDAO;

    @Override
    public void init() throws ServletException {
        otpDAO = new PasswordResetOTPDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Get existing session
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(contextPath
                + "/forgot-password.jsp?error=Please+start+the+password+reset+process+again.");
            return;
        }

        // 2. Get email and account type
        String email = (String) session.getAttribute(
            "forgotPasswordEmail"
        );

        String accountType = (String) session.getAttribute(
            "forgotPasswordAccountType"
        );

        if (email == null || email.trim().isEmpty()
                || accountType == null
                || (!"USER".equalsIgnoreCase(accountType)
                    && !"ADMIN".equalsIgnoreCase(accountType)
                    && !"STAFF".equalsIgnoreCase(accountType))) {

            response.sendRedirect(contextPath
                + "/forgot-password.jsp?error=Session+expired.+Please+try+again.");
            return;
        }

        email = email.trim();

        // 3. Check whether OTP was sent
        Boolean otpSent = (Boolean) session.getAttribute("otpSent");

        if (!Boolean.TRUE.equals(otpSent)) {
            response.sendRedirect(contextPath
                + "/forgot-password.jsp?error=Please+request+an+OTP+first.");
            return;
        }

        // 4. Check session expiry
        Long otpExpiresAt = (Long) session.getAttribute("otpExpiresAt");

        if (otpExpiresAt == null
                || System.currentTimeMillis() >= otpExpiresAt) {

            session.setAttribute("passwordResetVerified", false);

            response.sendRedirect(contextPath
                + "/verify-otp.jsp?error=OTP+has+expired.+Please+request+a+new+OTP.");
            return;
        }

        // 5. Get OTP from form
        String otp = request.getParameter("otp");

        if (otp == null || !otp.matches("\\d{6}")) {
            response.sendRedirect(contextPath
                + "/verify-otp.jsp?error=Please+enter+a+valid+6-digit+OTP.");
            return;
        }

        // 6. Retrieve latest OTP from database
        PasswordResetOTP resetOTP =
            otpDAO.getLatestOTPByEmail(email);

        if (resetOTP == null) {
            response.sendRedirect(contextPath
                + "/verify-otp.jsp?error=OTP+not+found.+Please+request+a+new+OTP.");
            return;
        }

        // 7. Check OTP account type
        if (resetOTP.getAccountType() == null
                || !accountType.equalsIgnoreCase(
                    resetOTP.getAccountType())) {

            response.sendRedirect(contextPath
                + "/verify-otp.jsp?error=Invalid+OTP+request.");
            return;
        }

        // 8. Check database expiry
        if (resetOTP.getExpiresAt() == null
                || System.currentTimeMillis()
                    >= resetOTP.getExpiresAt().getTime()) {

            session.setAttribute("passwordResetVerified", false);

            response.sendRedirect(contextPath
                + "/verify-otp.jsp?error=OTP+has+expired.+Please+request+a+new+OTP.");
            return;
        }

        // 9. Verify OTP in database
        boolean validOTP = otpDAO.verifyOTP(email, otp);

        if (!validOTP) {
            response.sendRedirect(contextPath
                + "/verify-otp.jsp?error=Invalid+or+expired+OTP.");
            return;
        }

        // 10. Mark OTP as verified in database
        boolean marked = otpDAO.markOTPAsVerified(
            resetOTP.getOtpId()
        );

        if (!marked) {
            response.sendRedirect(contextPath
                + "/verify-otp.jsp?error=Unable+to+verify+OTP.+Please+try+again.");
            return;
        }

        // 11. Mark reset flow as verified in session
        session.setAttribute("passwordResetVerified", true);

        // Remove resend cooldown
        session.removeAttribute("lastResendTime");

        // 12. Redirect to reset password page
        response.sendRedirect(contextPath + "/reset-password.jsp");
    }
}

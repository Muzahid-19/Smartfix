
package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.dao.PasswordResetOTPDAO;
import com.smartfix.dao.StaffDAO;
import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.PasswordResetOTPDAOImpl;
import com.smartfix.dao.impl.StaffDAOImpl;
import com.smartfix.dao.impl.UserDAOImpl;
import com.smartfix.utli.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

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

        String contextPath = request.getContextPath();

        // 1. Check existing session
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(contextPath
                + "/forgot-password.jsp?error=Please+start+the+password+reset+process+again.");
            return;
        }

        // 2. Check OTP verification
        Boolean verified = (Boolean) session.getAttribute(
            "passwordResetVerified"
        );

        if (!Boolean.TRUE.equals(verified)) {
            response.sendRedirect(contextPath
                + "/forgot-password.jsp?error=Please+verify+OTP+first.");
            return;
        }

        // 3. Get email and account type from session
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

        // 4. Get passwords from form
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // 5. Validate empty fields
        if (password == null || password.trim().isEmpty()
                || confirmPassword == null
                || confirmPassword.trim().isEmpty()) {

            response.sendRedirect(contextPath
                + "/reset-password.jsp?error=Please+enter+both+passwords.");
            return;
        }

        // 6. Validate password length
        if (password.length() < 6) {
            response.sendRedirect(contextPath
                + "/reset-password.jsp?error=Password+must+be+at+least+6+characters.");
            return;
        }

        // 7. Validate password confirmation
        if (!password.equals(confirmPassword)) {
            response.sendRedirect(contextPath
                + "/reset-password.jsp?error=Passwords+do+not+match.");
            return;
        }

        // 8. Hash password using BCrypt
        final String hashedPassword;

        try {
            hashedPassword = PasswordUtil.hashPassword(password);
        } catch (RuntimeException e) {
            response.sendRedirect(contextPath
                + "/reset-password.jsp?error=Unable+to+process+password.+Please+try+again.");
            return;
        }

        // 9. Update password in the appropriate table
        boolean updated;

        if ("STAFF".equalsIgnoreCase(accountType)) {
            updated = staffDAO.updatePasswordByEmail(
                email,
                hashedPassword
            );
        } else {
            // USER or ADMIN
            updated = userDAO.updatePasswordByEmail(
                email,
                hashedPassword
            );
        }

        // 10. Handle update result
        if (updated) {

            // Delete the used OTP
            otpDAO.deleteOTPByEmail(email);

            // Clear password-reset session attributes
            session.removeAttribute("forgotPasswordEmail");
            session.removeAttribute("forgotPasswordAccountType");
            session.removeAttribute("otpSent");
            session.removeAttribute("otpExpiresAt");
            session.removeAttribute("lastResendTime");
            session.removeAttribute("passwordResetVerified");

            response.sendRedirect(contextPath
                + "/login.jsp?message=Password+reset+successfully.+Please+login.");
            return;
        }

        response.sendRedirect(contextPath
            + "/reset-password.jsp?error=Unable+to+reset+password.+Please+try+again.");
    }
}

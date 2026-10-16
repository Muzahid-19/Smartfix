package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.User;
import com.smartfix.service.UserService;
import com.smartfix.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/change-password")
public class AdminChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {

        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
            );

            return;
        }

        User admin =
                (User) session.getAttribute("user");

        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                admin.getRole().trim()
            )) {

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
            );

            return;
        }

        request.getRequestDispatcher(
            "/admin/change-password.jsp"
        ).forward(
            request,
            response
        );
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
            );

            return;
        }

        User admin =
                (User) session.getAttribute("user");

        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                admin.getRole().trim()
            )) {

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
            );

            return;
        }

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (currentPassword != null) {
            currentPassword =
                    currentPassword.trim();
        }

        if (newPassword != null) {
            newPassword =
                    newPassword.trim();
        }

        if (confirmPassword != null) {
            confirmPassword =
                    confirmPassword.trim();
        }

        /*
         * Check empty fields
         */
        if (currentPassword == null ||
            currentPassword.isEmpty() ||
            newPassword == null ||
            newPassword.isEmpty() ||
            confirmPassword == null ||
            confirmPassword.isEmpty()) {

            request.setAttribute(
                "error",
                "All password fields are required."
            );

            request.getRequestDispatcher(
                "/admin/change-password.jsp"
            ).forward(
                request,
                response
            );

            return;
        }

        /*
         * Check current password
         */
        User verifiedAdmin =
                userService.getUserByEmailAndPassword(
                    admin.getEmail(),
                    currentPassword
                );

        if (verifiedAdmin == null) {

            request.setAttribute(
                "error",
                "Current password is incorrect."
            );

            request.getRequestDispatcher(
                "/admin/change-password.jsp"
            ).forward(
                request,
                response
            );

            return;
        }

        /*
         * Check new password
         */
        if (newPassword.length() < 6) {

            request.setAttribute(
                "error",
                "New password must contain at least 6 characters."
            );

            request.getRequestDispatcher(
                "/admin/change-password.jsp"
            ).forward(
                request,
                response
            );

            return;
        }

        /*
         * Check password confirmation
         */
        if (!newPassword.equals(confirmPassword)) {

            request.setAttribute(
                "error",
                "New password and confirm password do not match."
            );

            request.getRequestDispatcher(
                "/admin/change-password.jsp"
            ).forward(
                request,
                response
            );

            return;
        }

        /*
         * Create updated admin object
         */
        User updatedAdmin =
                new User();

        updatedAdmin.setUserId(
            admin.getUserId()
        );

        updatedAdmin.setName(
            admin.getName()
        );

        updatedAdmin.setEmail(
            admin.getEmail()
        );

        updatedAdmin.setPassword(
            newPassword
        );

        updatedAdmin.setPhone(
            admin.getPhone()
        );

        updatedAdmin.setAddress(
            admin.getAddress()
        );

        updatedAdmin.setRole(
            admin.getRole()
        );

        /*
         * Update password
         */
        boolean updated =
                userService.updateUser(
                    updatedAdmin
                );

        if (updated) {

            /*
             * Update session with new password
             */
            session.setAttribute(
                "user",
                updatedAdmin
            );

            session.setAttribute(
                "userId",
                updatedAdmin.getUserId()
            );

            session.setAttribute(
                "role",
                updatedAdmin.getRole()
            );

            response.sendRedirect(
                request.getContextPath()
                + "/admin/profile?passwordChanged=true"
            );

            return;
        }

        request.setAttribute(
            "error",
            "Unable to change password. Please try again."
        );

        request.getRequestDispatcher(
            "/admin/change-password.jsp"
        ).forward(
            request,
            response
        );
    }
}
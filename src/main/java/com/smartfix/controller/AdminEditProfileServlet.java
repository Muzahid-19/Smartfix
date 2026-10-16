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

@WebServlet("/admin/edit-profile")
public class AdminEditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    // =====================================================
    // OPEN EDIT PROFILE PAGE
    // =====================================================

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User admin =
                (User) session.getAttribute("user");

        // Check admin login
        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                admin.getRole().trim()
            )) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Get latest data from database
        User latestAdmin =
                userService.getUserById(
                    admin.getUserId()
                );

        if (latestAdmin != null) {
            admin = latestAdmin;
        }

        request.setAttribute(
            "admin",
            admin
        );

        request.getRequestDispatcher(
            "/admin/edit-profile.jsp"
        ).forward(
            request,
            response
        );
    }

    // =====================================================
    // SAVE EDITED PROFILE
    // =====================================================

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User sessionAdmin =
                (User) session.getAttribute("user");

        // Check admin login
        if (sessionAdmin == null ||
            sessionAdmin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                sessionAdmin.getRole().trim()
            )) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // =================================================
        // GET FORM DATA
        // =================================================

        String name =
                request.getParameter("name");

        String email =
                request.getParameter("email");

        String phone =
                request.getParameter("phone");

        String address =
                request.getParameter("address");

        // =================================================
        // TRIM DATA
        // =================================================

        if (name != null) {
            name = name.trim();
        }

        if (email != null) {
            email = email.trim();
        }

        if (phone != null) {
            phone = phone.trim();
        }

        if (address != null) {
            address = address.trim();
        }

        // =================================================
        // VALIDATION
        // =================================================

        if (name == null ||
            name.isEmpty() ||
            email == null ||
            email.isEmpty()) {

            request.setAttribute(
                "error",
                "Name and email are required."
            );

            request.setAttribute(
                "admin",
                sessionAdmin
            );

            request.getRequestDispatcher(
                "/admin/edit-profile.jsp"
            ).forward(
                request,
                response
            );

            return;
        }

        // =================================================
        // CREATE UPDATED ADMIN
        // =================================================

        User updatedAdmin =
                new User();

        updatedAdmin.setUserId(
            sessionAdmin.getUserId()
        );

        updatedAdmin.setName(
            name
        );

        updatedAdmin.setEmail(
            email
        );

        updatedAdmin.setPhone(
            phone
        );

        updatedAdmin.setAddress(
            address
        );

        // Keep existing password
        updatedAdmin.setPassword(
            sessionAdmin.getPassword()
        );

        // Keep ADMIN role
        updatedAdmin.setRole(
            sessionAdmin.getRole()
        );

        // =================================================
        // UPDATE DATABASE
        // =================================================

        boolean updated = false;

        try {

            updated =
                userService.updateUser(
                    updatedAdmin
                );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                "error",
                "Database error while updating profile."
            );

            request.setAttribute(
                "admin",
                sessionAdmin
            );

            request.getRequestDispatcher(
                "/admin/edit-profile.jsp"
            ).forward(
                request,
                response
            );

            return;
        }

        // =================================================
        // SUCCESS
        // =================================================

        if (updated) {

            // Update session with latest information
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

            // Go through AdminProfileServlet
            response.sendRedirect(
                request.getContextPath()
                + "/admin/profile"
            );

            return;
        }

        // =================================================
        // UPDATE FAILED
        // =================================================

        request.setAttribute(
            "error",
            "Unable to update profile. Please try again."
        );

        request.setAttribute(
            "admin",
            sessionAdmin
        );

        request.getRequestDispatcher(
            "/admin/edit-profile.jsp"
        ).forward(
            request,
            response
        );
    }
}
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

@WebServlet("/user/change-password")
public class UserChangePasswordServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null ||
            user.getRole() == null ||
            !"USER".equalsIgnoreCase(user.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.getRequestDispatcher(
            "/user/change-password.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null ||
            user.getRole() == null ||
            !"USER".equalsIgnoreCase(user.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
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
            currentPassword = currentPassword.trim();
        }

        if (newPassword != null) {
            newPassword = newPassword.trim();
        }

        if (confirmPassword != null) {
            confirmPassword = confirmPassword.trim();
        }

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
                "/user/change-password.jsp"
            ).forward(request, response);

            return;
        }

        User verifiedUser =
                userService.getUserByEmailAndPassword(
                    user.getEmail(),
                    currentPassword
                );

        if (verifiedUser == null) {

            request.setAttribute(
                "error",
                "Current password is incorrect."
            );

            request.getRequestDispatcher(
                "/user/change-password.jsp"
            ).forward(request, response);

            return;
        }

        if (newPassword.length() < 6) {

            request.setAttribute(
                "error",
                "New password must contain at least 6 characters."
            );

            request.getRequestDispatcher(
                "/user/change-password.jsp"
            ).forward(request, response);

            return;
        }

        if (!newPassword.equals(confirmPassword)) {

            request.setAttribute(
                "error",
                "New password and confirm password do not match."
            );

            request.getRequestDispatcher(
                "/user/change-password.jsp"
            ).forward(request, response);

            return;
        }

        if (newPassword.equals(currentPassword)) {

            request.setAttribute(
                "error",
                "New password must be different from current password."
            );

            request.getRequestDispatcher(
                "/user/change-password.jsp"
            ).forward(request, response);

            return;
        }

        User updatedUser = new User();

        updatedUser.setUserId(user.getUserId());
        updatedUser.setName(user.getName());
        updatedUser.setEmail(user.getEmail());
        updatedUser.setPassword(newPassword);
        updatedUser.setPhone(user.getPhone());
        updatedUser.setAddress(user.getAddress());
        updatedUser.setRole(user.getRole());

        boolean updated =
                userService.updateUser(updatedUser);

        if (updated) {

            session.setAttribute("user", updatedUser);
            session.setAttribute(
                "userId",
                updatedUser.getUserId()
            );
            session.setAttribute(
                "role",
                updatedUser.getRole()
            );

            response.sendRedirect(
                request.getContextPath()
                + "/user/profile.jsp?passwordChanged=true"
            );

            return;
        }

        request.setAttribute(
            "error",
            "Unable to change password. Please try again."
        );

        request.getRequestDispatcher(
            "/user/change-password.jsp"
        ).forward(request, response);
    }
}
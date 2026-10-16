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

@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check session
        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Get logged-in user
        User admin = (User) session.getAttribute("user");

        // Check admin role
        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Get latest admin data from database
        User latestAdmin =
                userService.getUserById(admin.getUserId());

        if (latestAdmin != null) {

            // Keep session data updated
            session.setAttribute("user", latestAdmin);

            request.setAttribute(
                "admin",
                latestAdmin
            );

        } else {

            request.setAttribute(
                "admin",
                admin
            );
        }

        // Open admin profile page
        request.getRequestDispatcher(
            "/admin/profile.jsp"
        ).forward(request, response);
    }
}
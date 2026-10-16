package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.modelcom.User;
import com.smartfix.service.UserService;
import com.smartfix.service.impl.UserServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/users")
public class AdminUsersServlet extends HttpServlet {

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

        // Check admin
        User admin = (User) session.getAttribute("user");

        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // Get all users
        List<User> users = userService.getAllUsers();

        // Debug
        System.out.println("================================");
        System.out.println("ADMIN USERS PAGE");
        System.out.println("TOTAL USERS: " +
                (users == null ? "NULL" : users.size()));
        System.out.println("================================");

        // Send users to JSP
        request.setAttribute("users", users);

        // Open JSP
        request.getRequestDispatcher(
            "/admin/users.jsp"
        ).forward(request, response);
    }
}
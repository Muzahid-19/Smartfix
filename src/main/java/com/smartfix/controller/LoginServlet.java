
package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;
import com.smartfix.service.StaffService;
import com.smartfix.service.UserService;
import com.smartfix.service.impl.StaffServiceImpl;
import com.smartfix.service.impl.UserServiceImpl;
import com.smartfix.utli.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;
    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
        staffService = new StaffServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {
            redirectToLogin(request, response);
            return;
        }

        // 1. Check user/admin account by email
        User user = userService.loginUser(email.trim(), password);

        if (user != null
                && PasswordUtil.checkPassword(
                        password, user.getPassword())) {

            HttpSession session = request.getSession();

            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());

            if ("ADMIN".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(
                    request.getContextPath() + "/admin/dashboard"
                );
            } else {
                response.sendRedirect(
                    request.getContextPath() + "/user/dashboard.jsp"
                );
            }

            return;
        }

        // 2. Check staff account
        Staff staff = staffService.loginStaff(email.trim(), password);

        if (staff != null
                && PasswordUtil.checkPassword(
                        password, staff.getPassword())) {

            HttpSession session = request.getSession();

            session.setAttribute("staff", staff);
            session.setAttribute("staffId", staff.getStaffId());
            session.setAttribute("role", "STAFF");

            response.sendRedirect(
                request.getContextPath() + "/staff/dashboard.jsp"
            );

            return;
        }

        // 3. Login failed
        redirectToLogin(request, response);
    }

    private void redirectToLogin(HttpServletRequest request,
                                 HttpServletResponse response)
            throws IOException {

        response.sendRedirect(
            request.getContextPath()
            + "/login.jsp?error=Invalid%20email%20or%20password"
        );
    }
}

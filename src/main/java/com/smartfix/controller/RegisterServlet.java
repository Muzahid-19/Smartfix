
package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.User;
import com.smartfix.service.UserService;
import com.smartfix.service.impl.UserServiceImpl;
import com.smartfix.utli.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Get data from registration form
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roomNumber = request.getParameter("roomNumber");

        // Validate password input
        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect(
                request.getContextPath()
                + "/register.jsp?error=Password%20is%20required"
            );
            return;
        }

        // Hash the password before saving
        String hashedPassword = PasswordUtil.hashPassword(password);

        // Create User object
        User user = new User();

        user.setName(name);
        user.setEmail(email);
        user.setPassword(hashedPassword);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRoomNumber(roomNumber);
        user.setRole("USER");

        // Save user
        boolean result = userService.registerUser(user);

        if (result) {
            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp?message=Registration%20successful"
            );
        } else {
            response.sendRedirect(
                request.getContextPath()
                + "/register.jsp?error=Registration%20failed"
            );
        }
    }
}

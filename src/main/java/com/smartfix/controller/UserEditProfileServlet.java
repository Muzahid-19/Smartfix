
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

@WebServlet("/user/edit-profile")
public class UserEditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserServiceImpl();
    }

    /* =====================================================
       OPEN EDIT PROFILE PAGE
       ===================================================== */

    @Override
    protected void doGet(HttpServletRequest request,
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

        if (user == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.setAttribute("user", user);

        request.getRequestDispatcher(
            "/user/edit-profile.jsp"
        ).forward(request, response);
    }

    /* =====================================================
       SAVE EDITED PROFILE
       ===================================================== */

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User sessionUser =
                (User) session.getAttribute("user");

        if (sessionUser == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        /* ================= GET FORM DATA ================= */

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String roomNumber = request.getParameter("roomNumber");

        /* ================= TRIM DATA ================= */

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

        if (roomNumber != null) {
            roomNumber = roomNumber.trim();
        }

        /* ================= VALIDATION ================= */

        if (name == null || name.isEmpty()
                || email == null || email.isEmpty()) {

            request.setAttribute(
                "error",
                "Name and email are required."
            );

            request.setAttribute("user", sessionUser);

            request.getRequestDispatcher(
                "/user/edit-profile.jsp"
            ).forward(request, response);

            return;
        }

        /* ================= CREATE UPDATED USER ================= */

        User updatedUser = new User();

        updatedUser.setUserId(sessionUser.getUserId());
        updatedUser.setName(name);
        updatedUser.setEmail(email);
        updatedUser.setPhone(phone);
        updatedUser.setAddress(address);

        // NEW: ROOM NUMBER
        updatedUser.setRoomNumber(roomNumber);

        // Keep existing password
        updatedUser.setPassword(sessionUser.getPassword());

        // Keep existing role
        updatedUser.setRole(sessionUser.getRole());

        /* ================= UPDATE DATABASE ================= */

        boolean updated = userService.updateUser(updatedUser);

        /* ================= SUCCESS ================= */

        if (updated) {

            session.setAttribute("user", updatedUser);
            session.setAttribute("userId", updatedUser.getUserId());
            session.setAttribute("role", updatedUser.getRole());

            response.sendRedirect(
                request.getContextPath() + "/user/profile.jsp"
            );

            return;
        }

        /* ================= UPDATE FAILED ================= */

        request.setAttribute(
            "error",
            "Unable to update profile. Please try again."
        );

        request.setAttribute("user", sessionUser);

        request.getRequestDispatcher(
            "/user/edit-profile.jsp"
        ).forward(request, response);
    }
}

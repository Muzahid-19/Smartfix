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

@WebServlet("/admin/delete-user")
public class AdminDeleteUserServlet extends HttpServlet {

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

        // =====================================================
        // SESSION CHECK
        // =====================================================

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
            );

            return;
        }


        // =====================================================
        // ADMIN CHECK
        // =====================================================

        User admin =
                (User) session.getAttribute("user");

        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                admin.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
            );

            return;
        }


        // =====================================================
        // GET USER ID
        // =====================================================

        String idParam =
                request.getParameter("userId");

        if (idParam == null ||
            idParam.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath()
                + "/admin/users"
            );

            return;
        }


        try {

            int userId =
                    Integer.parseInt(
                        idParam.trim()
                    );


            // =================================================
            // PREVENT ADMIN FROM DELETING THEMSELVES
            // =================================================

            if (userId == admin.getUserId()) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/users?error=self"
                );

                return;
            }


            // =================================================
            // DELETE USER
            // =================================================

            boolean success =
                    userService.deleteUser(
                        userId
                    );


            if (success) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/users?message=deleted"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/users?error=deletefailed"
                );
            }


        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/admin/users?error=invalid"
            );
        }
    }
}
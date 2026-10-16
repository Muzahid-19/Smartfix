package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.User;
import com.smartfix.service.StaffService;
import com.smartfix.service.impl.StaffServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/delete-staff")
public class AdminDeleteStaffServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        staffService = new StaffServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // ================================================
        // SESSION CHECK
        // ================================================

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // ================================================
        // ADMIN CHECK
        // ================================================

        User admin =
                (User) session.getAttribute("user");

        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                admin.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // ================================================
        // STAFF ID
        // ================================================

        String idParam =
                request.getParameter("staffId");

        if (idParam == null ||
            idParam.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath()
                + "/admin/staff"
            );
            return;
        }

        try {

            int staffId =
                    Integer.parseInt(
                        idParam.trim()
                    );

            // ============================================
            // DELETE STAFF
            // ============================================

            boolean success =
                    staffService.deleteStaff(
                        staffId
                    );

            if (success) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/staff?message=deleted"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/staff?error=deletefailed"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/admin/staff?error=invalid"
            );
        }
    }
}
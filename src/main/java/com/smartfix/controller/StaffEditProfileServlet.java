package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Staff;
import com.smartfix.service.StaffService;
import com.smartfix.service.impl.StaffServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/edit-profile")
public class StaffEditProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        staffService = new StaffServiceImpl();
    }

    // =====================================================
    // OPEN EDIT PROFILE PAGE
    // =====================================================

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

        Staff staff =
                (Staff) session.getAttribute("staff");

        if (staff == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.setAttribute(
            "staff",
            staff
        );

        request.getRequestDispatcher(
            "/staff/edit-profile.jsp"
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

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Staff sessionStaff =
                (Staff) session.getAttribute("staff");

        if (sessionStaff == null) {
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

        String specialization =
                request.getParameter("specialization");

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

        if (specialization != null) {
            specialization = specialization.trim();
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
                "staff",
                sessionStaff
            );

            request.getRequestDispatcher(
                "/staff/edit-profile.jsp"
            ).forward(
                request,
                response
            );

            return;
        }

        // =================================================
        // CREATE UPDATED STAFF
        // =================================================

        Staff updatedStaff = new Staff();

        updatedStaff.setStaffId(
            sessionStaff.getStaffId()
        );

        updatedStaff.setName(name);

        updatedStaff.setEmail(email);

        updatedStaff.setPhone(phone);

        updatedStaff.setSpecialization(
            specialization
        );

        // Keep existing password
        updatedStaff.setPassword(
            sessionStaff.getPassword()
        );

        // =================================================
        // UPDATE DATABASE
        // =================================================

        boolean updated = false;

        try {

            updated =
                staffService.updateStaff(
                    updatedStaff
                );

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                "error",
                "Database error while updating profile."
            );

            request.setAttribute(
                "staff",
                sessionStaff
            );

            request.getRequestDispatcher(
                "/staff/edit-profile.jsp"
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

            // Update session
            session.setAttribute(
                "staff",
                updatedStaff
            );

            session.setAttribute(
                "staffId",
                updatedStaff.getStaffId()
            );

            session.setAttribute(
                "role",
                "STAFF"
            );

            /*
             * IMPORTANT:
             * Go through StaffProfileServlet.
             */
            response.sendRedirect(
                request.getContextPath()
                + "/staff/profile"
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
            "staff",
            sessionStaff
        );

        request.getRequestDispatcher(
            "/staff/edit-profile.jsp"
        ).forward(
            request,
            response
        );
    }
}
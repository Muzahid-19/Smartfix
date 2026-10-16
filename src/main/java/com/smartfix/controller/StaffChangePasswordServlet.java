
package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Staff;
import com.smartfix.service.StaffService;
import com.smartfix.service.impl.StaffServiceImpl;
import com.smartfix.utli.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/change-password")
public class StaffChangePasswordServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private StaffService staffService;

    @Override
    public void init() throws ServletException {
        staffService = new StaffServiceImpl();
    }

    // GET - Open change password page
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("staff") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        request.getRequestDispatcher(
            "/staff/change-password.jsp"
        ).forward(request, response);
    }

    // POST - Change password
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            !(session.getAttribute("staff") instanceof Staff)) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Staff staff = (Staff) session.getAttribute("staff");

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        // Validate required fields
        if (currentPassword == null || currentPassword.isEmpty() ||
            newPassword == null || newPassword.isEmpty() ||
            confirmPassword == null || confirmPassword.isEmpty()) {

            request.setAttribute(
                "error", "All password fields are required."
            );
            showChangePasswordPage(request, response);
            return;
        }

        // Do not trim passwords: spaces can be part of a password.

        // Retrieve the latest staff record from the database
        Staff verifiedStaff =
                staffService.getStaffByEmail(staff.getEmail());

        // Verify current password using BCrypt
        if (verifiedStaff == null ||
            verifiedStaff.getPassword() == null ||
            !PasswordUtil.checkPassword(
                currentPassword,
                verifiedStaff.getPassword()
            )) {

            request.setAttribute(
                "error", "Current password is incorrect."
            );
            showChangePasswordPage(request, response);
            return;
        }

        // Validate new password
        if (newPassword.length() < 6) {
            request.setAttribute(
                "error",
                "New password must contain at least 6 characters."
            );
            showChangePasswordPage(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute(
                "error",
                "New password and confirm password do not match."
            );
            showChangePasswordPage(request, response);
            return;
        }

        if (newPassword.equals(currentPassword)) {
            request.setAttribute(
                "error",
                "New password must be different from current password."
            );
            showChangePasswordPage(request, response);
            return;
        }

        // Create updated staff object
        Staff updatedStaff = new Staff();

        updatedStaff.setStaffId(verifiedStaff.getStaffId());
        updatedStaff.setName(verifiedStaff.getName());
        updatedStaff.setEmail(verifiedStaff.getEmail());

        // Hash the new password exactly once
        String hashedPassword;

        try {
            hashedPassword = PasswordUtil.hashPassword(newPassword);
        } catch (RuntimeException e) {
            log("Failed to hash staff password.", e);

            request.setAttribute(
                "error", "Unable to change password. Please try again."
            );
            showChangePasswordPage(request, response);
            return;
        }

        updatedStaff.setPassword(hashedPassword);
        updatedStaff.setPhone(verifiedStaff.getPhone());
        updatedStaff.setSpecialization(
            verifiedStaff.getSpecialization()
        );

        // Update database
        boolean updated = staffService.updateStaff(updatedStaff);

        if (updated) {
            // Store the updated staff details in the session
            session.setAttribute("staff", updatedStaff);
            session.setAttribute("staffId", updatedStaff.getStaffId());
            session.setAttribute("role", "STAFF");

            response.sendRedirect(
                request.getContextPath()
                + "/staff/profile?passwordChanged=true"
            );
            return;
        }

        request.setAttribute(
            "error", "Unable to change password. Please try again."
        );
        showChangePasswordPage(request, response);
    }

    private void showChangePasswordPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
            "/staff/change-password.jsp"
        ).forward(request, response);
    }
}

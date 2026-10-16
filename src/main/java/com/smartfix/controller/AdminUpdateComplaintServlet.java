package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.User;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.impl.ComplaintServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/update-complaint")
public class AdminUpdateComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;

    @Override
    public void init() throws ServletException {
        complaintService = new ComplaintServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // ==============================
        // 1. Check admin session
        // ==============================

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        User admin = (User) session.getAttribute("user");

        if (admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        // ==============================
        // 2. Get form values
        // ==============================

        String complaintIdParam =
                request.getParameter("complaintId");

        String priority =
                request.getParameter("priority");

        String status =
                request.getParameter("status");

        String resolutionNotes =
                request.getParameter("resolutionNotes");

        // ==============================
        // 3. Validate complaint ID
        // ==============================

        if (complaintIdParam == null ||
            complaintIdParam.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath() + "/admin/complaints"
            );
            return;
        }

        try {

            int complaintId =
                    Integer.parseInt(complaintIdParam);

            // ==============================
            // 4. Update priority
            // ==============================

            if (priority != null &&
                !priority.trim().isEmpty()) {

                complaintService.updateComplaintPriority(
                    complaintId,
                    priority
                );
            }

            // ==============================
            // 5. Update status
            // ==============================

            if (status != null &&
                !status.trim().isEmpty()) {

                complaintService.updateComplaintStatus(
                    complaintId,
                    status
                );
            }

            // ==============================
            // 6. Update resolution notes
            // ==============================

            if (resolutionNotes != null) {

                complaintService.addResolutionNotes(
                    complaintId,
                    resolutionNotes
                );
            }

            // ==============================
            // 7. Redirect back to details
            // ==============================

            response.sendRedirect(
                request.getContextPath()
                + "/admin/complaint-details?id="
                + complaintId
                + "&success=updated"
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/admin/complaints"
            );
        }
    }
}
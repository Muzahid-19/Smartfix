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

@WebServlet("/admin/update-status")
public class UpdateComplaintStatusServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;

    @Override
    public void init() throws ServletException {

        complaintService =
            new ComplaintServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
            request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );

            return;
        }

        User admin =
            (User) session.getAttribute("user");

        if (admin == null ||
            !"ADMIN".equalsIgnoreCase(admin.getRole())) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );

            return;
        }

        try {

            int complaintId =
                Integer.parseInt(
                    request.getParameter("complaintId")
                );

            String status =
                request.getParameter("status");

            boolean result =
                complaintService.updateComplaintStatus(
                    complaintId,
                    status
                );

            if (result) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/complaint-details?id="
                    + complaintId
                    + "&success=Status updated successfully"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath()
                    + "/admin/complaint-details?id="
                    + complaintId
                    + "&error=Unable to update status"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath()
                + "/admin/complaints?error=Invalid request"
            );
        }
    }
}
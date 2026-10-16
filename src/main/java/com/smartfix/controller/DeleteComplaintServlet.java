package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.User;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.impl.ComplaintServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/delete-complaint")
public class DeleteComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;


    @Override
    public void init() throws ServletException {

        complaintService =
                new ComplaintServiceImpl();
    }


    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        // Check login
        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        try {

            // Get complaint ID
            String complaintIdParameter =
                    request.getParameter("complaintId");


            if (complaintIdParameter == null ||
                complaintIdParameter.trim().isEmpty()) {

                session.setAttribute(
                        "errorMessage",
                        "Invalid complaint ID."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/myComplaints"
                );

                return;
            }


            int complaintId =
                    Integer.parseInt(
                            complaintIdParameter
                    );


            // Get logged-in user
            User user =
                    (User) session.getAttribute("user");


            int userId =
                    user.getUserId();


            // Get complaint
            Complaint complaint =
                    complaintService.getComplaintById(
                            complaintId
                    );


            // Complaint doesn't exist
            if (complaint == null) {

                session.setAttribute(
                        "errorMessage",
                        "Complaint not found."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/myComplaints"
                );

                return;
            }


            // Check ownership
            if (complaint.getUserId() != userId) {

                session.setAttribute(
                        "errorMessage",
                        "You are not allowed to delete this complaint."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/myComplaints"
                );

                return;
            }


            // Only PENDING complaints can be deleted
            if (!"PENDING".equalsIgnoreCase(
                    complaint.getStatus())) {

                session.setAttribute(
                        "errorMessage",
                        "Only pending complaints can be deleted."
                );

                response.sendRedirect(
                        request.getContextPath()
                        + "/myComplaints"
                );

                return;
            }


            // Soft delete
            boolean deleted =
                    complaintService.deleteComplaint(
                            complaintId
                    );


            if (deleted) {

                session.setAttribute(
                        "successMessage",
                        "Complaint deleted successfully."
                );

            } else {

                session.setAttribute(
                        "errorMessage",
                        "Unable to delete the complaint."
                );
            }


        } catch (NumberFormatException e) {

            session.setAttribute(
                    "errorMessage",
                    "Invalid complaint ID."
            );


        } catch (Exception e) {

            e.printStackTrace();

            session.setAttribute(
                    "errorMessage",
                    "Something went wrong while deleting the complaint."
            );
        }


        response.sendRedirect(
                request.getContextPath()
                + "/myComplaints"
        );
    }
}
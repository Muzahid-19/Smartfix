package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Comment;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.Staff;

import com.smartfix.service.CommentService;
import com.smartfix.service.ComplaintService;

import com.smartfix.service.impl.CommentServiceImpl;
import com.smartfix.service.impl.ComplaintServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/add-comment")
public class StaffCommentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private CommentService commentService;
    private ComplaintService complaintService;

    @Override
    public void init() throws ServletException {

        commentService =
                new CommentServiceImpl();

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

        if (session == null ||
            session.getAttribute("staff") == null) {

            response.sendRedirect(
                request.getContextPath()
                + "/login.jsp"
            );

            return;
        }


        Staff staff =
                (Staff) session.getAttribute("staff");


        String complaintIdParam =
                request.getParameter("complaintId");

        String commentText =
                request.getParameter("commentText");


        if (complaintIdParam == null ||
            complaintIdParam.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath()
                + "/staff/complaints"
            );

            return;
        }


        if (commentText == null ||
            commentText.trim().isEmpty()) {

            response.sendRedirect(
                request.getContextPath()
                + "/staff/complaint-details?id="
                + complaintIdParam
                + "&comment=empty"
            );

            return;
        }


        try {

            int complaintId =
                    Integer.parseInt(
                        complaintIdParam
                    );


            Complaint complaint =
                    complaintService
                    .getComplaintById(
                        complaintId
                    );


            if (complaint == null) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaints"
                );

                return;
            }


            /*
             * Security:
             * Staff can comment only on
             * complaints assigned to them.
             */

            if (complaint.getStaffId() == null ||
                complaint.getStaffId()
                    != staff.getStaffId()) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaints"
                );

                return;
            }


            /*
             * Create comment
             */

            Comment comment =
                    new Comment();


            comment.setComplaintId(
                complaintId
            );


            /*
             * This is a STAFF comment.
             *
             * Therefore staff_id is used.
             *
             * user_id remains NULL.
             */

            comment.setStaffId(
                staff.getStaffId()
            );


            comment.setCommentText(
                commentText.trim()
            );


            boolean success =
                    commentService.addComment(
                        comment
                    );


            if (success) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaint-details?id="
                    + complaintId
                    + "&comment=success"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaint-details?id="
                    + complaintId
                    + "&comment=failed"
                );
            }


        } catch (NumberFormatException e) {

            response.sendRedirect(
                request.getContextPath()
                + "/staff/complaints"
            );
        }
    }
}
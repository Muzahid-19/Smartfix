package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Comment;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.User;

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

@WebServlet("/user/add-comment")
public class UserCommentServlet extends HttpServlet {

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
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        User user =
                (User) session.getAttribute("user");

        String complaintIdParam =
                request.getParameter("complaintId");

        String commentText =
                request.getParameter("commentText");

        if (complaintIdParam == null ||
            complaintIdParam.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/complaints"
            );

            return;
        }

        if (commentText == null ||
            commentText.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/complaint-details?id="
                    + complaintIdParam
                    + "&error=empty"
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
                        + "/user/complaints"
                );

                return;
            }

            /*
             * Security:
             * User can comment only on
             * his/her own complaint.
             */
            if (complaint.getUserId()
                    != user.getUserId()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaints"
                );

                return;
            }

            Comment comment =
                    new Comment();

            comment.setComplaintId(
                    complaintId
            );

            comment.setUserId(
                    user.getUserId()
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
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&comment=success"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&comment=failed"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/user/complaints"
            );
        }
    }
}
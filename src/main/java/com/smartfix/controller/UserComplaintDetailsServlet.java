package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.modelcom.Comment;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.ComplaintHistory;
import com.smartfix.modelcom.Rating;
import com.smartfix.modelcom.User;

import com.smartfix.service.CommentService;
import com.smartfix.service.ComplaintHistoryService;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.RatingService;

import com.smartfix.service.impl.CommentServiceImpl;
import com.smartfix.service.impl.ComplaintHistoryServiceImpl;
import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.RatingServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/complaint-details")
public class UserComplaintDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private ComplaintHistoryService complaintHistoryService;
    private CommentService commentService;
    private RatingService ratingService;

    @Override
    public void init() throws ServletException {

        complaintService =
                new ComplaintServiceImpl();

        complaintHistoryService =
                new ComplaintHistoryServiceImpl();

        commentService =
                new CommentServiceImpl();

        ratingService =
                new RatingServiceImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        /*
         * CHECK LOGIN
         */

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

        /*
         * GET COMPLAINT ID
         */

        String idParam =
                request.getParameter("id");

        if (idParam == null ||
            idParam.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/myComplaints"
            );

            return;
        }

        try {

            int complaintId =
                    Integer.parseInt(idParam);

            /*
             * GET COMPLAINT
             */

            Complaint complaint =
                    complaintService.getComplaintById(
                            complaintId
                    );

            if (complaint == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/myComplaints"
                );

                return;
            }

            /*
             * SECURITY CHECK
             *
             * Make sure this complaint
             * belongs to the logged-in user.
             */

            if (complaint.getUserId()
                    != user.getUserId()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/myComplaints"
                );

                return;
            }

            /*
             * GET COMPLAINT HISTORY
             */

            List<ComplaintHistory> historyList =
                    complaintHistoryService
                    .getHistoryByComplaintId(
                            complaintId
                    );

            /*
             * GET COMMENTS
             */

            List<Comment> commentList =
                    commentService
                    .getCommentsByComplaintId(
                            complaintId
                    );

            /*
             * GET RATING
             *
             * If the complaint has already
             * been rated, this will contain
             * the rating.
             *
             * Otherwise it will be null.
             */

            Rating rating =
                    ratingService
                    .getRatingByComplaintId(
                            complaintId
                    );

            /*
             * SEND DATA TO JSP
             */

            request.setAttribute(
                    "complaint",
                    complaint
            );

            request.setAttribute(
                    "historyList",
                    historyList
            );

            request.setAttribute(
                    "commentList",
                    commentList
            );

            request.setAttribute(
                    "rating",
                    rating
            );

            /*
             * OPEN COMPLAINT DETAILS PAGE
             */

            request.getRequestDispatcher(
                    "/user/complaint-details.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/myComplaints"
            );
        }
    }
}
package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.Rating;
import com.smartfix.modelcom.User;

import com.smartfix.service.ComplaintService;
import com.smartfix.service.RatingService;

import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.RatingServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/user/add-rating")
public class UserRatingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private RatingService ratingService;

    @Override
    public void init() throws ServletException {

        complaintService =
                new ComplaintServiceImpl();

        ratingService =
                new RatingServiceImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request,
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
         * GET PARAMETERS
         */

        String complaintIdParam =
                request.getParameter("complaintId");

        String ratingParam =
                request.getParameter("rating");

        String feedback =
                request.getParameter("feedback");

        /*
         * CHECK COMPLAINT ID
         */

        if (complaintIdParam == null ||
            complaintIdParam.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/myComplaints"
            );

            return;
        }

        try {

            int complaintId =
                    Integer.parseInt(
                            complaintIdParam
                    );

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
             * Complaint must belong
             * to logged-in user.
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
             * ONLY RESOLVED COMPLAINTS
             * CAN BE RATED
             */

            if (complaint.getStatus() == null ||
                !"RESOLVED".equalsIgnoreCase(
                        complaint.getStatus().trim())) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&rating=notresolved"
                );

                return;
            }

            /*
             * CHECK RATING VALUE
             */

            if (ratingParam == null ||
                ratingParam.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&rating=invalid"
                );

                return;
            }

            int ratingValue =
                    Integer.parseInt(
                            ratingParam
                    );

            /*
             * RATING MUST BE 1 TO 5
             */

            if (ratingValue < 1 ||
                ratingValue > 5) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&rating=invalid"
                );

                return;
            }

            /*
             * CHECK WHETHER USER
             * ALREADY RATED THIS COMPLAINT
             */

            Rating existingRating =
                    ratingService
                    .getRatingByComplaintId(
                            complaintId
                    );

            if (existingRating != null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&rating=exists"
                );

                return;
            }

            /*
             * PREPARE RATING
             */

            Rating rating =
                    new Rating();

            rating.setComplaintId(
                    complaintId
            );

            rating.setUserId(
                    user.getUserId()
            );

            rating.setRating(
                    ratingValue
            );

            if (feedback == null) {
                feedback = "";
            }

            rating.setFeedback(
                    feedback.trim()
            );

            /*
             * SAVE RATING
             */

            boolean success =
                    ratingService.addRating(
                            rating
                    );

            /*
             * REDIRECT
             */

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&rating=success"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/user/complaint-details?id="
                        + complaintId
                        + "&rating=failed"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/myComplaints"
            );
        }
    }
}
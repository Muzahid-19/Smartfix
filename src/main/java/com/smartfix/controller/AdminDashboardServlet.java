package com.smartfix.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.Rating;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;

import com.smartfix.service.ComplaintService;
import com.smartfix.service.RatingService;
import com.smartfix.service.StaffService;
import com.smartfix.service.UserService;
import com.smartfix.service.NotificationService;

import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.RatingServiceImpl;
import com.smartfix.service.impl.StaffServiceImpl;
import com.smartfix.service.impl.UserServiceImpl;
import com.smartfix.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private UserService userService;
    private StaffService staffService;
    private RatingService ratingService;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {

        complaintService = new ComplaintServiceImpl();
        userService = new UserServiceImpl();
        staffService = new StaffServiceImpl();
        ratingService = new RatingServiceImpl();
        notificationService = new NotificationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // CHECK SESSION
        // ==========================================

        HttpSession session = request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // ==========================================
        // GET LOGGED-IN ADMIN
        // ==========================================

        User admin = (User) session.getAttribute("user");

        // ==========================================
        // CHECK ADMIN ROLE
        // ==========================================

        if (admin == null ||
            admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(
                    admin.getRole().trim())) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // ==========================================
        // GET UNREAD NOTIFICATION COUNT
        // ==========================================

        int unreadCount =
                notificationService.getUnreadNotificationCount(
                        admin.getUserId(),
                        admin.getRole().trim().toUpperCase()
                );

        // ==========================================
        // GET ALL USERS
        // ==========================================

        List<User> users =
                userService.getAllUsers();

        // ==========================================
        // GET ALL STAFF
        // ==========================================

        List<Staff> staff =
                staffService.getAllStaff();

        // ==========================================
        // GET ALL COMPLAINTS
        // ==========================================

        List<Complaint> complaints =
                complaintService.getAllComplaints();

        // ==========================================
        // GET ALL RATINGS
        // ==========================================

        List<Rating> ratings =
                ratingService.getAllRatings();

        // ==========================================
        // TOTAL COUNTS
        // ==========================================

        int totalUsers = 0;
        int totalStaff = 0;
        int totalComplaints = 0;
        int totalRatings = 0;

        if (users != null) {
            totalUsers = users.size();
        }

        if (staff != null) {
            totalStaff = staff.size();
        }

        if (complaints != null) {
            totalComplaints = complaints.size();
        }

        if (ratings != null) {
            totalRatings = ratings.size();
        }

        // ==========================================
        // COMPLAINT STATUS COUNTS
        // ==========================================

        int pending = 0;
        int assigned = 0;
        int inProgress = 0;
        int resolved = 0;

        if (complaints != null) {

            for (Complaint complaint : complaints) {

                String status = complaint.getStatus();

                if (status == null) {
                    continue;
                }

                status = status.trim();

                if ("PENDING".equalsIgnoreCase(status)) {

                    pending++;

                } else if ("ASSIGNED".equalsIgnoreCase(status)) {

                    assigned++;

                } else if ("IN PROGRESS".equalsIgnoreCase(status)) {

                    inProgress++;

                } else if ("RESOLVED".equalsIgnoreCase(status)) {

                    resolved++;
                }
            }
        }

        // ==========================================
        // CATEGORY-WISE COMPLAINT COUNTS
        // ==========================================

        Map<String, Integer> categoryComplaintCounts =
                complaintService.getComplaintCountByCategory();

        // ==========================================
        // PRIORITY-WISE COMPLAINT COUNTS
        // ==========================================

        Map<String, Integer> priorityComplaintCounts =
                complaintService.getComplaintCountByPriority();

        // ==========================================
        // HIGH PRIORITY COMPLAINTS
        // ==========================================

        List<Complaint> highPriorityComplaints =
                complaintService.getHighPriorityComplaints();

        // ==========================================
        // CALCULATE AVERAGE RATING
        // ==========================================

        double averageRating = 0.0;

        if (ratings != null && !ratings.isEmpty()) {

            int totalRatingValue = 0;

            for (Rating rating : ratings) {

                totalRatingValue += rating.getRating();
            }

            averageRating =
                    (double) totalRatingValue / ratings.size();
        }

        // ==========================================
        // RECENT COMPLAINTS
        // ==========================================

        List<Complaint> recentComplaints =
                new ArrayList<>();

        if (complaints != null) {

            int limit =
                    Math.min(5, complaints.size());

            for (int i = 0; i < limit; i++) {

                recentComplaints.add(
                        complaints.get(i)
                );
            }
        }

        // ==========================================
        // RECENT RATINGS
        // ==========================================

        List<Rating> recentRatings =
                new ArrayList<>();

        if (ratings != null) {

            int limit =
                    Math.min(5, ratings.size());

            for (int i = 0; i < limit; i++) {

                recentRatings.add(
                        ratings.get(i)
                );
            }
        }

        // ==========================================
        // SEND USER DATA TO JSP
        // ==========================================

        request.setAttribute(
                "totalUsers",
                totalUsers
        );

        // ==========================================
        // SEND STAFF DATA
        // ==========================================

        request.setAttribute(
                "totalStaff",
                totalStaff
        );

        // ==========================================
        // SEND COMPLAINT DATA
        // ==========================================

        request.setAttribute(
                "totalComplaints",
                totalComplaints
        );

        request.setAttribute(
                "pendingComplaints",
                pending
        );

        request.setAttribute(
                "assignedComplaints",
                assigned
        );

        request.setAttribute(
                "inProgressComplaints",
                inProgress
        );

        request.setAttribute(
                "resolvedComplaints",
                resolved
        );

        // ==========================================
        // SEND CATEGORY ANALYTICS DATA
        // ==========================================

        request.setAttribute(
                "categoryComplaintCounts",
                categoryComplaintCounts
        );

        // ==========================================
        // SEND PRIORITY ANALYTICS DATA
        // ==========================================

        request.setAttribute(
                "priorityComplaintCounts",
                priorityComplaintCounts
        );

        // ==========================================
        // SEND HIGH PRIORITY COMPLAINTS
        // ==========================================

        request.setAttribute(
                "highPriorityComplaints",
                highPriorityComplaints
        );

        // ==========================================
        // SEND RATING DATA
        // ==========================================

        request.setAttribute(
                "totalRatings",
                totalRatings
        );

        request.setAttribute(
                "averageRating",
                averageRating
        );

        request.setAttribute(
                "recentRatings",
                recentRatings
        );

        // ==========================================
        // SEND RECENT COMPLAINTS
        // ==========================================

        request.setAttribute(
                "recentComplaints",
                recentComplaints
        );

        // ==========================================
        // SEND NOTIFICATION DATA
        // ==========================================

        request.setAttribute(
                "unreadCount",
                unreadCount
        );

        // ==========================================
        // OPEN ADMIN DASHBOARD
        // ==========================================

        request.getRequestDispatcher(
                "/admin/dashboard.jsp"
        ).forward(request, response);
    }
}
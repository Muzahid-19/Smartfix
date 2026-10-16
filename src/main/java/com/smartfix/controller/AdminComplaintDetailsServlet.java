
package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.UserDAOImpl;
import com.smartfix.modelcom.Comment;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.ComplaintHistory;
import com.smartfix.modelcom.Notification;
import com.smartfix.modelcom.Rating;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;

import com.smartfix.service.CommentService;
import com.smartfix.service.ComplaintHistoryService;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.NotificationService;
import com.smartfix.service.RatingService;
import com.smartfix.service.StaffService;

import com.smartfix.service.impl.CommentServiceImpl;
import com.smartfix.service.impl.ComplaintHistoryServiceImpl;
import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.NotificationServiceImpl;
import com.smartfix.service.impl.RatingServiceImpl;
import com.smartfix.service.impl.StaffServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/complaint-details")
public class AdminComplaintDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private ComplaintHistoryService complaintHistoryService;
    private CommentService commentService;
    private RatingService ratingService;
    private StaffService staffService;
    private UserDAO userDAO;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        complaintService = new ComplaintServiceImpl();
        complaintHistoryService = new ComplaintHistoryServiceImpl();
        commentService = new CommentServiceImpl();
        ratingService = new RatingServiceImpl();
        staffService = new StaffServiceImpl();
        userDAO = new UserDAOImpl();
        notificationService = new NotificationServiceImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");

        if (admin == null || admin.getRole() == null
                || !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/complaints");
            return;
        }

        try {
            int complaintId = Integer.parseInt(idParam.trim());

            Complaint complaint =
                    complaintService.getComplaintById(complaintId);

            if (complaint == null) {
                response.sendRedirect(
                        request.getContextPath() + "/admin/complaints");
                return;
            }

            // Get the user who submitted the complaint.
            User complaintUser =
                    userDAO.getUserById(complaint.getUserId());

            String roomNumber = "Not provided";

            if (complaintUser != null
                    && complaintUser.getRoomNumber() != null
                    && !complaintUser.getRoomNumber().trim().isEmpty()) {
                roomNumber = complaintUser.getRoomNumber().trim();
            }

            List<ComplaintHistory> historyList =
                    complaintHistoryService.getHistoryByComplaintId(
                            complaintId);

            List<Comment> commentList =
                    commentService.getCommentsByComplaintId(
                            complaintId);

            Rating rating =
                    ratingService.getRatingByComplaintId(complaintId);

            List<Staff> staffList = staffService.getAllStaff();

            Staff complaintStaff = null;

            if (complaint.getStaffId() != null && staffList != null) {
                for (Staff staff : staffList) {
                    if (staff.getStaffId() == complaint.getStaffId()) {
                        complaintStaff = staff;
                        break;
                    }
                }
            }

            request.setAttribute("complaint", complaint);
            request.setAttribute("complaintUser", complaintUser);
            request.setAttribute("roomNumber", roomNumber);
            request.setAttribute("complaintStaff", complaintStaff);
            request.setAttribute("historyList", historyList);
            request.setAttribute("commentList", commentList);
            request.setAttribute("rating", rating);
            request.setAttribute("staffList", staffList);

            request.getRequestDispatcher(
                    "/admin/complaint-details.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/admin/complaints");
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");

        if (admin == null || admin.getRole() == null
                || !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String complaintIdParam = request.getParameter("complaintId");
        String staffIdParam = request.getParameter("staffId");

        if (complaintIdParam == null || staffIdParam == null
                || complaintIdParam.trim().isEmpty()
                || staffIdParam.trim().isEmpty()) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/complaints?error=invalid");
            return;
        }

        try {
            int complaintId =
                    Integer.parseInt(complaintIdParam.trim());
            int staffId =
                    Integer.parseInt(staffIdParam.trim());

            Complaint complaint =
                    complaintService.getComplaintById(complaintId);

            if (complaint == null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/complaints?error=invalid");
                return;
            }

            List<Staff> staffList = staffService.getAllStaff();
            boolean staffExists = false;

            if (staffList != null) {
                for (Staff staff : staffList) {
                    if (staff.getStaffId() == staffId) {
                        staffExists = true;
                        break;
                    }
                }
            }

            if (!staffExists) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/complaints?error=invalid");
                return;
            }

            boolean assigned =
                    complaintService.assignComplaint(
                            complaintId, staffId);

            if (assigned) {
                User complaintUser =
                        userDAO.getUserById(complaint.getUserId());

                String roomNumber = "Not provided";

                if (complaintUser != null
                        && complaintUser.getRoomNumber() != null
                        && !complaintUser.getRoomNumber().trim().isEmpty()) {
                    roomNumber = complaintUser.getRoomNumber().trim();
                }

                Notification staffNotification =
                        new Notification(
                                staffId,
                                "STAFF",
                                complaintId,
                                "You have been assigned complaint #"
                                + complaintId
                                + ". Room Number: "
                                + roomNumber
                                + ".");

                notificationService.addNotification(staffNotification);

                Notification userNotification =
                        new Notification(
                                complaint.getUserId(),
                                "USER",
                                complaintId,
                                "Your complaint has been assigned to staff.");

                notificationService.addNotification(userNotification);

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/complaints?message=assigned");

            } else {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/complaints?error=assignfailed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/complaints?error=invalid");
        }
    }
}

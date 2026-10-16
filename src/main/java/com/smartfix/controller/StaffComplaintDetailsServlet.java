
package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.UserDAOImpl;

import com.smartfix.modelcom.Comment;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.ComplaintHistory;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;

import com.smartfix.service.CommentService;
import com.smartfix.service.ComplaintHistoryService;
import com.smartfix.service.ComplaintService;

import com.smartfix.service.impl.CommentServiceImpl;
import com.smartfix.service.impl.ComplaintHistoryServiceImpl;
import com.smartfix.service.impl.ComplaintServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/complaint-details")
public class StaffComplaintDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private ComplaintHistoryService complaintHistoryService;
    private CommentService commentService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {

        complaintService = new ComplaintServiceImpl();

        complaintHistoryService =
                new ComplaintHistoryServiceImpl();

        commentService = new CommentServiceImpl();

        userDAO = new UserDAOImpl();

        System.out.println(
                "StaffComplaintDetailsServlet initialized"
        );
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println(
                "=========================================="
        );

        System.out.println(
                "STAFF COMPLAINT DETAILS SERVLET CALLED"
        );

        // Check staff session
        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("staff") == null) {

            System.out.println("Staff session not found");

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        Staff staff =
                (Staff) session.getAttribute("staff");

        int staffId = staff.getStaffId();

        System.out.println("Staff ID: " + staffId);

        // Get complaint ID
        String idParam = request.getParameter("id");

        System.out.println(
                "Complaint ID parameter: " + idParam
        );

        if (idParam == null || idParam.trim().isEmpty()) {

            System.out.println("Complaint ID is missing");

            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/complaints"
            );

            return;
        }

        try {

            int complaintId =
                    Integer.parseInt(idParam.trim());

            System.out.println(
                    "Complaint ID: " + complaintId
            );

            // Retrieve complaint
            Complaint complaint =
                    complaintService.getComplaintById(
                            complaintId
                    );

            if (complaint == null) {

                System.out.println("Complaint not found");

                response.sendRedirect(
                        request.getContextPath()
                                + "/staff/complaints"
                );

                return;
            }

            System.out.println(
                    "Complaint found: " + complaint.getTitle()
            );

            System.out.println(
                    "Complaint Staff ID: "
                            + complaint.getStaffId()
            );

            // Verify complaint ownership
            if (complaint.getStaffId() == null ||
                    complaint.getStaffId().intValue() != staffId) {

                System.out.println(
                        "Complaint does not belong to this staff member"
                );

                response.sendRedirect(
                        request.getContextPath()
                                + "/staff/complaints"
                );

                return;
            }

            // ==========================================
            // GET COMPLAINT OWNER AND ROOM NUMBER
            // ==========================================

            User complaintUser = null;

            try {

                complaintUser =
                        userDAO.getUserById(
                                complaint.getUserId()
                        );

                if (complaintUser != null) {

                    System.out.println(
                            "Complaint owner retrieved successfully"
                    );

                    System.out.println(
                            "Room Number: "
                                    + complaintUser.getRoomNumber()
                    );

                } else {

                    System.out.println(
                            "Complaint owner was not found"
                    );
                }

            } catch (Exception e) {

                // A room lookup failure should not prevent
                // the staff member from viewing the complaint.
                System.err.println(
                        "Could not retrieve complaint owner's room number"
                );

                e.printStackTrace();
            }

            // ==========================================
            // GET COMPLAINT HISTORY
            // ==========================================

            List<ComplaintHistory> history =
                    complaintHistoryService
                            .getHistoryByComplaintId(
                                    complaintId
                            );

            // ==========================================
            // GET COMMENTS
            // ==========================================

            List<Comment> comments =
                    commentService.getCommentsByComplaintId(
                            complaintId
                    );

            System.out.println(
                    "------------------------------------------"
            );

            System.out.println("COMMENTS QUERY RESULT");

            System.out.println(
                    "Complaint ID: " + complaintId
            );

            System.out.println(
                    "Comments object: " + comments
            );

            System.out.println(
                    "Comments count: "
                            + (comments == null
                                    ? "NULL"
                                    : comments.size())
            );

            if (comments != null) {

                for (Comment comment : comments) {

                    System.out.println(
                            "Comment ID: "
                                    + comment.getCommentId()
                    );

                    System.out.println(
                            "Comment Text: "
                                    + comment.getCommentText()
                    );

                    System.out.println(
                            "Comment User ID: "
                                    + comment.getUserId()
                    );
                }
            }

            System.out.println(
                    "History count: "
                            + (history == null
                                    ? "NULL"
                                    : history.size())
            );

            System.out.println(
                    "------------------------------------------"
            );

            // ==========================================
            // SEND DATA TO JSP
            // ==========================================

            request.setAttribute(
                    "complaint",
                    complaint
            );

            request.setAttribute(
                    "complaintUser",
                    complaintUser
            );

            request.setAttribute(
                    "history",
                    history
            );

            request.setAttribute(
                    "comments",
                    comments
            );

            request.setAttribute(
                    "staff",
                    staff
            );

            System.out.println(
                    "Request attribute 'complaintUser': "
                            + request.getAttribute("complaintUser")
            );

            System.out.println(
                    "Request attribute 'comments': "
                            + request.getAttribute("comments")
            );

            System.out.println(
                    "Forwarding to staff/complaint-details.jsp"
            );

            System.out.println(
                    "=========================================="
            );

            request.getRequestDispatcher(
                    "/staff/complaint-details.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            System.out.println(
                    "Invalid complaint ID: " + idParam
            );

            response.sendRedirect(
                    request.getContextPath()
                            + "/staff/complaints"
            );
        }
    }
}

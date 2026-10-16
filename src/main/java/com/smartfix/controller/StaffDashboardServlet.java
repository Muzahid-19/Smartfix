
package com.smartfix.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.UserDAOImpl;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.NotificationService;
import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private NotificationService notificationService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        complaintService = new ComplaintServiceImpl();
        notificationService = new NotificationServiceImpl();
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader(
                "Cache-Control",
                "no-cache, no-store, must-revalidate"
        );
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        Staff staff = (Staff) session.getAttribute("staff");

        if (staff == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        int staffId = staff.getStaffId();

        // Fetch complaints assigned to the logged-in staff member.
        List<Complaint> complaints;

        try {
            complaints =
                    complaintService.getComplaintsByStaffId(staffId);

            if (complaints == null) {
                complaints = new ArrayList<>();
            }
        } catch (Exception e) {
            getServletContext().log(
                    "Failed to load complaints for staff ID: " + staffId,
                    e
            );

            throw new ServletException(
                    "Unable to load staff complaints.",
                    e
            );
        }

        int total = complaints.size();
        int assigned = 0;
        int inProgress = 0;
        int resolved = 0;
        int pending = 0;

        Map<Integer, String> roomNumbers = new HashMap<>();

        for (Complaint complaint : complaints) {

            // Normalize statuses such as IN_PROGRESS and IN-PROGRESS.
            String status = complaint.getStatus();

            if (status != null) {
                status = status.trim()
                        .toUpperCase(java.util.Locale.ROOT)
                        .replace('_', ' ')
                        .replace('-', ' ')
                        .replaceAll("\\s+", " ");

                switch (status) {
                    case "ASSIGNED":
                        assigned++;
                        break;

                    case "IN PROGRESS":
                        inProgress++;
                        break;

                    case "RESOLVED":
                        resolved++;
                        break;

                    case "PENDING":
                        pending++;
                        break;

                    default:
                        System.out.println(
                                "Unrecognized status: " + status
                                + ", complaint ID: "
                                + complaint.getComplaintId()
                        );
                }
            }

            // Load the complaint owner's room number.
            String roomNumber = "Not provided";

            try {
                User complaintUser =
                        userDAO.getUserById(complaint.getUserId());

                if (complaintUser != null
                        && complaintUser.getRoomNumber() != null
                        && !complaintUser.getRoomNumber()
                                .trim().isEmpty()) {

                    roomNumber =
                            complaintUser.getRoomNumber().trim();
                }
            } catch (Exception e) {
                getServletContext().log(
                        "Could not retrieve room number for complaint ID: "
                        + complaint.getComplaintId(),
                        e
                );
            }

            roomNumbers.put(
                    complaint.getComplaintId(),
                    roomNumber
            );
        }

        // Load unread notification count.
        int unreadCount = 0;

        try {
            unreadCount =
                    notificationService.getUnreadNotificationCount(
                            staffId,
                            "STAFF"
                    );
        } catch (Exception e) {
            getServletContext().log(
                    "Could not retrieve notifications for staff ID: "
                    + staffId,
                    e
            );
        }

        // Debug output.
        System.out.println("========== STAFF DASHBOARD ==========");
        System.out.println("Staff ID: " + staffId);
        System.out.println("Staff Name: " + staff.getName());
        System.out.println("Total complaints: " + total);
        System.out.println("Assigned: " + assigned);
        System.out.println("In progress: " + inProgress);
        System.out.println("Resolved: " + resolved);
        System.out.println("Pending: " + pending);
        System.out.println("Unread notifications: " + unreadCount);
        System.out.println("=====================================");

        // Supply all values to the JSP on every dashboard request.
        request.setAttribute("complaints", complaints);
        request.setAttribute("roomNumbers", roomNumbers);
        request.setAttribute("staff", staff);

        request.setAttribute("total", total);
        request.setAttribute("assigned", assigned);
        request.setAttribute("inProgress", inProgress);
        request.setAttribute("resolved", resolved);
        request.setAttribute("pending", pending);
        request.setAttribute("unreadCount", unreadCount);

        // Forward internally so request attributes remain available.
        request.getRequestDispatcher(
                "/staff/dashboard.jsp"
        ).forward(request, response);
    }
}

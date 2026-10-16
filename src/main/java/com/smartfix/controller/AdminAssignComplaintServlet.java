
package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.dao.StaffDAO;
import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.StaffDAOImpl;
import com.smartfix.dao.impl.UserDAOImpl;

import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.Notification;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;

import com.smartfix.service.ComplaintService;
import com.smartfix.service.EmailService;
import com.smartfix.service.NotificationService;

import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.EmailServiceImpl;
import com.smartfix.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/assign-complaint")
public class AdminAssignComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private NotificationService notificationService;
    private EmailService emailService;

    private StaffDAO staffDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {

        complaintService = new ComplaintServiceImpl();
        notificationService = new NotificationServiceImpl();
        emailService = new EmailServiceImpl();

        staffDAO = new StaffDAOImpl();
        userDAO = new UserDAOImpl();
    }

    private String safe(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "Not provided";
        }
        return value.trim();
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");

        if (admin.getRole() == null ||
            !"ADMIN".equalsIgnoreCase(admin.getRole().trim())) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        String complaintIdParam = request.getParameter("complaintId");
        String staffIdParam = request.getParameter("staffId");

        if (complaintIdParam == null ||
            complaintIdParam.trim().isEmpty() ||
            staffIdParam == null ||
            staffIdParam.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/admin/complaints");
            return;
        }

        try {

            int complaintId = Integer.parseInt(complaintIdParam.trim());
            int staffId = Integer.parseInt(staffIdParam.trim());

            // 1. Get complaint
            Complaint complaint =
                    complaintService.getComplaintById(complaintId);

            if (complaint == null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/complaints?error=Complaint+not+found");
                return;
            }

            // 2. Get assigned staff
            Staff staff = staffDAO.getStaffById(staffId);

            if (staff == null) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/complaints?error=Staff+not+found");
                return;
            }

            // 3. Assign complaint in the database
            boolean assigned =
                    complaintService.assignComplaint(complaintId, staffId);

            if (!assigned) {
                response.sendRedirect(
                        request.getContextPath()
                        + "/admin/complaints?error=Unable+to+assign");
                return;
            }

            System.out.println(
                    "Complaint #" + complaintId
                    + " assigned to staff #" + staffId);

            // 4. Get complaint owner
            int userId = complaint.getUserId();
            User complaintUser = userDAO.getUserById(userId);

            // 5. Create staff notification
            try {
                String staffMessage =
                        "New complaint assigned to you. Complaint ID: #"
                        + complaintId
                        + ". Title: " + safe(complaint.getTitle())
                        + ". Priority: " + safe(complaint.getPriority())
                        + ". Status: ASSIGNED";

                Notification staffNotification =
                        new Notification(
                                staffId,
                                "STAFF",
                                complaintId,
                                staffMessage);

                notificationService.addNotification(staffNotification);

            } catch (Exception e) {
                System.err.println("Could not create staff notification.");
                e.printStackTrace();
            }

            // 6. EMAIL TO STAFF
            // Includes user contact details and complete complaint details.
            if (staff.getEmail() != null &&
                !staff.getEmail().trim().isEmpty()) {

                String userName = complaintUser != null
                        ? safe(complaintUser.getName())
                        : "Not available";

                String userEmail = complaintUser != null
                        ? safe(complaintUser.getEmail())
                        : "Not available";

                String userPhone = complaintUser != null
                        ? safe(complaintUser.getPhone())
                        : "Not available";

                String roomNumber = complaintUser != null
                        ? safe(complaintUser.getRoomNumber())
                        : "Not available";

                String staffEmailBody =
                        "Hello " + safe(staff.getName()) + ",\n\n"
                        + "A new complaint has been assigned to you in SmartFix.\n\n"

                        + "========== USER DETAILS ==========\n"
                        + "User ID: " + userId + "\n"
                        + "User Name: " + userName + "\n"
                        + "User Email: " + userEmail + "\n"
                        + "User Phone: " + userPhone + "\n"
                        + "Room Number: " + roomNumber + "\n\n"

                        + "========== COMPLAINT DETAILS ==========\n"
                        + "Complaint ID: #" + complaintId + "\n"
                        + "Title: " + safe(complaint.getTitle()) + "\n"
                        + "Description: " + safe(complaint.getDescription()) + "\n"
                        + "Category: " + safe(complaint.getCategory()) + "\n"
                        + "Priority: " + safe(complaint.getPriority()) + "\n"
                        + "Status: ASSIGNED\n\n"

                        + "Please log in to SmartFix to review the complaint "
                        + "and update its progress.\n\n"
                        + "Regards,\n"
                        + "SmartFix Team";

                try {
                    emailService.sendEmail(
                            staff.getEmail(),
                            "SmartFix - New Complaint Assigned #" + complaintId,
                            staffEmailBody);

                    System.out.println("Staff email sent to: " + staff.getEmail());

                } catch (Exception e) {
                    System.err.println("Failed to send staff email.");
                    e.printStackTrace();
                }

            } else {
                System.out.println("Staff email address is missing.");
            }

            // 7. Create user notification
            try {
                String userMessage =
                        "Your complaint #" + complaintId
                        + " has been assigned to "
                        + safe(staff.getName())
                        + ". Status: ASSIGNED.";

                Notification userNotification =
                        new Notification(
                                userId,
                                "USER",
                                complaintId,
                                userMessage);

                notificationService.addNotification(userNotification);

            } catch (Exception e) {
                System.err.println("Could not create user notification.");
                e.printStackTrace();
            }

            // 8. EMAIL TO USER
            // Includes the assigned staff member's contact details.
            if (complaintUser != null &&
                complaintUser.getEmail() != null &&
                !complaintUser.getEmail().trim().isEmpty()) {

                String staffName = safe(staff.getName());
                String staffPhone = safe(staff.getPhone());

                String userEmailBody =
                        "Hello " + safe(complaintUser.getName()) + ",\n\n"
                        + "Good news! Your complaint has been assigned "
                        + "to a staff member.\n\n"

                        + "========== COMPLAINT DETAILS ==========\n"
                        + "Complaint ID: #" + complaintId + "\n"
                        + "Title: " + safe(complaint.getTitle()) + "\n"
                        + "Description: " + safe(complaint.getDescription()) + "\n"
                        + "Category: " + safe(complaint.getCategory()) + "\n"
                        + "Priority: " + safe(complaint.getPriority()) + "\n"
                        + "Current Status: ASSIGNED\n\n"

                        + "========== ASSIGNED STAFF DETAILS ==========\n"
                        + "Staff Name: " + staffName + "\n"
                        + "Staff Phone: " + staffPhone + "\n\n"

                        + "The assigned staff member will handle your complaint. "
                        + "Please keep your complaint ID for reference.\n\n"
                        + "Regards,\n"
                        + "SmartFix Team";

                try {
                    emailService.sendEmail(
                            complaintUser.getEmail(),
                            "SmartFix - Your Complaint Has Been Assigned #"
                                    + complaintId,
                            userEmailBody);

                    System.out.println(
                            "User email sent to: " + complaintUser.getEmail());

                } catch (Exception e) {
                    System.err.println("Failed to send user email.");
                    e.printStackTrace();
                }

            } else {
                System.out.println("User email address is missing.");
            }

            // 9. Redirect after assignment and notification attempts
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/complaints"
                    + "?success=Complaint+assigned+successfully");

        } catch (NumberFormatException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/complaints?error=Invalid+ID");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/complaints?error=Something+went+wrong");
        }
    }
}

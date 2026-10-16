
package com.smartfix.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.UserDAOImpl;
import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.Notification;
import com.smartfix.modelcom.User;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.EmailService;
import com.smartfix.service.NotificationService;
import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.EmailServiceImpl;
import com.smartfix.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/addComplaint")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class ComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private NotificationService notificationService;
    private UserDAO userDAO;
    private EmailService emailService;

    @Override
    public void init() throws ServletException {

        complaintService = new ComplaintServiceImpl();
        notificationService = new NotificationServiceImpl();
        userDAO = new UserDAOImpl();
        emailService = new EmailServiceImpl();
    }

    // Returns a fallback when a value is missing
    private String safeValue(String value) {

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
                request.getContextPath() + "/login.jsp"
            );

            return;
        }

        User user = (User) session.getAttribute("user");

        // ==============================
        // USER DETAILS
        // ==============================

        String userName = safeValue(user.getName());
        String userEmail = safeValue(user.getEmail());
        String phoneNumber = safeValue(user.getPhone());
        String roomNumber = safeValue(user.getRoomNumber());

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String category = request.getParameter("category");
        String priority = request.getParameter("priority");

        Part imagePart = request.getPart("complaintImage");

        String imagePath = null;

        // ==============================
        // IMAGE UPLOAD
        // ==============================

        if (imagePart != null && imagePart.getSize() > 0) {

            String submittedFileName =
                    imagePart.getSubmittedFileName();

            if (submittedFileName == null ||
                    submittedFileName.trim().isEmpty()) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/user/raise-complaint.jsp"
                    + "?error=Invalid image file"
                );

                return;
            }

            String originalFileName =
                    Paths.get(submittedFileName)
                         .getFileName()
                         .toString();

            String extension = "";

            int dotIndex = originalFileName.lastIndexOf(".");

            if (dotIndex >= 0) {
                extension = originalFileName.substring(dotIndex)
                                             .toLowerCase();
            }

            if (!extension.equals(".jpg") &&
                    !extension.equals(".jpeg") &&
                    !extension.equals(".png") &&
                    !extension.equals(".gif") &&
                    !extension.equals(".webp")) {

                response.sendRedirect(
                    request.getContextPath()
                    + "/user/raise-complaint.jsp"
                    + "?error=Invalid image format"
                );

                return;
            }

            String fileName =
                    "complaint_"
                    + user.getUserId()
                    + "_"
                    + System.currentTimeMillis()
                    + extension;

            String uploadPath =
                    getServletContext().getRealPath(
                        "/images/complaints"
                    );

            if (uploadPath == null) {

                throw new ServletException(
                    "Could not resolve complaint image upload directory."
                );
            }

            File uploadDirectory = new File(uploadPath);

            if (!uploadDirectory.exists() &&
                    !uploadDirectory.mkdirs()) {

                throw new ServletException(
                    "Could not create complaint image directory."
                );
            }

            String filePath =
                    uploadPath + File.separator + fileName;

            imagePart.write(filePath);

            imagePath = "images/complaints/" + fileName;

            System.out.println(
                "Complaint image uploaded: " + imagePath
            );
        }

        // ==============================
        // CREATE COMPLAINT
        // ==============================

        Complaint complaint = new Complaint();

        complaint.setUserId(user.getUserId());
        complaint.setTitle(title);
        complaint.setDescription(description);
        complaint.setCategory(category);
        complaint.setPriority(priority);
        complaint.setStatus("PENDING");
        complaint.setImagePath(imagePath);

        int complaintId = complaintService.addComplaint(complaint);

        // ==============================
        // COMPLAINT SUCCESS
        // ==============================

        if (complaintId > 0) {

            List<User> admins = userDAO.getAllAdmins();

            // ==============================
            // ADMIN NOTIFICATION + EMAIL
            // ==============================

            for (User admin : admins) {

                // 1. IN-APP NOTIFICATION

                Notification notification =
                        new Notification(
                            admin.getUserId(),
                            "ADMIN",
                            complaintId,
                            "New complaint received. "
                            + "User: " + userName
                            + ", Room Number: " + roomNumber
                        );

                notificationService.addNotification(notification);

                // 2. EMAIL NOTIFICATION

                String emailMessage =
                        "Hello Admin,\n\n"
                        + "A new complaint has been raised in SmartFix.\n\n"

                        + "========== COMPLAINANT DETAILS ==========\n"
                        + "User ID: " + user.getUserId() + "\n"
                        + "User Name: " + userName + "\n"
                        + "User Email: " + userEmail + "\n"
                        + "Phone Number: " + phoneNumber + "\n"
                        + "Room Number: " + roomNumber + "\n\n"

                        + "========== COMPLAINT DETAILS ==========\n"
                        + "Complaint ID: #" + complaintId + "\n"
                        + "Title: " + safeValue(title) + "\n"
                        + "Description: " + safeValue(description) + "\n"
                        + "Category: " + safeValue(category) + "\n"
                        + "Priority: " + safeValue(priority) + "\n"
                        + "Status: PENDING\n\n"

                        + "Please log in to SmartFix to review "
                        + "and manage this complaint.\n\n"
                        + "Regards,\n"
                        + "SmartFix Team";

                try {

                    emailService.sendEmail(
                        admin.getEmail(),
                        "SmartFix - New Complaint Received",
                        emailMessage
                    );

                    System.out.println(
                        "Complaint email sent to admin: "
                        + admin.getEmail()
                    );

                } catch (Exception e) {

                    System.err.println(
                        "Failed to send complaint email to: "
                        + admin.getEmail()
                    );

                    e.printStackTrace();
                }
            }

            // ==============================
            // SUCCESS REDIRECT
            // ==============================

            response.sendRedirect(
                request.getContextPath()
                + "/user/dashboard.jsp"
                + "?message=Complaint raised successfully"
            );

        } else {

            // ==============================
            // COMPLAINT FAILED
            // ==============================

            response.sendRedirect(
                request.getContextPath()
                + "/user/raise-complaint.jsp"
                + "?error=Failed to raise complaint"
            );
        }
    }
}

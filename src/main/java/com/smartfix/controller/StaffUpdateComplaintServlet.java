package com.smartfix.controller;

import java.io.IOException;

import com.smartfix.dao.UserDAO;
import com.smartfix.dao.impl.UserDAOImpl;

import com.smartfix.modelcom.Complaint;
import com.smartfix.modelcom.ComplaintHistory;
import com.smartfix.modelcom.Notification;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;

import com.smartfix.service.ComplaintHistoryService;
import com.smartfix.service.ComplaintService;
import com.smartfix.service.EmailService;
import com.smartfix.service.NotificationService;

import com.smartfix.service.impl.ComplaintHistoryServiceImpl;
import com.smartfix.service.impl.ComplaintServiceImpl;
import com.smartfix.service.impl.EmailServiceImpl;
import com.smartfix.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/staff/update-complaint")
public class StaffUpdateComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ComplaintService complaintService;
    private ComplaintHistoryService complaintHistoryService;
    private NotificationService notificationService;
    private EmailService emailService;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {

        complaintService =
                new ComplaintServiceImpl();

        complaintHistoryService =
                new ComplaintHistoryServiceImpl();

        notificationService =
                new NotificationServiceImpl();

        emailService =
                new EmailServiceImpl();

        userDAO =
                new UserDAOImpl();
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

        int staffId =
                staff.getStaffId();

        String complaintIdParam =
                request.getParameter("complaintId");

        String newStatus =
                request.getParameter("status");

        String resolutionNotes =
                request.getParameter("resolutionNotes");

        if (complaintIdParam == null ||
            complaintIdParam.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaints"
            );

            return;
        }

        try {

            int complaintId =
                    Integer.parseInt(
                            complaintIdParam.trim()
                    );

            Complaint complaint =
                    complaintService.getComplaintById(
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
             * STAFF SECURITY CHECK
             */
            if (complaint.getStaffId() == null ||
                complaint.getStaffId() != staffId) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/staff/complaints"
                );

                return;
            }

            String oldStatus =
                    complaint.getStatus();

            if (resolutionNotes == null) {
                resolutionNotes = "";
            }

            resolutionNotes =
                    resolutionNotes.trim();

            /*
             * CHECK STATUS CHANGE
             */
            boolean statusChanged = false;

            if (newStatus != null &&
                !newStatus.trim().isEmpty()) {

                newStatus =
                        newStatus.trim();

                if (oldStatus == null ||
                    !oldStatus.equalsIgnoreCase(newStatus)) {

                    statusChanged = true;
                }
            }

            /*
             * UPDATE STATUS
             */
            if (statusChanged) {

                boolean statusUpdated =
                        complaintService.updateComplaintStatus(
                                complaintId,
                                newStatus
                        );

                if (!statusUpdated) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/staff/complaint-details?id="
                            + complaintId
                            + "&error=Unable+to+update+status"
                    );

                    return;
                }
            }

            /*
             * UPDATE RESOLUTION NOTES
             */
            complaintService.addResolutionNotes(
                    complaintId,
                    resolutionNotes
            );

            /*
             * =================================================
             * STATUS CHANGED
             * =================================================
             */
            if (statusChanged) {

                /*
                 * SAVE HISTORY
                 */
                ComplaintHistory history =
                        new ComplaintHistory();

                history.setComplaintId(
                        complaintId
                );

                history.setChangedBy(
                        staffId
                );

                history.setOldStatus(
                        oldStatus
                );

                history.setNewStatus(
                        newStatus
                );

                if (!resolutionNotes.isEmpty()) {

                    history.setRemarks(
                            resolutionNotes
                    );

                } else {

                    history.setRemarks(
                            "Status changed from "
                            + oldStatus
                            + " to "
                            + newStatus
                    );
                }

                boolean historyAdded =
                        complaintHistoryService.addHistory(
                                history
                        );

                if (!historyAdded) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/staff/complaint-details?id="
                            + complaintId
                            + "&error=History+could+not+be+saved"
                    );

                    return;
                }

                /*
                 * =================================================
                 * USER IN-APP NOTIFICATION
                 * =================================================
                 */

                int userId =
                        complaint.getUserId();

                String message =
                        "Your complaint #"
                        + complaintId
                        + " status has been changed to "
                        + newStatus
                        + ".";

                Notification notification =
                        new Notification(
                                userId,
                                "USER",
                                complaintId,
                                message
                        );

                boolean notificationAdded =
                        notificationService.addNotification(
                                notification
                        );

                System.out.println(
                        "=========================================="
                );

                System.out.println(
                        "STAFF -> USER NOTIFICATION"
                );

                System.out.println(
                        "Staff ID: "
                        + staffId
                );

                System.out.println(
                        "User ID: "
                        + userId
                );

                System.out.println(
                        "Complaint ID: "
                        + complaintId
                );

                System.out.println(
                        "Old Status: "
                        + oldStatus
                );

                System.out.println(
                        "New Status: "
                        + newStatus
                );

                System.out.println(
                        "Notification Added: "
                        + notificationAdded
                );

                System.out.println(
                        "=========================================="
                );

                /*
                 * =================================================
                 * USER EMAIL
                 * =================================================
                 */

                User user =
                        userDAO.getUserById(userId);

                if (user != null &&
                    user.getEmail() != null &&
                    !user.getEmail().trim().isEmpty()) {

                    emailService.sendEmail(
                            user.getEmail(),
                            "SmartFix - Complaint Status Updated",
                            "Hello "
                            + user.getName()
                            + ",\n\n"
                            + "Your complaint status has been updated.\n\n"
                            + "Complaint ID: #"
                            + complaintId
                            + "\n"
                            + "Previous Status: "
                            + oldStatus
                            + "\n"
                            + "Current Status: "
                            + newStatus
                            + "\n\n"
                            + "Please login to SmartFix to view the latest update.\n\n"
                            + "Regards,\n"
                            + "SmartFix Team"
                    );

                } else {

                    System.out.println(
                            "User email not found for user ID: "
                            + userId
                    );
                }
            }

            /*
             * SUCCESS
             */
            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaint-details?id="
                    + complaintId
                    + "&success=updated"
            );

        } catch (NumberFormatException e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaints"
                    + "?error=Invalid+complaint+ID"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/staff/complaints"
                    + "?error=Unable+to+update+complaint"
            );
        }
    }
}
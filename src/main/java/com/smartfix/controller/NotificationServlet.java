package com.smartfix.controller;

import java.io.IOException;
import java.util.List;

import com.smartfix.modelcom.Notification;
import com.smartfix.modelcom.Staff;
import com.smartfix.modelcom.User;
import com.smartfix.service.NotificationService;
import com.smartfix.service.impl.NotificationServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {

        notificationService =
                new NotificationServiceImpl();
    }

    // =========================================================
    // GET - DISPLAY NOTIFICATIONS
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        User user =
                (User) session.getAttribute("user");

        Staff staff =
                (Staff) session.getAttribute("staff");

        int recipientId;
        String recipientRole;

        // =====================================================
        // USER / ADMIN
        // =====================================================

        if (user != null) {

            recipientId =
                    user.getUserId();

            recipientRole =
                    user.getRole();

            if (recipientRole == null ||
                recipientRole.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp"
                );

                return;
            }

            recipientRole =
                    recipientRole.trim().toUpperCase();
        }

        // =====================================================
        // STAFF
        // =====================================================

        else if (staff != null) {

            recipientId =
                    staff.getStaffId();

            recipientRole =
                    "STAFF";
        }

        // =====================================================
        // NO LOGIN
        // =====================================================

        else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // =====================================================
        // DEBUG
        // =====================================================

        System.out.println(
                "========================================"
        );

        System.out.println(
                "NOTIFICATION PAGE"
        );

        System.out.println(
                "Recipient ID: "
                + recipientId
        );

        System.out.println(
                "Recipient Role: "
                + recipientRole
        );

        // =====================================================
        // GET NOTIFICATIONS
        // =====================================================

        List<Notification> notifications =
                notificationService
                        .getNotificationsByRecipient(
                                recipientId,
                                recipientRole
                        );

        // =====================================================
        // GET UNREAD COUNT
        // =====================================================

        int unreadCount =
                notificationService
                        .getUnreadNotificationCount(
                                recipientId,
                                recipientRole
                        );

        System.out.println(
                "Notifications Found: "
                + notifications.size()
        );

        System.out.println(
                "Unread Count: "
                + unreadCount
        );

        // Print notifications for debugging
        for (Notification notification : notifications) {

            System.out.println(
                    "Notification ID: "
                    + notification.getNotificationId()
                    + " | Recipient ID: "
                    + notification.getRecipientId()
                    + " | Role: "
                    + notification.getRecipientRole()
                    + " | Read: "
                    + notification.isRead()
                    + " | Message: "
                    + notification.getMessage()
            );
        }

        System.out.println(
                "========================================"
        );

        // =====================================================
        // SEND DATA TO JSP
        // =====================================================

        request.setAttribute(
                "notifications",
                notifications
        );

        request.setAttribute(
                "unreadCount",
                unreadCount
        );

        request.setAttribute(
                "recipientRole",
                recipientRole
        );

        // =====================================================
        // OPEN JSP
        // =====================================================

        request.getRequestDispatcher(
                "/WEB-INF/views/notifications.jsp"
        ).forward(
                request,
                response
        );
    }

    // =========================================================
    // POST - MARK READ
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        User user =
                (User) session.getAttribute("user");

        Staff staff =
                (Staff) session.getAttribute("staff");

        int recipientId;
        String recipientRole;

        // =====================================================
        // USER / ADMIN
        // =====================================================

        if (user != null) {

            recipientId =
                    user.getUserId();

            recipientRole =
                    user.getRole();

            if (recipientRole == null ||
                recipientRole.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/login.jsp"
                );

                return;
            }

            recipientRole =
                    recipientRole.trim().toUpperCase();
        }

        // =====================================================
        // STAFF
        // =====================================================

        else if (staff != null) {

            recipientId =
                    staff.getStaffId();

            recipientRole =
                    "STAFF";
        }

        // =====================================================
        // NO LOGIN
        // =====================================================

        else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        // =====================================================
        // GET ACTION
        // =====================================================

        String action =
                request.getParameter("action");

        // =====================================================
        // MARK ALL READ
        // =====================================================

        if ("markAllRead".equals(action)) {

            notificationService.markAllAsRead(
                    recipientId,
                    recipientRole
            );

            response.sendRedirect(
                    request.getContextPath()
                    + "/notifications"
            );

            return;
        }

        // =====================================================
        // MARK ONE READ
        // =====================================================

        if ("markRead".equals(action)) {

            String notificationIdParam =
                    request.getParameter(
                            "notificationId"
                    );

            if (notificationIdParam == null ||
                notificationIdParam.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/notifications"
                );

                return;
            }

            try {

                int notificationId =
                        Integer.parseInt(
                                notificationIdParam.trim()
                        );

                notificationService.markAsRead(
                        notificationId,
                        recipientId,
                        recipientRole
                );

            } catch (NumberFormatException e) {

                e.printStackTrace();
            }

            response.sendRedirect(
                    request.getContextPath()
                    + "/notifications"
            );

            return;
        }

        // =====================================================
        // INVALID ACTION
        // =====================================================

        response.sendRedirect(
                request.getContextPath()
                + "/notifications"
        );
    }
}
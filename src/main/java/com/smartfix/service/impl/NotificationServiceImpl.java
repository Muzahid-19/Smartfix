package com.smartfix.service.impl;

import java.util.List;

import com.smartfix.dao.NotificationDAO;
import com.smartfix.dao.impl.NotificationDAOImpl;
import com.smartfix.modelcom.Notification;
import com.smartfix.service.NotificationService;

public class NotificationServiceImpl
        implements NotificationService {

    private NotificationDAO notificationDAO;

    public NotificationServiceImpl() {
        notificationDAO =
                new NotificationDAOImpl();
    }

    @Override
    public boolean addNotification(
            Notification notification) {

        return notificationDAO.addNotification(
                notification
        );
    }

    @Override
    public List<Notification> getNotificationsByRecipient(
            int recipientId,
            String recipientRole) {

        return notificationDAO
                .getNotificationsByRecipient(
                        recipientId,
                        recipientRole
                );
    }

    @Override
    public int getUnreadNotificationCount(
            int recipientId,
            String recipientRole) {

        return notificationDAO
                .getUnreadNotificationCount(
                        recipientId,
                        recipientRole
                );
    }

    @Override
    public boolean markAsRead(
            int notificationId,
            int recipientId,
            String recipientRole) {

        return notificationDAO.markAsRead(
                notificationId,
                recipientId,
                recipientRole
        );
    }

    @Override
    public boolean markAllAsRead(
            int recipientId,
            String recipientRole) {

        return notificationDAO.markAllAsRead(
                recipientId,
                recipientRole
        );
    }
}
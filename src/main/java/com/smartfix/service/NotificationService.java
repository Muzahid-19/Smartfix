package com.smartfix.service;

import java.util.List;

import com.smartfix.modelcom.Notification;

public interface NotificationService {

    boolean addNotification(Notification notification);

    List<Notification> getNotificationsByRecipient(
            int recipientId,
            String recipientRole);

    int getUnreadNotificationCount(
            int recipientId,
            String recipientRole);

    boolean markAsRead(
            int notificationId,
            int recipientId,
            String recipientRole);

    boolean markAllAsRead(
            int recipientId,
            String recipientRole);
}
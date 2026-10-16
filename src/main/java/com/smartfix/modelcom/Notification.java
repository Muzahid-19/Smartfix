package com.smartfix.modelcom;

import java.sql.Timestamp;

public class Notification {

    private int notificationId;
    private int recipientId;
    private String recipientRole;
    private Integer complaintId;
    private String message;
    private boolean read;
    private Timestamp createdAt;

    public Notification() {
    }

    public Notification(int recipientId,
                        String recipientRole,
                        Integer complaintId,
                        String message) {

        this.recipientId = recipientId;
        this.recipientRole = recipientRole;
        this.complaintId = complaintId;
        this.message = message;
        this.read = false;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getRecipientId() {
        return recipientId;
    }

    public void setRecipientId(int recipientId) {
        this.recipientId = recipientId;
    }

    public String getRecipientRole() {
        return recipientRole;
    }

    public void setRecipientRole(String recipientRole) {
        this.recipientRole = recipientRole;
    }

    public Integer getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(Integer complaintId) {
        this.complaintId = complaintId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
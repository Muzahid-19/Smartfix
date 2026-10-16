package com.smartfix.modelcom;

import java.sql.Timestamp;

public class Complaint {

    private int complaintId;

    private int userId;

    private Integer staffId;

    private String title;

    private String description;

    private String category;

    private String priority;

    private String status;

    private String imagePath;

    private String resolutionNotes;

    private Timestamp createdAt;

    private Timestamp resolvedAt;

    private boolean deleted;


    public Complaint() {

    }


    public Complaint(int complaintId, int userId, Integer staffId,

                     String title, String description, String category,

                     String priority, String status, String imagePath,

                     String resolutionNotes, Timestamp createdAt,

                     Timestamp resolvedAt) {

        this.complaintId = complaintId;

        this.userId = userId;

        this.staffId = staffId;

        this.title = title;

        this.description = description;

        this.category = category;

        this.priority = priority;

        this.status = status;

        this.imagePath = imagePath;

        this.resolutionNotes = resolutionNotes;

        this.createdAt = createdAt;

        this.resolvedAt = resolvedAt;

    }


    public int getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
    }


    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    public Integer getStaffId() {
        return staffId;
    }

    public void setStaffId(Integer staffId) {
        this.staffId = staffId;
    }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }


    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }


    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }


    public String getResolutionNotes() {
        return resolutionNotes;
    }

    public void setResolutionNotes(String resolutionNotes) {
        this.resolutionNotes = resolutionNotes;
    }


    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }


    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }


    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }

}
package com.smartfix.modelcom;

import java.sql.Timestamp;

public class Rating {

    private int ratingId;
    private int complaintId;
    private int userId;
    private int rating;
    private String feedback;
    private Timestamp createdAt;

    public Rating() {
    }

    public Rating(int ratingId, int complaintId, int userId,
                  int rating, String feedback, Timestamp createdAt) {
        this.ratingId = ratingId;
        this.complaintId = complaintId;
        this.userId = userId;
        this.rating = rating;
        this.feedback = feedback;
        this.createdAt = createdAt;
    }

    public int getRatingId() {
        return ratingId;
    }

    public void setRatingId(int ratingId) {
        this.ratingId = ratingId;
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

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
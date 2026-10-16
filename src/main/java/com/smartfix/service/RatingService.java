package com.smartfix.service;

import java.util.List;

import com.smartfix.modelcom.Rating;

public interface RatingService {

    boolean addRating(Rating rating);

    Rating getRatingByComplaintId(int complaintId);

    List<Rating> getRatingsByUserId(int userId);

    List<Rating> getAllRatings();

    boolean updateRating(Rating rating);

    boolean deleteRating(int ratingId);
}
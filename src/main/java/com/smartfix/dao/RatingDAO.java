package com.smartfix.dao;

import java.util.List;
import com.smartfix.modelcom.Rating;

public interface RatingDAO {

    boolean addRating(Rating rating);

    Rating getRatingByComplaintId(int complaintId);

    List<Rating> getRatingsByUserId(int userId);

    List<Rating> getAllRatings();

    boolean updateRating(Rating rating);

    boolean deleteRating(int ratingId);
}
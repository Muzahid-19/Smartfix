package com.smartfix.service.impl;

import java.util.List;

import com.smartfix.dao.RatingDAO;
import com.smartfix.dao.impl.RatingDAOImpl;
import com.smartfix.modelcom.Rating;
import com.smartfix.service.RatingService;

public class RatingServiceImpl implements RatingService {

    private RatingDAO ratingDAO;

    public RatingServiceImpl() {

        ratingDAO = new RatingDAOImpl();
    }

    @Override
    public boolean addRating(Rating rating) {

        return ratingDAO.addRating(rating);
    }

    @Override
    public Rating getRatingByComplaintId(int complaintId) {

        return ratingDAO.getRatingByComplaintId(complaintId);
    }

    @Override
    public List<Rating> getRatingsByUserId(int userId) {

        return ratingDAO.getRatingsByUserId(userId);
    }

    @Override
    public List<Rating> getAllRatings() {

        return ratingDAO.getAllRatings();
    }

    @Override
    public boolean updateRating(Rating rating) {

        return ratingDAO.updateRating(rating);
    }

    @Override
    public boolean deleteRating(int ratingId) {

        return ratingDAO.deleteRating(ratingId);
    }
}
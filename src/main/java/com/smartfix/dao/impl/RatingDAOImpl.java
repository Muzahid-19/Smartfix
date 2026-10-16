package com.smartfix.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.smartfix.dao.RatingDAO;
import com.smartfix.modelcom.Rating;
import com.smartfix.utli.DBConnection;

public class RatingDAOImpl implements RatingDAO {

    @Override
    public boolean addRating(Rating rating) {

        String sql = "INSERT INTO ratings "
                + "(complaint_id, user_id, rating, feedback) "
                + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, rating.getComplaintId());
            ps.setInt(2, rating.getUserId());
            ps.setInt(3, rating.getRating());
            ps.setString(4, rating.getFeedback());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Rating getRatingByComplaintId(int complaintId) {

        String sql = "SELECT * FROM ratings WHERE complaint_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, complaintId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractRating(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Rating> getRatingsByUserId(int userId) {

        List<Rating> ratings = new ArrayList<>();

        String sql = "SELECT * FROM ratings "
                + "WHERE user_id = ? "
                + "ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ratings.add(extractRating(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ratings;
    }

    @Override
    public List<Rating> getAllRatings() {

        List<Rating> ratings = new ArrayList<>();

        String sql = "SELECT * FROM ratings "
                + "ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ratings.add(extractRating(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return ratings;
    }

    @Override
    public boolean updateRating(Rating rating) {

        String sql = "UPDATE ratings SET rating = ?, feedback = ? "
                + "WHERE rating_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, rating.getRating());
            ps.setString(2, rating.getFeedback());
            ps.setInt(3, rating.getRatingId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteRating(int ratingId) {

        String sql = "DELETE FROM ratings WHERE rating_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, ratingId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Rating extractRating(ResultSet rs) throws SQLException {

        Rating rating = new Rating();

        rating.setRatingId(rs.getInt("rating_id"));
        rating.setComplaintId(rs.getInt("complaint_id"));
        rating.setUserId(rs.getInt("user_id"));
        rating.setRating(rs.getInt("rating"));
        rating.setFeedback(rs.getString("feedback"));
        rating.setCreatedAt(rs.getTimestamp("created_at"));

        return rating;
    }
}
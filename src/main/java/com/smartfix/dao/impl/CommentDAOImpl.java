package com.smartfix.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.smartfix.dao.CommentDAO;
import com.smartfix.modelcom.Comment;
import com.smartfix.utli.DBConnection;

public class CommentDAOImpl implements CommentDAO {

    @Override
    public boolean addComment(Comment comment) {

        String sql = "INSERT INTO comments "
                   + "(complaint_id, user_id, staff_id, comment_text) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, comment.getComplaintId());

            /*
             * USER COMMENT
             *
             * getUserId() returns 0 when there is no user.
             * Therefore:
             * 0 = no user
             * >0 = user
             */
            if (comment.getUserId() > 0) {

                ps.setInt(2, comment.getUserId());

            } else {

                ps.setNull(2, java.sql.Types.INTEGER);
            }

            /*
             * STAFF COMMENT
             */
            if (comment.getStaffId() != null) {

                ps.setInt(3, comment.getStaffId());

            } else {

                ps.setNull(3, java.sql.Types.INTEGER);
            }

            ps.setString(4, comment.getCommentText());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    @Override
    public Comment getCommentById(int commentId) {

        String sql = "SELECT * FROM comments "
                   + "WHERE comment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, commentId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    return extractComment(rs);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }


    @Override
    public List<Comment> getCommentsByComplaintId(int complaintId) {

        List<Comment> comments = new ArrayList<>();

        String sql = "SELECT * FROM comments "
                   + "WHERE complaint_id = ? "
                   + "ORDER BY created_at ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, complaintId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    comments.add(extractComment(rs));
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return comments;
    }


    @Override
    public boolean deleteComment(int commentId) {

        String sql = "DELETE FROM comments "
                   + "WHERE comment_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, commentId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    private Comment extractComment(ResultSet rs)
            throws SQLException {

        Comment comment = new Comment();

        comment.setCommentId(
                rs.getInt("comment_id")
        );

        comment.setComplaintId(
                rs.getInt("complaint_id")
        );


        // Get user_id
        int userId = rs.getInt("user_id");

        if (!rs.wasNull()) {

            comment.setUserId(userId);
        }


        // Get staff_id
        int staffId = rs.getInt("staff_id");

        if (!rs.wasNull()) {

            comment.setStaffId(staffId);
        }


        comment.setCommentText(
                rs.getString("comment_text")
        );

        comment.setCreatedAt(
                rs.getTimestamp("created_at")
        );

        return comment;
    }
}
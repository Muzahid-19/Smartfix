
package com.smartfix.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.smartfix.dao.ComplaintDAO;
import com.smartfix.modelcom.Complaint;
import com.smartfix.utli.DBConnection;

public class ComplaintDAOImpl implements ComplaintDAO {

    @Override
    public int addComplaint(Complaint complaint) {

        String sql = "INSERT INTO complaints "
                + "(user_id, title, description, category, priority, status, image_path) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(
                     sql,
                     Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, complaint.getUserId());
            ps.setString(2, complaint.getTitle());
            ps.setString(3, complaint.getDescription());
            ps.setString(4, complaint.getCategory());
            ps.setString(5, complaint.getPriority());
            ps.setString(6, complaint.getStatus());
            ps.setString(7, complaint.getImagePath());

            int rows = ps.executeUpdate();

            if (rows > 0) {

                try (ResultSet rs = ps.getGeneratedKeys()) {

                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }


    @Override
    public Complaint getComplaintById(int complaintId) {

        String sql = "SELECT * FROM complaints "
                + "WHERE complaint_id = ? "
                + "AND is_deleted = 0";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, complaintId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractComplaint(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }


    @Override
    public List<Complaint> getComplaintsByUserId(int userId) {

        List<Complaint> complaints = new ArrayList<>();

        String sql = "SELECT * FROM complaints "
                + "WHERE user_id = ? "
                + "AND is_deleted = 0 "
                + "ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                complaints.add(extractComplaint(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return complaints;
    }


    @Override
    public List<Complaint> getComplaintsByStaffId(int staffId) {

        List<Complaint> complaints = new ArrayList<>();

        String sql = "SELECT * FROM complaints "
                + "WHERE staff_id = ? "
                + "AND is_deleted = 0 "
                + "ORDER BY "
                + "CASE priority "
                + "WHEN 'HIGH' THEN 1 "
                + "WHEN 'MEDIUM' THEN 2 "
                + "WHEN 'LOW' THEN 3 "
                + "ELSE 4 "
                + "END, created_at ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, staffId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                complaints.add(extractComplaint(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return complaints;
    }


    @Override
    public List<Complaint> getAllComplaints() {

        List<Complaint> complaints = new ArrayList<>();

        String sql = "SELECT * FROM complaints "
                + "WHERE is_deleted = 0 "
                + "ORDER BY created_at DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                complaints.add(extractComplaint(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return complaints;
    }


    @Override
    public boolean assignComplaint(int complaintId, int staffId) {

        String sql = "UPDATE complaints "
                + "SET staff_id = ?, status = 'ASSIGNED' "
                + "WHERE complaint_id = ? "
                + "AND is_deleted = 0";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, staffId);
            ps.setInt(2, complaintId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean updateComplaintStatus(int complaintId, String status) {

        String sql;

        if ("RESOLVED".equalsIgnoreCase(status)) {

            sql = "UPDATE complaints "
                    + "SET status = ?, resolved_at = CURRENT_TIMESTAMP "
                    + "WHERE complaint_id = ? "
                    + "AND is_deleted = 0";

        } else {

            sql = "UPDATE complaints "
                    + "SET status = ?, resolved_at = NULL "
                    + "WHERE complaint_id = ? "
                    + "AND is_deleted = 0";
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, complaintId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean updateComplaintPriority(int complaintId,
                                            String priority) {

        String sql = "UPDATE complaints "
                + "SET priority = ? "
                + "WHERE complaint_id = ? "
                + "AND is_deleted = 0";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, priority);
            ps.setInt(2, complaintId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean addResolutionNotes(int complaintId,
                                      String resolutionNotes) {

        String sql = "UPDATE complaints "
                + "SET resolution_notes = ? "
                + "WHERE complaint_id = ? "
                + "AND is_deleted = 0";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, resolutionNotes);
            ps.setInt(2, complaintId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    /*
     * SOFT DELETE
     *
     * The complaint is NOT physically removed.
     * is_deleted is changed from 0 to 1.
     *
     * Only PENDING complaints can be deleted.
     */
    @Override
    public boolean deleteComplaint(int complaintId) {

        String sql = "UPDATE complaints "
                + "SET is_deleted = 1 "
                + "WHERE complaint_id = ? "
                + "AND status = 'PENDING' "
                + "AND is_deleted = 0";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, complaintId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public Map<String, Integer> getComplaintCountByCategory() {

        Map<String, Integer> categoryCounts =
                new LinkedHashMap<>();

        String sql = "SELECT category, COUNT(*) AS complaint_count "
                + "FROM complaints "
                + "WHERE is_deleted = 0 "
                + "GROUP BY category "
                + "ORDER BY complaint_count DESC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                String category =
                        rs.getString("category");

                if (category == null ||
                    category.trim().isEmpty()) {

                    category = "Other";
                }

                int count =
                        rs.getInt("complaint_count");

                categoryCounts.put(
                        category,
                        count
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return categoryCounts;
    }


    @Override
    public Map<String, Integer> getComplaintCountByPriority() {

        Map<String, Integer> priorityCounts =
                new LinkedHashMap<>();

        String sql = "SELECT priority, COUNT(*) AS complaint_count "
                + "FROM complaints "
                + "WHERE is_deleted = 0 "
                + "GROUP BY priority "
                + "ORDER BY "
                + "CASE priority "
                + "WHEN 'HIGH' THEN 1 "
                + "WHEN 'MEDIUM' THEN 2 "
                + "WHEN 'LOW' THEN 3 "
                + "ELSE 4 "
                + "END";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                String priority =
                        rs.getString("priority");

                if (priority == null ||
                    priority.trim().isEmpty()) {

                    priority = "OTHER";
                }

                int count =
                        rs.getInt("complaint_count");

                priorityCounts.put(
                        priority,
                        count
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return priorityCounts;
    }


    @Override
    public List<Complaint> getHighPriorityComplaints() {

        List<Complaint> complaints =
                new ArrayList<>();

        String sql = "SELECT * FROM complaints "
                + "WHERE UPPER(priority) = 'HIGH' "
                + "AND is_deleted = 0 "
                + "ORDER BY created_at ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                complaints.add(
                        extractComplaint(rs)
                );
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return complaints;
    }


    private Complaint extractComplaint(
            ResultSet rs) throws SQLException {

        Complaint complaint =
                new Complaint();

        complaint.setComplaintId(
                rs.getInt("complaint_id")
        );

        complaint.setUserId(
                rs.getInt("user_id")
        );

        int staffId =
                rs.getInt("staff_id");

        if (rs.wasNull()) {

            complaint.setStaffId(null);

        } else {

            complaint.setStaffId(staffId);
        }

        complaint.setTitle(
                rs.getString("title")
        );

        complaint.setDescription(
                rs.getString("description")
        );

        complaint.setCategory(
                rs.getString("category")
        );

        complaint.setPriority(
                rs.getString("priority")
        );

        complaint.setStatus(
                rs.getString("status")
        );

        complaint.setImagePath(
                rs.getString("image_path")
        );

        complaint.setResolutionNotes(
                rs.getString("resolution_notes")
        );

        complaint.setCreatedAt(
                rs.getTimestamp("created_at")
        );

        complaint.setResolvedAt(
                rs.getTimestamp("resolved_at")
        );

        complaint.setDeleted(
                rs.getBoolean("is_deleted")
        );

        return complaint;
    }
}

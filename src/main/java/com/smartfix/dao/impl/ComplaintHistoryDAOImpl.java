package com.smartfix.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.smartfix.dao.ComplaintHistoryDAO;
import com.smartfix.modelcom.ComplaintHistory;
import com.smartfix.utli.DBConnection;

public class ComplaintHistoryDAOImpl
        implements ComplaintHistoryDAO {

    @Override
    public boolean addHistory(
            ComplaintHistory history) {

        String sql =
                "INSERT INTO complaint_history "
                + "(complaint_id, changed_by, old_status, "
                + "new_status, remarks) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection =
                    DBConnection.getConnection();
             PreparedStatement ps =
                    connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    history.getComplaintId()
            );

            ps.setInt(
                    2,
                    history.getChangedBy()
            );

            ps.setString(
                    3,
                    history.getOldStatus()
            );

            ps.setString(
                    4,
                    history.getNewStatus()
            );

            ps.setString(
                    5,
                    history.getRemarks()
            );

            int result =
                    ps.executeUpdate();

            System.out.println(
                    "History INSERT result: "
                    + result
            );

            return result > 0;

        } catch (SQLException e) {

            System.out.println(
                    "ERROR INSERTING COMPLAINT HISTORY"
            );

            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<ComplaintHistory>
    getHistoryByComplaintId(
            int complaintId) {

        List<ComplaintHistory> historyList =
                new ArrayList<>();

        String sql =
                "SELECT * FROM complaint_history "
                + "WHERE complaint_id = ? "
                + "ORDER BY changed_at ASC";

        try (Connection connection =
                    DBConnection.getConnection();
             PreparedStatement ps =
                    connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    complaintId
            );

            try (ResultSet rs =
                    ps.executeQuery()) {

                while (rs.next()) {

                    historyList.add(
                            extractHistory(rs)
                    );
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "ERROR FETCHING COMPLAINT HISTORY"
            );

            e.printStackTrace();
        }

        System.out.println(
                "History records found for complaint "
                + complaintId
                + ": "
                + historyList.size()
        );

        return historyList;
    }

    @Override
    public ComplaintHistory getHistoryById(
            int historyId) {

        String sql =
                "SELECT * FROM complaint_history "
                + "WHERE history_id = ?";

        try (Connection connection =
                    DBConnection.getConnection();
             PreparedStatement ps =
                    connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    historyId
            );

            try (ResultSet rs =
                    ps.executeQuery()) {

                if (rs.next()) {

                    return extractHistory(rs);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }

    private ComplaintHistory extractHistory(
            ResultSet rs)
            throws SQLException {

        ComplaintHistory history =
                new ComplaintHistory();

        history.setHistoryId(
                rs.getInt("history_id")
        );

        history.setComplaintId(
                rs.getInt("complaint_id")
        );

        history.setChangedBy(
                rs.getInt("changed_by")
        );

        history.setOldStatus(
                rs.getString("old_status")
        );

        history.setNewStatus(
                rs.getString("new_status")
        );

        history.setRemarks(
                rs.getString("remarks")
        );

        history.setChangedAt(
                rs.getTimestamp("changed_at")
        );

        return history;
    }
}
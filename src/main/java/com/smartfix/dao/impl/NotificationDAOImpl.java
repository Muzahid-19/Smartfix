package com.smartfix.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.smartfix.dao.NotificationDAO;
import com.smartfix.modelcom.Notification;
import com.smartfix.utli.DBConnection;

public class NotificationDAOImpl implements NotificationDAO {

    // =========================================================
    // ADD NOTIFICATION
    // =========================================================

    @Override
    public boolean addNotification(Notification notification) {

        String sql =
                "INSERT INTO notifications "
                + "(recipient_id, recipient_role, complaint_id, message, is_read) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    notification.getRecipientId()
            );

            ps.setString(
                    2,
                    notification.getRecipientRole()
                            .trim()
                            .toUpperCase()
            );

            if (notification.getComplaintId() != null) {

                ps.setInt(
                        3,
                        notification.getComplaintId()
                );

            } else {

                ps.setNull(
                        3,
                        java.sql.Types.INTEGER
                );
            }

            ps.setString(
                    4,
                    notification.getMessage()
            );

            /*
             * New notifications must be UNREAD.
             */
            ps.setBoolean(
                    5,
                    false
            );

            int rows =
                    ps.executeUpdate();

            System.out.println(
                    "Notification inserted. Rows: "
                    + rows
            );

            return rows > 0;

        } catch (SQLException e) {

            System.out.println(
                    "ERROR: Unable to add notification"
            );

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // GET NOTIFICATIONS BY RECIPIENT
    // =========================================================

    @Override
    public List<Notification> getNotificationsByRecipient(
            int recipientId,
            String recipientRole) {

        List<Notification> notifications =
                new ArrayList<>();

        String sql =
                "SELECT * FROM notifications "
                + "WHERE recipient_id = ? "
                + "AND UPPER(TRIM(recipient_role)) = ? "
                + "ORDER BY created_at DESC";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    recipientId
            );

            ps.setString(
                    2,
                    recipientRole
                            .trim()
                            .toUpperCase()
            );

            try (ResultSet rs =
                         ps.executeQuery()) {

                while (rs.next()) {

                    Notification notification =
                            extractNotification(rs);

                    notifications.add(
                            notification
                    );
                }
            }

            System.out.println(
                    "=========================================="
            );

            System.out.println(
                    "NOTIFICATION DAO"
            );

            System.out.println(
                    "Recipient ID: "
                    + recipientId
            );

            System.out.println(
                    "Recipient Role: "
                    + recipientRole
            );

            System.out.println(
                    "Notifications Found: "
                    + notifications.size()
            );

            System.out.println(
                    "=========================================="
            );

        } catch (SQLException e) {

            System.out.println(
                    "ERROR: Unable to get notifications"
            );

            e.printStackTrace();
        }

        return notifications;
    }


    // =========================================================
    // GET UNREAD COUNT
    // =========================================================

    @Override
    public int getUnreadNotificationCount(
            int recipientId,
            String recipientRole) {

        String sql =
                "SELECT COUNT(*) "
                + "FROM notifications "
                + "WHERE recipient_id = ? "
                + "AND UPPER(TRIM(recipient_role)) = ? "
                + "AND is_read = 0";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    recipientId
            );

            ps.setString(
                    2,
                    recipientRole
                            .trim()
                            .toUpperCase()
            );

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {

                    int count =
                            rs.getInt(1);

                    System.out.println(
                            "Unread notifications for "
                            + recipientRole
                            + " ID "
                            + recipientId
                            + ": "
                            + count
                    );

                    return count;
                }
            }

        } catch (SQLException e) {

            System.out.println(
                    "ERROR: Unable to get unread count"
            );

            e.printStackTrace();
        }

        return 0;
    }


    // =========================================================
    // MARK ONE NOTIFICATION AS READ
    // =========================================================

    @Override
    public boolean markAsRead(
            int notificationId,
            int recipientId,
            String recipientRole) {

        String sql =
                "UPDATE notifications "
                + "SET is_read = 1 "
                + "WHERE notification_id = ? "
                + "AND recipient_id = ? "
                + "AND UPPER(TRIM(recipient_role)) = ?";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    notificationId
            );

            ps.setInt(
                    2,
                    recipientId
            );

            ps.setString(
                    3,
                    recipientRole
                            .trim()
                            .toUpperCase()
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // MARK ALL AS READ
    // =========================================================

    @Override
    public boolean markAllAsRead(
            int recipientId,
            String recipientRole) {

        String sql =
                "UPDATE notifications "
                + "SET is_read = 1 "
                + "WHERE recipient_id = ? "
                + "AND UPPER(TRIM(recipient_role)) = ? "
                + "AND is_read = 0";

        try (Connection connection =
                     DBConnection.getConnection();

             PreparedStatement ps =
                     connection.prepareStatement(sql)) {

            ps.setInt(
                    1,
                    recipientId
            );

            ps.setString(
                    2,
                    recipientRole
                            .trim()
                            .toUpperCase()
            );

            return ps.executeUpdate() >= 0;

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return false;
    }


    // =========================================================
    // EXTRACT NOTIFICATION
    // =========================================================

    private Notification extractNotification(
            ResultSet rs) throws SQLException {

        Notification notification =
                new Notification();

        notification.setNotificationId(
                rs.getInt(
                        "notification_id"
                )
        );

        notification.setRecipientId(
                rs.getInt(
                        "recipient_id"
                )
        );

        notification.setRecipientRole(
                rs.getString(
                        "recipient_role"
                )
        );

        int complaintId =
                rs.getInt(
                        "complaint_id"
                );

        if (rs.wasNull()) {

            notification.setComplaintId(
                    null
            );

        } else {

            notification.setComplaintId(
                    complaintId
            );
        }

        notification.setMessage(
                rs.getString(
                        "message"
                )
        );

        notification.setRead(
                rs.getBoolean(
                        "is_read"
                )
        );

        notification.setCreatedAt(
                rs.getTimestamp(
                        "created_at"
                )
        );

        return notification;
    }
}
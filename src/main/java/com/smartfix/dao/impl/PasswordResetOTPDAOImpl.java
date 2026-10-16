
package com.smartfix.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.smartfix.dao.PasswordResetOTPDAO;
import com.smartfix.modelcom.PasswordResetOTP;
import com.smartfix.utli.DBConnection;

public class PasswordResetOTPDAOImpl
        implements PasswordResetOTPDAO {

    @Override
    public boolean saveOTP(PasswordResetOTP passwordResetOTP) {

        String sql =
            "INSERT INTO password_reset_otp "
            + "(email, otp, account_type, expires_at, is_verified) "
            + "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, passwordResetOTP.getEmail());
            ps.setString(2, passwordResetOTP.getOtp());
            ps.setString(3, passwordResetOTP.getAccountType());
            ps.setTimestamp(4, passwordResetOTP.getExpiresAt());
            ps.setBoolean(5, false);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public PasswordResetOTP getLatestOTPByEmail(String email) {

        String sql =
            "SELECT * FROM password_reset_otp "
            + "WHERE email = ? "
            + "AND is_verified = 0 "
            + "AND expires_at > CURRENT_TIMESTAMP "
            + "ORDER BY created_at DESC, otp_id DESC "
            + "LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, email.trim());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractOTP(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean verifyOTP(String email, String otp) {

        String sql =
            "SELECT otp_id FROM password_reset_otp "
            + "WHERE email = ? "
            + "AND otp = ? "
            + "AND is_verified = 0 "
            + "AND expires_at > CURRENT_TIMESTAMP "
            + "ORDER BY created_at DESC, otp_id DESC "
            + "LIMIT 1";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, email.trim());
            ps.setString(2, otp.trim());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean markOTPAsVerified(int otpId) {

        String sql =
            "UPDATE password_reset_otp "
            + "SET is_verified = 1 "
            + "WHERE otp_id = ? "
            + "AND is_verified = 0 "
            + "AND expires_at > CURRENT_TIMESTAMP";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, otpId);

            return ps.executeUpdate() == 1;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteOTPByEmail(String email) {

        String sql =
            "DELETE FROM password_reset_otp WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, email.trim());
            ps.executeUpdate();

            return true;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private PasswordResetOTP extractOTP(ResultSet rs)
            throws SQLException {

        PasswordResetOTP otp = new PasswordResetOTP();

        otp.setOtpId(rs.getInt("otp_id"));
        otp.setEmail(rs.getString("email"));
        otp.setOtp(rs.getString("otp"));
        otp.setAccountType(rs.getString("account_type"));
        otp.setExpiresAt(rs.getTimestamp("expires_at"));
        otp.setVerified(rs.getBoolean("is_verified"));
        otp.setCreatedAt(rs.getTimestamp("created_at"));

        return otp;
    }
}

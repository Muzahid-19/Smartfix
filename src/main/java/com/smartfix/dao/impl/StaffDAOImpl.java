
package com.smartfix.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.smartfix.dao.StaffDAO;
import com.smartfix.modelcom.Staff;
import com.smartfix.utli.DBConnection;

public class StaffDAOImpl implements StaffDAO {

    @Override
    public boolean registerStaff(Staff staff) {

        String sql = "INSERT INTO staff "
                + "(name, email, password, phone, specialization) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, staff.getName());
            ps.setString(2, staff.getEmail());
            ps.setString(3, staff.getPassword());
            ps.setString(4, staff.getPhone());
            ps.setString(5, staff.getSpecialization());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Login lookup by email only.
    // Password verification is performed in StaffServiceImpl.
    @Override
    public Staff loginStaff(String email, String password) {
        return getStaffByEmail(email);
    }

    @Override
    public Staff getStaffById(int staffId) {

        String sql = "SELECT * FROM staff WHERE staff_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, staffId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractStaff(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public Staff getStaffByEmail(String email) {

        String sql = "SELECT * FROM staff WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractStaff(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Staff> getAllStaff() {

        List<Staff> staffList = new ArrayList<>();

        String sql = "SELECT * FROM staff ORDER BY staff_id ASC";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                staffList.add(extractStaff(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return staffList;
    }

    @Override
    public boolean updateStaff(Staff staff) {

        String sql = "UPDATE staff SET "
                + "name = ?, email = ?, password = ?, "
                + "phone = ?, specialization = ? "
                + "WHERE staff_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, staff.getName());
            ps.setString(2, staff.getEmail());
            ps.setString(3, staff.getPassword());
            ps.setString(4, staff.getPhone());
            ps.setString(5, staff.getSpecialization());
            ps.setInt(6, staff.getStaffId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updatePasswordByEmail(String email, String password) {

        String sql = "UPDATE staff SET password = ? WHERE email = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setString(1, password);
            ps.setString(2, email);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteStaff(int staffId) {

        String sql = "DELETE FROM staff WHERE staff_id = ?";

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement ps = connection.prepareStatement(sql)) {

            ps.setInt(1, staffId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    private Staff extractStaff(ResultSet rs) throws SQLException {

        Staff staff = new Staff();

        staff.setStaffId(rs.getInt("staff_id"));
        staff.setName(rs.getString("name"));
        staff.setEmail(rs.getString("email"));
        staff.setPassword(rs.getString("password"));
        staff.setPhone(rs.getString("phone"));
        staff.setSpecialization(rs.getString("specialization"));

        return staff;
    }
}

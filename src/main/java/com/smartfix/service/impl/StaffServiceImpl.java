
package com.smartfix.service.impl;

import java.util.List;

import com.smartfix.dao.StaffDAO;
import com.smartfix.dao.impl.StaffDAOImpl;
import com.smartfix.modelcom.Staff;
import com.smartfix.service.StaffService;
import com.smartfix.utli.PasswordUtil;

public class StaffServiceImpl implements StaffService {

    private StaffDAO staffDAO;

    public StaffServiceImpl() {
        staffDAO = new StaffDAOImpl();
    }

    @Override
    public boolean registerStaff(Staff staff) {

        if (staff == null) {
            return false;
        }

        if (staff.getName() == null
                || staff.getName().trim().isEmpty()) {
            return false;
        }

        if (staff.getEmail() == null
                || staff.getEmail().trim().isEmpty()) {
            return false;
        }

        if (staff.getPassword() == null
                || staff.getPassword().isEmpty()) {
            return false;
        }

        // Hash the password before saving staff
        String hashedPassword =
                PasswordUtil.hashPassword(staff.getPassword());

        staff.setPassword(hashedPassword);

        return staffDAO.registerStaff(staff);
    }

    @Override
    public Staff loginStaff(String email, String password) {

        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {
            return null;
        }

        // Retrieve staff by email
        Staff staff = staffDAO.getStaffByEmail(email.trim());

        if (staff == null || staff.getPassword() == null) {
            return null;
        }

        // Verify the entered password against the BCrypt hash
        if (PasswordUtil.checkPassword(
                password, staff.getPassword())) {
            return staff;
        }

        return null;
    }

    @Override
    public Staff getStaffById(int staffId) {
        return staffDAO.getStaffById(staffId);
    }

    @Override
    public Staff getStaffByEmail(String email) {

        if (email == null || email.trim().isEmpty()) {
            return null;
        }

        return staffDAO.getStaffByEmail(email.trim());
    }

    @Override
    public List<Staff> getAllStaff() {
        return staffDAO.getAllStaff();
    }

    @Override
    public boolean updateStaff(Staff staff) {

        if (staff == null || staff.getStaffId() <= 0) {
            return false;
        }

        return staffDAO.updateStaff(staff);
    }

    @Override
    public boolean deleteStaff(int staffId) {

        if (staffId <= 0) {
            return false;
        }

        return staffDAO.deleteStaff(staffId);
    }
}

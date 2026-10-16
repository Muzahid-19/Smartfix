package com.smartfix.dao;

import java.util.List;

import com.smartfix.modelcom.Staff;

public interface StaffDAO {

    boolean registerStaff(Staff staff);

    Staff loginStaff(String email, String password);

    Staff getStaffById(int staffId);

    Staff getStaffByEmail(String email);

    List<Staff> getAllStaff();

    boolean updateStaff(Staff staff);

    boolean updatePasswordByEmail(String email, String password);

    boolean deleteStaff(int staffId);
}
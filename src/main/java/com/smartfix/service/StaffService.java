package com.smartfix.service;

import java.util.List;
import com.smartfix.modelcom.Staff;

public interface StaffService {

    boolean registerStaff(Staff staff);

    Staff loginStaff(String email, String password);

    Staff getStaffById(int staffId);

    Staff getStaffByEmail(String email);

    List<Staff> getAllStaff();

    boolean updateStaff(Staff staff);

    boolean deleteStaff(int staffId);
}
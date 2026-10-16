package com.smartfix.dao;

import java.util.List;
import java.util.Map;

import com.smartfix.modelcom.Complaint;

public interface ComplaintDAO {

	int addComplaint(Complaint complaint);

    Complaint getComplaintById(int complaintId);

    List<Complaint> getComplaintsByUserId(int userId);

    List<Complaint> getComplaintsByStaffId(int staffId);

    List<Complaint> getAllComplaints();

    boolean assignComplaint(int complaintId, int staffId);

    boolean updateComplaintStatus(int complaintId, String status);

    boolean updateComplaintPriority(int complaintId, String priority);

    boolean addResolutionNotes(int complaintId, String resolutionNotes);

    boolean deleteComplaint(int complaintId);

    // Category-wise complaint count
    Map<String, Integer> getComplaintCountByCategory();

    // Priority-wise complaint count
    Map<String, Integer> getComplaintCountByPriority();

    // Get all HIGH priority complaints
    List<Complaint> getHighPriorityComplaints();
}
package com.smartfix.service.impl;

import java.util.List;
import java.util.Map;

import com.smartfix.dao.ComplaintDAO;
import com.smartfix.dao.impl.ComplaintDAOImpl;
import com.smartfix.modelcom.Complaint;
import com.smartfix.service.ComplaintService;

public class ComplaintServiceImpl implements ComplaintService {

    private ComplaintDAO complaintDAO;

    public ComplaintServiceImpl() {

        complaintDAO =
                new ComplaintDAOImpl();
    }

    @Override
    public int addComplaint(Complaint complaint) {

        return complaintDAO.addComplaint(complaint);
    }

    @Override
    public Complaint getComplaintById(int complaintId) {

        return complaintDAO.getComplaintById(complaintId);
    }

    @Override
    public List<Complaint> getComplaintsByUserId(int userId) {

        return complaintDAO.getComplaintsByUserId(userId);
    }

    @Override
    public List<Complaint> getComplaintsByStaffId(int staffId) {

        return complaintDAO.getComplaintsByStaffId(staffId);
    }

    @Override
    public List<Complaint> getAllComplaints() {

        return complaintDAO.getAllComplaints();
    }

    @Override
    public boolean assignComplaint(int complaintId,
                                   int staffId) {

        return complaintDAO.assignComplaint(
                complaintId,
                staffId
        );
    }

    @Override
    public boolean updateComplaintStatus(int complaintId,
                                         String status) {

        return complaintDAO.updateComplaintStatus(
                complaintId,
                status
        );
    }

    @Override
    public boolean updateComplaintPriority(int complaintId,
                                           String priority) {

        return complaintDAO.updateComplaintPriority(
                complaintId,
                priority
        );
    }

    @Override
    public boolean addResolutionNotes(int complaintId,
                                      String resolutionNotes) {

        return complaintDAO.addResolutionNotes(
                complaintId,
                resolutionNotes
        );
    }

    @Override
    public boolean deleteComplaint(int complaintId) {

        return complaintDAO.deleteComplaint(
                complaintId
        );
    }

    @Override
    public Map<String, Integer> getComplaintCountByCategory() {

        return complaintDAO.getComplaintCountByCategory();
    }

    @Override
    public Map<String, Integer> getComplaintCountByPriority() {

        return complaintDAO.getComplaintCountByPriority();
    }

    @Override
    public List<Complaint> getHighPriorityComplaints() {

        return complaintDAO.getHighPriorityComplaints();
    }
}
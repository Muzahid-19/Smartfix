package com.smartfix.service.impl;

import java.util.List;

import com.smartfix.dao.ComplaintHistoryDAO;
import com.smartfix.dao.impl.ComplaintHistoryDAOImpl;
import com.smartfix.modelcom.ComplaintHistory;
import com.smartfix.service.ComplaintHistoryService;

public class ComplaintHistoryServiceImpl implements ComplaintHistoryService {

    private ComplaintHistoryDAO complaintHistoryDAO;

    public ComplaintHistoryServiceImpl() {
        complaintHistoryDAO = new ComplaintHistoryDAOImpl();
    }

    @Override
    public boolean addHistory(ComplaintHistory history) {
        return complaintHistoryDAO.addHistory(history);
    }

    @Override
    public List<ComplaintHistory> getHistoryByComplaintId(int complaintId) {
        return complaintHistoryDAO.getHistoryByComplaintId(complaintId);
    }

    @Override
    public ComplaintHistory getHistoryById(int historyId) {
        return complaintHistoryDAO.getHistoryById(historyId);
    }
}
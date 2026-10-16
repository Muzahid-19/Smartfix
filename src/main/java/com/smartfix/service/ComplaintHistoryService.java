package com.smartfix.service;

import java.util.List;

import com.smartfix.modelcom.ComplaintHistory;

public interface ComplaintHistoryService {

    boolean addHistory(ComplaintHistory history);

    List<ComplaintHistory> getHistoryByComplaintId(int complaintId);

    ComplaintHistory getHistoryById(int historyId);
}
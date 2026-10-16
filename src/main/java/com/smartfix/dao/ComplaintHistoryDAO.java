package com.smartfix.dao;

import java.util.List;

import com.smartfix.modelcom.ComplaintHistory;

public interface ComplaintHistoryDAO {

    boolean addHistory(ComplaintHistory history);

    List<ComplaintHistory> getHistoryByComplaintId(int complaintId);

    ComplaintHistory getHistoryById(int historyId);
}
package com.smartfix.modelcom;

import java.sql.Timestamp;

public class ComplaintHistory {

    private int historyId;
    private int complaintId;
    private int changedBy;
    private String oldStatus;
    private String newStatus;
    private String remarks;
    private Timestamp changedAt;

    public ComplaintHistory() {
    }

    public ComplaintHistory(int historyId, int complaintId, int changedBy,
                            String oldStatus, String newStatus,
                            String remarks, Timestamp changedAt) {
        this.historyId = historyId;
        this.complaintId = complaintId;
        this.changedBy = changedBy;
        this.oldStatus = oldStatus;
        this.newStatus = newStatus;
        this.remarks = remarks;
        this.changedAt = changedAt;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getComplaintId() {
        return complaintId;
    }

    public void setComplaintId(int complaintId) {
        this.complaintId = complaintId;
    }

    public int getChangedBy() {
        return changedBy;
    }

    public void setChangedBy(int changedBy) {
        this.changedBy = changedBy;
    }

    public String getOldStatus() {
        return oldStatus;
    }

    public void setOldStatus(String oldStatus) {
        this.oldStatus = oldStatus;
    }

    public String getNewStatus() {
        return newStatus;
    }

    public void setNewStatus(String newStatus) {
        this.newStatus = newStatus;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Timestamp getChangedAt() {
        return changedAt;
    }

    public void setChangedAt(Timestamp changedAt) {
        this.changedAt = changedAt;
    }
}
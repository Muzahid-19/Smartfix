package com.smartfix.modelcom;

import java.sql.Timestamp;

public class PasswordResetOTP {

    private int otpId;
    private String email;
    private String otp;
    private String accountType;
    private Timestamp expiresAt;
    private boolean verified;
    private Timestamp createdAt;

    public PasswordResetOTP() {
    }

    public PasswordResetOTP(
            String email,
            String otp,
            String accountType,
            Timestamp expiresAt) {

        this.email = email;
        this.otp = otp;
        this.accountType = accountType;
        this.expiresAt = expiresAt;
        this.verified = false;
    }

    public int getOtpId() {
        return otpId;
    }

    public void setOtpId(int otpId) {
        this.otpId = otpId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    public boolean isVerified() {
        return verified;
    }

    public void setVerified(boolean verified) {
        this.verified = verified;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
package com.smartfix.dao;

import com.smartfix.modelcom.PasswordResetOTP;

public interface PasswordResetOTPDAO {

    boolean saveOTP(PasswordResetOTP passwordResetOTP);

    PasswordResetOTP getLatestOTPByEmail(String email);

    boolean verifyOTP(String email, String otp);

    boolean markOTPAsVerified(int otpId);

    boolean deleteOTPByEmail(String email);
}
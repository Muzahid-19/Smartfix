package com.smartfix.utli;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL = "muzahidali385@gmail.com";
    private static final String APP_PASSWORD = "vhbm yzhx vwcd kfkf";

    public static boolean sendOTP(String toEmail, String otp) {

        String host = "smtp.gmail.com";

        Properties properties = new Properties();

        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(
                properties,
                new Authenticator() {

                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(
                                FROM_EMAIL,
                                APP_PASSWORD
                        );
                    }
                }
        );

        try {

            Message message = new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(FROM_EMAIL, "SmartFix")
            );

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail)
            );

            message.setSubject("SmartFix - Password Reset OTP");

            message.setText(
                    "Your SmartFix password reset OTP is: " + otp
                    + "\n\nThis OTP is valid for 10 minutes."
                    + "\n\nIf you did not request this password reset, please ignore this email."
            );

            Transport.send(message);

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }
}
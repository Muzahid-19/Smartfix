
package com.smartfix.service.impl;

import com.smartfix.service.EmailService;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

public class EmailServiceImpl implements EmailService {

    private static final String FROM_EMAIL =
            "muzahidali385@gmail.com";

    // For local testing only. Use a newly generated Gmail App Password.
    private static final String APP_PASSWORD =
            "vhbm yzhx vwcd kfkf";

    @Override
    public void sendEmail(
            String toEmail,
            String subject,
            String messageText) {

        if (toEmail == null || toEmail.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Recipient email cannot be empty."
            );
        }

        if (APP_PASSWORD.equals(
                "PASTE_YOUR_NEW_GMAIL_APP_PASSWORD_HERE")) {
            throw new IllegalStateException(
                    "Please configure your Gmail App Password in EmailServiceImpl."
            );
        }

        Properties properties = new Properties();

        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        properties.put("mail.smtp.connectiontimeout", "10000");
        properties.put("mail.smtp.timeout", "10000");
        properties.put("mail.smtp.writetimeout", "10000");

        Session session = Session.getInstance(
                properties,
                new Authenticator() {
                    @Override
                    protected PasswordAuthentication
                    getPasswordAuthentication() {

                        return new PasswordAuthentication(
                                FROM_EMAIL,
                                APP_PASSWORD.replaceAll("\\s+", "")
                        );
                    }
                }
        );

        try {
            Message message = new MimeMessage(session);

            message.setFrom(
                    new InternetAddress(FROM_EMAIL)
            );

            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(toEmail.trim(), true)
            );

            message.setSubject(
                    subject == null ? "" : subject
            );

            message.setText(
                    messageText == null ? "" : messageText
            );

            Transport.send(message);

            System.out.println(
                    "Email sent successfully to: " + toEmail
            );

        } catch (Exception e) {
            System.err.println(
                    "Email sending failed for: " + toEmail
            );

            e.printStackTrace();

            throw new RuntimeException(
                    "Failed to send email to " + toEmail,
                    e
            );
        }
    }
}

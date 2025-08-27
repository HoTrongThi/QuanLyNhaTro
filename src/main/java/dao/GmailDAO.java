package dao;

import config.GmailConfig;
import model.EmailRequest;
import model.EmailResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

/**
 * Gmail Data Access Object
 * Xử lý gửi email thông qua Gmail SMTP
 */
@Repository
public class GmailDAO {
    
    @Autowired
    private GmailConfig gmailConfig;
    
    /**
     * Gửi email thông qua Gmail SMTP
     */
    public EmailResponse sendEmail(EmailRequest emailRequest) {
        try {
            // Validate input
            if (emailRequest == null) {
                return EmailResponse.failure("Email request không được null");
            }
            
            if (emailRequest.getToEmail() == null || emailRequest.getToEmail().trim().isEmpty()) {
                return EmailResponse.failure("Email người nhận không được để trống");
            }
            
            if (emailRequest.getSubject() == null || emailRequest.getSubject().trim().isEmpty()) {
                return EmailResponse.failure("Tiêu đề email không được để trống");
            }
            
            if (emailRequest.getContent() == null || emailRequest.getContent().trim().isEmpty()) {
                return EmailResponse.failure("Nội dung email không được để trống");
            }
            
            // Tạo properties cho SMTP
            Properties props = new Properties();
            props.put("mail.smtp.host", gmailConfig.getSmtpHost());
            props.put("mail.smtp.port", gmailConfig.getSmtpPort());
            props.put("mail.smtp.auth", gmailConfig.isSmtpAuth());
            props.put("mail.smtp.starttls.enable", gmailConfig.isSmtpStarttls());
            props.put("mail.smtp.ssl.trust", gmailConfig.getSmtpHost());
            
            // Tạo session với authentication
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                        gmailConfig.getGmailUsername(), 
                        gmailConfig.getGmailPassword()
                    );
                }
            });
            
            // Tạo message
            MimeMessage message = new MimeMessage(session);
            
            // Set người gửi
            message.setFrom(new InternetAddress(
                gmailConfig.getFromEmail(), 
                gmailConfig.getFromName(), 
                "UTF-8"
            ));
            
            // Set người nhận
            String recipientName = emailRequest.getToName() != null ? 
                emailRequest.getToName() : emailRequest.getToEmail();
            message.setRecipient(
                Message.RecipientType.TO, 
                new InternetAddress(emailRequest.getToEmail(), recipientName, "UTF-8")
            );
            
            // Set tiêu đề
            message.setSubject(emailRequest.getSubject(), "UTF-8");
            
            // Set nội dung
            if (emailRequest.isHtml()) {
                message.setContent(emailRequest.getContent(), "text/html; charset=UTF-8");
            } else {
                message.setText(emailRequest.getContent(), "UTF-8");
            }
            
            // Gửi email
            Transport.send(message);
            
            return EmailResponse.success("Email đã được gửi thành công tới " + emailRequest.getToEmail());
            
        } catch (MessagingException e) {
            System.err.println("Lỗi gửi email: " + e.getMessage());
            e.printStackTrace();
            return EmailResponse.failure("Lỗi gửi email", e.getMessage());
        } catch (Exception e) {
            System.err.println("Lỗi không xác định khi gửi email: " + e.getMessage());
            e.printStackTrace();
            return EmailResponse.failure("Lỗi không xác định khi gửi email", e.getMessage());
        }
    }
    
    /**
     * Gửi thông báo hóa đơn qua email
     */
    public boolean sendInvoiceNotification(String toEmail, String toName, String roomName, String period, String totalAmount) {
        return sendInvoiceNotificationWithQR(toEmail, toName, roomName, period, totalAmount, null);
    }
    
    /**
     * Gửi thông báo hóa đơn qua email với QR code MoMo
     */
    public boolean sendInvoiceNotificationWithQR(String toEmail, String toName, String roomName, String period, String totalAmount, String qrCodeUrl) {
        try {
            // Tạo tiêu đề email
            String subject = String.format(gmailConfig.getInvoiceCreatedSubject(), roomName);
            
            // Tạo phần QR code nếu có
            String qrSection = "";
            if (qrCodeUrl != null && !qrCodeUrl.trim().isEmpty()) {
                qrSection = String.format(gmailConfig.getQrCodeSectionTemplate(), qrCodeUrl);
            }
            
            // Tạo nội dung email từ template
            String content = String.format(
                gmailConfig.getInvoiceCreatedTemplate(),
                toName != null ? toName : "Quý khách",
                roomName,
                period,
                totalAmount,
                qrSection
            );
            
            // Tạo email request
            EmailRequest emailRequest = new EmailRequest(toEmail, toName, subject, content, true);
            
            // Gửi email
            EmailResponse response = sendEmail(emailRequest);
            
            return response.isSuccess();
            
        } catch (Exception e) {
            System.err.println("Lỗi gửi thông báo hóa đơn: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra định dạng email
     */
    public boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        // Regex đơn giản để kiểm tra email
        String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        return email.matches(emailRegex);
    }
    
    /**
     * Gửi email test
     */
    public EmailResponse sendTestEmail(String toEmail, String toName) {
        String subject = "Test Email từ Hệ thống Quản lý Phòng trọ";
        String content = String.format(
            "Xin chào %s,<br><br>" +
            "Đây là email test từ Hệ thống Quản lý Phòng trọ.<br>" +
            "Nếu bạn nhận được email này, nghĩa là cấu hình email đã hoạt động thành công!<br><br>" +
            "Trân trọng,<br>" +
            "Hệ thống Quản lý Phòng trọ",
            toName != null ? toName : "Quý khách"
        );
        
        EmailRequest emailRequest = new EmailRequest(toEmail, toName, subject, content, true);
        return sendEmail(emailRequest);
    }
}
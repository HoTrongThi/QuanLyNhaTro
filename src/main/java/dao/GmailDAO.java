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
 * Lớp Data Access Object cho Gmail
 * Xử lý việc gửi email thông qua Gmail SMTP
 * Tích hợp với Gmail API để gửi email thông báo hóa đơn và email test
 * Hỗ trợ gửi email HTML với QR code MoMo tích hợp
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Repository
public class GmailDAO {
    
    // ==================== CÁC THUỘC TÍNH ====================
    
    /** Cấu hình Gmail - chứa thông tin SMTP và template email */
    @Autowired
    private GmailConfig gmailConfig;
    
    // ==================== CÁC PHƯƠNG THỨC CHÍNH ====================
    
    /**
     * Gửi email thông qua Gmail SMTP
     * Phương thức chính để gửi email với đầy đủ tính năng xác thực và xử lý lỗi
     * Hỗ trợ gửi email HTML và text thuần
     * Tự động xử lý encoding UTF-8 cho tiếng Việt
     * 
     * @param emailRequest đối tượng chứa thông tin email cần gửi
     * @return EmailResponse chứa kết quả gửi email
     */
    public EmailResponse sendEmail(EmailRequest emailRequest) {
        try {
            // Bước 1: Kiểm tra tính hợp lệ của dữ liệu đầu vào
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
            
            // Bước 2: Thiết lập cấu hình SMTP
            Properties props = new Properties();
            props.put("mail.smtp.host", gmailConfig.getSmtpHost());           // Máy chủ SMTP
            props.put("mail.smtp.port", gmailConfig.getSmtpPort());           // Cổng SMTP
            props.put("mail.smtp.auth", gmailConfig.isSmtpAuth());            // Bật xác thực
            props.put("mail.smtp.starttls.enable", gmailConfig.isSmtpStarttls()); // Bật mã hóa
            props.put("mail.smtp.ssl.trust", gmailConfig.getSmtpHost());      // Tin cậy SSL
            
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
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Gửi thông báo hóa đơn qua email (không có QR code)
     * Phương thức tiện ích gọi email thông báo hóa đơn cơ bản
     * 
     * @param toEmail địa chỉ email người nhận
     * @param toName tên người nhận
     * @param roomName tên phòng
     * @param period kỳ thanh toán
     * @param totalAmount tổng số tiền
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendInvoiceNotification(String toEmail, String toName, String roomName, String period, String totalAmount) {
        return sendInvoiceNotificationWithQR(toEmail, toName, roomName, period, totalAmount, null);
    }
    
    /**
     * Gửi thông báo hóa đơn qua email với QR code MoMo
     * Phương thức chính để gửi email thông báo hóa đơn có kèm QR code thanh toán
     * Sờ dụng template HTML đẹp mắt với QR code MoMo tích hợp
     * 
     * @param toEmail địa chỉ email người nhận
     * @param toName tên người nhận
     * @param roomName tên phòng
     * @param period kỳ thanh toán (MM/yyyy)
     * @param totalAmount tổng số tiền đã format
     * @param qrCodeUrl URL của QR code MoMo (có thể null)
     * @return true nếu gửi thành công, false nếu thất bại
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
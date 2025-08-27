package config;

import org.springframework.stereotype.Component;

/**
 * Gmail SMTP Configuration
 * Cấu hình gửi email thông qua Gmail SMTP
 */
@Component
public class GmailConfig {
    
    // Gmail SMTP Configuration
    public static final String SMTP_HOST = "smtp.gmail.com";
    public static final String SMTP_PORT = "587";
    public static final boolean SMTP_AUTH = true;
    public static final boolean SMTP_STARTTLS = true;
    
    // Gmail Account Credentials (Cần cập nhật với thông tin thực tế)
    public static final String GMAIL_USERNAME = "hotrongthi2709@gmail.com"; // Thay bằng email thực tế
    public static final String GMAIL_PASSWORD = "ktyb waeu giyk jnpe";     // Thay bằng App Password thực tế
    
    // Email Configuration
    public static final String FROM_EMAIL = "hotrongthi2709@gmail.com";      // Thay bằng email thực tế
    public static final String FROM_NAME = "Hệ thống Quản lý Phòng trọ";
    
    // Email Templates
    public static final String INVOICE_CREATED_SUBJECT = "Thông báo hóa đơn mới - Phòng %s";
    
    public static final String INVOICE_CREATED_TEMPLATE = 
        "<!DOCTYPE html>" +
        "<html>" +
        "<head>" +
        "    <meta charset='UTF-8'>" +
        "    <style>" +
        "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
        "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
        "        .header { background-color: #007bff; color: white; padding: 20px; text-align: center; }" +
        "        .content { padding: 20px; background-color: #f8f9fa; }" +
        "        .invoice-details { background-color: white; padding: 15px; border-radius: 5px; margin: 15px 0; }" +
        "        .amount { font-size: 24px; font-weight: bold; color: #007bff; }" +
        "        .payment-section { background-color: white; padding: 20px; border-radius: 5px; margin: 15px 0; text-align: center; border: 2px solid #28a745; }" +
        "        .qr-code { margin: 15px 0; }" +
        "        .qr-code img { max-width: 250px; height: auto; border: 1px solid #ddd; border-radius: 5px; }" +
        "        .payment-note { color: #28a745; font-weight: bold; margin: 10px 0; }" +
        "        .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }" +
        "    </style>" +
        "</head>" +
        "<body>" +
        "    <div class='container'>" +
        "        <div class='header'>" +
        "            <h1>🏠 Thông báo Hóa đơn mới</h1>" +
        "        </div>" +
        "        <div class='content'>" +
        "            <p>Xin chào <strong>%s</strong>,</p>" +
        "            <p>Chúng tôi xin thông báo hóa đơn mới đã được tạo cho phòng của bạn:</p>" +
        "            <div class='invoice-details'>" +
        "                <h3>📋 Chi tiết hóa đơn</h3>" +
        "                <p><strong>Phòng:</strong> %s</p>" +
        "                <p><strong>Kỳ thanh toán:</strong> %s</p>" +
        "                <p><strong>Tổng tiền:</strong> <span class='amount'>%s VNĐ</span></p>" +
        "            </div>" +
        "            %s" + // QR Code section placeholder
        "            <p>Vui lòng đăng nhập vào hệ thống để xem chi tiết hóa đơn và thực hiện thanh toán.</p>" +
        "            <p>Cảm ơn bạn đã sử dụng dịch vụ của chúng tôi!</p>" +
        "        </div>" +
        "        <div class='footer'>" +
        "            <p>© 2025 Hệ thống Quản lý Phòng trọ. Mọi quyền được bảo lưu.</p>" +
        "            <p>Email này được gửi tự động, vui lòng không trả lời.</p>" +
        "        </div>" +
        "    </div>" +
        "</body>" +
        "</html>";
    
    // Getters
    public String getSmtpHost() {
        return SMTP_HOST;
    }
    
    public String getSmtpPort() {
        return SMTP_PORT;
    }
    
    public boolean isSmtpAuth() {
        return SMTP_AUTH;
    }
    
    public boolean isSmtpStarttls() {
        return SMTP_STARTTLS;
    }
    
    public String getGmailUsername() {
        return GMAIL_USERNAME;
    }
    
    public String getGmailPassword() {
        return GMAIL_PASSWORD;
    }
    
    public String getFromEmail() {
        return FROM_EMAIL;
    }
    
    public String getFromName() {
        return FROM_NAME;
    }
    
    public String getInvoiceCreatedSubject() {
        return INVOICE_CREATED_SUBJECT;
    }
    
    public String getInvoiceCreatedTemplate() {
        return INVOICE_CREATED_TEMPLATE;
    }
    
    // QR Code Payment Section Template
    public static final String QR_CODE_SECTION_TEMPLATE = 
        "<div class='payment-section'>" +
        "    <h3>📱 Thanh toán nhanh với MoMo</h3>" +
        "    <p class='payment-note'>Quét mã QR bên dưới để thanh toán ngay!</p>" +
        "    <div class='qr-code'>" +
        "        <img src='%s' alt='MoMo QR Code' />" +
        "    </div>" +
        "    <p><strong>Hoặc:</strong> Mở ứng dụng MoMo và quét mã QR trên</p>" +
        "    <p style='font-size: 12px; color: #666;'>Mã QR có hiệu lực trong 24 giờ</p>" +
        "</div>";
    
    public String getQrCodeSectionTemplate() {
        return QR_CODE_SECTION_TEMPLATE;
    }
}
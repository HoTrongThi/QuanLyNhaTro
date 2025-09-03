package config;

import org.springframework.stereotype.Component;

/**
 * Lớp cấu hình Gmail SMTP
 * Chứa tất cả thông tin cấu hình để gửi email thông qua Gmail SMTP
 * Bao gồm thông tin đăng nhập, cấu hình SMTP và template email
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Component
public class GmailConfig {
    
    // ==================== CẤU HÌNH GMAIL SMTP ====================
    
    /** Địa chỉ máy chủ SMTP của Gmail */
    public static final String SMTP_HOST = "smtp.gmail.com";
    
    /** Cổng SMTP của Gmail (587 cho STARTTLS) */
    public static final String SMTP_PORT = "587";
    
    /** Bật xác thực SMTP */
    public static final boolean SMTP_AUTH = true;
    
    /** Bật mã hóa STARTTLS */
    public static final boolean SMTP_STARTTLS = true;
    
    // ==================== THÔNG TIN ĐĂNG NHẬP GMAIL ====================
    
    /** Tên đăng nhập Gmail (địa chỉ email) */
    public static final String GMAIL_USERNAME = "hotrongthi2709@gmail.com";
    
    /** Mật khẩu ứng dụng Gmail (App Password) - KHÔNG PHẢI mật khẩu thường */
    public static final String GMAIL_PASSWORD = "ktyb waeu giyk jnpe";
    
    // ==================== CẤU HÌNH EMAIL ====================
    
    /** Địa chỉ email người gửi */
    public static final String FROM_EMAIL = "hotrongthi2709@gmail.com";
    
    /** Tên hiển thị của người gửi */
    public static final String FROM_NAME = "Hệ thống Quản lý Phòng trọ";
    
    // ==================== TEMPLATE EMAIL ====================
    
    /** Tiêu đề email thông báo hóa đơn mới (%s sẽ được thay thế bằng tên phòng) */
    public static final String INVOICE_CREATED_SUBJECT = "Thông báo hóa đơn mới - Phòng %s";
    
    /** 
     * Template HTML cho email thông báo hóa đơn mới
     * Bao gồm:
     * - Header với tiêu đề
     * - Thông tin chi tiết hóa đơn
     * - Phần QR code MoMo (nếu có)
     * - Footer với thông tin liên hệ
     * 
     * Các tham số %s theo thứ tự:
     * 1. Tên người nhận
     * 2. Tên phòng
     * 3. Kỳ thanh toán
     * 4. Tổng tiền
     * 5. Phần QR code (có thể rỗng)
     */
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
    
    // ==================== CÁC PHƯƠNG THỨC GETTER ====================
    
    /**
     * Lấy địa chỉ máy chủ SMTP
     * @return địa chỉ SMTP host
     */
    public String getSmtpHost() {
        return SMTP_HOST;
    }
    
    /**
     * Lấy cổng SMTP
     * @return cổng SMTP
     */
    public String getSmtpPort() {
        return SMTP_PORT;
    }
    
    /**
     * Kiểm tra có bật xác thực SMTP hay không
     * @return true nếu bật xác thực
     */
    public boolean isSmtpAuth() {
        return SMTP_AUTH;
    }
    
    /**
     * Kiểm tra có bật STARTTLS hay không
     * @return true nếu bật STARTTLS
     */
    public boolean isSmtpStarttls() {
        return SMTP_STARTTLS;
    }
    
    /**
     * Lấy tên đăng nhập Gmail
     * @return địa chỉ email Gmail
     */
    public String getGmailUsername() {
        return GMAIL_USERNAME;
    }
    
    /**
     * Lấy mật khẩu ứng dụng Gmail
     * @return App Password của Gmail
     */
    public String getGmailPassword() {
        return GMAIL_PASSWORD;
    }
    
    /**
     * Lấy địa chỉ email người gửi
     * @return địa chỉ email người gửi
     */
    public String getFromEmail() {
        return FROM_EMAIL;
    }
    
    /**
     * Lấy tên hiển thị của người gửi
     * @return tên người gửi
     */
    public String getFromName() {
        return FROM_NAME;
    }
    
    /**
     * Lấy template tiêu đề email hóa đơn
     * @return template tiêu đề email
     */
    public String getInvoiceCreatedSubject() {
        return INVOICE_CREATED_SUBJECT;
    }
    
    /**
     * Lấy template HTML cho email hóa đơn
     * @return template HTML email
     */
    public String getInvoiceCreatedTemplate() {
        return INVOICE_CREATED_TEMPLATE;
    }
    
    // ==================== TEMPLATE QR CODE MOMO ====================
    
    /** 
     * Template HTML cho phần QR code MoMo trong email
     * Bao gồm:
     * - Tiêu đề phần thanh toán
     * - Hình ảnh QR code
     * - Hướng dẫn sử dụng
     * - Thông tin hiệu lực
     * 
     * Tham số %s: URL của hình ảnh QR code
     */
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
    
    /**
     * Lấy template HTML cho phần QR code MoMo
     * @return template HTML QR code
     */
    public String getQrCodeSectionTemplate() {
        return QR_CODE_SECTION_TEMPLATE;
    }
}
package model;

/**
 * Lớp Model cho Yêu cầu Gửi Email
 * Đại diện cho dữ liệu cần thiết để gửi email qua hệ thống
 * Hỗ trợ gửi email dạng text thường hoặc HTML
 * Sử dụng cho thông báo hóa đơn, xác nhận thanh toán và liên lạc khách hàng
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class EmailRequest {
    
    // ==================== THÔNG TIN NGƯỜI NHẬN ====================
    
    /** Địa chỉ email người nhận */
    private String toEmail;
    
    /** Tên người nhận (hiển thị trong email) */
    private String toName;
    
    // ==================== NỘI DUNG EMAIL ====================
    
    /** Tiêu đề email */
    private String subject;
    
    /** Nội dung email (text hoặc HTML) */
    private String content;
    
    /** Đánh dấu nội dung có phải là HTML hay không */
    private boolean isHtml;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public EmailRequest() {}
    
    /**
     * Constructor cho email dạng text thường
     * Mặc định sẽ gửi dưới dạng text (không phải HTML)
     * 
     * @param toEmail địa chỉ email người nhận
     * @param toName tên người nhận
     * @param subject tiêu đề email
     * @param content nội dung email
     */
    public EmailRequest(String toEmail, String toName, String subject, String content) {
        this.toEmail = toEmail;
        this.toName = toName;
        this.subject = subject;
        this.content = content;
        this.isHtml = false; // Mặc định là text thường
    }
    
    /**
     * Constructor đầy đủ với tùy chọn HTML
     * Cho phép chỉ định loại nội dung (text hoặc HTML)
     * 
     * @param toEmail địa chỉ email người nhận
     * @param toName tên người nhận
     * @param subject tiêu đề email
     * @param content nội dung email
     * @param isHtml true nếu nội dung là HTML, false nếu là text
     */
    public EmailRequest(String toEmail, String toName, String subject, String content, boolean isHtml) {
        this.toEmail = toEmail;
        this.toName = toName;
        this.subject = subject;
        this.content = content;
        this.isHtml = isHtml;
    }
    
    // Getters and Setters
    public String getToEmail() {
        return toEmail;
    }
    
    public void setToEmail(String toEmail) {
        this.toEmail = toEmail;
    }
    
    public String getToName() {
        return toName;
    }
    
    public void setToName(String toName) {
        this.toName = toName;
    }
    
    public String getSubject() {
        return subject;
    }
    
    public void setSubject(String subject) {
        this.subject = subject;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public boolean isHtml() {
        return isHtml;
    }
    
    public void setHtml(boolean html) {
        isHtml = html;
    }
    
    @Override
    public String toString() {
        return "EmailRequest{" +
                "toEmail='" + toEmail + '\'' +
                ", toName='" + toName + '\'' +
                ", subject='" + subject + '\'' +
                ", isHtml=" + isHtml +
                '}';
    }
}
package model;

/**
 * Lớp Model cho Phản hồi Gửi Email
 * Đại diện cho kết quả sau khi gửi email qua hệ thống
 * Chứa thông tin thành công/thất bại, thông báo và chi tiết lỗi
 * Hỗ trợ các factory method để tạo response nhanh chóng
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class EmailResponse {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** Trạng thái gửi email (true: thành công, false: thất bại) */
    private boolean success;
    
    /** Thông báo kết quả (thành công hoặc lỗi) */
    private String message;
    
    /** Chi tiết lỗi (nếu có) */
    private String errorDetails;
    
    // Constructors
    public EmailResponse() {}
    
    public EmailResponse(boolean success, String message) {
        this.success = success;
        this.message = message;
    }
    
    public EmailResponse(boolean success, String message, String errorDetails) {
        this.success = success;
        this.message = message;
        this.errorDetails = errorDetails;
    }
    
    // ==================== CÁC FACTORY METHOD ====================
    
    /**
     * Tạo response thành công
     * 
     * @param message thông báo thành công
     * @return EmailResponse với trạng thái thành công
     */
    public static EmailResponse success(String message) {
        return new EmailResponse(true, message);
    }
    
    /**
     * Tạo response thất bại
     * 
     * @param message thông báo lỗi
     * @return EmailResponse với trạng thái thất bại
     */
    public static EmailResponse failure(String message) {
        return new EmailResponse(false, message);
    }
    
    /**
     * Tạo response thất bại với chi tiết lỗi
     * 
     * @param message thông báo lỗi
     * @param errorDetails chi tiết lỗi kỹ thuật
     * @return EmailResponse với trạng thái thất bại và chi tiết lỗi
     */
    public static EmailResponse failure(String message, String errorDetails) {
        return new EmailResponse(false, message, errorDetails);
    }
    
    // Getters and Setters
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getErrorDetails() {
        return errorDetails;
    }
    
    public void setErrorDetails(String errorDetails) {
        this.errorDetails = errorDetails;
    }
    
    @Override
    public String toString() {
        return "EmailResponse{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", errorDetails='" + errorDetails + '\'' +
                '}';
    }
}
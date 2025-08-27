package model;

/**
 * Email Response Model
 * Model cho phản hồi sau khi gửi email
 */
public class EmailResponse {
    private boolean success;
    private String message;
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
    
    // Static factory methods
    public static EmailResponse success(String message) {
        return new EmailResponse(true, message);
    }
    
    public static EmailResponse failure(String message) {
        return new EmailResponse(false, message);
    }
    
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
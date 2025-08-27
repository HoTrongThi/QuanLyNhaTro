package model;

/**
 * Email Request Model
 * Model cho yêu cầu gửi email
 */
public class EmailRequest {
    private String toEmail;
    private String toName;
    private String subject;
    private String content;
    private boolean isHtml;
    
    // Constructors
    public EmailRequest() {}
    
    public EmailRequest(String toEmail, String toName, String subject, String content) {
        this.toEmail = toEmail;
        this.toName = toName;
        this.subject = subject;
        this.content = content;
        this.isHtml = false;
    }
    
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
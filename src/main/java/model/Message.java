package model;

import java.sql.Timestamp;

/**
 * Message Model Class
 * Represents the messages table in the database
 * Handles communication between users and admins
 */
public class Message {
    private int messageId;
    private int senderId;
    private int receiverId;
    private String content;
    private Timestamp createdAt;
    private String status; // UNREAD or read
    
    // Additional fields for display purposes
    private String senderName;
    private String receiverName;
    private String senderRole;
    private String receiverRole;
    
    // Default constructor
    public Message() {}
    
    // Constructor for sending messages
    public Message(int senderId, int receiverId, String content) {
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.content = content;
        this.status = "UNREAD";
    }
    
    // Full constructor
    public Message(int messageId, int senderId, int receiverId, String content, 
                   Timestamp createdAt, String status) {
        this.messageId = messageId;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.content = content;
        this.createdAt = createdAt;
        this.status = status;
    }
    
    // Getters and Setters
    public int getMessageId() {
        return messageId;
    }
    
    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }
    
    public int getSenderId() {
        return senderId;
    }
    
    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }
    
    public int getReceiverId() {
        return receiverId;
    }
    
    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    // Display fields getters and setters
    public String getSenderName() {
        return senderName;
    }
    
    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }
    
    public String getReceiverName() {
        return receiverName;
    }
    
    public void setReceiverName(String receiverName) {
        this.receiverName = receiverName;
    }
    
    public String getSenderRole() {
        return senderRole;
    }
    
    public void setSenderRole(String senderRole) {
        this.senderRole = senderRole;
    }
    
    public String getReceiverRole() {
        return receiverRole;
    }
    
    public void setReceiverRole(String receiverRole) {
        this.receiverRole = receiverRole;
    }
    
    // Utility methods
    public boolean isUnread() {
        return "UNREAD".equals(this.status);
    }
    
    public boolean isRead() {
        return "read".equals(this.status);
    }
    
    public void markAsRead() {
        this.status = "read";
    }
    
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
            return sdf.format(createdAt);
        }
        return "";
    }
    
    public String getStatusDisplayName() {
        if ("UNREAD".equals(this.status)) {
            return "Chưa đọc";
        } else if ("read".equals(this.status)) {
            return "Đã đọc";
        }
        return this.status;
    }
    
    public String getShortContent(int maxLength) {
        if (content != null && content.length() > maxLength) {
            return content.substring(0, maxLength) + "...";
        }
        return content;
    }
    
    @Override
    public String toString() {
        return "Message{" +
                "messageId=" + messageId +
                ", senderId=" + senderId +
                ", receiverId=" + receiverId +
                ", content='" + content + '\'' +
                ", createdAt=" + createdAt +
                ", status='" + status + '\'' +
                ", senderName='" + senderName + '\'' +
                ", receiverName='" + receiverName + '\'' +
                '}';
    }
}

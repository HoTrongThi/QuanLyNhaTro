package model;

import java.sql.Timestamp;

/**
 * Lớp Model cho Tin nhắn
 * Đại diện cho bảng messages trong cơ sở dữ liệu
 * Xử lý giao tiếp giữa người dùng và quản trị viên
 * Hỗ trợ gửi, nhận, đánh dấu đã đọc và quản lý trạng thái tin nhắn
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class Message {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của tin nhắn (Primary Key) */
    private int messageId;
    
    /** ID người gửi (Foreign Key đến bảng users) */
    private int senderId;
    
    /** ID người nhận (Foreign Key đến bảng users) */
    private int receiverId;
    
    /** Nội dung tin nhắn */
    private String content;
    
    /** Thời gian tạo tin nhắn */
    private Timestamp createdAt;
    
    /** Trạng thái tin nhắn (UNREAD: chưa đọc, read: đã đọc) */
    private String status;
    
    // ==================== THUỘC TÍNH HIỂN THỊ (TỮ JOIN) ====================
    
    /** Tên người gửi (từ bảng users) */
    private String senderName;
    
    /** Tên người nhận (từ bảng users) */
    private String receiverName;
    
    /** Vai trò người gửi (USER hoặc ADMIN) */
    private String senderRole;
    
    /** Vai trò người nhận (USER hoặc ADMIN) */
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
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra tin nhắn có chưa được đọc hay không
     * 
     * @return true nếu tin nhắn chưa được đọc, false nếu đã đọc
     */
    public boolean isUnread() {
        return "UNREAD".equals(this.status);
    }
    
    /**
     * Kiểm tra tin nhắn đã được đọc hay chưa
     * 
     * @return true nếu tin nhắn đã được đọc, false nếu chưa
     */
    public boolean isRead() {
        return "read".equals(this.status);
    }
    
    /**
     * Đánh dấu tin nhắn là đã đọc
     * Thay đổi trạng thái từ UNREAD thành read
     */
    public void markAsRead() {
        this.status = "read";
    }
    
    /**
     * Lấy thời gian tạo tin nhắn đã được format
     * 
     * @return chuỗi thời gian dạng "dd/MM/yyyy HH:mm"
     */
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
            return sdf.format(createdAt);
        }
        return "";
    }
    
    /**
     * Lấy tên hiển thị trạng thái tin nhắn bằng tiếng Việt
     * 
     * @return tên trạng thái tiếng Việt
     */
    public String getStatusDisplayName() {
        if ("UNREAD".equals(this.status)) {
            return "Chưa đọc";
        } else if ("read".equals(this.status)) {
            return "Đã đọc";
        }
        return this.status;
    }
    
    /**
     * Lấy nội dung tin nhắn rút gọn
     * Cắt bớt nội dung nếu quá dài và thêm "..."
     * 
     * @param maxLength độ dài tối đa
     * @return nội dung đã rút gọn
     */
    public String getShortContent(int maxLength) {
        if (content != null && content.length() > maxLength) {
            return content.substring(0, maxLength) + "...";
        }
        return content;
    }
    
    /**
     * Kiểm tra xem tin nhắn có phải từ admin gửi hay không
     * 
     * @return true nếu người gửi là admin, false nếu không
     */
    public boolean isFromAdmin() {
        return "ADMIN".equals(this.senderRole);
    }
    
    /**
     * Kiểm tra xem tin nhắn có phải gửi cho admin hay không
     * 
     * @return true nếu người nhận là admin, false nếu không
     */
    public boolean isToAdmin() {
        return "ADMIN".equals(this.receiverRole);
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

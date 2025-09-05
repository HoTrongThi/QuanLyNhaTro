package model;

import java.sql.Timestamp;

/**
 * Lớp Model cho Người dùng
 * Đại diện cho bảng users trong cơ sở dữ liệu
 * Chứa thông tin cơ bản của người dùng và các thuộc tính liên quan đến tin nhắn
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class User {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của người dùng (Primary Key) */
    private int userId;
    
    /** Tên đăng nhập (duy nhất) */
    private String username;
    
    /** Mật khẩu đã được mã hóa */
    private String password;
    
    /** Họ và tên đầy đủ của người dùng */
    private String fullName;
    
    /** Số điện thoại liên hệ */
    private String phone;
    
    /** Địa chỉ email */
    private String email;
    
    /** Địa chỉ nhà */
    private String address;
    
    /** Vai trò của người dùng (ADMIN hoặc USER) */
    private String role;
    
    /** Thời gian tạo tài khoản */
    private Timestamp createdAt;
    
    // ==================== THUỘC TÍNH LIÊN QUAN ĐẾN TIN NHẮN ====================
    
    /** Có tin nhắn chưa đọc hay không (dùng cho danh sách liên hệ) */
    private boolean hasUnreadMessages;
    
    /** Nội dung tin nhắn cuối cùng */
    private String lastMessage;
    
    /** Thời gian tin nhắn cuối cùng */
    private Timestamp lastMessageTime;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public User() {}
    
    /**
     * Constructor cho đăng nhập
     * @param username tên đăng nhập
     * @param password mật khẩu
     */
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    /**
     * Constructor cho đăng ký tài khoản mới
     * @param username tên đăng nhập
     * @param password mật khẩu
     * @param fullName họ tên đầy đủ
     * @param phone số điện thoại
     * @param email địa chỉ email
     * @param address địa chỉ nhà
     * @param role vai trò (ADMIN/USER)
     */
    public User(String username, String password, String fullName, String phone, String email, String address, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.role = role;
    }
    
    /**
     * Constructor đầy đủ với tất cả thuộc tính
     * @param userId ID người dùng
     * @param username tên đăng nhập
     * @param password mật khẩu
     * @param fullName họ tên đầy đủ
     * @param phone số điện thoại
     * @param email địa chỉ email
     * @param address địa chỉ nhà
     * @param role vai trò (ADMIN/USER)
     * @param createdAt thời gian tạo tài khoản
     */
    public User(int userId, String username, String password, String fullName, String phone, String email, String address, String role, Timestamp createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.role = role;
        this.createdAt = createdAt;
    }
    
    // ==================== CÁC PHƯƠNG THỨC GETTER VÀ SETTER ====================
    
    /**
     * Lấy ID người dùng
     * @return ID người dùng
     */
    public int getUserId() {
        return userId;
    }
    
    /**
     * Đặt ID người dùng
     * @param userId ID người dùng mới
     */
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    /**
     * Lấy tên đăng nhập
     * @return tên đăng nhập
     */
    public String getUsername() {
        return username;
    }
    
    /**
     * Đặt tên đăng nhập
     * @param username tên đăng nhập mới
     */
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra người dùng có phải là quản trị viên hay không
     * Bao gồm cả ADMIN và SUPER_ADMIN
     * @return true nếu là admin hoặc super admin, false nếu không
     */
    public boolean isAdmin() {
        return "ADMIN".equals(this.role) || "SUPER_ADMIN".equals(this.role);
    }
    
    /**
     * Kiểm tra người dùng có phải là Super Admin hay không
     * @return true nếu là super admin, false nếu không
     */
    public boolean isSuperAdmin() {
        return "SUPER_ADMIN".equals(this.role);
    }
    
    /**
     * Kiểm tra người dùng có phải là người dùng thường hay không
     * @return true nếu là user thường, false nếu không
     */
    public boolean isUser() {
        return "USER".equals(this.role);
    }
    
    /**
     * Lấy tên hiển thị của vai trò
     * @return tên vai trò bằng tiếng Việt
     */
    public String getRoleDisplayName() {
        switch (this.role) {
            case "SUPER_ADMIN": return "Super Admin";
            case "ADMIN": return "Quản trị viên";
            case "USER": return "Người dùng";
            default: return this.role;
        }
    }
    
    /**
     * Lấy icon của vai trò
     * @return Bootstrap icon class
     */
    public String getRoleIcon() {
        switch (this.role) {
            case "SUPER_ADMIN": return "bi bi-shield-fill-exclamation";
            case "ADMIN": return "bi bi-person-gear";
            case "USER": return "bi bi-person";
            default: return "bi bi-person";
        }
    }
    
    // Message-related getters and setters
    public boolean hasUnreadMessages() {
        return hasUnreadMessages;
    }
    
    public boolean getHasUnreadMessages() {
        return hasUnreadMessages;
    }
    
    public void setHasUnreadMessages(boolean hasUnreadMessages) {
        this.hasUnreadMessages = hasUnreadMessages;
    }
    
    public String getLastMessage() {
        return lastMessage;
    }
    
    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }
    
    public Timestamp getLastMessageTime() {
        return lastMessageTime;
    }
    
    public void setLastMessageTime(Timestamp lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", address='" + address + '\'' +
                ", role='" + role + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}

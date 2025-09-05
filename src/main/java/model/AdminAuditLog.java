package model;

import java.sql.Timestamp;

/**
 * Lớp Model cho log hoạt động của Super Admin
 * Đại diện cho bảng admin_audit_log trong cơ sở dữ liệu
 * Theo dõi tất cả hoạt động của Super Admin đối với các Admin
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class AdminAuditLog {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của log (Primary Key) */
    private int logId;
    
    /** ID của Super Admin thực hiện hành động */
    private int superAdminId;
    
    /** ID của Admin bị tác động (null nếu là hành động tổng quát) */
    private Integer targetAdminId;
    
    /** Loại hành động */
    private String action;
    
    /** Chi tiết hành động (JSON format) */
    private String details;
    
    /** IP address của Super Admin */
    private String ipAddress;
    
    /** User agent của browser */
    private String userAgent;
    
    /** Thời gian thực hiện */
    private Timestamp createdAt;
    
    // ==================== THUỘC TÍNH HIỂN THỊ (TỪ JOIN) ====================
    
    /** Tên đăng nhập của Super Admin */
    private String superAdminUsername;
    
    /** Họ tên đầy đủ của Super Admin */
    private String superAdminName;
    
    /** Tên đăng nhập của Admin bị tác động */
    private String targetAdminUsername;
    
    /** Họ tên đầy đủ của Admin bị tác động */
    private String targetAdminName;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public AdminAuditLog() {}
    
    /**
     * Constructor để tạo log mới
     * @param superAdminId ID Super Admin
     * @param targetAdminId ID Admin bị tác động
     * @param action loại hành động
     * @param details chi tiết hành động
     * @param ipAddress IP address
     */
    public AdminAuditLog(int superAdminId, Integer targetAdminId, String action, String details, String ipAddress) {
        this.superAdminId = superAdminId;
        this.targetAdminId = targetAdminId;
        this.action = action;
        this.details = details;
        this.ipAddress = ipAddress;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Constructor đầy đủ
     * @param logId ID log
     * @param superAdminId ID Super Admin
     * @param targetAdminId ID Admin bị tác động
     * @param action loại hành động
     * @param details chi tiết
     * @param ipAddress IP address
     * @param userAgent user agent
     * @param createdAt thời gian tạo
     */
    public AdminAuditLog(int logId, int superAdminId, Integer targetAdminId, String action, 
                        String details, String ipAddress, String userAgent, Timestamp createdAt) {
        this.logId = logId;
        this.superAdminId = superAdminId;
        this.targetAdminId = targetAdminId;
        this.action = action;
        this.details = details;
        this.ipAddress = ipAddress;
        this.userAgent = userAgent;
        this.createdAt = createdAt;
    }
    
    // ==================== CÁC PHƯƠNG THỨC GETTER VÀ SETTER ====================
    
    public int getLogId() {
        return logId;
    }
    
    public void setLogId(int logId) {
        this.logId = logId;
    }
    
    public int getSuperAdminId() {
        return superAdminId;
    }
    
    public void setSuperAdminId(int superAdminId) {
        this.superAdminId = superAdminId;
    }
    
    public Integer getTargetAdminId() {
        return targetAdminId;
    }
    
    public void setTargetAdminId(Integer targetAdminId) {
        this.targetAdminId = targetAdminId;
    }
    
    public String getAction() {
        return action;
    }
    
    public void setAction(String action) {
        this.action = action;
    }
    
    public String getDetails() {
        return details;
    }
    
    public void setDetails(String details) {
        this.details = details;
    }
    
    public String getIpAddress() {
        return ipAddress;
    }
    
    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }
    
    public String getUserAgent() {
        return userAgent;
    }
    
    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // Display properties getters/setters
    public String getSuperAdminUsername() {
        return superAdminUsername;
    }
    
    public void setSuperAdminUsername(String superAdminUsername) {
        this.superAdminUsername = superAdminUsername;
    }
    
    public String getSuperAdminName() {
        return superAdminName;
    }
    
    public void setSuperAdminName(String superAdminName) {
        this.superAdminName = superAdminName;
    }
    
    public String getTargetAdminUsername() {
        return targetAdminUsername;
    }
    
    public void setTargetAdminUsername(String targetAdminUsername) {
        this.targetAdminUsername = targetAdminUsername;
    }
    
    public String getTargetAdminName() {
        return targetAdminName;
    }
    
    public void setTargetAdminName(String targetAdminName) {
        this.targetAdminName = targetAdminName;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Lấy tên hiển thị của hành động
     * @return tên hành động bằng tiếng Việt
     */
    public String getActionDisplayName() {
        switch (this.action) {
            case "CREATE_ADMIN":
                return "Tạo Admin mới";
            case "UPDATE_ADMIN":
                return "Cập nhật thông tin Admin";
            case "DELETE_ADMIN":
                return "Xóa Admin";
            case "RESET_PASSWORD":
                return "Reset mật khẩu";
            case "SUSPEND_ADMIN":
                return "Tạm khóa Admin";
            case "ACTIVATE_ADMIN":
                return "Kích hoạt Admin";
            case "VIEW_ADMIN_DATA":
                return "Xem dữ liệu Admin";
            case "SYSTEM_CONFIG":
                return "Cấu hình hệ thống";
            default:
                return this.action;
        }
    }
    
    /**
     * Lấy CSS class cho badge hành động
     * @return CSS class phù hợp với hành động
     */
    public String getActionBadgeClass() {
        switch (this.action) {
            case "CREATE_ADMIN":
                return "bg-success"; // Xanh lá - tạo mới
            case "UPDATE_ADMIN":
                return "bg-info"; // Xanh nhạt - cập nhật
            case "DELETE_ADMIN":
                return "bg-danger"; // Đỏ - xóa
            case "RESET_PASSWORD":
                return "bg-warning"; // Vàng - reset password
            case "SUSPEND_ADMIN":
                return "bg-danger"; // Đỏ - tạm khóa
            case "ACTIVATE_ADMIN":
                return "bg-success"; // Xanh lá - kích hoạt
            case "VIEW_ADMIN_DATA":
                return "bg-secondary"; // Xám - xem dữ liệu
            case "SYSTEM_CONFIG":
                return "bg-primary"; // Xanh dương - cấu hình
            default:
                return "bg-secondary";
        }
    }
    
    /**
     * Lấy icon cho hành động
     * @return Bootstrap icon class
     */
    public String getActionIcon() {
        switch (this.action) {
            case "CREATE_ADMIN":
                return "bi-person-plus-fill"; // Thêm người
            case "UPDATE_ADMIN":
                return "bi-pencil-square"; // Bút chì
            case "DELETE_ADMIN":
                return "bi-person-dash-fill"; // Xóa người
            case "RESET_PASSWORD":
                return "bi-key-fill"; // Chìa khóa
            case "SUSPEND_ADMIN":
                return "bi-person-x-fill"; // Người bị cấm
            case "ACTIVATE_ADMIN":
                return "bi-person-check-fill"; // Người được tick
            case "VIEW_ADMIN_DATA":
                return "bi-eye-fill"; // Mắt
            case "SYSTEM_CONFIG":
                return "bi-gear-fill"; // Bánh răng
            default:
                return "bi-activity";
        }
    }
    
    /**
     * Lấy mức độ quan trọng của hành động
     * @return mức độ quan trọng (HIGH, MEDIUM, LOW)
     */
    public String getActionSeverity() {
        switch (this.action) {
            case "DELETE_ADMIN":
            case "RESET_PASSWORD":
            case "SUSPEND_ADMIN":
                return "HIGH"; // Hành động quan trọng
            case "CREATE_ADMIN":
            case "UPDATE_ADMIN":
            case "ACTIVATE_ADMIN":
            case "SYSTEM_CONFIG":
                return "MEDIUM"; // Hành động trung bình
            case "VIEW_ADMIN_DATA":
                return "LOW"; // Hành động ít quan trọng
            default:
                return "MEDIUM";
        }
    }
    
    /**
     * Lấy CSS class cho mức độ quan trọng
     * @return CSS class cho severity
     */
    public String getSeverityBadgeClass() {
        switch (getActionSeverity()) {
            case "HIGH":
                return "bg-danger";
            case "MEDIUM":
                return "bg-warning";
            case "LOW":
                return "bg-info";
            default:
                return "bg-secondary";
        }
    }
    
    /**
     * Lấy thời gian thực hiện định dạng
     * @return chuỗi thời gian đã format
     */
    public String getFormattedCreatedAt() {
        if (createdAt != null) {
            return new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(createdAt);
        }
        return "";
    }
    
    /**
     * Lấy thời gian tương đối (vd: "2 giờ trước")
     * @return chuỗi thời gian tương đối
     */
    public String getRelativeTime() {
        if (createdAt == null) return "";
        
        long diffInMillis = System.currentTimeMillis() - createdAt.getTime();
        long diffInSeconds = diffInMillis / 1000;
        long diffInMinutes = diffInSeconds / 60;
        long diffInHours = diffInMinutes / 60;
        long diffInDays = diffInHours / 24;
        
        if (diffInDays > 0) {
            return diffInDays + " ngày trước";
        } else if (diffInHours > 0) {
            return diffInHours + " giờ trước";
        } else if (diffInMinutes > 0) {
            return diffInMinutes + " phút trước";
        } else {
            return "Vừa xong";
        }
    }
    
    /**
     * Kiểm tra có phải hành động quan trọng hay không
     * @return true nếu là hành động quan trọng
     */
    public boolean isCriticalAction() {
        return "HIGH".equals(getActionSeverity());
    }
    
    /**
     * Lấy mô tả ngắn gọn của log
     * @return mô tả ngắn gọn
     */
    public String getShortDescription() {
        String actionName = getActionDisplayName();
        String targetName = (targetAdminName != null) ? targetAdminName : "hệ thống";
        return superAdminName + " đã " + actionName.toLowerCase() + " cho " + targetName;
    }
    
    /**
     * Kiểm tra có target admin hay không
     * @return true nếu có target admin
     */
    public boolean hasTargetAdmin() {
        return targetAdminId != null && targetAdminId > 0;
    }
    
    /**
     * Lấy browser name từ user agent
     * @return tên browser
     */
    public String getBrowserName() {
        if (userAgent == null || userAgent.isEmpty()) return "Unknown";
        
        if (userAgent.contains("Chrome")) return "Chrome";
        if (userAgent.contains("Firefox")) return "Firefox";
        if (userAgent.contains("Safari")) return "Safari";
        if (userAgent.contains("Edge")) return "Edge";
        if (userAgent.contains("Opera")) return "Opera";
        
        return "Other";
    }
    
    @Override
    public String toString() {
        return "AdminAuditLog{" +
                "logId=" + logId +
                ", superAdminId=" + superAdminId +
                ", targetAdminId=" + targetAdminId +
                ", action='" + action + '\'' +
                ", superAdminName='" + superAdminName + '\'' +
                ", targetAdminName='" + targetAdminName + '\'' +
                ", createdAt=" + createdAt +
                ", ipAddress='" + ipAddress + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        AdminAuditLog that = (AdminAuditLog) o;
        return logId == that.logId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(logId);
    }
}
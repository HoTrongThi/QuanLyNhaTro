package model;

import java.sql.Date;

/**
 * Lớp Model cho Người thuê
 * Đại diện cho việc phân công người dùng thuê phòng trong hệ thống
 * Quản lý mối quan hệ giữa người dùng và phòng trọ
 * Hỗ trợ theo dõi thời gian thuê và trạng thái hoạt động
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class Tenant {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của người thuê (Primary Key) */
    private int tenantId;
    
    /** ID người dùng (Foreign Key đến bảng users) */
    private int userId;
    
    /** ID phòng (Foreign Key đến bảng rooms) */
    private int roomId;
    
    /** Ngày bắt đầu thuê phòng */
    private Date startDate;
    
    /** Ngày kết thúc thuê (null nếu vẫn đang thuê) */
    private Date endDate;
    
    // ==================== THUỘC TÍNH HIỂN THỊ (TỪ JOIN) ====================
    
    /** Tên đăng nhập của người dùng (từ bảng users) */
    private String userName;
    
    /** Họ tên đầy đủ của người thuê (từ bảng users) */
    private String fullName;
    
    /** Số điện thoại liên hệ (từ bảng users) */
    private String phone;
    
    /** Địa chỉ email (từ bảng users) */
    private String email;
    
    /** Địa chỉ nhà (từ bảng users) */
    private String address;
    
    /** Tên phòng đang thuê (từ bảng rooms) */
    private String roomName;
    
    /** Giá phòng hiện tại (từ bảng rooms) */
    private java.math.BigDecimal roomPrice;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public Tenant() {}
    
    /**
     * Constructor để tạo người thuê mới
     * Sử dụng khi thêm người thuê mới vào phòng
     * 
     * @param userId ID người dùng
     * @param roomId ID phòng
     * @param startDate ngày bắt đầu thuê
     */
    public Tenant(int userId, int roomId, Date startDate) {
        this.userId = userId;
        this.roomId = roomId;
        this.startDate = startDate;
    }
    
    /**
     * Constructor đầy đủ với tất cả thuộc tính cơ bản
     * Sử dụng khi lấy dữ liệu từ database
     * 
     * @param tenantId ID người thuê
     * @param userId ID người dùng
     * @param roomId ID phòng
     * @param startDate ngày bắt đầu thuê
     * @param endDate ngày kết thúc thuê
     */
    public Tenant(int tenantId, int userId, int roomId, Date startDate, Date endDate) {
        this.tenantId = tenantId;
        this.userId = userId;
        this.roomId = roomId;
        this.startDate = startDate;
        this.endDate = endDate;
    }
    
    // Getters and Setters
    public int getTenantId() {
        return tenantId;
    }
    
    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getRoomId() {
        return roomId;
    }
    
    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
    
    public Date getStartDate() {
        return startDate;
    }
    
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }
    
    public Date getEndDate() {
        return endDate;
    }
    
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
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
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    public java.math.BigDecimal getRoomPrice() {
        return roomPrice;
    }
    
    public void setRoomPrice(java.math.BigDecimal roomPrice) {
        this.roomPrice = roomPrice;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra người thuê có đang hoạt động hay không
     * Người thuê được coi là hoạt động nếu chưa có ngày kết thúc
     * 
     * @return true nếu đang hoạt động, false nếu đã kết thúc
     */
    public boolean isActive() {
        return endDate == null;
    }
    
    /**
     * Lấy trạng thái hiển thị của người thuê
     * 
     * @return "Đang thuê" nếu hoạt động, "Đã kết thúc" nếu không
     */
    public String getStatus() {
        return isActive() ? "Đang thuê" : "Đã kết thúc";
    }
    
    // ToString method for debugging
    @Override
    public String toString() {
        return "Tenant{" +
                "tenantId=" + tenantId +
                ", userId=" + userId +
                ", roomId=" + roomId +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", fullName='" + fullName + '\'' +
                ", roomName='" + roomName + '\'' +
                '}';
    }
    
    // Equals and HashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Tenant tenant = (Tenant) o;
        return tenantId == tenant.tenantId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(tenantId);
    }
}

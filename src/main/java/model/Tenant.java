package model;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

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
    
    // ==================== THUỘC TÍNH THANH TOÁN ====================
    
    /** Trạng thái thanh toán (PAID/UNPAID) */
    private String paymentStatus;
    
    /** Danh sách kỳ nợ (nếu có) */
    private List<String> unpaidPeriods;
    
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
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public List<String> getUnpaidPeriods() {
        return unpaidPeriods;
    }
    
    public void setUnpaidPeriods(List<String> unpaidPeriods) {
        this.unpaidPeriods = unpaidPeriods;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra người thuê có đang hoạt động hay không
     * Người thuê được coi là hoạt động nếu:
     * - Chưa có ngày kết thúc (endDate == null), HOẶC
     * - Có ngày kết thúc nhưng chưa đến ngày đó (endDate > today)
     * 
     * @return true nếu đang hoạt động, false nếu đã kết thúc
     */
    public boolean isActive() {
        if (endDate == null) {
            return true;
        }
        LocalDate today = LocalDate.now();
        LocalDate endLocalDate = endDate.toLocalDate();
        return endLocalDate.isAfter(today);
    }
    
    /**
     * Kiểm tra người thuê có sắp kết thúc hợp đồng không
     * 
     * @return true nếu có ngày kết thúc trong tương lai
     */
    public boolean isEndingSoon() {
        if (endDate == null) {
            return false;
        }
        LocalDate today = LocalDate.now();
        LocalDate endLocalDate = endDate.toLocalDate();
        return endLocalDate.isAfter(today);
    }
    
    /**
     * Kiểm tra hợp đồng có kết thúc hôm nay không
     * 
     * @return true nếu kết thúc hôm nay
     */
    public boolean isEndingToday() {
        if (endDate == null) {
            return false;
        }
        LocalDate today = LocalDate.now();
        LocalDate endLocalDate = endDate.toLocalDate();
        return endLocalDate.equals(today);
    }
    
    /**
     * Lấy trạng thái hiển thị chi tiết của người thuê
     * 
     * @return trạng thái với thông tin ngày kết thúc nếu có
     */
    public String getDetailedStatus() {
        if (endDate == null) {
            return "Đang thuê";
        }
        
        LocalDate today = LocalDate.now();
        LocalDate endLocalDate = endDate.toLocalDate();
        
        if (endLocalDate.isAfter(today)) {
            return "Sắp kết thúc vào " + endDate.toString();
        } else {
            return "Đã kết thúc";
        }
    }
    
    /**
     * Lấy trạng thái hiển thị đơn giản của người thuê
     * 
     * @return "Đang thuê" nếu hoạt động, "Đã kết thúc" nếu không
     */
    public String getStatus() {
        return isActive() ? "Đang thuê" : "Đã kết thúc";
    }
    
    /**
     * Lấy CSS class cho badge trạng thái
     * 
     * @return CSS class phù hợp với trạng thái
     */
    public String getStatusBadgeClass() {
        if (endDate == null) {
            return "badge-active"; // Đang thuê
        }
        
        LocalDate today = LocalDate.now();
        LocalDate endLocalDate = endDate.toLocalDate();
        
        if (endLocalDate.isAfter(today)) {
            return "badge-warning"; // Sắp kết thúc
        } else {
            return "badge-inactive"; // Đã kết thúc
        }
    }
    
    // ==================== CÁC PHƯƠNG THỨC THANH TOÁN ====================
    
    /**
     * Kiểm tra có đang nợ tiền không
     * 
     * @return true nếu có kỳ nợ
     */
    public boolean hasUnpaidBills() {
        return paymentStatus != null && paymentStatus.startsWith("UNPAID");
    }
    
    /**
     * Lấy trạng thái thanh toán hiển thị
     * 
     * @return trạng thái thanh toán dễ đọc
     */
    public String getPaymentStatusDisplay() {
        if (paymentStatus == null || "PAID".equals(paymentStatus)) {
            return "Đã thanh toán";
        } else if (paymentStatus.startsWith("UNPAID:")) {
            return "Đang nợ";
        } else {
            return "Chưa rõ";
        }
    }
    
    /**
     * Lấy CSS class cho badge thanh toán
     * 
     * @return CSS class phù hợp với trạng thái thanh toán
     */
    public String getPaymentBadgeClass() {
        if (paymentStatus == null || "PAID".equals(paymentStatus)) {
            return "bg-success"; // Xanh lá - đã thanh toán
        } else if (paymentStatus.startsWith("UNPAID:")) {
            return "bg-danger"; // Đỏ - đang nợ
        } else {
            return "bg-secondary"; // Xám - chưa rõ
        }
    }
    
    /**
     * Lấy danh sách kỳ nợ dạng chuỗi
     * 
     * @return chuỗi các kỳ nợ, cách nhau bởi dấu phẩy
     */
    public String getUnpaidPeriodsString() {
        if (unpaidPeriods == null || unpaidPeriods.isEmpty()) {
            return "";
        }
        return String.join(", ", unpaidPeriods);
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

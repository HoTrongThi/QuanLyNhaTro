package model;

import java.sql.Timestamp;

/**
 * Lớp Model cho quản lý mối quan hệ Super Admin - Admin
 * Đại diện cho bảng admin_management trong cơ sở dữ liệu
 * Quản lý việc gán admin cho super admin và theo dõi trạng thái
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class AdminManagement {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của bản ghi quản lý (Primary Key) */
    private int managementId;
    
    /** ID của Super Admin quản lý */
    private int superAdminId;
    
    /** ID của Admin được quản lý */
    private int adminId;
    
    /** Ngày được gán */
    private Timestamp assignedDate;
    
    /** Trạng thái quản lý (ACTIVE, SUSPENDED, INACTIVE) */
    private String status;
    
    /** Ghi chú */
    private String notes;
    
    /** Thời gian tạo */
    private Timestamp createdAt;
    
    /** Thời gian cập nhật */
    private Timestamp updatedAt;
    
    // ==================== THUỘC TÍNH HIỂN THỊ (TỪ JOIN) ====================
    
    /** Tên đăng nhập của Super Admin */
    private String superAdminUsername;
    
    /** Họ tên đầy đủ của Super Admin */
    private String superAdminName;
    
    /** Email của Super Admin */
    private String superAdminEmail;
    
    /** Tên đăng nhập của Admin */
    private String adminUsername;
    
    /** Họ tên đầy đủ của Admin */
    private String adminName;
    
    /** Email của Admin */
    private String adminEmail;
    
    /** Số điện thoại của Admin */
    private String adminPhone;
    
    /** Thời gian tạo tài khoản Admin */
    private Timestamp adminCreatedAt;
    
    // ==================== THUỘC TÍNH THỐNG KÊ ====================
    
    /** Số lượng phòng mà admin này quản lý */
    private int totalRoomsManaged;
    
    /** Số lượng người thuê mà admin này quản lý */
    private int totalUsersManaged;
    
    /** Doanh thu tháng này của admin */
    private java.math.BigDecimal monthlyRevenue;
    
    /** Số hóa đơn chưa thanh toán */
    private int unpaidInvoices;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public AdminManagement() {}
    
    /**
     * Constructor để tạo mối quan hệ quản lý mới
     * @param superAdminId ID của Super Admin
     * @param adminId ID của Admin
     * @param status trạng thái quản lý
     * @param notes ghi chú
     */
    public AdminManagement(int superAdminId, int adminId, String status, String notes) {
        this.superAdminId = superAdminId;
        this.adminId = adminId;
        this.status = status;
        this.notes = notes;
        this.assignedDate = new Timestamp(System.currentTimeMillis());
    }
    
    /**
     * Constructor đầy đủ
     * @param managementId ID quản lý
     * @param superAdminId ID Super Admin
     * @param adminId ID Admin
     * @param assignedDate ngày gán
     * @param status trạng thái
     * @param notes ghi chú
     * @param createdAt thời gian tạo
     * @param updatedAt thời gian cập nhật
     */
    public AdminManagement(int managementId, int superAdminId, int adminId, Timestamp assignedDate, 
                          String status, String notes, Timestamp createdAt, Timestamp updatedAt) {
        this.managementId = managementId;
        this.superAdminId = superAdminId;
        this.adminId = adminId;
        this.assignedDate = assignedDate;
        this.status = status;
        this.notes = notes;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // ==================== CÁC PHƯƠNG THỨC GETTER VÀ SETTER ====================
    
    public int getManagementId() {
        return managementId;
    }
    
    public void setManagementId(int managementId) {
        this.managementId = managementId;
    }
    
    public int getSuperAdminId() {
        return superAdminId;
    }
    
    public void setSuperAdminId(int superAdminId) {
        this.superAdminId = superAdminId;
    }
    
    public int getAdminId() {
        return adminId;
    }
    
    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
    
    public Timestamp getAssignedDate() {
        return assignedDate;
    }
    
    public void setAssignedDate(Timestamp assignedDate) {
        this.assignedDate = assignedDate;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
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
    
    public String getSuperAdminEmail() {
        return superAdminEmail;
    }
    
    public void setSuperAdminEmail(String superAdminEmail) {
        this.superAdminEmail = superAdminEmail;
    }
    
    public String getAdminUsername() {
        return adminUsername;
    }
    
    public void setAdminUsername(String adminUsername) {
        this.adminUsername = adminUsername;
    }
    
    public String getAdminName() {
        return adminName;
    }
    
    public void setAdminName(String adminName) {
        this.adminName = adminName;
    }
    
    public String getAdminEmail() {
        return adminEmail;
    }
    
    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail;
    }
    
    public String getAdminPhone() {
        return adminPhone;
    }
    
    public void setAdminPhone(String adminPhone) {
        this.adminPhone = adminPhone;
    }
    
    public Timestamp getAdminCreatedAt() {
        return adminCreatedAt;
    }
    
    public void setAdminCreatedAt(Timestamp adminCreatedAt) {
        this.adminCreatedAt = adminCreatedAt;
    }
    
    // Statistics getters/setters
    public int getTotalRoomsManaged() {
        return totalRoomsManaged;
    }
    
    public void setTotalRoomsManaged(int totalRoomsManaged) {
        this.totalRoomsManaged = totalRoomsManaged;
    }
    
    public int getTotalUsersManaged() {
        return totalUsersManaged;
    }
    
    public void setTotalUsersManaged(int totalUsersManaged) {
        this.totalUsersManaged = totalUsersManaged;
    }
    
    public java.math.BigDecimal getMonthlyRevenue() {
        return monthlyRevenue;
    }
    
    public void setMonthlyRevenue(java.math.BigDecimal monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }
    
    public int getUnpaidInvoices() {
        return unpaidInvoices;
    }
    
    public void setUnpaidInvoices(int unpaidInvoices) {
        this.unpaidInvoices = unpaidInvoices;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra trạng thái có đang hoạt động hay không
     * @return true nếu đang hoạt động
     */
    public boolean isActive() {
        return "ACTIVE".equals(this.status);
    }
    
    /**
     * Kiểm tra có bị tạm khóa hay không
     * @return true nếu bị tạm khóa
     */
    public boolean isSuspended() {
        return "SUSPENDED".equals(this.status);
    }
    
    /**
     * Kiểm tra có bị vô hiệu hóa hay không
     * @return true nếu bị vô hiệu hóa
     */
    public boolean isInactive() {
        return "INACTIVE".equals(this.status);
    }
    
    /**
     * Lấy tên hiển thị của trạng thái
     * @return tên trạng thái bằng tiếng Việt
     */
    public String getStatusDisplayName() {
        switch (this.status) {
            case "ACTIVE":
                return "Đang hoạt động";
            case "SUSPENDED":
                return "Tạm khóa";
            case "INACTIVE":
                return "Vô hiệu hóa";
            default:
                return this.status;
        }
    }
    
    /**
     * Lấy CSS class cho badge trạng thái
     * @return CSS class phù hợp với trạng thái
     */
    public String getStatusBadgeClass() {
        switch (this.status) {
            case "ACTIVE":
                return "bg-success"; // Xanh lá - hoạt động
            case "SUSPENDED":
                return "bg-warning"; // Vàng - tạm khóa
            case "INACTIVE":
                return "bg-danger"; // Đỏ - vô hiệu hóa
            default:
                return "bg-secondary";
        }
    }
    
    /**
     * Lấy CSS class cho trạng thái (alias cho getStatusBadgeClass)
     * @return CSS class phù hợp với trạng thái
     */
    public String getStatusCssClass() {
        return getStatusBadgeClass();
    }
    
    /**
     * Lấy icon cho trạng thái
     * @return Bootstrap icon class
     */
    public String getStatusIcon() {
        switch (this.status) {
            case "ACTIVE":
                return "bi-check-circle-fill"; // Dấu tick
            case "SUSPENDED":
                return "bi-pause-circle-fill"; // Dấu tạm dừng
            case "INACTIVE":
                return "bi-x-circle-fill"; // Dấu X
            default:
                return "bi-question-circle";
        }
    }
    
    /**
     * Lấy thời gian gán định dạng
     * @return chuỗi thời gian đã format
     */
    public String getFormattedAssignedDate() {
        if (assignedDate != null) {
            return new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(assignedDate);
        }
        return "";
    }
    
    /**
     * Lấy doanh thu định dạng
     * @return chuỗi doanh thu đã format
     */
    public String getFormattedMonthlyRevenue() {
        if (monthlyRevenue != null) {
            return String.format("%,.0f VNĐ", monthlyRevenue.doubleValue());
        }
        return "0 VNĐ";
    }
    
    /**
     * Kiểm tra admin có hiệu quả hay không (dựa trên số liệu)
     * @return true nếu admin hoạt động hiệu quả
     */
    public boolean isEffectiveAdmin() {
        return isActive() && totalRoomsManaged > 0 && unpaidInvoices < totalRoomsManaged;
    }
    
    /**
     * Lấy mức độ hiệu quả
     * @return mức độ hiệu quả (HIGH, MEDIUM, LOW)
     */
    public String getEfficiencyLevel() {
        if (!isActive()) return "INACTIVE";
        
        if (totalRoomsManaged == 0) return "NO_DATA";
        
        double unpaidRatio = (double) unpaidInvoices / totalRoomsManaged;
        
        if (unpaidRatio <= 0.1) return "HIGH"; // <= 10% nợ
        else if (unpaidRatio <= 0.3) return "MEDIUM"; // <= 30% nợ
        else return "LOW"; // > 30% nợ
    }
    
    /**
     * Lấy tên hiển thị mức độ hiệu quả
     * @return tên mức độ hiệu quả
     */
    public String getEfficiencyDisplayName() {
        switch (getEfficiencyLevel()) {
            case "HIGH":
                return "Cao";
            case "MEDIUM":
                return "Trung bình";
            case "LOW":
                return "Thấp";
            case "INACTIVE":
                return "Không hoạt động";
            case "NO_DATA":
                return "Chưa có dữ liệu";
            default:
                return "Không xác định";
        }
    }
    
    /**
     * Lấy CSS class cho badge hiệu quả
     * @return CSS class cho mức độ hiệu quả
     */
    public String getEfficiencyBadgeClass() {
        switch (getEfficiencyLevel()) {
            case "HIGH":
                return "bg-success";
            case "MEDIUM":
                return "bg-warning";
            case "LOW":
                return "bg-danger";
            case "INACTIVE":
                return "bg-secondary";
            case "NO_DATA":
                return "bg-info";
            default:
                return "bg-secondary";
        }
    }
    
    @Override
    public String toString() {
        return "AdminManagement{" +
                "managementId=" + managementId +
                ", superAdminId=" + superAdminId +
                ", adminId=" + adminId +
                ", superAdminName='" + superAdminName + '\'' +
                ", adminName='" + adminName + '\'' +
                ", status='" + status + '\'' +
                ", assignedDate=" + assignedDate +
                ", totalRoomsManaged=" + totalRoomsManaged +
                ", totalUsersManaged=" + totalUsersManaged +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        AdminManagement that = (AdminManagement) o;
        return managementId == that.managementId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(managementId);
    }
}
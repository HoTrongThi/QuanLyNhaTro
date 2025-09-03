package model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * Lớp Model cho Chi phí phát sinh
 * Đại diện cho các chi phí phát sinh/bổ sung của người thuê
 * Bao gồm sửa chữa, vệ sinh, phạt, đền bù, thay thế thiết bị, v.v.
 * Hỗ trợ theo dõi và quản lý các khoản chi phí ngoài dịch vụ cơ bản
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class AdditionalCost {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của chi phí phát sinh (Primary Key) */
    private int costId;
    
    /** ID người thuê (Foreign Key đến bảng tenants) */
    private int tenantId;
    
    /** Mô tả chi tiết về chi phí (ví dụ: "Sửa chữa điều hòa", "Phạt để rác") */
    private String description;
    
    /** Số tiền chi phí (VNĐ) */
    private BigDecimal amount;
    
    /** Ngày phát sinh chi phí */
    private Date date;
    
    // ==================== THUỘC TÍNH HIỂN THỊ (TỮ JOIN) ====================
    
    /** Tên người thuê (từ bảng tenants/users) */
    private String tenantName;
    
    /** Tên phòng (từ bảng rooms) */
    private String roomName;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public AdditionalCost() {}
    
    /**
     * Constructor để tạo chi phí phát sinh mới (không có ID)
     * Sử dụng khi thêm chi phí phát sinh mới vào hệ thống
     * 
     * @param tenantId ID người thuê
     * @param description mô tả chi phí
     * @param amount số tiền
     * @param date ngày phát sinh
     */
    public AdditionalCost(int tenantId, String description, BigDecimal amount, Date date) {
        this.tenantId = tenantId;
        this.description = description;
        this.amount = amount;
        this.date = date;
    }
    
    /**
     * Constructor đầy đủ với tất cả thuộc tính
     * Sử dụng khi lấy dữ liệu từ database
     * 
     * @param costId ID chi phí
     * @param tenantId ID người thuê
     * @param description mô tả chi phí
     * @param amount số tiền
     * @param date ngày phát sinh
     */
    public AdditionalCost(int costId, int tenantId, String description, BigDecimal amount, Date date) {
        this.costId = costId;
        this.tenantId = tenantId;
        this.description = description;
        this.amount = amount;
        this.date = date;
    }
    
    // Getters and Setters
    public int getCostId() {
        return costId;
    }
    
    public void setCostId(int costId) {
        this.costId = costId;
    }
    
    public int getTenantId() {
        return tenantId;
    }
    
    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
    
    // Related entity properties
    public String getTenantName() {
        return tenantName;
    }
    
    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }
    
    public String getRoomName() {
        return roomName;
    }
    
    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
    
    @Override
    public String toString() {
        return "AdditionalCost{" +
                "costId=" + costId +
                ", tenantId=" + tenantId +
                ", description='" + description + '\'' +
                ", amount=" + amount +
                ", date=" + date +
                ", tenantName='" + tenantName + '\'' +
                ", roomName='" + roomName + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        AdditionalCost that = (AdditionalCost) o;
        return costId == that.costId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(costId);
    }
}

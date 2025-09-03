package model;

import java.math.BigDecimal;

/**
 * Lớp Model cho Sử dụng Dịch vụ
 * Đại diện cho dữ liệu sử dụng dịch vụ của người thuê
 * Bao gồm số lượng tiêu thụ điện, nước và các dịch vụ khác
 * Hỗ trợ tính toán tự động tổng chi phí dựa trên số lượng và đơn giá
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class ServiceUsage {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của bản ghi sử dụng (Primary Key) */
    private int usageId;
    
    /** ID người thuê (Foreign Key đến bảng tenants) */
    private int tenantId;
    
    /** ID dịch vụ (Foreign Key đến bảng services) */
    private int serviceId;
    
    /** Tháng sử dụng (1-12) */
    private int month;
    
    /** Năm sử dụng */
    private int year;
    
    /** Số lượng sử dụng (kWh, m3, tháng, xe, v.v.) */
    private BigDecimal quantity;
    
    // ==================== THUỘC TÍNH HIỂN THỊ (TỮ JOIN) ====================
    
    /** Tên dịch vụ (từ bảng services) */
    private String serviceName;
    
    /** Đơn vị tính của dịch vụ (từ bảng services) */
    private String serviceUnit;
    
    /** Giá trên đơn vị (từ bảng services) */
    private BigDecimal pricePerUnit;
    
    /** Tên người thuê (từ bảng tenants/users) */
    private String tenantName;
    
    /** Tên phòng (từ bảng rooms) */
    private String roomName;
    
    /** Tổng chi phí (quantity * pricePerUnit) */
    private BigDecimal totalCost;
    
    // Constructors
    public ServiceUsage() {}
    
    public ServiceUsage(int tenantId, int serviceId, int month, int year, BigDecimal quantity) {
        this.tenantId = tenantId;
        this.serviceId = serviceId;
        this.month = month;
        this.year = year;
        this.quantity = quantity;
    }
    
    public ServiceUsage(int usageId, int tenantId, int serviceId, int month, int year, BigDecimal quantity) {
        this.usageId = usageId;
        this.tenantId = tenantId;
        this.serviceId = serviceId;
        this.month = month;
        this.year = year;
        this.quantity = quantity;
    }
    
    // Getters and Setters
    public int getUsageId() {
        return usageId;
    }
    
    public void setUsageId(int usageId) {
        this.usageId = usageId;
    }
    
    public int getTenantId() {
        return tenantId;
    }
    
    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }
    
    public int getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }
    
    public int getMonth() {
        return month;
    }
    
    public void setMonth(int month) {
        this.month = month;
    }
    
    public int getYear() {
        return year;
    }
    
    public void setYear(int year) {
        this.year = year;
    }
    
    public BigDecimal getQuantity() {
        return quantity;
    }
    
    public void setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
    }
    
    // Related entity properties
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public String getServiceUnit() {
        return serviceUnit;
    }
    
    public void setServiceUnit(String serviceUnit) {
        this.serviceUnit = serviceUnit;
    }
    
    public BigDecimal getPricePerUnit() {
        return pricePerUnit;
    }
    
    public void setPricePerUnit(BigDecimal pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }
    
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
    
    public BigDecimal getTotalCost() {
        return totalCost;
    }
    
    public void setTotalCost(BigDecimal totalCost) {
        this.totalCost = totalCost;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Tính toán tổng chi phí dịch vụ
     * Tự động tính toán dựa trên số lượng sử dụng và đơn giá
     * Công thức: totalCost = quantity * pricePerUnit
     */
    public void calculateTotalCost() {
        if (quantity != null && pricePerUnit != null) {
            this.totalCost = quantity.multiply(pricePerUnit);
        } else {
            this.totalCost = BigDecimal.ZERO;
        }
    }
    
    /**
     * Lấy chuỗi hiển thị kỳ sử dụng
     * 
     * @return chuỗi dạng "MM/yyyy" (ví dụ: "03/2025")
     */
    public String getPeriodDisplay() {
        return String.format("%02d/%d", month, year);
    }
    
    /**
     * Lấy số lượng đã format với đơn vị
     * 
     * @return chuỗi số lượng kèm đơn vị (ví dụ: "150 kWh")
     */
    public String getFormattedQuantity() {
        if (quantity != null && serviceUnit != null) {
            return String.format("%.2f %s", quantity, serviceUnit);
        }
        return "0";
    }
    
    /**
     * Lấy tổng chi phí đã format
     * 
     * @return chuỗi tiền đã format (ví dụ: "450,000 VNĐ")
     */
    public String getFormattedTotalCost() {
        if (totalCost != null) {
            return String.format("%,.0f VNĐ", totalCost);
        }
        return "0 VNĐ";
    }
    
    @Override
    public String toString() {
        return "ServiceUsage{" +
                "usageId=" + usageId +
                ", tenantId=" + tenantId +
                ", serviceId=" + serviceId +
                ", month=" + month +
                ", year=" + year +
                ", quantity=" + quantity +
                ", serviceName='" + serviceName + '\'' +
                ", serviceUnit='" + serviceUnit + '\'' +
                ", pricePerUnit=" + pricePerUnit +
                ", tenantName='" + tenantName + '\'' +
                ", roomName='" + roomName + '\'' +
                ", totalCost=" + totalCost +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        ServiceUsage that = (ServiceUsage) o;
        return usageId == that.usageId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(usageId);
    }
}

package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Lớp Model cho Hóa đơn
 * Đại diện cho một hóa đơn hoàn chỉnh bao gồm tiền phòng, dịch vụ và chi phí phát sinh
 * Tích hợp với hệ thống thanh toán MoMo và hỗ trợ quản lý trạng thái thanh toán
 * Hỗ trợ tính toán tự động và hiển thị thông tin chi tiết
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class Invoice {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của hóa đơn (Primary Key) */
    private int invoiceId;
    
    /** ID người thuê (Foreign Key) */
    private int tenantId;
    
    /** Tháng của hóa đơn (1-12) */
    private int month;
    
    /** Năm của hóa đơn */
    private int year;
    
    /** Tiền phòng (có thể được tính theo tỷ lệ) */
    private BigDecimal roomPrice;
    
    /** Tổng tiền dịch vụ (điện, nước, internet, v.v.) */
    private BigDecimal serviceTotal;
    
    /** Tổng chi phí phát sinh (phạt, sửa chữa, v.v.) */
    private BigDecimal additionalTotal;
    
    /** Tổng số tiền cần thanh toán */
    private BigDecimal totalAmount;
    
    /** Trạng thái hóa đơn (UNPAID: chưa thanh toán, PAID: đã thanh toán) */
    private String status;
    
    /** Thời gian tạo hóa đơn */
    private Timestamp createdAt;
    
    // ==================== THUỘC TÍNH HIỂN THỊ ====================
    
    /** Tên người thuê (dùng cho hiển thị) */
    private String tenantName;
    
    /** Tên phòng (dùng cho hiển thị) */
    private String roomName;
    
    /** Số điện thoại người dùng (dùng cho hiển thị) */
    private String userPhone;
    
    /** Email người dùng (dùng cho hiển thị) */
    private String userEmail;
    
    /** Số lượng người thuê trong phòng */
    private int tenantsCount;
    
    // ==================== THUỘC TÍNH THANH TOÁN MOMO ====================
    
    /** URL của QR code MoMo */
    private String momoQrCodeUrl;
    
    /** Mã đơn hàng MoMo */
    private String momoOrderId;
    
    /** Mã yêu cầu MoMo */
    private String momoRequestId;
    
    /** Trạng thái thanh toán MoMo (PENDING: chờ, PAID: thành công, FAILED: thất bại) */
    private String momoPaymentStatus;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public Invoice() {}
    
    /**
     * Constructor để tạo hóa đơn mới
     * @param tenantId ID người thuê
     * @param month tháng hóa đơn
     * @param year năm hóa đơn
     * @param roomPrice tiền phòng
     * @param serviceTotal tổng tiền dịch vụ
     * @param additionalTotal tổng chi phí phát sinh
     * @param totalAmount tổng số tiền
     */
    public Invoice(int tenantId, int month, int year, BigDecimal roomPrice, 
                  BigDecimal serviceTotal, BigDecimal additionalTotal, BigDecimal totalAmount) {
        this.tenantId = tenantId;
        this.month = month;
        this.year = year;
        this.roomPrice = roomPrice;
        this.serviceTotal = serviceTotal;
        this.additionalTotal = additionalTotal;
        this.totalAmount = totalAmount;
        this.status = "UNPAID"; // Mặc định là chưa thanh toán
    }
    
    /**
     * Constructor đầy đủ với tất cả thông tin cơ bản
     * @param invoiceId ID hóa đơn
     * @param tenantId ID người thuê
     * @param month tháng hóa đơn
     * @param year năm hóa đơn
     * @param roomPrice tiền phòng
     * @param serviceTotal tổng tiền dịch vụ
     * @param additionalTotal tổng chi phí phát sinh
     * @param totalAmount tổng số tiền
     * @param status trạng thái hóa đơn
     * @param createdAt thời gian tạo
     */
    public Invoice(int invoiceId, int tenantId, int month, int year, BigDecimal roomPrice, 
                  BigDecimal serviceTotal, BigDecimal additionalTotal, BigDecimal totalAmount,
                  String status, Timestamp createdAt) {
        this.invoiceId = invoiceId;
        this.tenantId = tenantId;
        this.month = month;
        this.year = year;
        this.roomPrice = roomPrice;
        this.serviceTotal = serviceTotal;
        this.additionalTotal = additionalTotal;
        this.totalAmount = totalAmount;
        this.status = status;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getInvoiceId() {
        return invoiceId;
    }
    
    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }
    
    public int getTenantId() {
        return tenantId;
    }
    
    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
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
    
    public BigDecimal getRoomPrice() {
        return roomPrice;
    }
    
    public void setRoomPrice(BigDecimal roomPrice) {
        this.roomPrice = roomPrice;
    }
    
    public BigDecimal getServiceTotal() {
        return serviceTotal;
    }
    
    public void setServiceTotal(BigDecimal serviceTotal) {
        this.serviceTotal = serviceTotal;
    }
    
    public BigDecimal getAdditionalTotal() {
        return additionalTotal;
    }
    
    public void setAdditionalTotal(BigDecimal additionalTotal) {
        this.additionalTotal = additionalTotal;
    }
    
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
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
    
    public String getUserPhone() {
        return userPhone;
    }
    
    public void setUserPhone(String userPhone) {
        this.userPhone = userPhone;
    }
    
    public String getUserEmail() {
        return userEmail;
    }
    
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }
    
    public int getTenantsCount() {
        return tenantsCount;
    }
    
    public void setTenantsCount(int tenantsCount) {
        this.tenantsCount = tenantsCount;
    }
    
    // MoMo Payment getters and setters
    public String getMomoQrCodeUrl() {
        return momoQrCodeUrl;
    }
    
    public void setMomoQrCodeUrl(String momoQrCodeUrl) {
        this.momoQrCodeUrl = momoQrCodeUrl;
    }
    
    public String getMomoOrderId() {
        return momoOrderId;
    }
    
    public void setMomoOrderId(String momoOrderId) {
        this.momoOrderId = momoOrderId;
    }
    
    public String getMomoRequestId() {
        return momoRequestId;
    }
    
    public void setMomoRequestId(String momoRequestId) {
        this.momoRequestId = momoRequestId;
    }
    
    public String getMomoPaymentStatus() {
        return momoPaymentStatus;
    }
    
    public void setMomoPaymentStatus(String momoPaymentStatus) {
        this.momoPaymentStatus = momoPaymentStatus;
    }
    
    // Helper methods
    public boolean isPaid() {
        return "PAID".equalsIgnoreCase(status);
    }
    
    public boolean isUnpaid() {
        return "UNPAID".equalsIgnoreCase(status);
    }
    
    public String getFormattedPeriod() {
        return String.format("%02d/%d", month, year);
    }
    
    public void calculateTotalAmount() {
        BigDecimal room = roomPrice != null ? roomPrice : BigDecimal.ZERO;
        BigDecimal service = serviceTotal != null ? serviceTotal : BigDecimal.ZERO;
        BigDecimal additional = additionalTotal != null ? additionalTotal : BigDecimal.ZERO;
        
        this.totalAmount = room.add(service).add(additional);
    }
    
    // MoMo Payment helper methods
    public boolean hasMomoQrCode() {
        return momoQrCodeUrl != null && !momoQrCodeUrl.trim().isEmpty();
    }
    
    public boolean isMomoPending() {
        return "PENDING".equalsIgnoreCase(momoPaymentStatus);
    }
    
    public boolean isMomoPaid() {
        return "PAID".equalsIgnoreCase(momoPaymentStatus);
    }
    
    public boolean isMomoFailed() {
        return "FAILED".equalsIgnoreCase(momoPaymentStatus);
    }
    
    @Override
    public String toString() {
        return "Invoice{" +
                "invoiceId=" + invoiceId +
                ", tenantId=" + tenantId +
                ", month=" + month +
                ", year=" + year +
                ", roomPrice=" + roomPrice +
                ", serviceTotal=" + serviceTotal +
                ", additionalTotal=" + additionalTotal +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                ", tenantName='" + tenantName + '\'' +
                ", roomName='" + roomName + '\'' +
                ", userPhone='" + userPhone + '\'' +
                ", userEmail='" + userEmail + '\'' +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Invoice invoice = (Invoice) o;
        return invoiceId == invoice.invoiceId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(invoiceId);
    }
}

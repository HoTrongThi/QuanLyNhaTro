package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Invoice Entity
 * Represents a complete invoice/bill for a tenant including room fee, services, and additional costs
 */
public class Invoice {
    private int invoiceId;
    private int tenantId;
    private int month;
    private int year;
    private BigDecimal roomPrice;
    private BigDecimal serviceTotal;
    private BigDecimal additionalTotal;
    private BigDecimal totalAmount;
    private String status; // UNPAID, PAID
    private Timestamp createdAt;
    
    // Related entities for display purposes
    private String tenantName;
    private String roomName;
    private String userPhone;
    private String userEmail;
    private int tenantsCount; // Number of tenants in the room
    
    // MoMo Payment fields
    private String momoQrCodeUrl;
    private String momoOrderId;
    private String momoRequestId;
    private String momoPaymentStatus; // PENDING, PAID, FAILED
    
    // Constructors
    public Invoice() {}
    
    public Invoice(int tenantId, int month, int year, BigDecimal roomPrice, 
                  BigDecimal serviceTotal, BigDecimal additionalTotal, BigDecimal totalAmount) {
        this.tenantId = tenantId;
        this.month = month;
        this.year = year;
        this.roomPrice = roomPrice;
        this.serviceTotal = serviceTotal;
        this.additionalTotal = additionalTotal;
        this.totalAmount = totalAmount;
        this.status = "UNPAID";
    }
    
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

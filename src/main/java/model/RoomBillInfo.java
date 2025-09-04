package model;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * Lớp hỗ trợ chứa thông tin phòng và hóa đơn cho giao diện room-based bills
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class RoomBillInfo {
    private int roomId;
    private String roomName;
    private List<Tenant> tenants;
    private int tenantCount;
    private boolean hasActiveTenants;
    private boolean hasUnpaidBills;
    private BigDecimal totalDebt;
    private int unpaidCount;
    private String unpaidPeriods;
    
    // Thêm các thuộc tính cho bulk bill generation
    private BigDecimal roomPrice;
    private BigDecimal fullRoomPrice; // Giá gốc phòng (trước khi tính tỷ lệ)
    private List<Service> services;
    private List<AdditionalCost> additionalCosts;
    private BigDecimal additionalTotal;
    private List<ServiceUsage> existingUsages;
    private Map<Integer, MeterReading> previousReadings; // Chỉ số trước đó cho các dịch vụ có công tơ
    
    // Constructors
    public RoomBillInfo() {}
    
    public RoomBillInfo(int roomId, String roomName) {
        this.roomId = roomId;
        this.roomName = roomName;
    }
    
    // Getters and Setters
    public int getRoomId() { 
        return roomId; 
    }
    
    public void setRoomId(int roomId) { 
        this.roomId = roomId; 
    }
    
    public String getRoomName() { 
        return roomName; 
    }
    
    public void setRoomName(String roomName) { 
        this.roomName = roomName; 
    }
    
    public List<Tenant> getTenants() { 
        return tenants; 
    }
    
    public void setTenants(List<Tenant> tenants) { 
        this.tenants = tenants; 
    }
    
    public int getTenantCount() { 
        return tenantCount; 
    }
    
    public void setTenantCount(int tenantCount) { 
        this.tenantCount = tenantCount; 
    }
    
    public boolean getHasActiveTenants() { 
        return hasActiveTenants; 
    }
    
    public void setHasActiveTenants(boolean hasActiveTenants) { 
        this.hasActiveTenants = hasActiveTenants; 
    }
    
    public boolean getHasUnpaidBills() { 
        return hasUnpaidBills; 
    }
    
    public void setHasUnpaidBills(boolean hasUnpaidBills) { 
        this.hasUnpaidBills = hasUnpaidBills; 
    }
    
    public BigDecimal getTotalDebt() { 
        return totalDebt; 
    }
    
    public void setTotalDebt(BigDecimal totalDebt) { 
        this.totalDebt = totalDebt; 
    }
    
    public int getUnpaidCount() { 
        return unpaidCount; 
    }
    
    public void setUnpaidCount(int unpaidCount) { 
        this.unpaidCount = unpaidCount; 
    }
    
    public String getUnpaidPeriods() { 
        return unpaidPeriods; 
    }
    
    public void setUnpaidPeriods(String unpaidPeriods) { 
        this.unpaidPeriods = unpaidPeriods; 
    }
    
    // Getter và Setter cho các thuộc tính mới
    public BigDecimal getRoomPrice() {
        return roomPrice;
    }
    
    public void setRoomPrice(BigDecimal roomPrice) {
        this.roomPrice = roomPrice;
    }
    
    public BigDecimal getFullRoomPrice() {
        return fullRoomPrice;
    }
    
    public void setFullRoomPrice(BigDecimal fullRoomPrice) {
        this.fullRoomPrice = fullRoomPrice;
    }
    
    public List<Service> getServices() {
        return services;
    }
    
    public void setServices(List<Service> services) {
        this.services = services;
    }
    
    public List<AdditionalCost> getAdditionalCosts() {
        return additionalCosts;
    }
    
    public void setAdditionalCosts(List<AdditionalCost> additionalCosts) {
        this.additionalCosts = additionalCosts;
    }
    
    public BigDecimal getAdditionalTotal() {
        return additionalTotal;
    }
    
    public void setAdditionalTotal(BigDecimal additionalTotal) {
        this.additionalTotal = additionalTotal;
    }
    
    public List<ServiceUsage> getExistingUsages() {
        return existingUsages;
    }
    
    public void setExistingUsages(List<ServiceUsage> existingUsages) {
        this.existingUsages = existingUsages;
    }
    
    public Map<Integer, MeterReading> getPreviousReadings() {
        return previousReadings;
    }
    
    public void setPreviousReadings(Map<Integer, MeterReading> previousReadings) {
        this.previousReadings = previousReadings;
    }
    
    // Utility methods
    @Override
    public String toString() {
        return "RoomBillInfo{" +
                "roomId=" + roomId +
                ", roomName='" + roomName + '\'' +
                ", tenantCount=" + tenantCount +
                ", hasActiveTenants=" + hasActiveTenants +
                ", hasUnpaidBills=" + hasUnpaidBills +
                ", totalDebt=" + totalDebt +
                ", unpaidCount=" + unpaidCount +
                ", unpaidPeriods='" + unpaidPeriods + '\'' +
                '}';
    }
}
package model;

import java.math.BigDecimal;

/**
 * ServiceUsage Entity
 * Represents service usage data (electricity, water consumption) for tenants
 */
public class ServiceUsage {
    private int usageId;
    private int tenantId;
    private int serviceId;
    private int month;
    private int year;
    private BigDecimal quantity;
    
    // Related entities for display purposes
    private String serviceName;
    private String serviceUnit;
    private BigDecimal pricePerUnit;
    private String tenantName;
    private String roomName;
    private BigDecimal totalCost; // quantity * pricePerUnit
    
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
    
    // Helper method to calculate total cost
    public void calculateTotalCost() {
        if (quantity != null && pricePerUnit != null) {
            this.totalCost = quantity.multiply(pricePerUnit);
        }
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

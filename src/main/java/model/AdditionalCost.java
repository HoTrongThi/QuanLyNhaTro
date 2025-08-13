package model;

import java.math.BigDecimal;
import java.util.Date;

/**
 * AdditionalCost Entity
 * Represents additional/incidental costs for tenants (repairs, cleaning, etc.)
 */
public class AdditionalCost {
    private int costId;
    private int tenantId;
    private String description;
    private BigDecimal amount;
    private Date date;
    
    // Related entities for display purposes
    private String tenantName;
    private String roomName;
    
    // Constructors
    public AdditionalCost() {}
    
    public AdditionalCost(int tenantId, String description, BigDecimal amount, Date date) {
        this.tenantId = tenantId;
        this.description = description;
        this.amount = amount;
        this.date = date;
    }
    
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

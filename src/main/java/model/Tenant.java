package model;

import java.sql.Date;

/**
 * Tenant Entity
 * Represents a tenant assignment (user renting a room) in the room management system
 */
public class Tenant {
    private int tenantId;
    private int userId;
    private int roomId;
    private Date startDate;
    private Date endDate;
    
    // Additional information from joins
    private String userName;
    private String fullName;
    private String phone;
    private String email;
    private String address;
    private String roomName;
    private java.math.BigDecimal roomPrice;
    
    // Constructors
    public Tenant() {}
    
    public Tenant(int userId, int roomId, Date startDate) {
        this.userId = userId;
        this.roomId = roomId;
        this.startDate = startDate;
    }
    
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
    
    // Helper methods
    public boolean isActive() {
        return endDate == null;
    }
    
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

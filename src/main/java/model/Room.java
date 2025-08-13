package model;

import java.math.BigDecimal;

/**
 * Room Model Class
 * Represents the rooms table in the database
 */
public class Room {
    private int roomId;
    private String roomName;
    private BigDecimal price;
    private String status; // AVAILABLE or OCCUPIED
    private String description;
    
    // Default constructor
    public Room() {}
    
    // Constructor without ID (for creating new rooms)
    public Room(String roomName, BigDecimal price, String status, String description) {
        this.roomName = roomName;
        this.price = price;
        this.status = status;
        this.description = description;
    }
    
    // Full constructor
    public Room(int roomId, String roomName, BigDecimal price, String status, String description) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.price = price;
        this.status = status;
        this.description = description;
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
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    // Helper methods
    public boolean isAvailable() {
        return "AVAILABLE".equals(this.status);
    }
    
    public boolean isOccupied() {
        return "OCCUPIED".equals(this.status);
    }
    
    public String getStatusDisplayName() {
        if ("AVAILABLE".equals(this.status)) {
            return "Có sẵn";
        } else if ("OCCUPIED".equals(this.status)) {
            return "Đã thuê";
        }
        return this.status;
    }
    
    public String getFormattedPrice() {
        if (price != null) {
            return String.format("%,.0f VNĐ", price);
        }
        return "0 VNĐ";
    }
    
    @Override
    public String toString() {
        return "Room{" +
                "roomId=" + roomId +
                ", roomName='" + roomName + '\'' +
                ", price=" + price +
                ", status='" + status + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}

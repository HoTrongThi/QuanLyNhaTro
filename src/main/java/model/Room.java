package model;

import java.math.BigDecimal;

/**
 * Lớp Model cho Phòng trọ
 * Đại diện cho bảng rooms trong cơ sở dữ liệu
 * Quản lý thông tin phòng bao gồm giá, trạng thái và mô tả
 * Hỗ trợ các phương thức tiện ích để hiển thị và kiểm tra trạng thái
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class Room {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của phòng (Primary Key) */
    private int roomId;
    
    /** Tên phòng (ví dụ: "Phòng 101", "A01") */
    private String roomName;
    
    /** Giá thuê phòng theo tháng (VNĐ) */
    private BigDecimal price;
    
    /** Trạng thái phòng (AVAILABLE: có sẵn, OCCUPIED: đã thuê) */
    private String status;
    
    /** Mô tả chi tiết về phòng (diện tích, tiện nghi, v.v.) */
    private String description;
    
    /** Tiện nghi phòng trọ (JSON format) */
    private String amenities;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public Room() {}
    
    /**
     * Constructor để tạo phòng mới (không có ID)
     * Sử dụng khi thêm phòng mới vào hệ thống
     * 
     * @param roomName tên phòng
     * @param price giá thuê tháng
     * @param status trạng thái phòng
     * @param description mô tả phòng
     */
    public Room(String roomName, BigDecimal price, String status, String description) {
        this.roomName = roomName;
        this.price = price;
        this.status = status;
        this.description = description;
        this.amenities = "[]";
    }
    
    /**
     * Constructor để tạo phòng mới với tiện nghi
     * 
     * @param roomName tên phòng
     * @param price giá thuê tháng
     * @param status trạng thái phòng
     * @param description mô tả phòng
     * @param amenities tiện nghi phòng
     */
    public Room(String roomName, BigDecimal price, String status, String description, String amenities) {
        this.roomName = roomName;
        this.price = price;
        this.status = status;
        this.description = description;
        this.amenities = amenities;
    }
    
    /**
     * Constructor đầy đủ với tất cả thuộc tính
     * Sử dụng khi lấy dữ liệu từ database
     * 
     * @param roomId ID phòng
     * @param roomName tên phòng
     * @param price giá thuê tháng
     * @param status trạng thái phòng
     * @param description mô tả phòng
     * @param amenities tiện nghi phòng
     */
    public Room(int roomId, String roomName, BigDecimal price, String status, String description, String amenities) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.price = price;
        this.status = status;
        this.description = description;
        this.amenities = amenities;
    }
    
    // ==================== CÁC PHƯƠNG THỨC GETTER VÀ SETTER ====================
    
    /**
     * Lấy ID phòng
     * @return ID phòng
     */
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
    
    public String getAmenities() {
        return amenities;
    }
    
    public void setAmenities(String amenities) {
        this.amenities = amenities;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra phòng có sẵn hay không
     * @return true nếu phòng có sẵn, false nếu không
     */
    public boolean isAvailable() {
        return "AVAILABLE".equals(this.status);
    }
    
    /**
     * Kiểm tra phòng đã được thuê hay chưa
     * @return true nếu phòng đã thuê, false nếu chưa
     */
    public boolean isOccupied() {
        return "OCCUPIED".equals(this.status);
    }
    
    /**
     * Lấy tên hiển thị trạng thái phòng bằng tiếng Việt
     * @return tên trạng thái tiếng Việt
     */
    public String getStatusDisplayName() {
        if ("AVAILABLE".equals(this.status)) {
            return "Có sẵn";
        } else if ("OCCUPIED".equals(this.status)) {
            return "Đã thuê";
        }
        return this.status;
    }
    
    /**
     * Lấy giá phòng đã được format với đơn vị tiền tệ
     * @return giá phòng đã format (ví dụ: "2,500,000 VNĐ")
     */
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
                ", amenities='" + amenities + '\'' +
                '}';
    }
}

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
    
    // ==================== THUỘC TÍNH THANH TOÁN ====================
    
    /** Trạng thái thanh toán của phòng (PAID/UNPAID) */
    private String paymentStatus;
    
    /** Danh sách kỳ nợ của phòng (nếu có) */
    private java.util.List<String> unpaidPeriods;
    
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
    
    public String getPaymentStatus() {
        return paymentStatus;
    }
    
    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    
    public java.util.List<String> getUnpaidPeriods() {
        return unpaidPeriods;
    }
    
    public void setUnpaidPeriods(java.util.List<String> unpaidPeriods) {
        this.unpaidPeriods = unpaidPeriods;
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
     * Kiểm tra phòng đang sửa chữa
     * @return true nếu phòng đang sửa chữa
     */
    public boolean isMaintenance() {
        return "MAINTENANCE".equals(this.status);
    }
    
    /**
     * Kiểm tra phòng đã đặt cọc
     * @return true nếu phòng đã đặt cọc
     */
    public boolean isReserved() {
        return "RESERVED".equals(this.status);
    }
    
    /**
     * Kiểm tra phòng ngưng sử dụng
     * @return true nếu phòng ngưng sử dụng
     */
    public boolean isSuspended() {
        return "SUSPENDED".equals(this.status);
    }
    
    /**
     * Kiểm tra phòng đang dọn dẹp
     * @return true nếu phòng đang dọn dẹp
     */
    public boolean isCleaning() {
        return "CLEANING".equals(this.status);
    }
    
    /**
     * Kiểm tra phòng hết hạn hợp đồng
     * @return true nếu phòng hết hạn hợp đồng
     */
    public boolean isContractExpired() {
        return "CONTRACT_EXPIRED".equals(this.status);
    }
    
    /**
     * Kiểm tra phòng có thể cho thuê không (AVAILABLE hoặc RESERVED)
     * @return true nếu phòng có thể cho thuê
     */
    public boolean isRentable() {
        return "AVAILABLE".equals(this.status) || "RESERVED".equals(this.status);
    }
    
    /**
     * Lấy tên hiển thị trạng thái phòng bằng tiếng Việt
     * @return tên trạng thái tiếng Việt
     */
    public String getStatusDisplayName() {
        switch (this.status) {
            case "AVAILABLE":
                return "Phòng trống";
            case "OCCUPIED":
                return "Đang thuê";
            case "MAINTENANCE":
                return "Đang sửa chữa";
            case "RESERVED":
                return "Đã đặt cọc";
            case "SUSPENDED":
                return "Ngưng sử dụng";
            case "CLEANING":
                return "Đang dọn dẹp";
            case "CONTRACT_EXPIRED":
                return "Hết hạn hợp đồng";
            default:
                return this.status;
        }
    }
    
    /**
     * Lấy CSS class cho badge trạng thái
     * @return CSS class phù hợp với trạng thái
     */
    public String getStatusBadgeClass() {
        switch (this.status) {
            case "AVAILABLE":
                return "bg-success"; // Xanh lá - có sẵn
            case "OCCUPIED":
                return "bg-primary"; // Xanh dương - đang thuê
            case "MAINTENANCE":
                return "bg-warning"; // Vàng - đang sửa chữa
            case "RESERVED":
                return "bg-info"; // Xanh nhạt - đã đặt cọc
            case "SUSPENDED":
                return "bg-secondary"; // Xám - ngưng sử dụng
            case "CLEANING":
                return "bg-light text-dark"; // Trắng - đang dọn dẹp
            case "CONTRACT_EXPIRED":
                return "bg-danger"; // Đỏ - hết hạn hợp đồng
            default:
                return "bg-secondary";
        }
    }
    
    /**
     * Lấy icon cho trạng thái phòng
     * @return Bootstrap icon class
     */
    public String getStatusIcon() {
        switch (this.status) {
            case "AVAILABLE":
                return "bi-door-open"; // Cửa mở
            case "OCCUPIED":
                return "bi-person-fill"; // Người
            case "MAINTENANCE":
                return "bi-tools"; // Công cụ
            case "RESERVED":
                return "bi-bookmark-fill"; // Đánh dấu
            case "SUSPENDED":
                return "bi-pause-circle"; // Tạm dừng
            case "CLEANING":
                return "bi-brush"; // Chổi
            case "CONTRACT_EXPIRED":
                return "bi-calendar-x"; // Lịch X
            default:
                return "bi-question-circle";
        }
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
    
    // ==================== CÁC PHƯƠNG THỨC THANH TOÁN ====================
    
    /**
     * Kiểm tra phòng có đang nợ tiền không
     * 
     * @return true nếu phòng có kỳ nợ
     */
    public boolean hasUnpaidBills() {
        return paymentStatus != null && paymentStatus.startsWith("UNPAID");
    }
    
    /**
     * Lấy trạng thái thanh toán hiển thị
     * 
     * @return trạng thái thanh toán dễ đọc
     */
    public String getPaymentStatusDisplay() {
        if (paymentStatus == null || "PAID".equals(paymentStatus)) {
            return "Đã thanh toán";
        } else if (paymentStatus.startsWith("UNPAID:")) {
            return "Đang nợ";
        } else {
            return "Chưa rõ";
        }
    }
    
    /**
     * Lấy CSS class cho badge thanh toán
     * 
     * @return CSS class phù hợp với trạng thái thanh toán
     */
    public String getPaymentBadgeClass() {
        if (paymentStatus == null || "PAID".equals(paymentStatus)) {
            return "bg-success"; // Xanh lá - đã thanh toán
        } else if (paymentStatus.startsWith("UNPAID:")) {
            return "bg-danger"; // Đỏ - đang nợ
        } else {
            return "bg-secondary"; // Xám - chưa rõ
        }
    }
    
    /**
     * Lấy danh sách kỳ nợ dạng chuỗi
     * 
     * @return chuỗi các kỳ nợ, cách nhau bởi dấu phẩy
     */
    public String getUnpaidPeriodsString() {
        if (unpaidPeriods == null || unpaidPeriods.isEmpty()) {
            return "";
        }
        return String.join(", ", unpaidPeriods);
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

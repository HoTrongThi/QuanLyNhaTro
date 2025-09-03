package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * Lớp Model cho Chỉ số Công tơ
 * Đại diện cho việc ghi chỉ số công tơ các dịch vụ (điện, nước) của người thuê
 * Sử dụng để theo dõi chỉ số công tơ theo thời gian và tính toán lượng tiêu thụ
 * Hỗ trợ tính toán tự động lượng tiêu thụ dựa trên chỉ số hiện tại và trước đó
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class MeterReading {
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của bản ghi chỉ số (Primary Key) */
    private int readingId;
    
    /** ID người thuê (Foreign Key đến bảng tenants) */
    private int tenantId;
    
    /** ID dịch vụ (Foreign Key đến bảng services) */
    private int serviceId;
    
    /** Chỉ số công tơ hiện tại (kWh cho điện, m3 cho nước) */
    private BigDecimal reading;
    
    /** Ngày ghi chỉ số */
    private Date readingDate;
    
    /** Tháng của chỉ số (1-12) */
    private int month;
    
    /** Năm của chỉ số */
    private int year;
    
    /** Thời gian tạo bản ghi */
    private Timestamp createdAt;
    
    // ==================== THUỘC TÍNH HIỂN THỊ VÀ TÍNH TOÁN ====================
    
    /** Tên dịch vụ (từ bảng services) */
    private String serviceName;
    
    /** Đơn vị tính của dịch vụ (từ bảng services) */
    private String serviceUnit;
    
    /** Tên người thuê (từ bảng tenants/users) */
    private String tenantName;
    
    /** Tên phòng (từ bảng rooms) */
    private String roomName;
    
    /** Chỉ số công tơ kỳ trước (để tính toán tiêu thụ) */
    private BigDecimal previousReading;
    
    /** Lượng tiêu thụ đã tính toán (chỉ số hiện tại - chỉ số trước) */
    private BigDecimal consumption;
    
    // Constructors
    public MeterReading() {}
    
    public MeterReading(int tenantId, int serviceId, BigDecimal reading, Date readingDate, int month, int year) {
        this.tenantId = tenantId;
        this.serviceId = serviceId;
        this.reading = reading;
        this.readingDate = readingDate;
        this.month = month;
        this.year = year;
    }
    
    public MeterReading(int readingId, int tenantId, int serviceId, BigDecimal reading, Date readingDate, int month, int year, Timestamp createdAt) {
        this.readingId = readingId;
        this.tenantId = tenantId;
        this.serviceId = serviceId;
        this.reading = reading;
        this.readingDate = readingDate;
        this.month = month;
        this.year = year;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getReadingId() {
        return readingId;
    }
    
    public void setReadingId(int readingId) {
        this.readingId = readingId;
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
    
    public BigDecimal getReading() {
        return reading;
    }
    
    public void setReading(BigDecimal reading) {
        this.reading = reading;
    }
    
    public Date getReadingDate() {
        return readingDate;
    }
    
    public void setReadingDate(Date readingDate) {
        this.readingDate = readingDate;
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
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
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
    
    public BigDecimal getPreviousReading() {
        return previousReading;
    }
    
    public void setPreviousReading(BigDecimal previousReading) {
        this.previousReading = previousReading;
    }
    
    public BigDecimal getConsumption() {
        return consumption;
    }
    
    public void setConsumption(BigDecimal consumption) {
        this.consumption = consumption;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Tính toán lượng tiêu thụ
     * Tự động tính toán dựa trên chỉ số hiện tại và chỉ số kỳ trước
     * Công thức: consumption = reading - previousReading
     */
    public void calculateConsumption() {
        if (reading != null && previousReading != null) {
            this.consumption = reading.subtract(previousReading);
            // Đảm bảo lượng tiêu thụ không âm (trường hợp thay công tơ mới)
            if (this.consumption.compareTo(BigDecimal.ZERO) < 0) {
                this.consumption = BigDecimal.ZERO;
            }
        } else {
            this.consumption = BigDecimal.ZERO;
        }
    }
    
    /**
     * Lấy chuỗi hiển thị kỳ ghi chỉ số
     * 
     * @return chuỗi dạng "MM/yyyy" (ví dụ: "03/2025")
     */
    public String getFormattedPeriod() {
        return String.format("%02d/%d", month, year);
    }
    
    /**
     * Lấy chỉ số đã format với đơn vị
     * 
     * @return chuỗi chỉ số kèm đơn vị (ví dụ: "1250.5 kWh")
     */
    public String getFormattedReading() {
        if (reading != null && serviceUnit != null) {
            return String.format("%.1f %s", reading, serviceUnit);
        }
        return "0";
    }
    
    /**
     * Lấy lượng tiêu thụ đã format
     * 
     * @return chuỗi lượng tiêu thụ kèm đơn vị (ví dụ: "150.5 kWh")
     */
    public String getFormattedConsumption() {
        if (consumption != null && serviceUnit != null) {
            return String.format("%.1f %s", consumption, serviceUnit);
        }
        return "0";
    }
    
    /**
     * Kiểm tra xem có chỉ số kỳ trước hay không
     * 
     * @return true nếu có chỉ số kỳ trước, false nếu không
     */
    public boolean hasPreviousReading() {
        return previousReading != null && previousReading.compareTo(BigDecimal.ZERO) >= 0;
    }
    
    @Override
    public String toString() {
        return "MeterReading{" +
                "readingId=" + readingId +
                ", tenantId=" + tenantId +
                ", serviceId=" + serviceId +
                ", reading=" + reading +
                ", readingDate=" + readingDate +
                ", month=" + month +
                ", year=" + year +
                ", serviceName='" + serviceName + '\'' +
                ", serviceUnit='" + serviceUnit + '\'' +
                ", tenantName='" + tenantName + '\'' +
                ", roomName='" + roomName + '\'' +
                ", previousReading=" + previousReading +
                ", consumption=" + consumption +
                ", createdAt=" + createdAt +
                '}';
    }
    
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        MeterReading that = (MeterReading) o;
        return readingId == that.readingId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(readingId);
    }
}
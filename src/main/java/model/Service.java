package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Lớp Model cho Dịch vụ (Phiên bản 2.0)
 * Đại diện cho các dịch vụ trong hệ thống quản lý phòng trọ
 * Hỗ trợ 5 loại dịch vụ: Miễn phí, Theo tháng, Theo chỉ số, Theo đầu người, Theo phòng
 * Hỗ trợ cấu hình tính toán linh hoạt (bậc thang, giá cố định, v.v.)
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 2.0
 * @since 2025
 */
public class Service {
    
    // ==================== ENUM ĐỊNH NGHĨA LOẠI DỊCH VỤ ====================
    
    /**
     * Enum định nghĩa các loại dịch vụ
     */
    public enum ServiceType {
        FREE("Miễn phí", "🆓"),
        MONTHLY("Theo tháng", "📅"),
        METER_READING("Theo chỉ số", "📊"),
        PER_PERSON("Theo đầu người", "👥"),
        PER_ROOM("Theo phòng", "🏠");
        
        private final String displayName;
        private final String icon;
        
        ServiceType(String displayName, String icon) {
            this.displayName = displayName;
            this.icon = icon;
        }
        
        public String getDisplayName() { return displayName; }
        public String getIcon() { return icon; }
    }
    
    // ==================== CÁC THUỘC TÍNH CƠ BẢN ====================
    
    /** ID duy nhất của dịch vụ (Primary Key) */
    private int serviceId;
    
    /** Tên dịch vụ (ví dụ: "Điện sinh hoạt", "Internet WiFi", "Vệ sinh chung") */
    private String serviceName;
    
    /** Đơn vị tính (ví dụ: "kWh", "m³", "tháng", "người", "phòng") */
    private String unit;
    
    /** Giá trên mỗi đơn vị (VNĐ) - Có thể là 0 cho dịch vụ miễn phí */
    private BigDecimal pricePerUnit;
    
    // ==================== CÁC THUỘC TÍNH MỚI ====================
    
    /** Loại dịch vụ */
    private ServiceType serviceType;
    
    /** Cấu hình tính toán (JSON format) */
    private String calculationConfig;
    
    /** ID Admin quản lý dịch vụ này (null = Super Admin hoặc dịch vụ chung) */
    private Integer managedByAdminId;
    
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public Service() {
        this.serviceType = ServiceType.MONTHLY; // Mặc định
    }
    
    /**
     * Constructor để tạo dịch vụ mới (phiên bản cũ - tương thích ngược)
     * 
     * @param serviceName tên dịch vụ
     * @param unit đơn vị tính
     * @param pricePerUnit giá trên đơn vị
     */
    public Service(String serviceName, String unit, BigDecimal pricePerUnit) {
        this();
        this.serviceName = serviceName;
        this.unit = unit;
        this.pricePerUnit = pricePerUnit;
    }
    
    /**
     * Constructor để tạo dịch vụ mới (phiên bản 2.0)
     * 
     * @param serviceName tên dịch vụ
     * @param unit đơn vị tính
     * @param pricePerUnit giá trên đơn vị
     * @param serviceType loại dịch vụ
     * @param calculationConfig cấu hình tính toán
     */
    public Service(String serviceName, String unit, BigDecimal pricePerUnit, 
                   ServiceType serviceType, String calculationConfig) {
        this();
        this.serviceName = serviceName;
        this.unit = unit;
        this.pricePerUnit = pricePerUnit;
        this.serviceType = serviceType;
        this.calculationConfig = calculationConfig;
    }
    
    /**
     * Constructor đầy đủ (từ database)
     */
    public Service(int serviceId, String serviceName, String unit, BigDecimal pricePerUnit,
                   ServiceType serviceType, String calculationConfig) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.unit = unit;
        this.pricePerUnit = pricePerUnit;
        this.serviceType = serviceType;
        this.calculationConfig = calculationConfig;
    }
    
    // ==================== GETTERS AND SETTERS ====================
    
    // Thuộc tính cơ bản
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    
    public String getServiceName() { return serviceName; }
    public void setServiceName(String serviceName) { this.serviceName = serviceName; }
    
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    
    public BigDecimal getPricePerUnit() { return pricePerUnit; }
    public void setPricePerUnit(BigDecimal pricePerUnit) { this.pricePerUnit = pricePerUnit; }
    
    // Thuộc tính mới
    public ServiceType getServiceType() { return serviceType; }
    public void setServiceType(ServiceType serviceType) { this.serviceType = serviceType; }
    
    /**
     * Set service type from string (for database compatibility)
     */
    public void setServiceType(String serviceTypeStr) {
        if (serviceTypeStr != null) {
            try {
                this.serviceType = ServiceType.valueOf(serviceTypeStr.toUpperCase());
            } catch (IllegalArgumentException e) {
                this.serviceType = ServiceType.MONTHLY; // Default fallback
            }
        }
    }
    
    /**
     * Get service type as string (for database compatibility)
     */
    public String getServiceTypeString() {
        return serviceType != null ? serviceType.name() : ServiceType.MONTHLY.name();
    }
    
    public String getCalculationConfig() { return calculationConfig; }
    public void setCalculationConfig(String calculationConfig) { this.calculationConfig = calculationConfig; }
    
    public Integer getManagedByAdminId() { return managedByAdminId; }
    public void setManagedByAdminId(Integer managedByAdminId) { this.managedByAdminId = managedByAdminId; }
    
    // ==================== UTILITY METHODS ====================
    
    /**
     * Kiểm tra xem dịch vụ có miễn phí không
     */
    public boolean isFree() {
        return serviceType == ServiceType.FREE;
    }
    
    /**
     * Lấy tên hiển thị đầy đủ với icon
     */
    public String getDisplayNameWithIcon() {
        return serviceType.getIcon() + " " + serviceName;
    }
    
    /**
     * Lấy mô tả ngắn về cách tính phí
     */
    public String getPricingDescription() {
        switch (serviceType) {
            case FREE:
                return "Miễn phí";
            case MONTHLY:
                return pricePerUnit + "₫/tháng";
            case METER_READING:
                return "Theo chỉ số " + (unit != null ? unit : "");
            case PER_PERSON:
                return pricePerUnit + "₫/người/tháng";
            case PER_ROOM:
                return pricePerUnit + "₫/phòng/tháng";
            default:
                return "Chưa xác định";
        }
    }
    
    // ==================== OBJECT METHODS ====================
    
    @Override
    public String toString() {
        return "Service{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", serviceType=" + serviceType +
                ", unit='" + unit + '\'' +
                ", pricePerUnit=" + pricePerUnit +

                '}';
    }
    
    // Equals and HashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        
        Service service = (Service) o;
        return serviceId == service.serviceId;
    }
    
    @Override
    public int hashCode() {
        return Integer.hashCode(serviceId);
    }
}

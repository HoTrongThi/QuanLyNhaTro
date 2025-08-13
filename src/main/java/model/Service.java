package model;

import java.math.BigDecimal;

/**
 * Service Entity
 * Represents a service (electricity, water, internet, etc.) in the room management system
 */
public class Service {
    private int serviceId;
    private String serviceName;
    private String unit;
    private BigDecimal pricePerUnit;
    
    // Constructors
    public Service() {}
    
    public Service(String serviceName, String unit, BigDecimal pricePerUnit) {
        this.serviceName = serviceName;
        this.unit = unit;
        this.pricePerUnit = pricePerUnit;
    }
    
    public Service(int serviceId, String serviceName, String unit, BigDecimal pricePerUnit) {
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.unit = unit;
        this.pricePerUnit = pricePerUnit;
    }
    
    // Getters and Setters
    public int getServiceId() {
        return serviceId;
    }
    
    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }
    
    public String getServiceName() {
        return serviceName;
    }
    
    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }
    
    public String getUnit() {
        return unit;
    }
    
    public void setUnit(String unit) {
        this.unit = unit;
    }
    
    public BigDecimal getPricePerUnit() {
        return pricePerUnit;
    }
    
    public void setPricePerUnit(BigDecimal pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }
    
    // ToString method for debugging
    @Override
    public String toString() {
        return "Service{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
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

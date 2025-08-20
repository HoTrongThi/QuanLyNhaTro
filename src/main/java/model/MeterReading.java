package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

/**
 * MeterReading Entity
 * Represents meter readings for services (electricity, water) for tenants
 * Used to track meter readings over time and calculate consumption
 */
public class MeterReading {
    private int readingId;
    private int tenantId;
    private int serviceId;
    private BigDecimal reading; // Current meter reading
    private Date readingDate;
    private int month;
    private int year;
    private Timestamp createdAt;
    
    // Related entities for display purposes
    private String serviceName;
    private String serviceUnit;
    private String tenantName;
    private String roomName;
    private BigDecimal previousReading; // Previous meter reading for calculation
    private BigDecimal consumption; // Calculated consumption (current - previous)
    
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
    
    // Helper method to calculate consumption
    public void calculateConsumption() {
        if (reading != null && previousReading != null) {
            this.consumption = reading.subtract(previousReading);
        } else {
            this.consumption = BigDecimal.ZERO;
        }
    }
    
    // Helper method to get formatted period
    public String getFormattedPeriod() {
        return String.format("%02d/%d", month, year);
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
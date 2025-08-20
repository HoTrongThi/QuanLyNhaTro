package dao;

import model.Service;
import org.springframework.stereotype.Repository;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Service Data Access Object
 * Handles database operations for services
 */
@Repository
public class ServiceDAO {
    
    /**
     * Get all services
     */
    public List<Service> getAllServices() {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, unit, price_per_unit FROM services ORDER BY service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setUnit(rs.getString("unit"));
                service.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                services.add(service);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all services: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }
    
    /**
     * Get service by ID
     */
    public Service getServiceById(int serviceId) {
        String sql = "SELECT service_id, service_name, unit, price_per_unit FROM services WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setUnit(rs.getString("unit"));
                service.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                return service;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting service by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Add a new service
     */
    public boolean addService(Service service) {
        String sql = "INSERT INTO services (service_name, unit, price_per_unit) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, service.getServiceName());
            pstmt.setString(2, service.getUnit());
            pstmt.setBigDecimal(3, service.getPricePerUnit());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update an existing service
     */
    public boolean updateService(Service service) {
        String sql = "UPDATE services SET service_name = ?, unit = ?, price_per_unit = ? WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, service.getServiceName());
            pstmt.setString(2, service.getUnit());
            pstmt.setBigDecimal(3, service.getPricePerUnit());
            pstmt.setInt(4, service.getServiceId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a service
     */
    public boolean deleteService(int serviceId) {
        String sql = "DELETE FROM services WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting service: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if service name exists (for adding new service)
     */
    public boolean serviceNameExists(String serviceName) {
        String sql = "SELECT COUNT(*) FROM services WHERE LOWER(service_name) = LOWER(?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, serviceName.trim());
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking service name existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if service name exists (for editing existing service, excluding current service)
     */
    public boolean serviceNameExists(String serviceName, int excludeServiceId) {
        String sql = "SELECT COUNT(*) FROM services WHERE LOWER(service_name) = LOWER(?) AND service_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, serviceName.trim());
            pstmt.setInt(2, excludeServiceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking service name existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if service is in use (has service usage records)
     */
    public boolean isServiceInUse(int serviceId) {
        String sql = "SELECT COUNT(*) FROM service_usage WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking if service is in use: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get total service count
     */
    public int getTotalServiceCount() {
        String sql = "SELECT COUNT(*) FROM services";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total service count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Search services by name
     */
    public List<Service> searchServicesByName(String searchTerm) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT service_id, service_name, unit, price_per_unit FROM services " +
                    "WHERE LOWER(service_name) LIKE LOWER(?) ORDER BY service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, "%" + searchTerm.trim() + "%");
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setUnit(rs.getString("unit"));
                service.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                services.add(service);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching services: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }
    
    /**
     * Get services that have been used by a specific tenant (services with usage history)
     * This shows only services that the tenant has used before
     */
    public List<Service> getServicesUsedByTenant(int tenantId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT DISTINCT s.service_id, s.service_name, s.unit, s.price_per_unit " +
                    "FROM services s " +
                    "INNER JOIN service_usage su ON s.service_id = su.service_id " +
                    "WHERE su.tenant_id = ? " +
                    "ORDER BY s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setUnit(rs.getString("unit"));
                service.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                services.add(service);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting services used by tenant: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }
    
    /**
     * Get services available for a tenant - this includes all services but you can modify
     * this logic to filter based on your business rules (e.g., room type, tenant preferences, etc.)
     */
    public List<Service> getServicesForTenant(int tenantId) {
        // For now, return all services. You can modify this method later 
        // to implement tenant-specific service filtering if needed
        return getAllServices();
    }
    
    /**
     * Check if a tenant has any service usage history
     */
    public boolean tenantHasServiceHistory(int tenantId) {
        String sql = "SELECT COUNT(*) FROM service_usage WHERE tenant_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking tenant service history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get services that have been used in a specific room
     * This shows services that any tenant in this room has used
     */
    public List<Service> getServicesByRoomId(int roomId) {
        List<Service> services = new ArrayList<>();
        String sql = "SELECT DISTINCT s.service_id, s.service_name, s.unit, s.price_per_unit " +
                    "FROM services s " +
                    "INNER JOIN service_usage su ON s.service_id = su.service_id " +
                    "INNER JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "WHERE t.room_id = ? " +
                    "ORDER BY s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getInt("service_id"));
                service.setServiceName(rs.getString("service_name"));
                service.setUnit(rs.getString("unit"));
                service.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                services.add(service);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting services by room ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return services;
    }
}

package dao;

import model.ServiceUsage;
import org.springframework.stereotype.Repository;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ServiceUsage Data Access Object
 * Handles database operations for service usage (electricity, water consumption)
 */
@Repository
public class ServiceUsageDAO {
    
    /**
     * Add service usage record
     */
    public boolean addServiceUsage(ServiceUsage usage) {
        String sql = "INSERT INTO service_usage (tenant_id, service_id, month, year, quantity) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, usage.getTenantId());
            pstmt.setInt(2, usage.getServiceId());
            pstmt.setInt(3, usage.getMonth());
            pstmt.setInt(4, usage.getYear());
            pstmt.setBigDecimal(5, usage.getQuantity());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding service usage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update service usage record
     */
    public boolean updateServiceUsage(ServiceUsage usage) {
        String sql = "UPDATE service_usage SET quantity = ? WHERE usage_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBigDecimal(1, usage.getQuantity());
            pstmt.setInt(2, usage.getUsageId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating service usage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get service usage by ID
     */
    public ServiceUsage getServiceUsageById(int usageId) {
        String sql = "SELECT su.usage_id, su.tenant_id, su.service_id, su.month, su.year, su.quantity, " +
                    "s.service_name, s.unit, s.price_per_unit, u.full_name, r.room_name " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE su.usage_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, usageId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                ServiceUsage usage = new ServiceUsage();
                usage.setUsageId(rs.getInt("usage_id"));
                usage.setTenantId(rs.getInt("tenant_id"));
                usage.setServiceId(rs.getInt("service_id"));
                usage.setMonth(rs.getInt("month"));
                usage.setYear(rs.getInt("year"));
                usage.setQuantity(rs.getBigDecimal("quantity"));
                usage.setServiceName(rs.getString("service_name"));
                usage.setServiceUnit(rs.getString("unit"));
                usage.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                usage.setTenantName(rs.getString("full_name"));
                usage.setRoomName(rs.getString("room_name"));
                usage.calculateTotalCost();
                return usage;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting service usage by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all service usage records for a specific tenant and period
     */
    public List<ServiceUsage> getServiceUsageByTenantAndPeriod(int tenantId, int month, int year) {
        List<ServiceUsage> usageList = new ArrayList<>();
        String sql = "SELECT su.usage_id, su.tenant_id, su.service_id, su.month, su.year, su.quantity, " +
                    "s.service_name, s.unit, s.price_per_unit, u.full_name, r.room_name " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE su.tenant_id = ? AND su.month = ? AND su.year = ? " +
                    "ORDER BY s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ServiceUsage usage = new ServiceUsage();
                usage.setUsageId(rs.getInt("usage_id"));
                usage.setTenantId(rs.getInt("tenant_id"));
                usage.setServiceId(rs.getInt("service_id"));
                usage.setMonth(rs.getInt("month"));
                usage.setYear(rs.getInt("year"));
                usage.setQuantity(rs.getBigDecimal("quantity"));
                usage.setServiceName(rs.getString("service_name"));
                usage.setServiceUnit(rs.getString("unit"));
                usage.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                usage.setTenantName(rs.getString("full_name"));
                usage.setRoomName(rs.getString("room_name"));
                usage.calculateTotalCost();
                usageList.add(usage);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting service usage by tenant and period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return usageList;
    }
    
    /**
     * Get all service usage records for a specific room and period
     */
    public List<ServiceUsage> getServiceUsageByRoomAndPeriod(int roomId, int month, int year) {
        List<ServiceUsage> usageList = new ArrayList<>();
        String sql = "SELECT su.usage_id, su.tenant_id, su.service_id, su.month, su.year, su.quantity, " +
                    "s.service_name, s.unit, s.price_per_unit, u.full_name, r.room_name " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.room_id = ? AND su.month = ? AND su.year = ? " +
                    "ORDER BY s.service_name, u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ServiceUsage usage = new ServiceUsage();
                usage.setUsageId(rs.getInt("usage_id"));
                usage.setTenantId(rs.getInt("tenant_id"));
                usage.setServiceId(rs.getInt("service_id"));
                usage.setMonth(rs.getInt("month"));
                usage.setYear(rs.getInt("year"));
                usage.setQuantity(rs.getBigDecimal("quantity"));
                usage.setServiceName(rs.getString("service_name"));
                usage.setServiceUnit(rs.getString("unit"));
                usage.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                usage.setTenantName(rs.getString("full_name"));
                usage.setRoomName(rs.getString("room_name"));
                usage.calculateTotalCost();
                usageList.add(usage);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting service usage by room and period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return usageList;
    }
    
    /**
     * Get all service usage records
     */
    public List<ServiceUsage> getAllServiceUsage() {
        List<ServiceUsage> usageList = new ArrayList<>();
        String sql = "SELECT su.usage_id, su.tenant_id, su.service_id, su.month, su.year, su.quantity, " +
                    "s.service_name, s.unit, s.price_per_unit, u.full_name, r.room_name " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "ORDER BY su.year DESC, su.month DESC, r.room_name, s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                ServiceUsage usage = new ServiceUsage();
                usage.setUsageId(rs.getInt("usage_id"));
                usage.setTenantId(rs.getInt("tenant_id"));
                usage.setServiceId(rs.getInt("service_id"));
                usage.setMonth(rs.getInt("month"));
                usage.setYear(rs.getInt("year"));
                usage.setQuantity(rs.getBigDecimal("quantity"));
                usage.setServiceName(rs.getString("service_name"));
                usage.setServiceUnit(rs.getString("unit"));
                usage.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                usage.setTenantName(rs.getString("full_name"));
                usage.setRoomName(rs.getString("room_name"));
                usage.calculateTotalCost();
                usageList.add(usage);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all service usage: " + e.getMessage());
            e.printStackTrace();
        }
        
        return usageList;
    }
    
    /**
     * Get current service usage by tenant ID (for user room view)
     */
    public List<ServiceUsage> getServiceUsageByTenantId(int tenantId) {
        List<ServiceUsage> usageList = new ArrayList<>();
        String sql = "SELECT su.usage_id, su.tenant_id, su.service_id, su.month, su.year, su.quantity, " +
                    "s.service_name, s.unit, s.price_per_unit, u.full_name, r.room_name " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE su.tenant_id = ? " +
                    "ORDER BY su.year DESC, su.month DESC, s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ServiceUsage usage = new ServiceUsage();
                usage.setUsageId(rs.getInt("usage_id"));
                usage.setTenantId(rs.getInt("tenant_id"));
                usage.setServiceId(rs.getInt("service_id"));
                usage.setMonth(rs.getInt("month"));
                usage.setYear(rs.getInt("year"));
                usage.setQuantity(rs.getBigDecimal("quantity"));
                usage.setServiceName(rs.getString("service_name"));
                usage.setServiceUnit(rs.getString("unit"));
                usage.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                usage.setTenantName(rs.getString("full_name"));
                usage.setRoomName(rs.getString("room_name"));
                usage.calculateTotalCost();
                usageList.add(usage);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting service usage by tenant ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return usageList;
    }
    
    /**
     * Delete service usage by ID
     */
    public boolean deleteServiceUsage(int usageId) {
        String sql = "DELETE FROM service_usage WHERE usage_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, usageId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting service usage: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if service usage exists for tenant, service, and period
     */
    public boolean serviceUsageExists(int tenantId, int serviceId, int month, int year) {
        String sql = "SELECT COUNT(*) FROM service_usage WHERE tenant_id = ? AND service_id = ? AND month = ? AND year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, serviceId);
            pstmt.setInt(3, month);
            pstmt.setInt(4, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking service usage existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if service usage exists for tenant, service, and period (excluding specific usage ID)
     */
    public boolean serviceUsageExists(int tenantId, int serviceId, int month, int year, int excludeUsageId) {
        String sql = "SELECT COUNT(*) FROM service_usage WHERE tenant_id = ? AND service_id = ? AND month = ? AND year = ? AND usage_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, serviceId);
            pstmt.setInt(3, month);
            pstmt.setInt(4, year);
            pstmt.setInt(5, excludeUsageId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking service usage existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Calculate total service cost for a tenant and period
     */
    public BigDecimal calculateServiceTotal(int tenantId, int month, int year) {
        String sql = "SELECT SUM(su.quantity * s.price_per_unit) as total " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "WHERE su.tenant_id = ? AND su.month = ? AND su.year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating service total: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Calculate total service cost for a room and period (room-based calculation)
     */
    public BigDecimal calculateServiceTotalByRoom(int roomId, int month, int year) {
        // Calculate service total for ALL tenants in the room
        // This avoids the representative tenant inconsistency issue
        String sql = "SELECT SUM(su.quantity * s.price_per_unit) as total " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "WHERE t.room_id = ? AND su.month = ? AND su.year = ?";
        

        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating service total by room: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Initialize services for a new tenant with 0 quantity for the current month
     * This creates initial service usage records that can be updated later
     */
    public boolean initializeServicesForTenant(int tenantId, List<Integer> serviceIds, int month, int year) {
        if (serviceIds == null || serviceIds.isEmpty()) {
            return true; // No services to initialize
        }
        
        String sql = "INSERT INTO service_usage (tenant_id, service_id, month, year, quantity) VALUES (?, ?, ?, ?, 0)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false); // Start transaction
            
            for (Integer serviceId : serviceIds) {
                // Check if service usage already exists for this tenant, service, month, year
                if (!serviceUsageExists(tenantId, serviceId, month, year)) {
                    pstmt.setInt(1, tenantId);
                    pstmt.setInt(2, serviceId);
                    pstmt.setInt(3, month);
                    pstmt.setInt(4, year);
                    pstmt.addBatch();
                }
            }
            
            int[] results = pstmt.executeBatch();
            conn.commit(); // Commit transaction
            
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error initializing services for tenant: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // ================= REPORTING METHODS =================
    
    /**
     * Get total revenue by service
     */
    public BigDecimal getTotalRevenueByService(int serviceId) {
        String sql = "SELECT SUM(su.quantity * s.price_per_unit) as total_revenue " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "WHERE su.service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal("total_revenue");
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total revenue by service: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get total usage count by service
     */
    public int getTotalUsageCountByService(int serviceId) {
        String sql = "SELECT COUNT(*) FROM service_usage WHERE service_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total usage count by service: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get revenue by service and period
     */
    public BigDecimal getRevenueByServiceAndPeriod(int serviceId, int month, int year) {
        String sql = "SELECT SUM(su.quantity * s.price_per_unit) as period_revenue " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "WHERE su.service_id = ? AND su.month = ? AND su.year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal("period_revenue");
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting revenue by service and period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get total quantity by service and period
     */
    public BigDecimal getTotalQuantityByServiceAndPeriod(int serviceId, int month, int year) {
        String sql = "SELECT SUM(quantity) as total_quantity FROM service_usage " +
                    "WHERE service_id = ? AND month = ? AND year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, serviceId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal quantity = rs.getBigDecimal("total_quantity");
                return quantity != null ? quantity : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total quantity by service and period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get service usage statistics by period
     */
    public List<ServiceUsage> getServiceUsageByPeriod(int month, int year) {
        List<ServiceUsage> usageList = new ArrayList<>();
        String sql = "SELECT su.usage_id, su.tenant_id, su.service_id, su.month, su.year, su.quantity, " +
                    "s.service_name, s.unit, s.price_per_unit, u.full_name, r.room_name " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "JOIN tenants t ON su.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE su.month = ? AND su.year = ? " +
                    "ORDER BY s.service_name, r.room_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                ServiceUsage usage = new ServiceUsage();
                usage.setUsageId(rs.getInt("usage_id"));
                usage.setTenantId(rs.getInt("tenant_id"));
                usage.setServiceId(rs.getInt("service_id"));
                usage.setMonth(rs.getInt("month"));
                usage.setYear(rs.getInt("year"));
                usage.setQuantity(rs.getBigDecimal("quantity"));
                usage.setServiceName(rs.getString("service_name"));
                usage.setServiceUnit(rs.getString("unit"));
                usage.setPricePerUnit(rs.getBigDecimal("price_per_unit"));
                usage.setTenantName(rs.getString("full_name"));
                usage.setRoomName(rs.getString("room_name"));
                usage.calculateTotalCost();
                usageList.add(usage);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting service usage by period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return usageList;
    }
}

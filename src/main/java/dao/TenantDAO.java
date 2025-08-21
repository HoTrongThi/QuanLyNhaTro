package dao;

import model.Tenant;
import model.User;
import model.Room;
import org.springframework.stereotype.Repository;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Tenant Data Access Object
 * Handles database operations for tenant management
 */
@Repository
public class TenantDAO {
    
    /**
     * Get all tenants with user and room information
     */
    public List<Tenant> getAllTenants() {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT t.tenant_id, t.user_id, t.room_id, t.start_date, t.end_date, " +
                    "u.username, u.full_name, u.phone, u.email, u.address, " +
                    "r.room_name, r.price as room_price " +
                    "FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "ORDER BY t.tenant_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Tenant tenant = mapResultSetToTenant(rs);
                tenants.add(tenant);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all tenants: " + e.getMessage());
            e.printStackTrace();
        }
        
        return tenants;
    }
    
    /**
     * Get active tenants only
     */
    public List<Tenant> getActiveTenants() {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT t.tenant_id, t.user_id, t.room_id, t.start_date, t.end_date, " +
                    "u.username, u.full_name, u.phone, u.email, u.address, " +
                    "r.room_name, r.price as room_price " +
                    "FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.end_date IS NULL " +
                    "ORDER BY t.tenant_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Tenant tenant = mapResultSetToTenant(rs);
                tenants.add(tenant);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting active tenants: " + e.getMessage());
            e.printStackTrace();
        }
        
        return tenants;
    }
    
    /**
     * Get tenant by ID
     */
    public Tenant getTenantById(int tenantId) {
        String sql = "SELECT t.tenant_id, t.user_id, t.room_id, t.start_date, t.end_date, " +
                    "u.username, u.full_name, u.phone, u.email, u.address, " +
                    "r.room_name, r.price as room_price " +
                    "FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.tenant_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTenant(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting tenant by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get tenant by user ID (active tenant)
     */
    public Tenant getActiveTenantByUserId(int userId) {
        String sql = "SELECT t.tenant_id, t.user_id, t.room_id, t.start_date, t.end_date, " +
                    "u.username, u.full_name, u.phone, u.email, u.address, " +
                    "r.room_name, r.price as room_price " +
                    "FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.user_id = ? AND t.end_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTenant(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting active tenant by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all tenants in a specific room (active tenants)
     */
    public List<Tenant> getTenantsByRoomId(int roomId) {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT t.tenant_id, t.user_id, t.room_id, t.start_date, t.end_date, " +
                    "u.username, u.full_name, u.phone, u.email, u.address, " +
                    "r.room_name, r.price as room_price " +
                    "FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.room_id = ? AND t.end_date IS NULL " +
                    "ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Tenant tenant = mapResultSetToTenant(rs);
                tenants.add(tenant);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting tenants by room ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return tenants;
    }
    
    /**
     * Add a new tenant (assign user to room)
     */
    public boolean addTenant(Tenant tenant) {
        String sql = "INSERT INTO tenants (user_id, room_id, start_date) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            

            
            pstmt.setInt(1, tenant.getUserId());
            pstmt.setInt(2, tenant.getRoomId());
            pstmt.setDate(3, tenant.getStartDate());
            
            int rowsAffected = pstmt.executeUpdate();

            
            if (rowsAffected > 0) {
                // Update room status based on tenant count

                updateRoomStatusBasedOnTenantCount(tenant.getRoomId());
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error adding tenant: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * End tenant lease
     */
    public boolean endTenantLease(int tenantId, Date endDate) {
        String sql = "UPDATE tenants SET end_date = ? WHERE tenant_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setDate(1, endDate);
            pstmt.setInt(2, tenantId);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get room ID and update status based on remaining tenants
                Tenant tenant = getTenantById(tenantId);
                if (tenant != null) {
                    updateRoomStatusBasedOnTenantCount(tenant.getRoomId());
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error ending tenant lease: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update tenant information (change room)
     */
    public boolean updateTenantRoom(int tenantId, int newRoomId) {
        Tenant currentTenant = getTenantById(tenantId);
        if (currentTenant == null) return false;
        
        String sql = "UPDATE tenants SET room_id = ? WHERE tenant_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, newRoomId);
            pstmt.setInt(2, tenantId);
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Update both rooms' status based on tenant count
                updateRoomStatusBasedOnTenantCount(currentTenant.getRoomId());
                updateRoomStatusBasedOnTenantCount(newRoomId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error updating tenant room: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get users who are not currently tenants (available for new rental)
     */
    public List<User> getAvailableUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT u.user_id, u.username, u.full_name, u.phone, u.email, u.address " +
                    "FROM users u " +
                    "WHERE u.role = 'USER' AND u.user_id NOT IN (" +
                    "    SELECT DISTINCT t.user_id FROM tenants t WHERE t.end_date IS NULL" +
                    ") ORDER BY u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Get available rooms (rooms with less than 4 tenants)
     */
    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.room_id, r.room_name, r.price, r.description, r.status, " +
                    "COALESCE(tenant_count.count, 0) as current_tenants " +
                    "FROM rooms r " +
                    "LEFT JOIN (" +
                    "    SELECT room_id, COUNT(*) as count " +
                    "    FROM tenants " +
                    "    WHERE end_date IS NULL " +
                    "    GROUP BY room_id" +
                    ") tenant_count ON r.room_id = tenant_count.room_id " +
                    "WHERE COALESCE(tenant_count.count, 0) < 4 " +
                    "ORDER BY r.room_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setDescription(rs.getString("description"));
                room.setStatus(rs.getString("status"));
                
                // Add current tenant count to description for display
                int currentTenants = rs.getInt("current_tenants");
                String displayDescription = room.getDescription() != null ? room.getDescription() : "";
                displayDescription += " (" + currentTenants + "/4 người)";
                room.setDescription(displayDescription);
                
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available rooms: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Search tenants by name or room
     */
    public List<Tenant> searchTenants(String searchTerm) {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT t.tenant_id, t.user_id, t.room_id, t.start_date, t.end_date, " +
                    "u.username, u.full_name, u.phone, u.email, u.address, " +
                    "r.room_name, r.price as room_price " +
                    "FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE LOWER(u.full_name) LIKE LOWER(?) OR LOWER(r.room_name) LIKE LOWER(?) " +
                    "ORDER BY t.tenant_id DESC";
        
        String searchPattern = "%" + searchTerm.trim() + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Tenant tenant = mapResultSetToTenant(rs);
                tenants.add(tenant);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching tenants: " + e.getMessage());
            e.printStackTrace();
        }
        
        return tenants;
    }
    
    /**
     * Get tenant statistics
     */
    public int getTotalTenantCount() {
        String sql = "SELECT COUNT(*) FROM tenants";
        return getCount(sql);
    }
    
    public int getActiveTenantCount() {
        String sql = "SELECT COUNT(*) FROM tenants WHERE end_date IS NULL";
        return getCount(sql);
    }
    
    public int getInactiveTenantCount() {
        String sql = "SELECT COUNT(*) FROM tenants WHERE end_date IS NOT NULL";
        return getCount(sql);
    }
    
    /**
     * Check if user is already renting this specific room
     */
    public boolean isUserAlreadyInRoom(int userId, int roomId) {
        String sql = "SELECT COUNT(*) FROM tenants WHERE user_id = ? AND room_id = ? AND end_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking if user is already in room: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get current tenant count for a room
     */
    public int getRoomTenantCount(int roomId) {
        String sql = "SELECT COUNT(*) FROM tenants WHERE room_id = ? AND end_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room tenant count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Helper methods
    private Tenant mapResultSetToTenant(ResultSet rs) throws SQLException {
        Tenant tenant = new Tenant();
        tenant.setTenantId(rs.getInt("tenant_id"));
        tenant.setUserId(rs.getInt("user_id"));
        tenant.setRoomId(rs.getInt("room_id"));
        tenant.setStartDate(rs.getDate("start_date"));
        tenant.setEndDate(rs.getDate("end_date"));
        tenant.setUserName(rs.getString("username"));
        tenant.setFullName(rs.getString("full_name"));
        tenant.setPhone(rs.getString("phone"));
        tenant.setEmail(rs.getString("email"));
        tenant.setAddress(rs.getString("address"));
        tenant.setRoomName(rs.getString("room_name"));
        tenant.setRoomPrice(rs.getBigDecimal("room_price"));
        return tenant;
    }
    
    private void updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, roomId);
            pstmt.executeUpdate();
            
        } catch (SQLException e) {
            System.err.println("Error updating room status: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Update room status based on current tenant count
     */
    private void updateRoomStatusBasedOnTenantCount(int roomId) {
        int tenantCount = getRoomTenantCount(roomId);
        String newStatus;
        
        if (tenantCount == 0) {
            newStatus = "AVAILABLE";
        } else {
            newStatus = "OCCUPIED";
        }
        
        updateRoomStatus(roomId, newStatus);

    }
    
    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get services assigned to a tenant based on service_usage table
     * Returns a formatted string with service names and their base costs
     */
    public String getTenantServicesDisplay(int tenantId) {
        StringBuilder servicesDisplay = new StringBuilder();
        String sql = "SELECT DISTINCT s.service_name, s.price_per_unit, s.unit " +
                    "FROM service_usage su " +
                    "JOIN services s ON su.service_id = s.service_id " +
                    "WHERE su.tenant_id = ? " +
                    "ORDER BY s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                if (servicesDisplay.length() > 0) {
                    servicesDisplay.append(", ");
                }
                String serviceName = rs.getString("service_name");
                double pricePerUnit = rs.getDouble("price_per_unit");
                String unit = rs.getString("unit");
                
                servicesDisplay.append(serviceName)
                              .append(" (")
                              .append(String.format("%,.0f₫/%s", pricePerUnit, unit))
                              .append(")");
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting tenant services display: " + e.getMessage());
            e.printStackTrace();
        }
        
        return servicesDisplay.length() > 0 ? servicesDisplay.toString() : "Không có dịch vụ";
    }
}

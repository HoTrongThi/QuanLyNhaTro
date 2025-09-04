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
 * Lớp Data Access Object cho Người thuê
 * Xử lý tất cả các thao tác cơ sở dữ liệu cho quản lý người thuê
 * Bao gồm phân công phòng, kết thúc hợp đồng, chuyển phòng và thống kê
 * Tự động cập nhật trạng thái phòng dựa trên số người thuê
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Repository
public class TenantDAO {
    
    // ==================== CÁC PHƯƠNG THỨC LẤY DỮ LIỆU ====================
    
    /**
     * Lấy danh sách tất cả người thuê kèm thông tin người dùng và phòng
     * Bao gồm cả người thuê đang hoạt động và đã kết thúc hợp đồng
     * Sắp xếp theo ID người thuê giảm dần (mới nhất trước)
     * 
     * @return danh sách tất cả người thuê với thông tin đầy đủ
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
                    "WHERE (t.end_date IS NULL OR t.end_date > CURRENT_DATE) " +
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
                    "WHERE t.user_id = ? AND (t.end_date IS NULL OR t.end_date > CURRENT_DATE)";
        
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
                    "WHERE t.room_id = ? AND (t.end_date IS NULL OR t.end_date > CURRENT_DATE) " +
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
     * Get active tenants in a specific room (alias for getTenantsByRoomId)
     */
    public List<Tenant> getActiveTenantsByRoomId(int roomId) {
        return getTenantsByRoomId(roomId);
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
                    "    SELECT DISTINCT t.user_id FROM tenants t WHERE (t.end_date IS NULL OR t.end_date > CURRENT_DATE)" +
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
     * Get available rooms (rooms with less than 4 tenants, excluding SUSPENDED and RESERVED)
     * Excludes rooms that are suspended or already reserved
     */
    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.room_id, r.room_name, r.price, r.description, r.status, " +
                    "COALESCE(tenant_count.count, 0) as current_tenants " +
                    "FROM rooms r " +
                    "LEFT JOIN (" +
                    "    SELECT room_id, COUNT(*) as count " +
                    "    FROM tenants " +
                    "    WHERE (end_date IS NULL OR end_date > CURRENT_DATE) " +
                    "    GROUP BY room_id" +
                    ") tenant_count ON r.room_id = tenant_count.room_id " +
                    "WHERE r.status NOT IN ('SUSPENDED', 'RESERVED') AND COALESCE(tenant_count.count, 0) < 4 " +
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
        String sql = "SELECT COUNT(*) FROM tenants WHERE (end_date IS NULL OR end_date > CURRENT_DATE)";
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
        String sql = "SELECT COUNT(*) FROM tenants WHERE user_id = ? AND room_id = ? AND (end_date IS NULL OR end_date > CURRENT_DATE)";
        
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
        String sql = "SELECT COUNT(*) FROM tenants WHERE room_id = ? AND (end_date IS NULL OR end_date > CURRENT_DATE)";
        
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
        String sql = "SELECT DISTINCT s.service_name " +
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
                servicesDisplay.append(serviceName);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting tenant services display: " + e.getMessage());
            e.printStackTrace();
        }
        
        return servicesDisplay.length() > 0 ? servicesDisplay.toString() : "Không có dịch vụ";
    }
    
    /**
     * Get tenants whose lease ends today (for scheduled termination)
     * @return List of tenants ending today
     */
    public List<Tenant> getTenantsEndingToday() {
        List<Tenant> tenants = new ArrayList<>();
        String sql = "SELECT t.tenant_id, t.user_id, t.room_id, t.start_date, t.end_date, " +
                    "u.username, u.full_name, u.phone, u.email, u.address, " +
                    "r.room_name, r.price as room_price " +
                    "FROM tenants t " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.end_date = CURRENT_DATE " +
                    "ORDER BY t.tenant_id";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Tenant tenant = mapResultSetToTenant(rs);
                tenants.add(tenant);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting tenants ending today: " + e.getMessage());
            e.printStackTrace();
        }
        
        return tenants;
    }
    
    /**
     * Get payment status for a tenant
     * Returns payment status and unpaid periods
     */
    public String getTenantPaymentStatus(int tenantId) {
        String sql = "SELECT COUNT(*) as unpaid_count, " +
                    "GROUP_CONCAT(CONCAT(LPAD(month, 2, '0'), '/', year) ORDER BY year, month SEPARATOR ', ') as unpaid_periods " +
                    "FROM invoices " +
                    "WHERE tenant_id = ? AND status = 'UNPAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int unpaidCount = rs.getInt("unpaid_count");
                String unpaidPeriods = rs.getString("unpaid_periods");
                
                System.out.println("[DEBUG] Tenant " + tenantId + " unpaid count: " + unpaidCount + ", periods: " + unpaidPeriods);
                
                if (unpaidCount == 0) {
                    return "PAID";
                } else {
                    return "UNPAID:" + (unpaidPeriods != null ? unpaidPeriods : "");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting tenant payment status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "UNKNOWN";
    }
    
    /**
     * Get unpaid invoices for a tenant
     * Returns list of unpaid periods with details
     */
    public List<String> getTenantUnpaidPeriods(int tenantId) {
        List<String> unpaidPeriods = new ArrayList<>();
        String sql = "SELECT month, year, total_amount " +
                    "FROM invoices " +
                    "WHERE tenant_id = ? AND status = 'UNPAID' " +
                    "ORDER BY year, month";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                int month = rs.getInt("month");
                int year = rs.getInt("year");
                java.math.BigDecimal amount = rs.getBigDecimal("total_amount");
                
                String period = String.format("%02d/%d", month, year);
                if (amount != null) {
                    period += " (" + String.format("%,.0f₫", amount) + ")";
                }
                unpaidPeriods.add(period);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting tenant unpaid periods: " + e.getMessage());
            e.printStackTrace();
        }
        
        return unpaidPeriods;
    }
    
    /**
     * Get payment status for a room (based on all tenants in the room)
     * Returns payment status and unpaid periods for the entire room
     */
    public String getRoomPaymentStatus(int roomId) {
        String sql = "SELECT COUNT(DISTINCT i.invoice_id) as unpaid_count, " +
                    "GROUP_CONCAT(DISTINCT CONCAT(LPAD(i.month, 2, '0'), '/', i.year) ORDER BY i.year, i.month SEPARATOR ', ') as unpaid_periods " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "WHERE t.room_id = ? AND i.status = 'UNPAID' " +
                    "AND (t.end_date IS NULL OR t.end_date > CURRENT_DATE)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int unpaidCount = rs.getInt("unpaid_count");
                String unpaidPeriods = rs.getString("unpaid_periods");
                
                System.out.println("[DEBUG] Room " + roomId + " unpaid count: " + unpaidCount + ", periods: " + unpaidPeriods);
                
                if (unpaidCount == 0) {
                    return "PAID";
                } else {
                    return "UNPAID:" + (unpaidPeriods != null ? unpaidPeriods : "");
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room payment status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return "UNKNOWN";
    }
    
    /**
     * Get unpaid periods for a room (all tenants combined)
     * Returns list of unpaid periods with details for the entire room
     */
    public List<String> getRoomUnpaidPeriods(int roomId) {
        List<String> unpaidPeriods = new ArrayList<>();
        String sql = "SELECT DISTINCT i.month, i.year, SUM(i.total_amount) as total_amount " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "WHERE t.room_id = ? AND i.status = 'UNPAID' " +
                    "AND (t.end_date IS NULL OR t.end_date > CURRENT_DATE) " +
                    "GROUP BY i.month, i.year " +
                    "ORDER BY i.year, i.month";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                int month = rs.getInt("month");
                int year = rs.getInt("year");
                java.math.BigDecimal amount = rs.getBigDecimal("total_amount");
                
                String period = String.format("%02d/%d", month, year);
                if (amount != null) {
                    period += " (" + String.format("%,.0f₫", amount) + ")";
                }
                unpaidPeriods.add(period);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room unpaid periods: " + e.getMessage());
            e.printStackTrace();
        }
        
        return unpaidPeriods;
    }
}

package dao;

import model.User;
import model.AdminManagement;
import model.AdminAuditLog;
import util.DBConnection;
import org.springframework.stereotype.Repository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.math.BigDecimal;

/**
 * DAO cho Super Admin
 * Xử lý tất cả các thao tác database liên quan đến Super Admin
 * Bao gồm quản lý admin, audit log và thống kê hệ thống
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Repository
public class SuperAdminDAO {
    
    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    // ==================== QUẢN LÝ ADMIN ====================
    
    /**
     * Lấy danh sách tất cả admin được quản lý
     * @param superAdminId ID của Super Admin
     * @return danh sách admin management
     */
    public List<AdminManagement> getAllManagedAdmins(int superAdminId) {
        List<AdminManagement> adminList = new ArrayList<>();
        
        // Query đơn giản hơn để tránh lỗi
        String sql = """
            SELECT am.*, 
                   sa.username as super_admin_username, sa.full_name as super_admin_name,
                   a.username as admin_username, a.full_name as admin_name, 
                   a.email as admin_email, a.phone as admin_phone, a.created_at as admin_created_at
            FROM admin_management am
            JOIN users sa ON am.super_admin_id = sa.user_id
            JOIN users a ON am.admin_id = a.user_id
            WHERE am.super_admin_id = ?
            ORDER BY am.assigned_date DESC
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, superAdminId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                AdminManagement admin = mapResultSetToAdminManagement(rs);
                
                // Tính toán thống kê riêng biệt cho từng admin
                calculateAdminStatistics(conn, admin);
                
                adminList.add(admin);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting managed admins: " + e.getMessage());
            e.printStackTrace();
        }
        
        return adminList;
    }
    
    /**
     * Tính toán thống kê cho một admin cụ thể
     */
    private void calculateAdminStatistics(Connection conn, AdminManagement admin) {
        try {
            // 1. Đếm số phòng quản lý
            int totalRooms = getAdminRoomCount(conn, admin.getAdminId());
            admin.setTotalRoomsManaged(totalRooms);
            
            // 2. Đếm số người thuê
            int totalUsers = getAdminUserCount(conn, admin.getAdminId());
            admin.setTotalUsersManaged(totalUsers);
            
            // 3. Đếm hóa đơn nợ
            int unpaidInvoices = getAdminUnpaidInvoices(conn, admin.getAdminId());
            admin.setUnpaidInvoices(unpaidInvoices);
            
        } catch (SQLException e) {
            System.err.println("Error calculating admin statistics for admin " + admin.getAdminId() + ": " + e.getMessage());
            // Set default values if calculation fails
            admin.setTotalRoomsManaged(0);
            admin.setTotalUsersManaged(0);
            admin.setUnpaidInvoices(0);
        }
    }
    
    /**
     * Đếm số phòng của admin
     */
    private int getAdminRoomCount(Connection conn, int adminId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE managed_by_admin_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, adminId);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            // Nếu cột managed_by_admin_id chưa tồn tại, trả về 0
            System.err.println("Warning: Could not count rooms for admin " + adminId + ": " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Đếm số người thuê của admin
     */
    private int getAdminUserCount(Connection conn, int adminId) throws SQLException {
        try {
            String sql = """
                SELECT COUNT(DISTINCT t.user_id) 
                FROM rooms r 
                JOIN tenants t ON r.room_id = t.room_id 
                WHERE r.managed_by_admin_id = ? AND (t.end_date IS NULL OR t.end_date > CURRENT_DATE)
                """;
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, adminId);
                ResultSet rs = stmt.executeQuery();
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            // Nếu cột managed_by_admin_id chưa tồn tại, trả về 0
            System.err.println("Warning: Could not count users for admin " + adminId + ": " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Đếm hóa đơn nợ của admin
     */
    private int getAdminUnpaidInvoices(Connection conn, int adminId) throws SQLException {
        try {
            String sql = """
                SELECT COUNT(i.invoice_id) 
                FROM rooms r 
                JOIN tenants t ON r.room_id = t.room_id 
                JOIN invoices i ON t.tenant_id = i.tenant_id 
                WHERE r.managed_by_admin_id = ? AND i.status = 'UNPAID'
                """;
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, adminId);
                ResultSet rs = stmt.executeQuery();
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            // Nếu cột managed_by_admin_id chưa tồn tại, trả về 0
            System.err.println("Warning: Could not count unpaid invoices for admin " + adminId + ": " + e.getMessage());
            return 0;
        }
    }
    
    /**
     * Lấy danh sách tất cả admin trong hệ thống
     * @return danh sách tất cả admin
     */
    public List<User> getAllAdmins() {
        List<User> adminList = new ArrayList<>();
        String sql = """
            SELECT u.*, am.status as management_status, am.notes as management_notes,
                   (SELECT COUNT(*) FROM rooms r 
                    JOIN tenants t ON r.room_id = t.room_id 
                    WHERE t.user_id IN (
                        SELECT user_id FROM users WHERE role = 'USER'
                    )) as managed_rooms
            FROM users u
            LEFT JOIN admin_management am ON u.user_id = am.admin_id
            WHERE u.role = 'ADMIN'
            ORDER BY u.created_at DESC
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User admin = mapResultSetToUser(rs);
                // Note: Management status and notes are handled separately in AdminManagement objects
                adminList.add(admin);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all admins: " + e.getMessage());
            e.printStackTrace();
        }
        
        return adminList;
    }
    
    /**
     * Tạo admin mới
     * @param admin thông tin admin mới
     * @param superAdminId ID Super Admin tạo
     * @param ipAddress IP address
     * @return true nếu thành công
     */
    public boolean createAdmin(User admin, int superAdminId, String ipAddress) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Tạo user admin
            String insertUserSql = """
                INSERT INTO users (username, password, full_name, phone, email, address, role)
                VALUES (?, ?, ?, ?, ?, ?, 'ADMIN')
                """;
            
            int adminId;
            try (PreparedStatement stmt = conn.prepareStatement(insertUserSql, Statement.RETURN_GENERATED_KEYS)) {
                stmt.setString(1, admin.getUsername());
                stmt.setString(2, passwordEncoder.encode(admin.getPassword()));
                stmt.setString(3, admin.getFullName());
                stmt.setString(4, admin.getPhone());
                stmt.setString(5, admin.getEmail());
                stmt.setString(6, admin.getAddress());
                
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Creating admin failed, no rows affected.");
                }
                
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        adminId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating admin failed, no ID obtained.");
                    }
                }
            }
            
            // 2. Gán vào admin_management
            String insertManagementSql = """
                INSERT INTO admin_management (super_admin_id, admin_id, status, notes)
                VALUES (?, ?, 'ACTIVE', 'Tạo bởi Super Admin')
                """;
            
            try (PreparedStatement stmt = conn.prepareStatement(insertManagementSql)) {
                stmt.setInt(1, superAdminId);
                stmt.setInt(2, adminId);
                stmt.executeUpdate();
            }
            
            // 3. Log hoạt động
            logAdminAction(conn, superAdminId, adminId, "CREATE_ADMIN", 
                String.format("{\"username\":\"%s\",\"full_name\":\"%s\",\"email\":\"%s\"}", 
                    admin.getUsername(), admin.getFullName(), admin.getEmail()), ipAddress);
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("Error creating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Cập nhật thông tin admin
     * @param admin thông tin admin cập nhật
     * @param superAdminId ID Super Admin thực hiện
     * @param ipAddress IP address
     * @return true nếu thành công
     */
    public boolean updateAdmin(User admin, int superAdminId, String ipAddress) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Cập nhật thông tin user
            String updateUserSql = """
                UPDATE users 
                SET full_name = ?, phone = ?, email = ?, address = ?
                WHERE user_id = ? AND role = 'ADMIN'
                """;
            
            try (PreparedStatement stmt = conn.prepareStatement(updateUserSql)) {
                stmt.setString(1, admin.getFullName());
                stmt.setString(2, admin.getPhone());
                stmt.setString(3, admin.getEmail());
                stmt.setString(4, admin.getAddress());
                stmt.setInt(5, admin.getUserId());
                
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Updating admin failed, no rows affected.");
                }
            }
            
            // 2. Log hoạt động
            logAdminAction(conn, superAdminId, admin.getUserId(), "UPDATE_ADMIN", 
                String.format("{\"full_name\":\"%s\",\"email\":\"%s\",\"phone\":\"%s\"}", 
                    admin.getFullName(), admin.getEmail(), admin.getPhone()), ipAddress);
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("Error updating admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Reset mật khẩu admin
     * @param adminId ID admin
     * @param newPassword mật khẩu mới
     * @param superAdminId ID Super Admin thực hiện
     * @param ipAddress IP address
     * @return true nếu thành công
     */
    public boolean resetAdminPassword(int adminId, String newPassword, int superAdminId, String ipAddress) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Cập nhật password
            String updatePasswordSql = """
                UPDATE users 
                SET password = ? 
                WHERE user_id = ? AND role = 'ADMIN'
                """;
            
            try (PreparedStatement stmt = conn.prepareStatement(updatePasswordSql)) {
                stmt.setString(1, passwordEncoder.encode(newPassword));
                stmt.setInt(2, adminId);
                
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Resetting password failed, no rows affected.");
                }
            }
            
            // 2. Log hoạt động
            logAdminAction(conn, superAdminId, adminId, "RESET_PASSWORD", 
                String.format("{\"timestamp\":\"%s\",\"method\":\"super_admin_reset\"}", 
                    new Timestamp(System.currentTimeMillis())), ipAddress);
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("Error resetting admin password: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    /**
     * Tạm khóa admin
     * @param adminId ID admin
     * @param superAdminId ID Super Admin thực hiện
     * @param reason lý do tạm khóa
     * @param ipAddress IP address
     * @return true nếu thành công
     */
    public boolean suspendAdmin(int adminId, int superAdminId, String reason, String ipAddress) {
        return updateAdminStatus(adminId, "SUSPENDED", reason, superAdminId, "SUSPEND_ADMIN", ipAddress);
    }
    
    /**
     * Kích hoạt admin
     * @param adminId ID admin
     * @param superAdminId ID Super Admin thực hiện
     * @param ipAddress IP address
     * @return true nếu thành công
     */
    public boolean activateAdmin(int adminId, int superAdminId, String ipAddress) {
        return updateAdminStatus(adminId, "ACTIVE", "Kích hoạt bởi Super Admin", superAdminId, "ACTIVATE_ADMIN", ipAddress);
    }
    
    /**
     * Xóa admin (soft delete - chuyển thành INACTIVE)
     * @param adminId ID admin
     * @param superAdminId ID Super Admin thực hiện
     * @param ipAddress IP address
     * @return true nếu thành công
     */
    public boolean deleteAdmin(int adminId, int superAdminId, String ipAddress) {
        return updateAdminStatus(adminId, "INACTIVE", "Xóa bởi Super Admin", superAdminId, "DELETE_ADMIN", ipAddress);
    }
    
    /**
     * Cập nhật trạng thái admin
     */
    private boolean updateAdminStatus(int adminId, String status, String notes, int superAdminId, String action, String ipAddress) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            
            // 1. Cập nhật trạng thái trong admin_management
            String updateStatusSql = """
                UPDATE admin_management 
                SET status = ?, notes = ?, updated_at = CURRENT_TIMESTAMP
                WHERE admin_id = ?
                """;
            
            try (PreparedStatement stmt = conn.prepareStatement(updateStatusSql)) {
                stmt.setString(1, status);
                stmt.setString(2, notes);
                stmt.setInt(3, adminId);
                
                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected == 0) {
                    throw new SQLException("Updating admin status failed, no rows affected.");
                }
            }
            
            // 2. Log hoạt động
            logAdminAction(conn, superAdminId, adminId, action, 
                String.format("{\"status\":\"%s\",\"notes\":\"%s\"}", status, notes), ipAddress);
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            System.err.println("Error updating admin status: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    // ==================== AUDIT LOG ====================
    
    /**
     * Lấy danh sách audit log
     * @param superAdminId ID Super Admin (null để lấy tất cả)
     * @param limit số lượng record
     * @return danh sách audit log
     */
    public List<AdminAuditLog> getAuditLogs(Integer superAdminId, int limit) {
        List<AdminAuditLog> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT al.*, 
                   sa.username as super_admin_username, sa.full_name as super_admin_name,
                   ta.username as target_admin_username, ta.full_name as target_admin_name
            FROM admin_audit_log al
            JOIN users sa ON al.super_admin_id = sa.user_id
            LEFT JOIN users ta ON al.target_admin_id = ta.user_id
            """);
        
        if (superAdminId != null) {
            sql.append(" WHERE al.super_admin_id = ?");
        }
        
        sql.append(" ORDER BY al.created_at DESC LIMIT ?");
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (superAdminId != null) {
                stmt.setInt(paramIndex++, superAdminId);
            }
            stmt.setInt(paramIndex, limit);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                AdminAuditLog log = mapResultSetToAuditLog(rs);
                logs.add(log);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting audit logs: " + e.getMessage());
            e.printStackTrace();
        }
        
        return logs;
    }
    
    /**
     * Log hoạt động admin
     */
    private void logAdminAction(Connection conn, int superAdminId, Integer targetAdminId, 
                               String action, String details, String ipAddress) throws SQLException {
        String sql = """
            INSERT INTO admin_audit_log (super_admin_id, target_admin_id, action, details, ip_address)
            VALUES (?, ?, ?, ?, ?)
            """;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, superAdminId);
            if (targetAdminId != null) {
                stmt.setInt(2, targetAdminId);
            } else {
                stmt.setNull(2, Types.INTEGER);
            }
            stmt.setString(3, action);
            stmt.setString(4, details);
            stmt.setString(5, ipAddress);
            
            stmt.executeUpdate();
        }
    }
    
    // ==================== THỐNG KÊ HỆ THỐNG ====================
    
    /**
     * Lấy thống kê tổng quan hệ thống
     * @return Map chứa các thống kê
     */
    public Map<String, Object> getSystemStats() {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DBConnection.getConnection()) {
            
            // Thống kê người dùng
            stats.put("totalSuperAdmins", getUserCountByRole(conn, "SUPER_ADMIN"));
            stats.put("totalAdmins", getUserCountByRole(conn, "ADMIN"));
            stats.put("totalUsers", getUserCountByRole(conn, "USER"));
            stats.put("activeAdmins", getActiveAdminCount(conn));
            stats.put("suspendedAdmins", getSuspendedAdminCount(conn));
            
            // Thống kê phòng
            stats.put("totalRooms", getTotalRoomCount(conn));
            stats.put("occupiedRooms", getOccupiedRoomCount(conn));
            stats.put("availableRooms", getAvailableRoomCount(conn));
            
            // Thống kê doanh thu
            stats.put("totalRevenue", getTotalRevenue(conn));
            stats.put("monthlyRevenue", getMonthlyRevenue(conn));
            stats.put("unpaidInvoices", getUnpaidInvoiceCount(conn));
            
            // Thống kê hoạt động
            stats.put("recentActions", getRecentActionCount(conn, 7)); // 7 ngày gần đây
            stats.put("criticalActions", getCriticalActionCount(conn, 30)); // 30 ngày gần đây
            
        } catch (SQLException e) {
            System.err.println("Error getting system stats: " + e.getMessage());
            e.printStackTrace();
        }
        
        return stats;
    }
    
    // ==================== HELPER METHODS ====================
    
    private int getUserCountByRole(Connection conn, String role) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getActiveAdminCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM admin_management WHERE status = 'ACTIVE'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getSuspendedAdminCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM admin_management WHERE status = 'SUSPENDED'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getTotalRoomCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getOccupiedRoomCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = 'OCCUPIED'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getAvailableRoomCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = 'AVAILABLE'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private BigDecimal getTotalRevenue(Connection conn) throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_amount), 0) FROM invoices WHERE status = 'PAID'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }
    
    private BigDecimal getMonthlyRevenue(Connection conn) throws SQLException {
        String sql = """
            SELECT COALESCE(SUM(total_amount), 0) 
            FROM invoices 
            WHERE status = 'PAID' 
            AND MONTH(created_at) = MONTH(CURRENT_DATE()) 
            AND YEAR(created_at) = YEAR(CURRENT_DATE())
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getBigDecimal(1) : BigDecimal.ZERO;
        }
    }
    
    private int getUnpaidInvoiceCount(Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM invoices WHERE status = 'UNPAID'";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getRecentActionCount(Connection conn, int days) throws SQLException {
        String sql = "SELECT COUNT(*) FROM admin_audit_log WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, days);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int getCriticalActionCount(Connection conn, int days) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM admin_audit_log 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL ? DAY)
            AND action IN ('DELETE_ADMIN', 'RESET_PASSWORD', 'SUSPEND_ADMIN')
            """;
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, days);
            ResultSet rs = stmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    // ==================== MAPPING METHODS ====================
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setEmail(rs.getString("email"));
        user.setAddress(rs.getString("address"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
    
    private AdminManagement mapResultSetToAdminManagement(ResultSet rs) throws SQLException {
        AdminManagement admin = new AdminManagement();
        admin.setManagementId(rs.getInt("management_id"));
        admin.setSuperAdminId(rs.getInt("super_admin_id"));
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setAssignedDate(rs.getTimestamp("assigned_date"));
        admin.setStatus(rs.getString("status"));
        admin.setNotes(rs.getString("notes"));
        
        // Display properties
        admin.setSuperAdminUsername(rs.getString("super_admin_username"));
        admin.setSuperAdminName(rs.getString("super_admin_name"));
        admin.setAdminUsername(rs.getString("admin_username"));
        admin.setAdminName(rs.getString("admin_name"));
        admin.setAdminEmail(rs.getString("admin_email"));
        admin.setAdminPhone(rs.getString("admin_phone"));
        admin.setAdminCreatedAt(rs.getTimestamp("admin_created_at"));
        
        // Statistics sẽ được tính toán riêng trong calculateAdminStatistics()
        // Không cần đọc từ ResultSet nữa
        
        return admin;
    }
    
    private AdminAuditLog mapResultSetToAuditLog(ResultSet rs) throws SQLException {
        AdminAuditLog log = new AdminAuditLog();
        log.setLogId(rs.getInt("log_id"));
        log.setSuperAdminId(rs.getInt("super_admin_id"));
        
        int targetAdminId = rs.getInt("target_admin_id");
        if (!rs.wasNull()) {
            log.setTargetAdminId(targetAdminId);
        }
        
        log.setAction(rs.getString("action"));
        log.setDetails(rs.getString("details"));
        log.setIpAddress(rs.getString("ip_address"));
        log.setUserAgent(rs.getString("user_agent"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Display properties
        log.setSuperAdminUsername(rs.getString("super_admin_username"));
        log.setSuperAdminName(rs.getString("super_admin_name"));
        log.setTargetAdminUsername(rs.getString("target_admin_username"));
        log.setTargetAdminName(rs.getString("target_admin_name"));
        
        return log;
    }
}
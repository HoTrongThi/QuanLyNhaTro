package dao;

import model.User;
import util.DBConnection;
import org.springframework.stereotype.Repository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp Data Access Object cho Người dùng (Đã cập nhật với Super Admin)
 * Xử lý tất cả các thao tác cơ sở dữ liệu cho thực thể User
 * Bao gồm đăng ký, đăng nhập, cập nhật thông tin và quản lý người dùng
 * Hỗ trợ 3 vai trò: SUPER_ADMIN, ADMIN, USER
 * Sử dụng BCrypt để mã hóa mật khẩu an toàn
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 2.0
 * @since 2025
 */
@Repository
public class UserDAO {
    
    // ==================== CÁC THUỘC TÍNH ====================
    
    /** Bộ mã hóa mật khẩu BCrypt - đảm bảo bảo mật cao */
    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    // ==================== CÁC PHƯƠNG THỨC ĐĂNG KÝ VÀ ĐĂNG NHẬP ====================
    
    /**
     * Đăng ký người dùng mới
     * Mã hóa mật khẩu bằng BCrypt trước khi lưu vào database
     * Kiểm tra tính duy nhất của username và email
     * 
     * @param user đối tượng User chứa thông tin đăng ký
     * @return true nếu đăng ký thành công, false nếu thất bại
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, password, full_name, phone, email, address, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Mã hóa mật khẩu trước khi lưu vào database
            String hashedPassword = passwordEncoder.encode(user.getPassword());
            
            // Đặt các tham số cho câu lệnh SQL
            stmt.setString(1, user.getUsername());   // Tên đăng nhập
            stmt.setString(2, hashedPassword);       // Mật khẩu đã mã hóa
            stmt.setString(3, user.getFullName());   // Họ tên đầy đủ
            stmt.setString(4, user.getPhone());      // Số điện thoại
            stmt.setString(5, user.getEmail());      // Địa chỉ email
            stmt.setString(6, user.getAddress());    // Địa chỉ nhà
            stmt.setString(7, user.getRole());       // Vai trò (SUPER_ADMIN/ADMIN/USER)
            
            // Thực thi câu lệnh và kiểm tra kết quả
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Lỗi đăng ký người dùng: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Xác thực đăng nhập người dùng
     * Kiểm tra tên đăng nhập và mật khẩu
     * Sử dụng BCrypt để so sánh mật khẩu đã mã hóa
     * Hỗ trợ tất cả các vai trò: SUPER_ADMIN, ADMIN, USER
     * 
     * @param username tên đăng nhập
     * @param password mật khẩu chưa mã hóa
     * @return đối tượng User nếu đăng nhập thành công, null nếu thất bại
     */
    public User loginUser(String username, String password) {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                
                // Verify password
                if (passwordEncoder.matches(password, hashedPassword)) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(hashedPassword);
                    user.setFullName(rs.getString("full_name"));
                    user.setPhone(rs.getString("phone"));
                    user.setEmail(rs.getString("email"));
                    user.setAddress(rs.getString("address"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    return user;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
        }
        
        return null;
    }
    
    // ==================== CÁC PHƯƠNG THỨC KIỂM TRA TÍNH DUY NHẤT ====================
    
    /**
     * Check if username already exists
     * @param username Username to check
     * @return true if username exists, false otherwise
     */
    public boolean usernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking username: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Check if email exists for other user (when updating profile)
     * @param email Email to check
     * @param excludeUserId User ID to exclude from check
     * @return true if email exists for another user, false otherwise
     */
    public boolean emailExistsForOtherUser(String email, int excludeUserId) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND user_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            stmt.setInt(2, excludeUserId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email for other user: " + e.getMessage());
        }
        
        return false;
    }
    
    // ==================== CÁC PHƯƠNG THỨC LẤY THÔNG TIN NGƯỜI DÙNG ====================
    
    /**
     * Get user by ID
     * @param userId User ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
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
            
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Get user by username
     * @param username Username
     * @return User object if found, null otherwise
     */
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
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
            
        } catch (SQLException e) {
            System.err.println("Error getting user by username: " + e.getMessage());
        }
        
        return null;
    }
    
    // ==================== CÁC PHƯƠNG THỨC LẤY DANH SÁCH THEO VAI TRÒ ====================
    
    /**
     * Get all Super Admins
     * @return List of Super Admin users
     */
    public List<User> getAllSuperAdmins() {
        return getUsersByRole("SUPER_ADMIN");
    }
    
    /**
     * Get all Admins
     * @return List of Admin users
     */
    public List<User> getAllAdmins() {
        return getUsersByRole("ADMIN");
    }
    
    /**
     * Get all regular users (non-admin)
     * @return List of users with role 'USER'
     */
    public List<User> getAllRegularUsers() {
        return getUsersByRole("USER");
    }
    
    /**
     * Get users by role
     * @param role Role to filter by
     * @return List of users with specified role
     */
    private List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, phone, email, address, role, created_at " +
                    "FROM users WHERE role = ? ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting users by role " + role + ": " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Get all users for admin management
     * @return List of all users (excluding passwords for security)
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, phone, email, address, role, created_at " +
                    "FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
        }
        
        return users;
    }
    
    // ==================== CÁC PHƯƠNG THỨC CẬP NHẬT THÔNG TIN ====================
    
    /**
     * Update user profile (personal information)
     * @param user User object with updated information
     * @return true if update successful, false otherwise
     */
    public boolean updateUserProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, phone = ?, email = ?, address = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getAddress());
            stmt.setInt(5, user.getUserId());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating user profile: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Update user password
     * @param userId User ID
     * @param newPassword New plain text password
     * @return true if update successful, false otherwise
     */
    public boolean updateUserPassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Hash new password
            String hashedPassword = passwordEncoder.encode(newPassword);
            
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating user password: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Update user role (Super Admin only)
     * @param userId User ID
     * @param newRole New role (SUPER_ADMIN, ADMIN, USER)
     * @return true if update successful, false otherwise
     */
    public boolean updateUserRole(int userId, String newRole) {
        // Validate role
        if (!isValidRole(newRole)) {
            System.err.println("Invalid role: " + newRole);
            return false;
        }
        
        String sql = "UPDATE users SET role = ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newRole);
            stmt.setInt(2, userId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating user role: " + e.getMessage());
            return false;
        }
    }
    
    // ==================== CÁC PHƯƠNG THỨC TÌM KIẾM ====================
    
    /**
     * Search users by name, username, or email
     * @param searchTerm Search term
     * @return List of matching users
     */
    public List<User> searchUsers(String searchTerm) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, phone, email, address, role, created_at " +
                    "FROM users WHERE LOWER(full_name) LIKE LOWER(?) OR " +
                    "LOWER(username) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?) " +
                    "ORDER BY full_name";
        
        String searchPattern = "%" + searchTerm.trim() + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching users: " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Search users by role and search term
     * @param role Role to filter by
     * @param searchTerm Search term
     * @return List of matching users
     */
    public List<User> searchUsersByRole(String role, String searchTerm) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, phone, email, address, role, created_at " +
                    "FROM users WHERE role = ? AND (LOWER(full_name) LIKE LOWER(?) OR " +
                    "LOWER(username) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)) " +
                    "ORDER BY full_name";
        
        String searchPattern = "%" + searchTerm.trim() + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching users by role: " + e.getMessage());
        }
        
        return users;
    }
    
    // ==================== CÁC PHƯƠNG THỨC XÓA ====================
    
    /**
     * Delete user (admin only)
     * @param userId User ID to delete
     * @return true if deletion successful, false otherwise
     */
    public boolean deleteUser(int userId) {
        // First check if user is currently a tenant
        String checkTenantSql = "SELECT COUNT(*) FROM tenants WHERE user_id = ? AND end_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Check if user is active tenant
            try (PreparedStatement checkStmt = conn.prepareStatement(checkTenantSql)) {
                checkStmt.setInt(1, userId);
                ResultSet rs = checkStmt.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    System.err.println("Cannot delete user: User is currently a tenant");
                    return false;
                }
            }
            
            // Check if user is Super Admin (prevent deletion of last Super Admin)
            User user = getUserById(userId);
            if (user != null && "SUPER_ADMIN".equals(user.getRole())) {
                int superAdminCount = getSuperAdminCount();
                if (superAdminCount <= 1) {
                    System.err.println("Cannot delete user: Cannot delete the last Super Admin");
                    return false;
                }
            }
            
            // Delete user
            String deleteSql = "DELETE FROM users WHERE user_id = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                deleteStmt.setInt(1, userId);
                int result = deleteStmt.executeUpdate();
                return result > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error deleting user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Check if user can be deleted (not an active tenant and not the last Super Admin)
     * @param userId User ID
     * @return true if user can be deleted, false otherwise
     */
    public boolean canDeleteUser(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            // Check if user is active tenant
            String tenantSql = "SELECT COUNT(*) FROM tenants WHERE user_id = ? AND end_date IS NULL";
            try (PreparedStatement stmt = conn.prepareStatement(tenantSql)) {
                stmt.setInt(1, userId);
                ResultSet rs = stmt.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Cannot delete active tenant
                }
            }
            
            // Check if user is Super Admin and is the last one
            User user = getUserById(userId);
            if (user != null && "SUPER_ADMIN".equals(user.getRole())) {
                int superAdminCount = getSuperAdminCount();
                if (superAdminCount <= 1) {
                    return false; // Cannot delete the last Super Admin
                }
            }
            
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error checking if user can be deleted: " + e.getMessage());
            return false;
        }
    }
    
    // ==================== CÁC PHƯƠNG THỨC XÁC THỰC ====================
    
    /**
     * Verify user password
     * @param userId User ID
     * @param password Plain text password to verify
     * @return true if password matches, false otherwise
     */
    public boolean verifyPassword(int userId, String password) {
        String sql = "SELECT password FROM users WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                return passwordEncoder.matches(password, hashedPassword);
            }
            
        } catch (SQLException e) {
            System.err.println("Error verifying password: " + e.getMessage());
        }
        
        return false;
    }
    
    // ==================== CÁC PHƯƠNG THỨC THỐNG KÊ ====================
    
    /**
     * Get user statistics
     */
    public int getTotalUserCount() {
        return getCount("SELECT COUNT(*) FROM users");
    }
    
    public int getSuperAdminCount() {
        return getCount("SELECT COUNT(*) FROM users WHERE role = 'SUPER_ADMIN'");
    }
    
    public int getAdminCount() {
        return getCount("SELECT COUNT(*) FROM users WHERE role = 'ADMIN'");
    }
    
    public int getRegularUserCount() {
        return getCount("SELECT COUNT(*) FROM users WHERE role = 'USER'");
    }
    
    public int getActiveTenantsCount() {
        return getCount("SELECT COUNT(DISTINCT user_id) FROM tenants WHERE end_date IS NULL");
    }
    
    /**
     * Helper method to get count from database
     */
    private int getCount(String sql) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting count: " + e.getMessage());
        }
        
        return 0;
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Validate role
     * @param role Role to validate
     * @return true if role is valid
     */
    private boolean isValidRole(String role) {
        return "SUPER_ADMIN".equals(role) || "ADMIN".equals(role) || "USER".equals(role);
    }
    
    /**
     * Check if user has specific role
     * @param userId User ID
     * @param role Role to check
     * @return true if user has the specified role
     */
    public boolean userHasRole(int userId, String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE user_id = ? AND role = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, role);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking user role: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Get users with pagination
     * @param offset Starting position
     * @param limit Number of records
     * @return List of users
     */
    public List<User> getUsersWithPagination(int offset, int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, phone, email, address, role, created_at " +
                    "FROM users ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting users with pagination: " + e.getMessage());
        }
        
        return users;
    }
}
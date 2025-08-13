package dao;

import model.User;
import util.DBConnection;
import org.springframework.stereotype.Repository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.sql.*;

/**
 * User Data Access Object
 * Handles all database operations for User entity
 */
@Repository
public class UserDAO {
    
    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    /**
     * Register a new user
     * @param user User object with registration details
     * @return true if registration successful, false otherwise
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (username, password, full_name, phone, email, address, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            // Hash password before storing
            String hashedPassword = passwordEncoder.encode(user.getPassword());
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, hashedPassword);
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getEmail());
            stmt.setString(6, user.getAddress());
            stmt.setString(7, user.getRole());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Authenticate user login
     * @param username Username
     * @param password Plain text password
     * @return User object if login successful, null otherwise
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
    
    /**
     * Get all regular users (non-admin)
     * @return List of users with role 'USER'
     */
    public java.util.List<User> getAllRegularUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
        String sql = "SELECT user_id, username, full_name, phone, email, address, created_at " +
                    "FROM users WHERE role = 'USER' ORDER BY full_name";
        
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
                user.setRole("USER");
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all regular users: " + e.getMessage());
        }
        
        return users;
    }
    
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
    
    /**
     * Get all users for admin management
     * @return List of all users (excluding passwords for security)
     */
    public java.util.List<User> getAllUsers() {
        java.util.List<User> users = new java.util.ArrayList<>();
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
    
    /**
     * Search users by name, username, or email
     * @param searchTerm Search term
     * @return List of matching users
     */
    public java.util.List<User> searchUsers(String searchTerm) {
        java.util.List<User> users = new java.util.ArrayList<>();
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
     * Get user statistics
     */
    public int getTotalUserCount() {
        return getCount("SELECT COUNT(*) FROM users");
    }
    
    public int getRegularUserCount() {
        return getCount("SELECT COUNT(*) FROM users WHERE role = 'USER'");
    }
    
    public int getAdminUserCount() {
        return getCount("SELECT COUNT(*) FROM users WHERE role = 'ADMIN'");
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
    
    /**
     * Check if user can be deleted (not an active tenant)
     * @param userId User ID
     * @return true if user can be deleted, false otherwise
     */
    public boolean canDeleteUser(int userId) {
        String sql = "SELECT COUNT(*) FROM tenants WHERE user_id = ? AND end_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) == 0; // Can delete if not an active tenant
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking if user can be deleted: " + e.getMessage());
        }
        
        return false;
    }
}

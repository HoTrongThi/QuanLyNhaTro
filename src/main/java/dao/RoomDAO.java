package dao;

import model.Room;
import util.DBConnection;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp Data Access Object cho Phòng trọ với Admin Data Isolation
 * Xử lý tất cả các thao tác cơ sở dữ liệu cho thực thể Room
 * Bao gồm CRUD operations, kiểm tra trạng thái và validation
 * Hỗ trợ quản lý trạng thái phòng và kiểm tra lịch sử thuê
 * Mỗi Admin chỉ thấy và quản lý rooms của mình
 * Super Admin thấy tất cả rooms
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 2.0 - Admin Isolation
 * @since 2025
 */
@Repository
public class RoomDAO {
    
    // ==================== ADMIN ISOLATION METHODS ====================
    
    /**
     * Lấy danh sách phòng theo Admin ID
     * Super Admin (adminId = null) sẽ thấy tất cả phòng
     * 
     * @param adminId ID của Admin (null cho Super Admin)
     * @return danh sách phòng thuộc quyền quản lý của Admin
     */
    public List<Room> getRoomsByAdmin(Integer adminId) {
        List<Room> rooms = new ArrayList<>();
        String sql;
        
        if (adminId == null) {
            // Super Admin - thấy tất cả phòng
            sql = "SELECT * FROM rooms ORDER BY room_name";
        } else {
            // Admin - chỉ thấy phòng của mình
            sql = "SELECT * FROM rooms WHERE managed_by_admin_id = ? ORDER BY room_name";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (adminId != null) {
                stmt.setInt(1, adminId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = mapResultSetToRoom(rs);
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách phòng theo admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Lấy thông tin phòng theo ID với kiểm tra quyền Admin
     * 
     * @param roomId ID của phòng
     * @param adminId ID của Admin (null cho Super Admin)
     * @return đối tượng Room nếu có quyền truy cập, null nếu không
     */
    public Room getRoomByIdAndAdmin(int roomId, Integer adminId) {
        String sql;
        
        if (adminId == null) {
            // Super Admin - truy cập tất cả phòng
            sql = "SELECT * FROM rooms WHERE room_id = ?";
        } else {
            // Admin - chỉ truy cập phòng của mình
            sql = "SELECT * FROM rooms WHERE room_id = ? AND managed_by_admin_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            if (adminId != null) {
                stmt.setInt(2, adminId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRoom(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room by ID and admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Thêm phòng mới với Admin ID
     * 
     * @param room đối tượng Room
     * @param adminId ID của Admin tạo phòng
     * @return true nếu thành công
     */
    public boolean addRoomWithAdmin(Room room, int adminId) {
        String sql = "INSERT INTO rooms (room_name, price, status, description, amenities, managed_by_admin_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getRoomName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getStatus());
            stmt.setString(4, room.getDescription());
            stmt.setString(5, room.getAmenities() != null ? room.getAmenities() : "[]");
            stmt.setInt(6, adminId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding room with admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // ==================== CÁC PHƯƠNG THỨC CRUD CƠ BẢN (LEGACY) ====================
    
    /**
     * Lấy danh sách tất cả phòng
     * Sắp xếp theo tên phòng tăng dần
     * 
     * @return danh sách tất cả phòng trong hệ thống
     */
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            // Duyệt qua tất cả kết quả và tạo đối tượng Room
            while (rs.next()) {
                Room room = mapResultSetToRoom(rs);
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Lỗi khi lấy danh sách phòng: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Lấy thông tin phòng theo ID
     * 
     * @param roomId ID của phòng cần tìm
     * @return đối tượng Room nếu tìm thấy, null nếu không
     */
    public Room getRoomById(int roomId) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToRoom(rs);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Thêm phòng mới vào hệ thống
     * Kiểm tra tính hợp lệ và thêm vào database
     * 
     * @param room đối tượng Room chứa thông tin phòng mới
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_name, price, status, description, amenities) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getRoomName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getStatus());
            stmt.setString(4, room.getDescription());
            stmt.setString(5, room.getAmenities() != null ? room.getAmenities() : "[]");
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding room: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update room
     * @param room Room object with updated data
     * @return true if successful, false otherwise
     */
    public boolean updateRoom(Room room) {
        String sql = "UPDATE rooms SET room_name = ?, price = ?, status = ?, description = ?, amenities = ? WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getRoomName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getStatus());
            stmt.setString(4, room.getDescription());
            stmt.setString(5, room.getAmenities() != null ? room.getAmenities() : "[]");
            stmt.setInt(6, room.getRoomId());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating room: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete room by ID
     * @param roomId Room ID to delete
     * @return true if successful, false otherwise
     */
    public boolean deleteRoom(int roomId) {
        // First check if room has active tenants
        if (isRoomOccupied(roomId)) {
            System.err.println("Cannot delete room - room has active tenants");
            return false;
        }
        
        // Check if room has any tenant history (including inactive tenants)
        if (hasRoomHistory(roomId)) {
            System.err.println("Cannot delete room - room has tenant history. Use soft delete or archive instead.");
            return false;
        }
        
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting room: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if room name already exists (for validation)
     * @param roomName Room name to check
     * @param excludeRoomId Room ID to exclude from check (for updates)
     * @return true if room name exists, false otherwise
     */
    public boolean roomNameExists(String roomName, int excludeRoomId) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE room_name = ? AND room_id != ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, roomName);
            stmt.setInt(2, excludeRoomId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking room name: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if room name already exists (for new rooms)
     * @param roomName Room name to check
     * @return true if room name exists, false otherwise
     */
    public boolean roomNameExists(String roomName) {
        return roomNameExists(roomName, 0);
    }
    
    /**
     * Check if room is currently occupied (has active tenants)
     * @param roomId Room ID to check
     * @return true if room has active tenants, false otherwise
     */
    public boolean isRoomOccupied(int roomId) {
        // Only check for ACTIVE tenants (end_date is NULL)
        String sql = "SELECT COUNT(*) FROM tenants WHERE room_id = ? AND end_date IS NULL";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int activeTenantsCount = rs.getInt(1);

                return activeTenantsCount > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking room occupation: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if room has any tenant history (for complete deletion check)
     * @param roomId Room ID to check
     * @return true if room has any tenant history, false otherwise
     */
    public boolean hasRoomHistory(int roomId) {
        String sql = "SELECT COUNT(*) FROM tenants WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking room history: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get available rooms
     * @return List of available rooms
     */
    public List<Room> getAvailableRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE status = 'AVAILABLE' ORDER BY room_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setStatus(rs.getString("status"));
                room.setDescription(rs.getString("description"));
                room.setAmenities(rs.getString("amenities"));
                
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available rooms: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Get total room count
     * @return Total number of rooms
     */
    public int getTotalRoomCount() {
        String sql = "SELECT COUNT(*) FROM rooms";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get available room count
     * @return Number of available rooms
     */
    public int getAvailableRoomCount() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = 'AVAILABLE'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available room count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get occupied room count
     * @return Number of occupied rooms
     */
    public int getOccupiedRoomCount() {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = 'OCCUPIED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting occupied room count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get room count by status
     * @param status Room status to count
     * @return Number of rooms with the specified status
     */
    public int getRoomCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE status = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room count by status: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get maintenance room count
     * @return Number of rooms under maintenance
     */
    public int getMaintenanceRoomCount() {
        return getRoomCountByStatus("MAINTENANCE");
    }
    
    /**
     * Get reserved room count
     * @return Number of reserved rooms
     */
    public int getReservedRoomCount() {
        return getRoomCountByStatus("RESERVED");
    }
    
    /**
     * Get suspended room count
     * @return Number of suspended rooms
     */
    public int getSuspendedRoomCount() {
        return getRoomCountByStatus("SUSPENDED");
    }
    
    /**
     * Get cleaning room count
     * @return Number of rooms being cleaned
     */
    public int getCleaningRoomCount() {
        return getRoomCountByStatus("CLEANING");
    }
    
    /**
     * Get contract expired room count
     * @return Number of rooms with expired contracts
     */
    public int getContractExpiredRoomCount() {
        return getRoomCountByStatus("CONTRACT_EXPIRED");
    }
    
    /**
     * Check if room can be safely deleted
     * @param roomId Room ID to check
     * @return true if room can be deleted (no active tenants and no history), false otherwise
     */
    public boolean canDeleteRoom(int roomId) {
        return !isRoomOccupied(roomId) && !hasRoomHistory(roomId);
    }
    
    /**
     * Get rooms for tenant management (only AVAILABLE and OCCUPIED status)
     * Used in tenant management page to show only relevant rooms
     * @return List of rooms with AVAILABLE or OCCUPIED status
     */
    public List<Room> getRoomsForTenantManagement() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE status IN ('AVAILABLE', 'OCCUPIED') ORDER BY room_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setStatus(rs.getString("status"));
                room.setDescription(rs.getString("description"));
                room.setAmenities(rs.getString("amenities"));
                
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting rooms for tenant management: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Search rooms by name or tenant name (for tenant management - only AVAILABLE and OCCUPIED)
     * @param searchTerm Search term to find rooms
     * @return List of rooms matching the search criteria with AVAILABLE or OCCUPIED status
     */
    public List<Room> searchRoomsForTenantManagement(String searchTerm) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT DISTINCT r.* FROM rooms r " +
                    "LEFT JOIN tenants t ON r.room_id = t.room_id AND t.end_date IS NULL " +
                    "LEFT JOIN users u ON t.user_id = u.user_id " +
                    "WHERE r.status IN ('AVAILABLE', 'OCCUPIED') " +
                    "  AND (LOWER(r.room_name) LIKE LOWER(?) " +
                    "       OR LOWER(u.full_name) LIKE LOWER(?)) " +
                    "ORDER BY r.room_name";
        
        String searchPattern = "%" + searchTerm.trim() + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setStatus(rs.getString("status"));
                room.setDescription(rs.getString("description"));
                room.setAmenities(rs.getString("amenities"));
                
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching rooms for tenant management: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Search rooms by name or tenant name
     * @param searchTerm Search term to find rooms
     * @return List of rooms matching the search criteria
     */
    public List<Room> searchRooms(String searchTerm) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT DISTINCT r.* FROM rooms r " +
                    "LEFT JOIN tenants t ON r.room_id = t.room_id AND t.end_date IS NULL " +
                    "LEFT JOIN users u ON t.user_id = u.user_id " +
                    "WHERE LOWER(r.room_name) LIKE LOWER(?) " +
                    "   OR LOWER(u.full_name) LIKE LOWER(?) " +
                    "ORDER BY r.room_name";
        
        String searchPattern = "%" + searchTerm.trim() + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setStatus(rs.getString("status"));
                room.setDescription(rs.getString("description"));
                room.setAmenities(rs.getString("amenities"));
                
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching rooms: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    // ==================== HELPER METHODS ====================
    
    /**
     * Map ResultSet to Room object
     */
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setRoomName(rs.getString("room_name"));
        room.setPrice(rs.getBigDecimal("price"));
        room.setStatus(rs.getString("status"));
        room.setDescription(rs.getString("description"));
        room.setAmenities(rs.getString("amenities"));
        return room;
    }
    
    // ==================== ADMIN ISOLATION STATISTICS ====================
    
    /**
     * Lấy tổng số phòng theo Admin
     */
    public int getTotalRoomCountByAdmin(Integer adminId) {
        String sql;
        
        if (adminId == null) {
            sql = "SELECT COUNT(*) FROM rooms";
        } else {
            sql = "SELECT COUNT(*) FROM rooms WHERE managed_by_admin_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (adminId != null) {
                stmt.setInt(1, adminId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total room count by admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Lấy số phòng theo trạng thái và Admin
     */
    public int getRoomCountByStatusAndAdmin(String status, Integer adminId) {
        String sql;
        
        if (adminId == null) {
            sql = "SELECT COUNT(*) FROM rooms WHERE status = ?";
        } else {
            sql = "SELECT COUNT(*) FROM rooms WHERE status = ? AND managed_by_admin_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            if (adminId != null) {
                stmt.setInt(2, adminId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room count by status and admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Lấy phòng available theo Admin
     */
    public List<Room> getAvailableRoomsByAdmin(Integer adminId) {
        List<Room> rooms = new ArrayList<>();
        String sql;
        
        if (adminId == null) {
            sql = "SELECT * FROM rooms WHERE status = 'AVAILABLE' ORDER BY room_name";
        } else {
            sql = "SELECT * FROM rooms WHERE status = 'AVAILABLE' AND managed_by_admin_id = ? ORDER BY room_name";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (adminId != null) {
                stmt.setInt(1, adminId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = mapResultSetToRoom(rs);
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting available rooms by admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    // ==================== CONVENIENCE METHODS ====================
    
    public int getAvailableRoomCountByAdmin(Integer adminId) {
        return getRoomCountByStatusAndAdmin("AVAILABLE", adminId);
    }
    
    public int getOccupiedRoomCountByAdmin(Integer adminId) {
        return getRoomCountByStatusAndAdmin("OCCUPIED", adminId);
    }
    
    public int getMaintenanceRoomCountByAdmin(Integer adminId) {
        return getRoomCountByStatusAndAdmin("MAINTENANCE", adminId);
    }
    
    /**
     * Cập nhật phòng với kiểm tra quyền Admin
     */
    public boolean updateRoomWithAdmin(Room room, Integer adminId) {
        String sql;
        
        if (adminId == null) {
            // Super Admin - cập nhật tất cả phòng
            sql = "UPDATE rooms SET room_name = ?, price = ?, status = ?, description = ?, amenities = ? " +
                  "WHERE room_id = ?";
        } else {
            // Admin - chỉ cập nhật phòng của mình
            sql = "UPDATE rooms SET room_name = ?, price = ?, status = ?, description = ?, amenities = ? " +
                  "WHERE room_id = ? AND managed_by_admin_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getRoomName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getStatus());
            stmt.setString(4, room.getDescription());
            stmt.setString(5, room.getAmenities() != null ? room.getAmenities() : "[]");
            stmt.setInt(6, room.getRoomId());
            
            if (adminId != null) {
                stmt.setInt(7, adminId);
            }
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating room with admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Xóa phòng với kiểm tra quyền Admin
     */
    public boolean deleteRoomWithAdmin(int roomId, Integer adminId) {
        // Kiểm tra quyền truy cập trước
        Room room = getRoomByIdAndAdmin(roomId, adminId);
        if (room == null) {
            System.err.println("No permission to delete this room or room not found");
            return false;
        }
        
        String sql;
        
        if (adminId == null) {
            sql = "DELETE FROM rooms WHERE room_id = ?";
        } else {
            sql = "DELETE FROM rooms WHERE room_id = ? AND managed_by_admin_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            if (adminId != null) {
                stmt.setInt(2, adminId);
            }
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting room with admin: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra tên phòng đã tồn tại trong phạm vi Admin
     */
    public boolean roomNameExistsInAdmin(String roomName, Integer adminId, int excludeRoomId) {
        String sql;
        
        if (adminId == null) {
            sql = "SELECT COUNT(*) FROM rooms WHERE room_name = ? AND room_id != ?";
        } else {
            sql = "SELECT COUNT(*) FROM rooms WHERE room_name = ? AND room_id != ? AND managed_by_admin_id = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, roomName);
            stmt.setInt(2, excludeRoomId);
            if (adminId != null) {
                stmt.setInt(3, adminId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking room name in admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Lấy phòng cho quản lý tenant theo Admin
     * Chỉ hiển thị phòng AVAILABLE và OCCUPIED
     */
    public List<Room> getRoomsForTenantManagementByAdmin(Integer adminId) {
        List<Room> rooms = new ArrayList<>();
        String sql;
        
        if (adminId == null) {
            // Super Admin - thấy tất cả phòng
            sql = "SELECT * FROM rooms WHERE status IN ('AVAILABLE', 'OCCUPIED') ORDER BY room_name";
        } else {
            // Admin - chỉ thấy phòng của mình
            sql = "SELECT * FROM rooms WHERE status IN ('AVAILABLE', 'OCCUPIED') AND managed_by_admin_id = ? ORDER BY room_name";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (adminId != null) {
                stmt.setInt(1, adminId);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = mapResultSetToRoom(rs);
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting rooms for tenant management by admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Tìm kiếm phòng cho quản lý tenant theo Admin
     */
    public List<Room> searchRoomsForTenantManagementByAdmin(String searchTerm, Integer adminId) {
        List<Room> rooms = new ArrayList<>();
        String sql;
        
        if (adminId == null) {
            sql = "SELECT * FROM rooms WHERE status IN ('AVAILABLE', 'OCCUPIED') " +
                  "AND LOWER(room_name) LIKE LOWER(?) ORDER BY room_name";
        } else {
            sql = "SELECT * FROM rooms WHERE status IN ('AVAILABLE', 'OCCUPIED') " +
                  "AND managed_by_admin_id = ? AND LOWER(room_name) LIKE LOWER(?) ORDER BY room_name";
        }
        
        String searchPattern = "%" + searchTerm.trim() + "%";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (adminId == null) {
                stmt.setString(1, searchPattern);
            } else {
                stmt.setInt(1, adminId);
                stmt.setString(2, searchPattern);
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Room room = mapResultSetToRoom(rs);
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error searching rooms for tenant management by admin: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
}

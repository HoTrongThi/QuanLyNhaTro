package dao;

import model.Room;
import util.DBConnection;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp Data Access Object cho Phòng trọ
 * Xử lý tất cả các thao tác cơ sở dữ liệu cho thực thể Room
 * Bao gồm CRUD operations, kiểm tra trạng thái và validation
 * Hỗ trợ quản lý trạng thái phòng và kiểm tra lịch sử thuê
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Repository
public class RoomDAO {
    
    // ==================== CÁC PHƯƠNG THỨC CRUD CƠ BẢN ====================
    
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
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));           // ID phòng
                room.setRoomName(rs.getString("room_name"));     // Tên phòng
                room.setPrice(rs.getBigDecimal("price"));        // Giá phòng
                room.setStatus(rs.getString("status"));          // Trạng thái
                room.setDescription(rs.getString("description")); // Mô tả
                room.setAmenities(rs.getString("amenities"));    // Tiện nghi
                
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
                Room room = new Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRoomName(rs.getString("room_name"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setStatus(rs.getString("status"));
                room.setDescription(rs.getString("description"));
                room.setAmenities(rs.getString("amenities"));
                
                return room;
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
}

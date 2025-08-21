package dao;

import model.Room;
import util.DBConnection;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Room Data Access Object
 * Handles all database operations for Room entity
 */
@Repository
public class RoomDAO {
    
    /**
     * Get all rooms
     * @return List of all rooms
     */
    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms ORDER BY room_name";
        
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
                
                rooms.add(room);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all rooms: " + e.getMessage());
            e.printStackTrace();
        }
        
        return rooms;
    }
    
    /**
     * Get room by ID
     * @param roomId Room ID
     * @return Room object if found, null otherwise
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
                
                return room;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting room by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Add new room
     * @param room Room object to add
     * @return true if successful, false otherwise
     */
    public boolean addRoom(Room room) {
        String sql = "INSERT INTO rooms (room_name, price, status, description) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getRoomName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getStatus());
            stmt.setString(4, room.getDescription());
            
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
        String sql = "UPDATE rooms SET room_name = ?, price = ?, status = ?, description = ? WHERE room_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, room.getRoomName());
            stmt.setBigDecimal(2, room.getPrice());
            stmt.setString(3, room.getStatus());
            stmt.setString(4, room.getDescription());
            stmt.setInt(5, room.getRoomId());
            
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
     * Check if room can be safely deleted
     * @param roomId Room ID to check
     * @return true if room can be deleted (no active tenants and no history), false otherwise
     */
    public boolean canDeleteRoom(int roomId) {
        return !isRoomOccupied(roomId) && !hasRoomHistory(roomId);
    }
}

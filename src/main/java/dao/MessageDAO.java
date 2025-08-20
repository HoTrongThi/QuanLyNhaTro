package dao;

import model.Message;
import model.User;
import util.DBConnection;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Message Data Access Object
 * Handles all database operations for Message entity
 */
@Repository
public class MessageDAO {
    
    /**
     * Send a new message
     * @param message Message object to send
     * @return true if successful, false otherwise
     */
    public boolean sendMessage(Message message) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, content) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, message.getSenderId());
            stmt.setInt(2, message.getReceiverId());
            stmt.setString(3, message.getContent());
            
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error sending message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all messages between two users (conversation)
     * @param user1Id First user ID
     * @param user2Id Second user ID
     * @return List of messages in chronological order
     */
    public List<Message> getConversation(int user1Id, int user2Id) {
        List<Message> messages = new ArrayList<>();
        String sql = """
            SELECT m.*, 
                   sender.full_name as sender_name, sender.role as sender_role,
                   receiver.full_name as receiver_name, receiver.role as receiver_role
            FROM messages m
            JOIN users sender ON m.sender_id = sender.user_id
            JOIN users receiver ON m.receiver_id = receiver.user_id
            WHERE (m.sender_id = ? AND m.receiver_id = ?) 
               OR (m.sender_id = ? AND m.receiver_id = ?)
            ORDER BY m.created_at ASC
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, user1Id);
            stmt.setInt(2, user2Id);
            stmt.setInt(3, user2Id);
            stmt.setInt(4, user1Id);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Message message = new Message();
                message.setMessageId(rs.getInt("message_id"));
                message.setSenderId(rs.getInt("sender_id"));
                message.setReceiverId(rs.getInt("receiver_id"));
                message.setContent(rs.getString("content"));
                message.setCreatedAt(rs.getTimestamp("created_at"));
                message.setStatus(rs.getString("status"));
                message.setSenderName(rs.getString("sender_name"));
                message.setReceiverName(rs.getString("receiver_name"));
                message.setSenderRole(rs.getString("sender_role"));
                message.setReceiverRole(rs.getString("receiver_role"));
                
                messages.add(message);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting conversation: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
    
    /**
     * Get all messages received by a user
     * @param userId User ID
     * @return List of received messages with sender info
     */
    public List<Message> getReceivedMessages(int userId) {
        List<Message> messages = new ArrayList<>();
        String sql = """
            SELECT m.*, 
                   sender.full_name as sender_name, sender.role as sender_role,
                   receiver.full_name as receiver_name, receiver.role as receiver_role
            FROM messages m
            JOIN users sender ON m.sender_id = sender.user_id
            JOIN users receiver ON m.receiver_id = receiver.user_id
            WHERE m.receiver_id = ?
            ORDER BY m.created_at DESC
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Message message = mapResultSetToMessage(rs);
                messages.add(message);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting received messages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
    
    /**
     * Get all messages sent by a user
     * @param userId User ID
     * @return List of sent messages with receiver info
     */
    public List<Message> getSentMessages(int userId) {
        List<Message> messages = new ArrayList<>();
        String sql = """
            SELECT m.*, 
                   sender.full_name as sender_name, sender.role as sender_role,
                   receiver.full_name as receiver_name, receiver.role as receiver_role
            FROM messages m
            JOIN users sender ON m.sender_id = sender.user_id
            JOIN users receiver ON m.receiver_id = receiver.user_id
            WHERE m.sender_id = ?
            ORDER BY m.created_at DESC
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Message message = mapResultSetToMessage(rs);
                messages.add(message);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting sent messages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
    
    /**
     * Mark a message as read
     * @param messageId Message ID
     * @return true if successful, false otherwise
     */
    public boolean markAsRead(int messageId) {
        String sql = "UPDATE messages SET status = 'read' WHERE message_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, messageId);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error marking message as read: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Mark all messages from a specific sender as read
     * @param receiverId Receiver ID
     * @param senderId Sender ID
     * @return true if successful, false otherwise
     */
    public boolean markConversationAsRead(int receiverId, int senderId) {
        String sql = "UPDATE messages SET status = 'read' WHERE receiver_id = ? AND sender_id = ? AND status = 'UNREAD'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, receiverId);
            stmt.setInt(2, senderId);
            int result = stmt.executeUpdate();
            return result >= 0; // Returns true even if no rows updated
            
        } catch (SQLException e) {
            System.err.println("Error marking conversation as read: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get count of unread messages for a user
     * @param userId User ID
     * @return Number of unread messages
     */
    public int getUnreadMessageCount(int userId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND status = 'UNREAD'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting unread message count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get list of users who have sent messages to the current user (for admin inbox)
     * @param userId Current user ID
     * @return List of users with last message info
     */
    public List<User> getMessageContacts(int userId) {
        List<User> contacts = new ArrayList<>();
        String sql = """
            SELECT DISTINCT u.user_id, u.username, u.full_name, u.role,
                   (SELECT COUNT(*) FROM messages WHERE sender_id = u.user_id AND receiver_id = ? AND status = 'UNREAD') as unread_count,
                   (SELECT content FROM messages WHERE (sender_id = u.user_id AND receiver_id = ?) OR (sender_id = ? AND receiver_id = u.user_id) ORDER BY created_at DESC LIMIT 1) as last_message,
                   (SELECT created_at FROM messages WHERE (sender_id = u.user_id AND receiver_id = ?) OR (sender_id = ? AND receiver_id = u.user_id) ORDER BY created_at DESC LIMIT 1) as last_message_time
            FROM users u
            WHERE u.user_id != ? 
            AND (
                u.user_id IN (SELECT DISTINCT sender_id FROM messages WHERE receiver_id = ?)
                OR u.user_id IN (SELECT DISTINCT receiver_id FROM messages WHERE sender_id = ?)
            )
            ORDER BY last_message_time DESC
            """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, userId);
            stmt.setInt(4, userId);
            stmt.setInt(5, userId);
            stmt.setInt(6, userId);
            stmt.setInt(7, userId);
            stmt.setInt(8, userId);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                User contact = new User();
                contact.setUserId(rs.getInt("user_id"));
                contact.setUsername(rs.getString("username"));
                contact.setFullName(rs.getString("full_name"));
                contact.setRole(rs.getString("role"));
                
                // Set message-related properties
                int unreadCount = rs.getInt("unread_count");
                contact.setHasUnreadMessages(unreadCount > 0);
                contact.setLastMessage(rs.getString("last_message"));
                contact.setLastMessageTime(rs.getTimestamp("last_message_time"));
                
                contacts.add(contact);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting message contacts: " + e.getMessage());
            e.printStackTrace();
        }
        
        return contacts;
    }
    
    /**
     * Get all admin users (for user to send messages to)
     * @return List of admin users
     */
    public List<User> getAllAdmins() {
        List<User> admins = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, role FROM users WHERE role = 'ADMIN' ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                User admin = new User();
                admin.setUserId(rs.getInt("user_id"));
                admin.setUsername(rs.getString("username"));
                admin.setFullName(rs.getString("full_name"));
                admin.setRole(rs.getString("role"));
                
                admins.add(admin);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all admins: " + e.getMessage());
            e.printStackTrace();
        }
        
        return admins;
    }
    
    /**
     * Get all users (for admin to send messages to)
     * @return List of all users
     */
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, username, full_name, role, email, phone FROM users WHERE role = 'USER' ORDER BY full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setRole(rs.getString("role"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                
                users.add(user);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all users: " + e.getMessage());
            e.printStackTrace();
        }
        
        return users;
    }
    
    /**
     * Delete a message (soft delete by setting status)
     * @param messageId Message ID
     * @return true if successful, false otherwise
     */
    public boolean deleteMessage(int messageId) {
        String sql = "DELETE FROM messages WHERE message_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, messageId);
            int result = stmt.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Helper method to map ResultSet to Message object
     */
    private Message mapResultSetToMessage(ResultSet rs) throws SQLException {
        Message message = new Message();
        message.setMessageId(rs.getInt("message_id"));
        message.setSenderId(rs.getInt("sender_id"));
        message.setReceiverId(rs.getInt("receiver_id"));
        message.setContent(rs.getString("content"));
        message.setCreatedAt(rs.getTimestamp("created_at"));
        message.setStatus(rs.getString("status"));
        message.setSenderName(rs.getString("sender_name"));
        message.setReceiverName(rs.getString("receiver_name"));
        message.setSenderRole(rs.getString("sender_role"));
        message.setReceiverRole(rs.getString("receiver_role"));
        
        return message;
    }
}

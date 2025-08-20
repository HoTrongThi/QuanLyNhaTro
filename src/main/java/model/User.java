package model;

import java.sql.Timestamp;

/**
 * User Model Class
 * Represents the users table in the database
 */
public class User {
    private int userId;
    private String username;
    private String password;
    private String fullName;
    private String phone;
    private String email;
    private String address;
    private String role; // ADMIN or USER
    private Timestamp createdAt;
    
    // Message-related properties (for contact list)
    private boolean hasUnreadMessages;
    private String lastMessage;
    private Timestamp lastMessageTime;
    
    // Default constructor
    public User() {}
    
    // Constructor for login
    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    // Constructor for registration
    public User(String username, String password, String fullName, String phone, String email, String address, String role) {
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.role = role;
    }
    
    // Full constructor
    public User(int userId, String username, String password, String fullName, String phone, String email, String address, String role, Timestamp createdAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.role = role;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    // Check if user is admin
    public boolean isAdmin() {
        return "ADMIN".equals(this.role);
    }
    
    // Check if user is regular user
    public boolean isUser() {
        return "USER".equals(this.role);
    }
    
    // Message-related getters and setters
    public boolean hasUnreadMessages() {
        return hasUnreadMessages;
    }
    
    public boolean getHasUnreadMessages() {
        return hasUnreadMessages;
    }
    
    public void setHasUnreadMessages(boolean hasUnreadMessages) {
        this.hasUnreadMessages = hasUnreadMessages;
    }
    
    public String getLastMessage() {
        return lastMessage;
    }
    
    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }
    
    public Timestamp getLastMessageTime() {
        return lastMessageTime;
    }
    
    public void setLastMessageTime(Timestamp lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", email='" + email + '\'' +
                ", address='" + address + '\'' +
                ", role='" + role + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}

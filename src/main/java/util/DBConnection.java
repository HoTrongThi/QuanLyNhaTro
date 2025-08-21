package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.springframework.stereotype.Component;

/**
 * Database Connection Utility Class
 * Quản lý kết nối cơ sở dữ liệu MySQL cho ứng dụng quản lý phòng trọ
 */
@Component
public class DBConnection {
    
    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/quan_ly_phong_tro";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "";
    
    // Database driver
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    static {
        try {
            // Load MySQL JDBC Driver
            Class.forName(DB_DRIVER);
            // MySQL JDBC Driver loaded successfully
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new RuntimeException("Failed to load MySQL JDBC Driver", e);
        }
    }
    
    /**
     * Get database connection
     * @return Connection object
     * @throws SQLException if connection fails
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            // Database connection established successfully
            return connection;
        } catch (SQLException e) {
            System.err.println("Failed to connect to database: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Close database connection safely
     * @param connection Connection to close
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                // Database connection closed successfully
            } catch (SQLException e) {
                System.err.println("Error closing database connection: " + e.getMessage());
            }
        }
    }
}

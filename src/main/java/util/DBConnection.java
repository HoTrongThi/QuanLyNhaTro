package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.springframework.stereotype.Component;

/**
 * Lớp tiện ích quản lý kết nối cơ sở dữ liệu
 * Cung cấp các phương thức để kết nối và đóng kết nối MySQL
 * Sử dụng pattern Singleton để quản lý kết nối hiệu quả
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Component
public class DBConnection {
    
    // ==================== CÁC THAM SỐ KẾT NỐI CƠ Sở DỮ LIỆU ====================
    
    /** Đường dẫn kết nối đến cơ sở dữ liệu MySQL */
    private static final String DB_URL = "jdbc:mysql://localhost:3306/quan_ly_phong_tro";
    
    /** Tên đăng nhập cơ sở dữ liệu */
    private static final String DB_USERNAME = "root";
    
    /** Mật khẩu cơ sở dữ liệu */
    private static final String DB_PASSWORD = "";
    
    /** Tên driver JDBC cho MySQL */
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // ==================== KHỐI TẠO DRIVER ====================
    
    /**
     * Khối static để tải MySQL JDBC Driver khi lớp được load
     * Đảm bảo driver được tải trước khi sử dụng
     */
    static {
        try {
            // Tải MySQL JDBC Driver
            Class.forName(DB_DRIVER);
            System.out.println("MySQL JDBC Driver đã được tải thành công!");
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy MySQL JDBC Driver!");
            e.printStackTrace();
            throw new RuntimeException("Không thể tải MySQL JDBC Driver", e);
        }
    }
    
    // ==================== CÁC PHƯƠNG THỨC CÔNG KHAI ====================
    
    /**
     * Lấy kết nối đến cơ sở dữ liệu
     * Tạo một kết nối mới đến MySQL database
     * 
     * @return đối tượng Connection để thực hiện các thao tác database
     * @throws SQLException nếu kết nối thất bại
     */
    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            System.out.println("Kết nối cơ sở dữ liệu thành công!");
            return connection;
        } catch (SQLException e) {
            System.err.println("Kết nối cơ sở dữ liệu thất bại: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Đóng kết nối cơ sở dữ liệu một cách an toàn
     * Kiểm tra và đóng kết nối nếu nó không null
     * Xử lý ngoại lệ nếu có lỗi khi đóng kết nối
     * 
     * @param connection kết nối cần đóng
     */
    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Kết nối cơ sở dữ liệu đã được đóng thành công!");
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng kết nối cơ sở dữ liệu: " + e.getMessage());
            }
        }
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra kết nối cơ sở dữ liệu có hoạt động hay không
     * 
     * @return true nếu kết nối thành công, false nếu thất bại
     */
    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            System.err.println("Kiểm tra kết nối thất bại: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Lấy thông tin cấu hình cơ sở dữ liệu
     * 
     * @return chuỗi chứa thông tin cấu hình
     */
    public static String getDatabaseInfo() {
        return String.format("Database URL: %s | Username: %s | Driver: %s", 
                           DB_URL, DB_USERNAME, DB_DRIVER);
    }
}

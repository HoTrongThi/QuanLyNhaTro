package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.springframework.stereotype.Component;

/**
 * Lớp tiện ích quản lý kết nối cơ sở dữ liệu
 * Hỗ trợ cả local development và Railway production
 * Sử dụng environment variables cho Railway
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 2.0 - Railway compatible
 * @since 2025
 */
@Component
public class DBConnection {
    
    // ==================== CÁC THAM SỐ KẾT NỐI CƠ SỞ DỮ LIỆU ====================
    
    /** Đường dẫn kết nối đến cơ sở dữ liệu */
    private static final String DB_URL = getDbUrl();
    
    /** Tên đăng nhập cơ sở dữ liệu */
    private static final String DB_USERNAME = getDbUsername();
    
    /** Mật khẩu cơ sở dữ liệu */
    private static final String DB_PASSWORD = getDbPassword();
    
    /** Tên driver JDBC cho MySQL */
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // ==================== CÁC PHƯƠNG THỨC CẤU HÌNH ====================
    
    /**
     * Lấy database URL từ environment variable hoặc default local
     */
    private static String getDbUrl() {
        // Railway tự động set MYSQL_PUBLIC_URL
        String railwayUrl = System.getenv("MYSQL_PUBLIC_URL");
        if (railwayUrl != null && !railwayUrl.isEmpty()) {
            // Convert mysql:// to jdbc:mysql://
            String jdbcUrl = railwayUrl.replace("mysql://", "jdbc:mysql://");
            // Add parameters
            if (!jdbcUrl.contains("?")) {
                jdbcUrl += "?useSSL=true&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&useUnicode=true";
            }
            return jdbcUrl;
        }
        
        // Fallback cho local development
        return "jdbc:mysql://mysql:3306/quan_ly_phong_tro?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&useUnicode=true";
    }
    
    /**
     * Lấy database username từ environment variable hoặc default local
     */
    private static String getDbUsername() {
        String username = System.getenv("MYSQLUSER");
        if (username != null && !username.isEmpty()) {
            return username;
        }
        return "qlpt_user"; // Local default
    }
    
    /**
     * Lấy database password từ environment variable hoặc default local
     */
    private static String getDbPassword() {
        String password = System.getenv("MYSQLPASSWORD");
        if (password != null && !password.isEmpty()) {
            return password;
        }
        return "qlpt_password"; // Local default
    }
    
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
            System.out.println("Environment: " + (isRailway() ? "Railway" : "Local"));
            System.out.println("Database URL: " + maskPassword(DB_URL));
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy MySQL JDBC Driver!");
            e.printStackTrace();
            throw new RuntimeException("Không thể tải MySQL JDBC Driver", e);
        }
    }
    
    // ==================== CÁC PHƯƠNG THỨC CÔNG KHAI ====================
    
    /**
     * Lấy kết nối đến cơ sở dữ liệu
     * Hỗ trợ cả MySQL (local) và Railway (production)
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
            System.err.println("URL: " + maskPassword(DB_URL));
            System.err.println("Username: " + DB_USERNAME);
            throw e;
        }
    }
    
    /**
     * Đóng kết nối cơ sở dữ liệu một cách an toàn
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
     * Lấy thông tin cấu hình cơ sở dữ liệu (ẩn mật khẩu)
     * 
     * @return chuỗi chứa thông tin cấu hình
     */
    public static String getDatabaseInfo() {
        return String.format("Database URL: %s | Username: %s | Driver: %s", 
                           maskPassword(DB_URL), DB_USERNAME, DB_DRIVER);
    }
    
    /**
     * Kiểm tra có đang chạy trên Railway không
     * 
     * @return true nếu là Railway environment
     */
    public static boolean isRailway() {
        return System.getenv("RAILWAY_ENVIRONMENT") != null || System.getenv("MYSQL_PUBLIC_URL") != null;
    }
    
    /**
     * Ẩn mật khẩu trong URL để log an toàn
     * 
     * @param url URL cần ẩn mật khẩu
     * @return URL đã ẩn mật khẩu
     */
    private static String maskPassword(String url) {
        if (url == null) return null;
        return url.replaceAll("://([^:]+):([^@]+)@", "://$1:****@");
    }
}
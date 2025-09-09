package util;

import java.net.URI;
import java.net.URISyntaxException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import org.springframework.stereotype.Component;

@Component
public class DBConnection {

    private static final String DB_URL;
    private static final String DB_USERNAME;
    private static final String DB_PASSWORD;
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";

    static {
        String envUrl = System.getenv("MYSQL_PUBLIC_URL");
        String tmpUrl = null, tmpUser = null, tmpPass = null;

        if (envUrl != null && !envUrl.isEmpty()) {
            try {
                URI uri = new URI(envUrl);

                tmpUser = uri.getUserInfo().split(":")[0];
                tmpPass = uri.getUserInfo().split(":")[1];
                String host = uri.getHost();
                int port = uri.getPort();
                String db = uri.getPath().substring(1); // bỏ dấu /

                tmpUrl = String.format(
                    "jdbc:mysql://%s:%d/%s?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&useUnicode=true",
                    host, port, db
                );

            } catch (URISyntaxException e) {
                throw new RuntimeException("Sai format MYSQL_PUBLIC_URL", e);
            }
        } else {
            // fallback local
            tmpUrl = "jdbc:mysql://localhost:3306/quan_ly_phong_tro?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8&allowPublicKeyRetrieval=true&useUnicode=true";
            tmpUser = "qlpt_user";
            tmpPass = "qlpt_password";
        }

        DB_URL = tmpUrl;
        DB_USERNAME = tmpUser;
        DB_PASSWORD = tmpPass;

        try {
            Class.forName(DB_DRIVER);
            System.out.println("MySQL JDBC Driver đã được tải!");
            System.out.println("Environment: " + (envUrl != null ? "Railway" : "Local"));
            System.out.println("Database URL: " + maskPassword(DB_URL));
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Không tìm thấy MySQL JDBC Driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Connection connection = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            System.out.println("✅ Kết nối DB thành công!");
            return connection;
        } catch (SQLException e) {
            System.err.println("❌ Kết nối DB thất bại: " + e.getMessage());
            System.err.println("URL: " + maskPassword(DB_URL));
            System.err.println("Username: " + DB_USERNAME);
            throw e;
        }
    }

    public static void closeConnection(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("🔒 Đóng kết nối DB thành công!");
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng kết nối DB: " + e.getMessage());
            }
        }
    }

    public static boolean testConnection() {
        try (Connection connection = getConnection()) {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }

    public static String getDatabaseInfo() {
        return String.format("Database URL: %s | Username: %s", maskPassword(DB_URL), DB_USERNAME);
    }

    private static String maskPassword(String url) {
        if (url == null) return null;
        return url.replaceAll("://([^:]+):([^@]+)@", "://$1:****@");
    }
}

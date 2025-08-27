# 🏠 Hệ thống Quản lý Phòng trọ

[![Java](https://img.shields.io/badge/Java-17+-orange.svg)](https://www.oracle.com/java/)
[![Spring](https://img.shields.io/badge/Spring-MVC-green.svg)](https://spring.io/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-blue.svg)](https://www.mysql.com/)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-5.3-purple.svg)](https://getbootstrap.com/)

Hệ thống quản lý phòng trọ hiện đại được xây dựng bằng Spring MVC, tích hợp thanh toán MoMo và thông báo SMS.

## ✨ Tính năng chính

### 👥 Quản lý người dùng
- ✅ Đăng ký, đăng nhập với validation
- ✅ Phân quyền Admin/User
- ✅ Quản lý thông tin cá nhân
- ✅ Hệ thống tin nhắn nội bộ

### 🏢 Quản lý phòng trọ
- ✅ CRUD phòng với validation
- ✅ Theo dõi trạng thái phòng (Trống/Đã thuê)
- ✅ Quản lý giá phòng và sức chứa
- ✅ Dashboard thống kê

### 🏠 Quản lý người thuê
- ✅ Thêm người thuê với gán dịch vụ tự động
- ✅ Tính toán prorated theo ngày ở thực tế
- ✅ Quản lý thời gian thuê và lịch sử
- ✅ Khởi tạo chỉ số công tơ tự động

### ⚡ Quản lý dịch vụ
- ✅ Quản lý dịch vụ (điện, nước, internet, v.v.)
- ✅ Theo dõi chỉ số công tơ
- ✅ Tính toán chi phí tự động
- ✅ Báo cáo sử dụng dịch vụ

### 💰 Quản lý hóa đơn
- ✅ Tạo hóa đơn tự động theo phòng
- ✅ Tính toán prorated chính xác
- ✅ Theo dõi trạng thái thanh toán
- ✅ **Tích hợp MoMo QR Code** 🔥
- ✅ **Thông báo Email tự động** 📧
- ✅ Báo cáo doanh thu chi tiết

### 💳 Thanh toán MoMo
- ✅ Tạo QR Code tự động sau khi tạo hóa đơn
- ✅ Xử lý callback và IPN
- ✅ Cập nhật trạng thái thanh toán real-time
- ✅ Tái tạo QR Code khi cần

### 📧 Thông báo Email
- ✅ Gửi Email tự động khi tạo hóa đơn
- ✅ Tích hợp Gmail SMTP
- ✅ Template email HTML đẹp mắt
- ✅ **Bao gồm mã QR MoMo động** 🔥
- ✅ Hỗ trợ gửi đến nhiều người thuê

## 🛠️ Công nghệ sử dụng

- **Backend**: Java 17 + Spring MVC
- **Database**: MySQL 8.0+
- **Frontend**: JSP + Bootstrap 5.3
- **Payment**: MoMo Sandbox API
- **Email**: Gmail SMTP
- **Build Tool**: Maven 3.6+
- **Server**: Apache Tomcat 10+

## 🚀 Cài đặt

### Yêu cầu hệ thống
- ☑️ Java 17+
- ☑️ MySQL 8.0+
- ☑️ Apache Tomcat 10+
- ☑️ Maven 3.6+
- ☑️ MoMo Sandbox Account (optional)
- ☑️ Gmail Account với App Password (optional)

### Hướng dẫn cài đặt

1. **Clone repository**
   ```bash
   git clone <repository-url>
   cd QuanLyPhongTro
   ```

2. **Tạo database**
   ```sql
   CREATE DATABASE quan_ly_phong_tro;
   ```

3. **Import database schema**
   ```bash
   mysql -u root -p quan_ly_phong_tro < database/quan_ly_phong_tro_complete.sql
   ```

4. **Cấu hình database connection**
   Chỉnh sửa file `src/main/java/util/DBConnection.java`:
   ```java
   private static final String DB_URL = "jdbc:mysql://localhost:3306/quan_ly_phong_tro";
   private static final String DB_USERNAME = "your_username";
   private static final String DB_PASSWORD = "your_password";
   ```

5. **Cấu hình MoMo (Optional)**
   Chỉnh sửa file `src/main/java/config/MoMoConfig.java`:
   ```java
   public static final String PARTNER_CODE = "your_partner_code";
   public static final String ACCESS_KEY = "your_access_key";
   public static final String SECRET_KEY = "your_secret_key";
   ```

6. **Cấu hình Gmail SMTP (Optional)**
   Chỉnh sửa file `src/main/java/config/GmailConfig.java`:
   ```java
   public static final String GMAIL_USERNAME = "your-email@gmail.com";
   public static final String GMAIL_PASSWORD = "your-app-password";
   public static final String FROM_EMAIL = "your-email@gmail.com";
   ```

7. **Build project**
   ```bash
   mvn clean compile
   ```

8. **Deploy to Tomcat**
   - Copy file WAR từ `target/` vào thư mục `webapps/` của Tomcat
   - Hoặc deploy trực tiếp từ IDE

9. **Truy cập ứng dụng**
   ```
   http://localhost:8080/QuanLyPhongTro
   ```

## 👤 Tài khoản mặc định

### Admin
- **Username**: `admin`
- **Password**: `admin123`
- **Quyền**: Quản lý toàn bộ hệ thống

### User
- **Username**: `user`
- **Password**: `user123`
- **Quyền**: Xem thông tin phòng và hóa đơn

## 📁 Cấu trúc project

```
QuanLyPhongTro/
├── src/main/java/
├── config/         # Configuration Classes
│   ├── MoMoConfig.java
│   └── GmailConfig.java
│   ├── controller/     # Spring MVC Controllers
│   │   ├── BillController.java
│   │   ├── MoMoPaymentController.java
│   │   └── ...
│   ├── dao/           # Data Access Objects
│   │   ├── MoMoDAO.java
│   │   ├── GmailDAO.java
│   │   └── ...
│   ├── model/         # Entity Models
│   │   ├── MoMoRequest.java
│   │   ├── EmailRequest.java
│   │   ├── EmailResponse.java
│   │   └── ...
│   └── util/          # Utility Classes
├── src/main/webapp/
│   ├── WEB-INF/views/ # JSP Views
│   └── resources/     # Static Resources
├── database/          # SQL Scripts
│   ├── quan_ly_phong_tro.sql
│   └── quan_ly_phong_tro_complete.sql
├── MOMO_INTEGRATION_GUIDE.md
└── pom.xml           # Maven Configuration
```

## 🔗 API Endpoints

### Authentication
- `GET /login` - Trang đăng nhập
- `POST /login` - Xử lý đăng nhập
- `GET /register` - Trang đăng ký
- `POST /register` - Xử lý đăng ký
- `GET /logout` - Đăng xuất

### Admin
- `GET /admin/dashboard` - Dashboard admin
- `GET /admin/rooms` - Quản lý phòng
- `GET /admin/tenants` - Quản lý người thuê
- `GET /admin/services` - Quản lý dịch vụ
- `GET /admin/bills` - Quản lý hóa đơn
- `GET /admin/bills/generate` - Tạo hóa đơn

### User
- `GET /user/dashboard` - Dashboard user
- `GET /user/room` - Thông tin phòng
- `GET /user/invoices` - Hóa đơn của tôi
- `GET /user/payments` - Lịch sử thanh toán

### MoMo Payment
- `GET /payment/momo/return` - Xử lý return từ MoMo
- `POST /payment/momo/notify` - Xử lý IPN từ MoMo
- `POST /payment/momo/regenerate-qr/{invoiceId}` - Tạo QR mới

## 🎯 Tính năng nổi bật

### 💰 Tính toán Prorated chính xác
- Tự động tính tiền phòng theo ngày ở thực tế
- Hỗ trợ tenant chuyển vào giữa tháng
- Tránh sai số làm tròn

### 📧 Thông báo Email tự động
- Template email HTML đẹp mắt với thông tin chi tiết
- Hiển thị thông tin phòng, kỳ thanh toán và số tiền
- **Tích hợp mã QR MoMo động** - Quét để thanh toán ngay
- Gửi tự động đến tất cả người thuê trong phòng
- Hỗ trợ hiển thị tiếng Việt

### 💳 MoMo QR Code
- Tự động tạo QR sau khi tạo hóa đơn
- Cập nhật trạng thái thanh toán real-time
- Hỗ trợ tái tạo QR khi cần

### 📊 Dashboard thống kê
- Doanh thu theo tháng/năm
- Tỷ lệ lấp đầy phòng
- Top dịch vụ được sử dụng
- Báo cáo chi tiết

## 🔧 Cấu hình Production

### MoMo Production
1. Đăng ký tài khoản MoMo Business
2. Cập nhật credentials trong `MoMoConfig.java`
3. Thay đổi endpoint từ sandbox sang production
4. Cấu hình domain thực tế cho callback URLs

### Gmail SMTP Production
1. Tạo Gmail App Password
2. Cập nhật thông tin đăng nhập trong GmailConfig.java
3. Kiểm tra cấu hình SMTP
4. Test với email thực

### Security
- Sử dụng HTTPS cho production
- Bảo mật database credentials
- Validate tất cả input
- Implement rate limiting

## 🐛 Troubleshooting

### Database Connection
```bash
# Kiểm tra MySQL service
sudo systemctl status mysql

# Kiểm tra port
netstat -tlnp | grep :3306
```

### MoMo Integration
- Kiểm tra credentials
- Verify callback URLs accessible
- Check signature validation

### Email Integration
- Kiểm tra Gmail App Password
- Xác nhận địa chỉ email hợp lệ
- Test với các nhà cung cấp email khác nhau

## 📈 Roadmap

- [ ] Mobile app (React Native)
- [ ] Email notifications
- [ ] Advanced reporting
- [ ] Multi-language support
- [ ] API documentation (Swagger)
- [ ] Docker containerization

## 🤝 Đóng góp

1. Fork repository
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📄 License

Project này được phân phối dưới MIT License. Xem file `LICENSE` để biết thêm chi tiết.

## 📞 Liên hệ

Nếu có bất kỳ câu hỏi nào, vui lòng liên hệ:
- 📧 Email: your.email@example.com
- 🐙 GitHub: [your-username](https://github.com/your-username)
- 💬 Issues: [GitHub Issues](https://github.com/your-username/QuanLyPhongTro/issues)

---

⭐ **Nếu project này hữu ích, hãy cho một star nhé!** ⭐
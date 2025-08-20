# Hệ Thống Quản Lý Phòng Trọ
## Room Management System

### 📖 Mô Tả Dự Án

Hệ thống quản lý phòng trọ được xây dựng bằng Spring MVC Framework với kiến trúc Model-View-Controller, hỗ trợ quản lý toàn diện các hoạt động cho thuê phòng trọ, từ quản lý phòng, khách thuê, dịch vụ đến hóa đơn thanh toán.

### 🏗️ Kiến Trúc Hệ Thống

**Framework**: Spring MVC 5.3.30  
**Database**: MySQL/MariaDB  
**Build Tool**: Apache Maven  
**Java Version**: 17  
**Web Server**: Servlet Container (Tomcat)

### 📁 Cấu Trúc Thư Mục

```
QuanLyPhongTro/
├── database/
│   └── quan_ly_phong_tro.sql          # Script tạo cơ sở dữ liệu
├── src/main/
│   ├── java/
│   │   ├── controller/                 # Các Controller xử lý HTTP requests
│   │   │   ├── AuthController.java     # Xác thực đăng nhập/đăng xuất
│   │   │   ├── AdminController.java    # Dashboard quản trị
│   │   │   ├── RoomController.java     # CRUD phòng trọ
│   │   │   ├── TenantController.java   # Quản lý khách thuê
│   │   │   ├── ServiceController.java  # Quản lý dịch vụ
│   │   │   ├── BillController.java     # Quản lý hóa đơn
│   │   │   ├── MessageController.java  # Quản lý tin nhắn
│   │   │   ├── UserController.java     # Dashboard người dùng
│   │   │   └── ...
│   │   ├── dao/                        # Data Access Objects
│   │   │   ├── UserDAO.java           # Thao tác CSDL người dùng
│   │   │   ├── RoomDAO.java           # Thao tác CSDL phòng trọ
│   │   │   ├── TenantDAO.java         # Thao tác CSDL khách thuê
│   │   │   ├── ServiceDAO.java        # Thao tác CSDL dịch vụ
│   │   │   ├── MessageDAO.java        # Thao tác CSDL tin nhắn
│   │   │   └── ...
│   │   ├── model/                      # Entity Classes
│   │   │   ├── User.java              # Người dùng (Admin/User)
│   │   │   ├── Room.java              # Phòng trọ
│   │   │   ├── Tenant.java            # Khách thuê
│   │   │   ├── Service.java           # Dịch vụ (điện, nước, internet...)
│   │   │   ├── Invoice.java           # Hóa đơn
│   │   │   ├── Message.java           # Tin nhắn
│   │   │   └── ...
│   │   └── util/
│   │       └── DBConnection.java       # Kết nối cơ sở dữ liệu
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── web.xml                # Cấu hình Servlet
│       │   ├── dispatcher-servlet.xml  # Cấu hình Spring MVC
│       │   └── views/                 # Thư mục JSP Views (cần tạo)
│       │       ├── auth/              # Trang xác thực
│       │       ├── admin/             # Giao diện quản trị
│       │       ├── user/              # Giao diện người dùng
│       │       ├── messages/          # Giao diện tin nhắn
│       │       └── error/             # Trang lỗi
│       ├── resources/                 # Static files (CSS, JS, Images)
│       └── index.jsp                  # Trang chủ
├── pom.xml                            # Maven dependencies
└── README.md                          # Tài liệu hướng dẫn
```

### 🗄️ Cấu Trúc Cơ Sở Dữ Liệu

#### Bảng Chính:
- **`users`** - Tài khoản người dùng (ADMIN/USER)
- **`rooms`** - Danh sách phòng trọ với giá và trạng thái
- **`tenants`** - Liên kết người dùng với phòng (hợp đồng thuê)
- **`services`** - Các dịch vụ (điện, nước, internet, vệ sinh...)
- **`service_usage`** - Lượng sử dụng dịch vụ hàng tháng của từng khách
- **`invoices`** - Hóa đơn thanh toán hàng tháng
- **`additional_costs`** - Chi phí phát sinh bổ sung
- **`messages`** - Tin nhắn giao tiếp giữa admin và user

#### Mối Quan Hệ:
- `tenants` liên kết `users` và `rooms` (Many-to-One)
- `service_usage` theo dõi việc sử dụng `services` của `tenants`
- `invoices` tự động tính toán từ giá phòng + dịch vụ + chi phí phát sinh
- `additional_costs` ghi nhận các khoản phí bổ sung cho từng khách thuê
- `messages` lưu trữ cuộc hội thoại giữa admin và các user

### ⚙️ Các Dependencies Maven

```xml
<dependencies>
    <!-- Spring MVC Framework -->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-webmvc</artifactId>
        <version>5.3.30</version>
    </dependency>
    
    <!-- Spring JDBC -->
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-jdbc</artifactId>
        <version>5.3.30</version>
    </dependency>
    
    <!-- MySQL Connector -->
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.33</version>
    </dependency>
    
    <!-- BCrypt Password Hashing -->
    <dependency>
        <groupId>org.springframework.security</groupId>
        <artifactId>spring-security-crypto</artifactId>
        <version>5.7.8</version>
    </dependency>
    
    <!-- JSON Processing -->
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
        <version>2.15.2</version>
    </dependency>
    
    <!-- JSP & JSTL Support -->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>jstl</artifactId>
        <version>1.2</version>
    </dependency>
</dependencies>
```

### 🔧 Cấu Hình Hệ Thống

#### 1. Database Connection (util/DBConnection.java)
```java
// Cấu hình kết nối MySQL
private static final String DB_URL = "jdbc:mysql://localhost:3306/quan_ly_phong_tro";
private static final String DB_USERNAME = "root";
private static final String DB_PASSWORD = "";
```

#### 2. Spring MVC Configuration
- **Component Scan**: Tự động phát hiện `@Controller`, `@Repository`, `@Service`
- **View Resolver**: JSP files trong `/WEB-INF/views/`
- **Static Resources**: Mapping cho CSS, JS, images
- **UTF-8 Encoding**: Hỗ trợ tiếng Việt đầy đủ
- **Exception Handling**: Trang lỗi tùy chỉnh 404/500

### 👥 Các Vai Trò Người Dùng

#### 🔑 ADMIN (Quản trị viên)
**Quyền hạn đầy đủ:**
- Quản lý phòng trọ (CRUD)
- Quản lý khách thuê (thêm, chuyển phòng, kết thúc hợp đồng)
- Quản lý dịch vụ (điện, nước, internet...)
- Theo dõi sử dụng dịch vụ hàng tháng
- Tạo và quản lý hóa đơn
- Ghi nhận chi phí phát sinh
- Xem báo cáo thống kê
- Quản lý tài khoản người dùng
- **✅ Quản lý tin nhắn (Hoàn thành)**

#### 👤 USER (Khách thuê)
**Quyền hạn giới hạn:**
- Xem thông tin phòng đang thuê
- Xem lịch sử hóa đơn và thanh toán
- Cập nhật thông tin cá nhân
- Xem chi tiết sử dụng dịch vụ
- **✅ Nhắn tin với quản trị viên (Hoàn thành)**

### 🚀 Hướng Dẫn Cài Đặt

#### Bước 1: Yêu Cầu Hệ Thống
- Java Development Kit (JDK) 17 trở lên
- Apache Maven 3.6+
- MySQL/MariaDB Server
- Apache Tomcat 9+ hoặc servlet container tương tự
- IDE: Eclipse/IntelliJ IDEA/VS Code (tùy chọn)

#### Bước 2: Chuẩn Bị Database
```bash
# 1. Tạo cơ sở dữ liệu
mysql -u root -p
CREATE DATABASE quan_ly_phong_tro CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

# 2. Import schema
mysql -u root -p quan_ly_phong_tro < database/quan_ly_phong_tro.sql
```

#### Bước 3: Cấu Hình Kết Nối
Chỉnh sửa file `src/main/java/util/DBConnection.java`:
```java
private static final String DB_URL = "jdbc:mysql://localhost:3306/quan_ly_phong_tro";
private static final String DB_USERNAME = "your_username";
private static final String DB_PASSWORD = "your_password";
```

#### Bước 4: Build và Deploy
```bash
# Compile project
```

#### Bước 5: Khởi Chạy
```bash
# Start Tomcat server

# Truy cập ứng dụng
http://localhost:8080/QuanLyPhongTro
```

### 📋 Chức Năng Chính

#### 🏠 Quản Lý Phòng Trọ
- **Thêm phòng mới**: Tên phòng, giá thuê, mô tả, trạng thái
- **Chỉnh sửa thông tin phòng**: Cập nhật giá, mô tả, trạng thái
- **Xóa phòng**: Chỉ được phép khi phòng chưa có người thuê
- **Tìm kiếm và lọc**: Theo tên, giá, trạng thái

#### 👥 Quản Lý Khách Thuê  
- **Đăng ký thuê phòng**: Gán người dùng vào phòng trống
- **Chuyển phòng**: Di chuyển khách sang phòng khác
- **Kết thúc hợp đồng**: Cập nhật ngày kết thúc, giải phóng phòng
- **Theo dõi lịch sử thuê**: Xem các hợp đồng cũ

#### ⚡ Quản Lý Dịch Vụ
- **Danh mục dịch vụ**: Điện, nước, internet, vệ sinh, bảo vệ...
- **Đơn vị tính**: kWh, m³, tháng, lần...
- **Giá dịch vụ**: Linh hoạt theo từng loại
- **Ghi nhận sử dụng**: Nhập số liệu hàng tháng cho từng khách

#### 💰 Quản Lý Hóa Đơn
- **Tự động tính toán**: Tiền phòng + dịch vụ + chi phí phát sinh
- **Trạng thái thanh toán**: UNPAID/PAID
- **Lịch sử hóa đơn**: Theo tháng/năm/khách thuê
- **Chi phí bổ sung**: Sửa chữa, phạt, tiện ích...

#### 💬 Hệ Thống Tin Nhắn ✅ **HOÀN THÀNH**
- **Gửi tin nhắn**: User có thể gửi tin nhắn cho admin
- **Nhận tin nhắn**: Admin nhận và phản hồi tin nhắn từ user
- **Cuộc hội thoại**: Theo dõi lịch sử trò chuyện theo thời gian thực
- **Thông báo tin mới**: Hiển thị số lượng tin nhắn chưa đọc
- **Giao diện thống nhất**: Thiết kế nhất quán với dashboard
- **Realtime updates**: Tự động cập nhật tin nhắn mới

#### 📊 Báo Cáo & Thống Kê
- **Dashboard tổng quan**: Số phòng, khách thuê, doanh thu
- **Báo cáo doanh thu**: Theo tháng, quý, năm
- **Tình hình phòng trọ**: Tỷ lệ lấp đầy, phòng trống
- **Công nợ**: Danh sách hóa đơn chưa thanh toán

### 🔐 Bảo Mật

#### Mã Hóa Mật Khẩu
- Sử dụng **BCrypt** để hash password
- Salt ngẫu nhiên cho mỗi mật khẩu
- Không lưu trữ plain text password

#### Phân Quyền Truy Cập
- **Session-based Authentication**
- **Role-based Access Control** (ADMIN/USER)
- Kiểm tra quyền truy cập ở mỗi controller method
- Redirect tự động về trang login khi chưa xác thực

#### Xử Lý Lỗi
- **Custom Error Pages**: 404, 500
- **Exception Handling**: Bắt và xử lý lỗi database
- **Input Validation**: Kiểm tra dữ liệu đầu vào

### 📱 Giao Diện Người Dùng

#### Thiết Kế Responsive
- **Bootstrap Framework** (cần tích hợp)
- Tương thích mobile và desktop
- Giao diện trực quan, dễ sử dụng

#### Tính Năng UX/UI
- **Flash Messages**: Thông báo thành công/lỗi
- **Pagination**: Phân trang cho danh sách lớn
- **Search & Filter**: Tìm kiếm và lọc dữ liệu
- **Confirmation Dialogs**: Xác nhận trước khi xóa

### 🚨 Lưu Ý Quan Trọng

#### Database Configuration
- Đảm bảo MySQL server đang chạy
- Kiểm tra charset UTF-8 để hỗ trợ tiếng Việt
- Backup database định kỳ

#### Development Environment
- Sử dụng IDE hỗ trợ Maven và Spring
- Cấu hình Tomcat integration
- Enable hot deployment cho development


---

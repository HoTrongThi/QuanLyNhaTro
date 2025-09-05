-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 05, 2025 at 09:05 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `quan_ly_phong_tro`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_admin_by_super_admin` (IN `p_super_admin_id` INT, IN `p_username` VARCHAR(50), IN `p_password` VARCHAR(255), IN `p_full_name` VARCHAR(100), IN `p_phone` VARCHAR(15), IN `p_email` VARCHAR(100), IN `p_address` VARCHAR(255), IN `p_notes` TEXT)   BEGIN
    DECLARE v_admin_id INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Tạo user admin
    INSERT INTO users (username, password, full_name, phone, email, address, role)
    VALUES (p_username, p_password, p_full_name, p_phone, p_email, p_address, 'ADMIN');
    
    SET v_admin_id = LAST_INSERT_ID();
    
    -- Gán vào admin_management
    INSERT INTO admin_management (super_admin_id, admin_id, status, notes)
    VALUES (p_super_admin_id, v_admin_id, 'ACTIVE', p_notes);
    
    -- Log hoạt động
    INSERT INTO admin_audit_log (super_admin_id, target_admin_id, action, details)
    VALUES (p_super_admin_id, v_admin_id, 'CREATE_ADMIN', 
            JSON_OBJECT('username', p_username, 'full_name', p_full_name, 'email', p_email));
    
    COMMIT;
    
    SELECT v_admin_id as new_admin_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_reset_admin_password` (IN `p_super_admin_id` INT, IN `p_admin_id` INT, IN `p_new_password` VARCHAR(255), IN `p_ip_address` VARCHAR(45))   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Cập nhật password
    UPDATE users 
    SET password = p_new_password 
    WHERE user_id = p_admin_id AND role = 'ADMIN';
    
    -- Log hoạt động
    INSERT INTO admin_audit_log (super_admin_id, target_admin_id, action, details, ip_address)
    VALUES (p_super_admin_id, p_admin_id, 'RESET_PASSWORD', 
            JSON_OBJECT('timestamp', NOW(), 'method', 'super_admin_reset'), p_ip_address);
    
    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `additional_costs`
--

CREATE TABLE `additional_costs` (
  `cost_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `description` varchar(255) NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `additional_costs`
--

INSERT INTO `additional_costs` (`cost_id`, `tenant_id`, `description`, `amount`, `date`) VALUES
(1, 1, 'Sửa chữa ống nước', 20000.00, '2025-09-04'),
(2, 2, 'Thay bóng đèn', 30000.00, '2025-09-04');

-- --------------------------------------------------------

--
-- Table structure for table `admin_audit_log`
--

CREATE TABLE `admin_audit_log` (
  `log_id` int(11) NOT NULL,
  `super_admin_id` int(11) NOT NULL COMMENT 'ID Super Admin thực hiện hành động',
  `target_admin_id` int(11) DEFAULT NULL COMMENT 'ID Admin bị tác động (null nếu là hành động tổng quát)',
  `action` enum('CREATE_ADMIN','UPDATE_ADMIN','DELETE_ADMIN','RESET_PASSWORD','SUSPEND_ADMIN','ACTIVATE_ADMIN','VIEW_ADMIN_DATA','SYSTEM_CONFIG') NOT NULL COMMENT 'Loại hành động',
  `details` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Chi tiết hành động (JSON format)' CHECK (json_valid(`details`)),
  `ip_address` varchar(45) DEFAULT NULL COMMENT 'IP address của Super Admin',
  `user_agent` text DEFAULT NULL COMMENT 'User agent của browser',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Bảng log hoạt động của Super Admin';

--
-- Dumping data for table `admin_audit_log`
--

INSERT INTO `admin_audit_log` (`log_id`, `super_admin_id`, `target_admin_id`, `action`, `details`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 10, 11, 'CREATE_ADMIN', '{\"username\":\"admin1\",\"full_name\":\"admin1\",\"email\":\"hotrongthi2709@gmail.com\"}', '0:0:0:0:0:0:0:1', NULL, '2025-09-05 06:53:32');

-- --------------------------------------------------------

--
-- Table structure for table `admin_management`
--

CREATE TABLE `admin_management` (
  `management_id` int(11) NOT NULL,
  `super_admin_id` int(11) NOT NULL COMMENT 'ID của Super Admin quản lý',
  `admin_id` int(11) NOT NULL COMMENT 'ID của Admin được quản lý',
  `assigned_date` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Ngày được gán',
  `status` enum('ACTIVE','SUSPENDED','INACTIVE') DEFAULT 'ACTIVE' COMMENT 'Trạng thái quản lý',
  `notes` text DEFAULT NULL COMMENT 'Ghi chú',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Bảng quản lý mối quan hệ Super Admin - Admin';

--
-- Dumping data for table `admin_management`
--

INSERT INTO `admin_management` (`management_id`, `super_admin_id`, `admin_id`, `assigned_date`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(3, 10, 11, '2025-09-05 06:53:32', 'ACTIVE', 'Tạo bởi Super Admin', '2025-09-05 06:53:32', '2025-09-05 06:53:32');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `invoice_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `room_price` decimal(12,2) NOT NULL,
  `service_total` decimal(12,2) NOT NULL,
  `additional_total` decimal(12,2) NOT NULL,
  `total_amount` decimal(12,2) NOT NULL,
  `status` enum('UNPAID','PAID') DEFAULT 'UNPAID',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `momo_qr_code_url` varchar(500) DEFAULT NULL COMMENT 'MoMo QR Code URL',
  `momo_order_id` varchar(100) DEFAULT NULL COMMENT 'MoMo Order ID',
  `momo_request_id` varchar(100) DEFAULT NULL COMMENT 'MoMo Request ID',
  `momo_payment_status` enum('PENDING','PAID','FAILED') DEFAULT NULL COMMENT 'MoMo Payment Status'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`invoice_id`, `tenant_id`, `month`, `year`, `room_price`, `service_total`, `additional_total`, `total_amount`, `status`, `created_at`, `momo_qr_code_url`, `momo_order_id`, `momo_request_id`, `momo_payment_status`) VALUES
(7, 1, 9, 2025, 1800000.00, 200000.00, 20000.00, 2020000.00, 'UNPAID', '2025-09-04 16:10:15', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfN18xNzU3MDAyMjE1MzU3%26v%3D3.0', 'INV_7_1757002215357', 'db06abb71e0e4645af05a5bc8faceaec', 'PENDING'),
(8, 2, 9, 2025, 4500000.00, 270000.00, 30000.00, 4800000.00, 'UNPAID', '2025-09-04 16:10:20', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfOF8xNzU3MDAyMjIwMjY0%26v%3D3.0', 'INV_8_1757002220264', 'ed9223e7c2d4481580df4a3cdac5fef4', 'PENDING'),
(11, 1, 10, 2025, 2000000.00, 200000.00, 0.00, 2200000.00, 'UNPAID', '2025-09-04 16:39:26', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfMTFfMTc1NzAwMzk2NjMxOA%26v%3D3.0', 'INV_11_1757003966318', '86c826bdd5d84fbc8b4fcb65a63378bc', 'PENDING'),
(12, 2, 10, 2025, 5000000.00, 190000.00, 0.00, 5190000.00, 'UNPAID', '2025-09-04 16:39:30', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfMTJfMTc1NzAwMzk3MDkzOQ%26v%3D3.0', 'INV_12_1757003970939', '75b8239d18bf4fc98d0fec352f3b6325', 'PENDING');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('UNREAD','READ') DEFAULT 'UNREAD'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `meter_readings`
--

CREATE TABLE `meter_readings` (
  `reading_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `reading` decimal(12,2) NOT NULL,
  `reading_date` date NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `meter_readings`
--

INSERT INTO `meter_readings` (`reading_id`, `tenant_id`, `service_id`, `reading`, `reading_date`, `month`, `year`, `created_at`) VALUES
(1, 1, 2, 1.00, '2025-09-04', 9, 2025, '2025-09-04 07:47:57'),
(2, 1, 1, 100.00, '2025-09-04', 9, 2025, '2025-09-04 07:47:57'),
(3, 2, 2, 2.00, '2025-09-04', 9, 2025, '2025-09-04 08:07:04'),
(4, 2, 1, 100.00, '2025-09-04', 9, 2025, '2025-09-04 08:07:04'),
(5, 3, 2, 2.00, '2025-09-04', 9, 2025, '2025-09-04 08:07:04'),
(6, 3, 1, 100.00, '2025-09-04', 9, 2025, '2025-09-04 08:07:04'),
(7, 1, 1, 150.00, '2025-09-04', 10, 2025, '2025-09-04 16:39:26'),
(8, 2, 1, 130.00, '2025-09-04', 10, 2025, '2025-09-04 16:39:30');

-- --------------------------------------------------------

--
-- Table structure for table `momo_payment_logs`
--

CREATE TABLE `momo_payment_logs` (
  `log_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `order_id` varchar(100) NOT NULL,
  `request_id` varchar(100) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `status` varchar(20) NOT NULL,
  `response_data` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_name` varchar(50) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `status` enum('AVAILABLE','OCCUPIED','MAINTENANCE','RESERVED','SUSPENDED','CLEANING','CONTRACT_EXPIRED') DEFAULT 'AVAILABLE',
  `description` text DEFAULT NULL,
  `amenities` text DEFAULT NULL COMMENT 'Tiện nghi phòng trọ (JSON format)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Bảng quản lý phòng trọ với thông tin tiện nghi';

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_name`, `price`, `status`, `description`, `amenities`) VALUES
(1, 'P01', 2000000.00, 'OCCUPIED', '', '[\"tv\",\"wardrobe\",\"bed\",\"washing_machine\"]'),
(2, 'P02', 5000000.00, 'OCCUPIED', '', '[\"kitchen\",\"bathroom\",\"bed\"]'),
(3, 'P03', 4000000.00, 'CLEANING', '', '[\"chair\",\"kitchen\",\"bathroom\",\"bed\",\"wardrobe\",\"washing_machine\"]'),
(4, 'P04', 3000000.00, 'AVAILABLE', '', '[\"tv\",\"chair\",\"wardrobe\",\"bed\"]'),
(5, 'P05', 4000000.00, 'RESERVED', '', '[\"fridge\",\"bed\",\"ac\",\"wardrobe\"]'),
(6, 'P06', 2000000.00, 'CONTRACT_EXPIRED', '', '[\"wardrobe\",\"bed\",\"desk\",\"washing_machine\"]'),
(7, 'P07', 3000000.00, 'MAINTENANCE', '', '[\"chair\",\"kitchen\",\"bathroom\",\"bed\"]'),
(8, 'P08', 2000000.00, 'SUSPENDED', '', '[\"bed\",\"desk\"]');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `service_id` int(11) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `service_type` enum('FREE','MONTHLY','METER_READING','PER_PERSON','PER_ROOM') NOT NULL DEFAULT 'MONTHLY',
  `calculation_config` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`calculation_config`)),
  `price_per_unit` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`service_id`, `service_name`, `unit`, `service_type`, `calculation_config`, `price_per_unit`) VALUES
(1, 'Điện sinh hoạt', 'kWh', 'MONTHLY', NULL, 3000.00),
(2, 'Nước sinh hoạt', 'người', 'MONTHLY', NULL, 30000.00),
(3, 'Gửi xe máy', 'tháng', 'MONTHLY', NULL, 20000.00),
(4, 'Internet WiFi', '', 'MONTHLY', NULL, 0.00),
(5, 'Thu rác', 'phòng', 'MONTHLY', NULL, 20000.00);

-- --------------------------------------------------------

--
-- Table structure for table `service_usage`
--

CREATE TABLE `service_usage` (
  `usage_id` int(11) NOT NULL,
  `tenant_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `quantity` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `service_usage`
--

INSERT INTO `service_usage` (`usage_id`, `tenant_id`, `service_id`, `month`, `year`, `quantity`) VALUES
(1, 1, 4, 9, 2025, 1.00),
(2, 1, 2, 9, 2025, 1.00),
(3, 1, 5, 9, 2025, 1.00),
(4, 1, 1, 9, 2025, 50.00),
(5, 2, 3, 9, 2025, 1.00),
(6, 2, 4, 9, 2025, 1.00),
(7, 2, 2, 9, 2025, 1.00),
(8, 2, 5, 9, 2025, 1.00),
(9, 2, 1, 9, 2025, 20.00),
(10, 3, 3, 9, 2025, 1.00),
(11, 3, 4, 9, 2025, 1.00),
(12, 3, 2, 9, 2025, 1.00),
(13, 3, 5, 9, 2025, 0.00),
(14, 3, 1, 9, 2025, 30.00),
(15, 1, 1, 10, 2025, 50.00),
(16, 1, 2, 10, 2025, 1.00),
(17, 1, 5, 10, 2025, 1.00),
(18, 2, 1, 10, 2025, 30.00),
(19, 2, 3, 10, 2025, 1.00),
(20, 2, 2, 10, 2025, 2.00),
(21, 2, 5, 10, 2025, 1.00);

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `tenant_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`tenant_id`, `user_id`, `room_id`, `start_date`, `end_date`) VALUES
(1, 3, 1, '2025-09-04', NULL),
(2, 4, 2, '2025-09-04', NULL),
(3, 5, 2, '2025-09-04', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `role` enum('SUPER_ADMIN','ADMIN','USER') NOT NULL DEFAULT 'USER',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `full_name`, `phone`, `email`, `address`, `role`, `created_at`) VALUES
(2, 'admin', '$2a$10$RMKuZdZWo82Jlp86UEl9lOqM.TBPzSv6FM5Pw28.jDP2RBpL7FLNS', 'thi', '42443431', 'admin@example.com', 'Bình Định', 'ADMIN', '2025-08-13 05:42:05'),
(3, 'user1', '$2a$10$PdLlvG4h9iU.MKiAFOGl0u13DiTzeR/PMbUVX6j9UmAODcwMpI0Wy', 'user1', '0971911556', 'oantai279@gmail.com', 'fdsafdfaf', 'USER', '2025-09-04 06:23:46'),
(4, 'user2', '$2a$10$vzbGOLjVb84fO71sg0/4IOCVY9u3BhGgk1LECzxBxwOccJckIHyjy', 'user2', '0971911553', 'test2@example.com', 'dfdfffdsf', 'USER', '2025-09-04 06:24:41'),
(5, 'user3', '$2a$10$ZwqWDKw/G3LAFGY0b3lgV.OrRHUDWXnxAd64Khn3Ky7IHoz/CrJeu', 'user3', '0971911552', 'test3@example.com', 'ggdgdsfgs', 'USER', '2025-09-04 06:25:12'),
(10, 'superadmin', '$2a$10$8iTIRHQGgs6jglUqMaAiqusyWaXrXXAzpdq6jWXL0GwVH7FklaUJ.', 'Super Administrator', '0999999999', 'superadmin@example.com', 'Hệ thống', 'SUPER_ADMIN', '2025-09-05 06:18:29'),
(11, 'admin1', '$2a$10$vXaNDeths5CPrnCevfCrr.RJA0yWk52YXWgerfRyPFKojvYS/3iV2', 'admin1', '0971911554', 'hotrongthi2709@gmail.com', 'fsafadfdfa', 'ADMIN', '2025-09-05 06:53:32');

-- --------------------------------------------------------

--
-- Stand-in structure for view `v_admin_management`
-- (See below for the actual view)
--
CREATE TABLE `v_admin_management` (
`management_id` int(11)
,`super_admin_id` int(11)
,`super_admin_username` varchar(50)
,`super_admin_name` varchar(100)
,`admin_id` int(11)
,`admin_username` varchar(50)
,`admin_name` varchar(100)
,`admin_email` varchar(100)
,`admin_phone` varchar(15)
,`admin_created_at` timestamp
,`assigned_date` timestamp
,`status` enum('ACTIVE','SUSPENDED','INACTIVE')
,`notes` text
,`total_rooms_managed` bigint(21)
,`total_users_managed` bigint(21)
);

-- --------------------------------------------------------

--
-- Structure for view `v_admin_management`
--
DROP TABLE IF EXISTS `v_admin_management`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_admin_management`  AS SELECT `am`.`management_id` AS `management_id`, `am`.`super_admin_id` AS `super_admin_id`, `sa`.`username` AS `super_admin_username`, `sa`.`full_name` AS `super_admin_name`, `am`.`admin_id` AS `admin_id`, `a`.`username` AS `admin_username`, `a`.`full_name` AS `admin_name`, `a`.`email` AS `admin_email`, `a`.`phone` AS `admin_phone`, `a`.`created_at` AS `admin_created_at`, `am`.`assigned_date` AS `assigned_date`, `am`.`status` AS `status`, `am`.`notes` AS `notes`, (select count(0) from `rooms` where `rooms`.`status` = 'OCCUPIED') AS `total_rooms_managed`, (select count(distinct `t`.`user_id`) from `tenants` `t` where `t`.`end_date` is null) AS `total_users_managed` FROM ((`admin_management` `am` join `users` `sa` on(`am`.`super_admin_id` = `sa`.`user_id`)) join `users` `a` on(`am`.`admin_id` = `a`.`user_id`)) WHERE `sa`.`role` = 'SUPER_ADMIN' AND `a`.`role` = 'ADMIN' ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `additional_costs`
--
ALTER TABLE `additional_costs`
  ADD PRIMARY KEY (`cost_id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `admin_audit_log`
--
ALTER TABLE `admin_audit_log`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_super_admin_action` (`super_admin_id`,`action`),
  ADD KEY `idx_target_admin` (`target_admin_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_action_date` (`action`,`created_at`),
  ADD KEY `idx_audit_log_date_action` (`created_at`,`action`);

--
-- Indexes for table `admin_management`
--
ALTER TABLE `admin_management`
  ADD PRIMARY KEY (`management_id`),
  ADD UNIQUE KEY `unique_admin_assignment` (`admin_id`),
  ADD KEY `idx_super_admin` (`super_admin_id`),
  ADD KEY `idx_admin_status` (`admin_id`,`status`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`invoice_id`),
  ADD KEY `tenant_id` (`tenant_id`),
  ADD KEY `idx_invoices_momo_order_id` (`momo_order_id`),
  ADD KEY `idx_invoices_momo_request_id` (`momo_request_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `meter_readings`
--
ALTER TABLE `meter_readings`
  ADD PRIMARY KEY (`reading_id`),
  ADD KEY `tenant_id` (`tenant_id`),
  ADD KEY `service_id` (`service_id`),
  ADD KEY `idx_tenant_service_period` (`tenant_id`,`service_id`,`month`,`year`),
  ADD KEY `idx_reading_date` (`reading_date`),
  ADD KEY `idx_period` (`year`,`month`);

--
-- Indexes for table `momo_payment_logs`
--
ALTER TABLE `momo_payment_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_momo_logs_invoice_id` (`invoice_id`),
  ADD KEY `idx_momo_logs_order_id` (`order_id`),
  ADD KEY `idx_momo_logs_status` (`status`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`service_id`);

--
-- Indexes for table `service_usage`
--
ALTER TABLE `service_usage`
  ADD PRIMARY KEY (`usage_id`),
  ADD KEY `tenant_id` (`tenant_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`tenant_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `room_id` (`room_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `idx_users_role_status` (`role`,`created_at`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `additional_costs`
--
ALTER TABLE `additional_costs`
  MODIFY `cost_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `admin_audit_log`
--
ALTER TABLE `admin_audit_log`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `admin_management`
--
ALTER TABLE `admin_management`
  MODIFY `management_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `invoice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meter_readings`
--
ALTER TABLE `meter_readings`
  MODIFY `reading_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `momo_payment_logs`
--
ALTER TABLE `momo_payment_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `service_usage`
--
ALTER TABLE `service_usage`
  MODIFY `usage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `tenant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `additional_costs`
--
ALTER TABLE `additional_costs`
  ADD CONSTRAINT `additional_costs_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`);

--
-- Constraints for table `admin_audit_log`
--
ALTER TABLE `admin_audit_log`
  ADD CONSTRAINT `admin_audit_log_ibfk_1` FOREIGN KEY (`super_admin_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `admin_audit_log_ibfk_2` FOREIGN KEY (`target_admin_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `admin_management`
--
ALTER TABLE `admin_management`
  ADD CONSTRAINT `admin_management_ibfk_1` FOREIGN KEY (`super_admin_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `admin_management_ibfk_2` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`);

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `meter_readings`
--
ALTER TABLE `meter_readings`
  ADD CONSTRAINT `meter_readings_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `meter_readings_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE;

--
-- Constraints for table `momo_payment_logs`
--
ALTER TABLE `momo_payment_logs`
  ADD CONSTRAINT `momo_payment_logs_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`invoice_id`) ON DELETE CASCADE;

--
-- Constraints for table `service_usage`
--
ALTER TABLE `service_usage`
  ADD CONSTRAINT `service_usage_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`),
  ADD CONSTRAINT `service_usage_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`);

--
-- Constraints for table `tenants`
--
ALTER TABLE `tenants`
  ADD CONSTRAINT `tenants_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `tenants_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

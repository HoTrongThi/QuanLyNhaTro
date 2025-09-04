-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 04, 2025 at 11:43 AM
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
(6, 3, 1, 100.00, '2025-09-04', 9, 2025, '2025-09-04 08:07:04');

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
  `status` enum('AVAILABLE','OCCUPIED') DEFAULT 'AVAILABLE',
  `description` text DEFAULT NULL,
  `amenities` text DEFAULT NULL COMMENT 'Tiện nghi phòng trọ (JSON format)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='Bảng quản lý phòng trọ với thông tin tiện nghi';

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_name`, `price`, `status`, `description`, `amenities`) VALUES
(1, 'P01', 2000000.00, 'OCCUPIED', '', '[\"tv\",\"wardrobe\",\"bed\",\"washing_machine\"]'),
(2, 'P02', 5000000.00, 'OCCUPIED', '', '[\"kitchen\",\"bathroom\",\"bed\"]'),
(3, 'P03', 4000000.00, 'AVAILABLE', '', '[\"chair\",\"kitchen\",\"bathroom\",\"bed\",\"wardrobe\",\"washing_machine\"]');

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
(1, 1, 4, 9, 2025, 0.00),
(2, 1, 2, 9, 2025, 0.00),
(3, 1, 5, 9, 2025, 0.00),
(4, 1, 1, 9, 2025, 0.00),
(5, 2, 3, 9, 2025, 0.00),
(6, 2, 4, 9, 2025, 0.00),
(7, 2, 2, 9, 2025, 0.00),
(8, 2, 5, 9, 2025, 0.00),
(9, 2, 1, 9, 2025, 0.00),
(10, 3, 3, 9, 2025, 0.00),
(11, 3, 4, 9, 2025, 0.00),
(12, 3, 2, 9, 2025, 0.00),
(13, 3, 5, 9, 2025, 0.00),
(14, 3, 1, 9, 2025, 0.00);

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
  `role` enum('ADMIN','USER') NOT NULL DEFAULT 'USER',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `full_name`, `phone`, `email`, `address`, `role`, `created_at`) VALUES
(2, 'admin', '$2a$10$RMKuZdZWo82Jlp86UEl9lOqM.TBPzSv6FM5Pw28.jDP2RBpL7FLNS', 'thi', '42443431', 'admin@example.com', 'Bình Định', 'ADMIN', '2025-08-13 05:42:05'),
(3, 'user1', '$2a$10$PdLlvG4h9iU.MKiAFOGl0u13DiTzeR/PMbUVX6j9UmAODcwMpI0Wy', 'user1', '0971911556', 'oantai279@gmail.com', 'fdsafdfaf', 'USER', '2025-09-04 06:23:46'),
(4, 'user2', '$2a$10$vzbGOLjVb84fO71sg0/4IOCVY9u3BhGgk1LECzxBxwOccJckIHyjy', 'user2', '0971911553', 'test2@example.com', 'dfdfffdsf', 'USER', '2025-09-04 06:24:41'),
(5, 'user3', '$2a$10$ZwqWDKw/G3LAFGY0b3lgV.OrRHUDWXnxAd64Khn3Ky7IHoz/CrJeu', 'user3', '0971911552', 'test3@example.com', 'ggdgdsfgs', 'USER', '2025-09-04 06:25:12');

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
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `additional_costs`
--
ALTER TABLE `additional_costs`
  MODIFY `cost_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `invoice_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meter_readings`
--
ALTER TABLE `meter_readings`
  MODIFY `reading_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `momo_payment_logs`
--
ALTER TABLE `momo_payment_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `service_usage`
--
ALTER TABLE `service_usage`
  MODIFY `usage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `tenant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `additional_costs`
--
ALTER TABLE `additional_costs`
  ADD CONSTRAINT `additional_costs_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`);

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

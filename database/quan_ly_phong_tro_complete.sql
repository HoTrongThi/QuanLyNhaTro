-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 13, 2025 at 05:41 PM (Updated with meter_readings table)
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
(1, 8, 'Sửa bóng đèn', 50000.00, '2025-08-13'),
(2, 9, 'Chi phí bảo trì', 100000.00, '2025-08-13');

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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
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
  `status` enum('UNREAD','read') DEFAULT 'UNREAD'
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

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_name` varchar(50) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  `status` enum('AVAILABLE','OCCUPIED') DEFAULT 'AVAILABLE',
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_name`, `price`, `status`, `description`) VALUES
(1, 'P01', 3000000.00, 'OCCUPIED', ''),
(3, 'P02', 2000000.00, 'OCCUPIED', 'Không có'),
(4, 'P03', 3000000.00, 'OCCUPIED', ''),
(5, 'P04', 5000000.00, 'OCCUPIED', '');

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `service_id` int(11) NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `price_per_unit` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`service_id`, `service_name`, `unit`, `price_per_unit`) VALUES
(1, 'Điện', 'kWh', 4000.00),
(3, 'Internet', 'tháng', 30000.00),
(4, 'Nước', 'm³', 5000.00);

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
(8, 1, 4, '2025-08-13', NULL),
(9, 3, 4, '2025-08-13', NULL);

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
(1, 'thi', '$2a$10$Qe5RtPqRBXDy.hMwGK9bVe3CdNkZm99LojgIy30O1S1yqBqjsyS.m', 'Hồ Trọng Thi', '0971911559', 'hotrongthi2709@gmail.com', 'Bình Định', 'USER', '2025-08-13 05:30:28'),
(2, 'admin', '$2a$10$RMKuZdZWo82Jlp86UEl9lOqM.TBPzSv6FM5Pw28.jDP2RBpL7FLNS', 'thi', '42443431', 'admin@example.com', 'Bình Định', 'ADMIN', '2025-08-13 05:42:05'),
(3, 'tan', '$2a$10$cUQIyY26eooXrtcXKPsbkeqtWJhasAUDR78cCBMiJ6e33iTB8k5Cm', 'Đặng Văn Tân', '0424434312', 'tan@gmail.com', 'Bình Định', 'USER', '2025-08-13 08:13:05'),
(4, 'nhat', '$2a$10$.fNsVSyOym4nnEYj86mq9.MbH/Od9iV/G9YlxUDv1D/ygZjwHfnli', 'Lê Đình Nhật', '0947248279', 'nhat@gmail.com', 'Bình Định', 'ADMIN', '2025-08-13 08:14:16'),
(6, 'thuy', '$2a$10$e4m1P8DAQ34r/XQAvb8JVOYtyI4GwT1TL.slLg6UypP7287mrw3NW', 'Nguyễn Thị Thúy', '09472847562', 'thuy@gmail.com', 'Bình Định', 'USER', '2025-08-13 14:43:57'),
(7, 'ngan', '$2a$10$dBZZ74lBxxB2PkzHFk2LA.x2fRpsUM1imqfrvZ35jxAElmFolHinq', 'Ngô Thị Kim Ngân', '0394726492', 'ngan@gmail.com', 'Quy Nhơn', 'USER', '2025-08-13 14:44:49');

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
  ADD KEY `tenant_id` (`tenant_id`);

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
  ADD KEY `idx_tenant_service_period` (`tenant_id`, `service_id`, `month`, `year`),
  ADD KEY `idx_reading_date` (`reading_date`),
  ADD KEY `idx_period` (`year`, `month`);

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
  MODIFY `invoice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `meter_readings`
--
ALTER TABLE `meter_readings`
  MODIFY `reading_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `service_usage`
--
ALTER TABLE `service_usage`
  MODIFY `usage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `tenant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `additional_costs`
--
ALTER TABLE `additional_costs`
  ADD CONSTRAINT `additional_costs_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE;

--
-- Constraints for table `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE;

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
-- Constraints for table `service_usage`
--
ALTER TABLE `service_usage`
  ADD CONSTRAINT `service_usage_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `service_usage_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE;

--
-- Constraints for table `tenants`
--
ALTER TABLE `tenants`
  ADD CONSTRAINT `tenants_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tenants_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`) ON DELETE CASCADE;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
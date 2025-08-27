-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 27, 2025 at 06:49 AM
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
(4, 11, 'Sửa quạt', 200000.00, '2025-08-19'),
(6, 21, 'mua thịt chó', 500000.00, '2025-08-19'),
(7, 22, 'Sửa quạt trần', 100000.00, '2025-08-20'),
(8, 20, 'Mua bimbim', 50000.00, '2025-08-20');

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
(40, 24, 9, 2025, 3000000.00, 330000.00, 0.00, 3330000.00, 'PAID', '2025-08-20 13:48:02', NULL, NULL, NULL, NULL),
(43, 28, 8, 2025, 1161290.28, 510000.00, 0.00, 1671290.28, 'PAID', '2025-08-20 15:03:15', NULL, NULL, NULL, NULL),
(44, 30, 8, 2025, 1161290.28, 31780000.00, 0.00, 32941290.28, 'PAID', '2025-08-20 16:05:50', NULL, NULL, NULL, NULL),
(45, 30, 9, 2025, 3000000.00, 480000.00, 0.00, 3480000.00, 'PAID', '2025-08-20 16:06:52', NULL, NULL, NULL, NULL),
(46, 28, 9, 2025, 3000000.00, 510000.00, 0.00, 3510000.00, 'PAID', '2025-08-20 17:50:15', NULL, NULL, NULL, NULL),
(47, 28, 10, 2025, 2999999.89, 510000.00, 0.00, 3509999.89, 'PAID', '2025-08-20 17:56:36', NULL, NULL, NULL, NULL),
(48, 28, 11, 2025, 3000000.00, 510000.00, 0.00, 3510000.00, 'PAID', '2025-08-20 18:08:14', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNDhfMTc1NTcxMzI5NDUxOA%26v%3D3.0', 'INV_48_1755713294518', '49f9230aa66f44559a4aa16355f9ec0a', 'PENDING'),
(49, 28, 12, 2025, 2999999.89, 510000.00, 0.00, 3509999.89, 'PAID', '2025-08-21 03:53:23', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNDlfMTc1NTc0ODQwMzUwNw%26v%3D3.0', 'INV_49_1755748403507', 'a9681814b88443948149e201c0d2a2eb', 'PENDING'),
(50, 28, 1, 2026, 3000000.00, 510000.00, 0.00, 3510000.00, 'UNPAID', '2025-08-21 04:04:03', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTBfMTc1NTc0OTA0MzgwOQ%26v%3D3.0', 'INV_50_1755749043809', '87cb6dd9019a4b1bbf0c34efcfc53be0', 'PENDING'),
(51, 31, 8, 2025, 1774193.52, 1190000.00, 0.00, 2964193.52, 'PAID', '2025-08-21 14:40:43', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTFfMTc1NTc4NzI0MzQ1Mw%26v%3D3.0', 'INV_51_1755787243453', '4ce13eda7c694bd4a49cbf87cb79912e', 'PENDING'),
(52, 31, 9, 2025, 5000000.00, 990000.00, 0.00, 5990000.00, 'PAID', '2025-08-21 14:57:41', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTJfMTc1NTc4ODI2MTExMg%26v%3D3.0', 'INV_52_1755788261112', '776206f3c5ef46228c111b10176f572b', 'PENDING'),
(53, 31, 10, 2025, 5000000.00, 480000.00, 0.00, 5480000.00, 'PAID', '2025-08-21 18:06:50', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTNfMTc1NTc5OTYxMDc4OQ%26v%3D3.0', 'INV_53_1755799610789', '20b75232d20b4959a11b98ed0c218403', 'PENDING'),
(54, 21, 10, 2025, 2000000.00, 480000.00, 0.00, 2480000.00, 'PAID', '2025-08-23 11:54:56', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTRfMTc1NTk1MDA5NjY1OQ%26v%3D3.0', 'INV_54_1755950096659', 'bcf1a6e11481416cba69a852e40fb3e3', 'PENDING'),
(55, 21, 11, 2025, 2000000.00, 780000.00, 0.00, 2780000.00, 'UNPAID', '2025-08-23 12:52:48', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTVfMTc1NTk1MzU2ODIyOQ%26v%3D3.0', 'INV_55_1755953568229', 'ade8691df0b74aa8a095196f87112a3a', 'PENDING'),
(56, 21, 12, 2025, 2000000.00, 480000.00, 0.00, 2480000.00, 'UNPAID', '2025-08-23 13:11:28', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTZfMTc1NTk1NDY4ODQ5MA%26v%3D3.0', 'INV_56_1755954688490', '5afee517e5cf46d580a111eff5004611', 'PENDING'),
(57, 31, 11, 2025, 5000000.00, 480000.00, 0.00, 5480000.00, 'UNPAID', '2025-08-27 04:37:14', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNTdfMTc1NjI2OTQzNDEyNw%26v%3D3.0', 'INV_57_1756269434127', 'b991658cadf9492b990d8a95da5f691b', 'PENDING'),
(58, 31, 12, 2025, 5000000.00, 480000.00, 0.00, 5480000.00, 'UNPAID', '2025-08-27 04:46:43', 'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=momo%3A%2F%2Fapp%3Faction%3DpayWithApp%26isScanQR%3Dtrue%26serviceType%3Dqr%26sid%3DTU9NT3xJTlZfNThfMTc1NjI3MDAwMzc2OQ%26v%3D3.0', 'INV_58_1756270003769', '4a56f28752fa4e8688fb75a310193055', 'PENDING');

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

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`message_id`, `sender_id`, `receiver_id`, `content`, `created_at`, `status`) VALUES
(1, 3, 2, 'aloo', '2025-08-13 15:53:53', 'READ'),
(2, 2, 1, 'heloooo', '2025-08-13 18:35:37', 'READ'),
(3, 1, 2, 'hi', '2025-08-13 18:36:46', 'READ'),
(4, 3, 2, 'alooo', '2025-08-13 19:00:13', 'READ'),
(5, 3, 4, 'aloooo', '2025-08-13 19:08:28', 'UNREAD'),
(6, 2, 7, 'aloooo', '2025-08-14 10:04:07', 'READ'),
(7, 7, 2, 'cak', '2025-08-14 10:05:25', 'READ');

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
(1, 6, 3, 900.00, '2025-08-19', 8, 2025, '2025-08-18 20:23:31'),
(2, 6, 4, 300.00, '2025-08-19', 8, 2025, '2025-08-18 20:23:31'),
(3, 6, 1, 700.00, '2025-08-19', 8, 2025, '2025-08-18 20:23:31'),
(5, 8, 4, 690.00, '2025-08-19', 8, 2025, '2025-08-19 11:06:23'),
(6, 18, 1, 300.00, '2025-08-19', 8, 2025, '2025-08-19 14:21:20'),
(7, 19, 1, 300.00, '2025-08-19', 8, 2025, '2025-08-19 14:27:12'),
(8, 20, 4, 150.00, '2025-08-19', 8, 2025, '2025-08-19 14:57:01'),
(9, 20, 1, 150.00, '2025-08-19', 8, 2025, '2025-08-19 14:57:01'),
(10, 21, 4, 150.00, '2025-08-19', 8, 2025, '2025-08-19 14:57:50'),
(11, 21, 1, 150.00, '2025-08-19', 8, 2025, '2025-08-19 14:57:50'),
(12, 20, 4, 170.00, '2025-08-20', 9, 2025, '2025-08-19 15:03:13'),
(13, 20, 1, 170.00, '2025-08-20', 9, 2025, '2025-08-20 06:00:49'),
(14, 22, 4, 150.00, '2025-08-20', 8, 2025, '2025-08-20 06:03:36'),
(15, 22, 1, 150.00, '2025-08-20', 8, 2025, '2025-08-20 06:03:36'),
(16, 23, 4, 150.00, '2025-08-20', 8, 2025, '2025-08-20 06:03:56'),
(17, 23, 1, 150.00, '2025-08-20', 8, 2025, '2025-08-20 06:03:56'),
(18, 22, 4, 170.00, '2025-08-20', 9, 2025, '2025-08-20 06:04:29'),
(19, 22, 1, 170.00, '2025-08-20', 9, 2025, '2025-08-20 06:04:29'),
(20, 22, 4, 200.00, '2025-08-20', 10, 2025, '2025-08-20 06:08:06'),
(21, 22, 1, 200.00, '2025-08-20', 10, 2025, '2025-08-20 06:08:06'),
(22, 22, 4, 250.00, '2025-08-20', 11, 2025, '2025-08-20 06:50:50'),
(23, 22, 1, 250.00, '2025-08-20', 11, 2025, '2025-08-20 06:50:50'),
(24, 20, 4, 200.00, '2025-08-20', 11, 2025, '2025-08-20 08:10:08'),
(25, 20, 1, 200.00, '2025-08-20', 11, 2025, '2025-08-20 08:10:08'),
(26, 24, 4, 100.00, '2025-08-20', 8, 2025, '2025-08-20 13:43:30'),
(27, 24, 1, 100.00, '2025-08-20', 8, 2025, '2025-08-20 13:43:30'),
(28, 25, 4, 100.00, '2025-08-20', 8, 2025, '2025-08-20 13:43:52'),
(29, 25, 1, 100.00, '2025-08-20', 8, 2025, '2025-08-20 13:43:52'),
(30, 24, 4, 130.00, '2025-08-20', 9, 2025, '2025-08-20 13:48:02'),
(31, 24, 1, 130.00, '2025-08-20', 9, 2025, '2025-08-20 13:48:02'),
(32, 26, 4, 250.00, '2025-08-20', 8, 2025, '2025-08-20 14:21:15'),
(33, 26, 1, 250.00, '2025-08-20', 8, 2025, '2025-08-20 14:21:15'),
(34, 27, 4, 200.00, '2025-08-20', 8, 2025, '2025-08-20 14:21:31'),
(35, 27, 1, 199.97, '2025-08-20', 8, 2025, '2025-08-20 14:21:31'),
(36, 26, 4, 300.00, '2025-08-20', 9, 2025, '2025-08-20 14:23:40'),
(37, 26, 1, 300.00, '2025-08-20', 9, 2025, '2025-08-20 14:23:41'),
(38, 28, 4, 150.00, '2025-08-20', 8, 2025, '2025-08-20 14:51:15'),
(39, 28, 1, 150.00, '2025-08-20', 8, 2025, '2025-08-20 14:51:15'),
(40, 29, 4, 100.00, '2025-08-20', 8, 2025, '2025-08-20 14:51:33'),
(41, 29, 1, 100.00, '2025-08-20', 8, 2025, '2025-08-20 14:51:33'),
(42, 30, 4, 250.00, '2025-08-20', 8, 2025, '2025-08-20 16:05:22'),
(43, 30, 1, 250.00, '2025-08-20', 8, 2025, '2025-08-20 16:05:22'),
(44, 30, 4, 300.00, '2025-08-20', 9, 2025, '2025-08-20 16:06:51'),
(45, 30, 1, 300.00, '2025-08-20', 9, 2025, '2025-08-20 16:06:52'),
(46, 28, 4, 200.00, '2025-08-21', 9, 2025, '2025-08-20 17:50:15'),
(47, 28, 1, 200.00, '2025-08-21', 9, 2025, '2025-08-20 17:50:15'),
(48, 28, 4, 250.00, '2025-08-21', 10, 2025, '2025-08-20 17:56:36'),
(49, 28, 1, 250.00, '2025-08-21', 10, 2025, '2025-08-20 17:56:36'),
(50, 28, 4, 300.00, '2025-08-21', 11, 2025, '2025-08-20 18:08:14'),
(51, 28, 1, 300.00, '2025-08-21', 11, 2025, '2025-08-20 18:08:14'),
(52, 28, 4, 350.00, '2025-08-21', 12, 2025, '2025-08-21 03:53:23'),
(53, 28, 1, 350.00, '2025-08-21', 12, 2025, '2025-08-21 03:53:23'),
(54, 28, 4, 400.00, '2025-08-21', 1, 2026, '2025-08-21 04:04:03'),
(55, 28, 1, 400.00, '2025-08-21', 1, 2026, '2025-08-21 04:04:03'),
(56, 31, 4, 150.00, '2025-08-21', 8, 2025, '2025-08-21 14:39:33'),
(57, 31, 1, 150.00, '2025-08-21', 8, 2025, '2025-08-21 14:39:33'),
(58, 31, 4, 200.00, '2025-08-21', 9, 2025, '2025-08-21 14:57:38'),
(59, 31, 1, 200.00, '2025-08-21', 9, 2025, '2025-08-21 14:57:41'),
(60, 31, 4, 250.00, '2025-08-22', 10, 2025, '2025-08-21 18:06:50'),
(61, 31, 1, 250.00, '2025-08-22', 10, 2025, '2025-08-21 18:06:50'),
(62, 21, 4, 200.00, '2025-08-23', 10, 2025, '2025-08-23 11:54:56'),
(63, 21, 1, 200.00, '2025-08-23', 10, 2025, '2025-08-23 11:54:56'),
(64, 21, 4, 250.00, '2025-08-23', 11, 2025, '2025-08-23 12:52:48'),
(65, 21, 1, 250.00, '2025-08-23', 11, 2025, '2025-08-23 12:52:48'),
(66, 21, 4, 300.00, '2025-08-23', 12, 2025, '2025-08-23 13:11:28'),
(67, 21, 1, 300.00, '2025-08-23', 12, 2025, '2025-08-23 13:11:28'),
(68, 31, 4, 300.00, '2025-08-27', 11, 2025, '2025-08-27 04:37:14'),
(69, 31, 1, 300.00, '2025-08-27', 11, 2025, '2025-08-27 04:37:14'),
(70, 31, 4, 350.00, '2025-08-27', 12, 2025, '2025-08-27 04:46:43'),
(71, 31, 1, 350.00, '2025-08-27', 12, 2025, '2025-08-27 04:46:43');

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
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_name`, `price`, `status`, `description`) VALUES
(1, 'P01', 3000000.00, 'OCCUPIED', ''),
(3, 'P02', 2000000.00, 'OCCUPIED', 'Không có'),
(4, 'P03', 3000000.00, 'OCCUPIED', ''),
(5, 'P04', 5000000.00, 'OCCUPIED', ''),
(7, 'P05', 3000000.00, 'OCCUPIED', ''),
(8, 'P06', 2000000.00, 'AVAILABLE', '');

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

--
-- Dumping data for table `service_usage`
--

INSERT INTO `service_usage` (`usage_id`, `tenant_id`, `service_id`, `month`, `year`, `quantity`) VALUES
(1, 2, 3, 8, 2025, 0.00),
(2, 2, 1, 8, 2025, 0.00),
(3, 3, 3, 8, 2025, 10.00),
(4, 3, 1, 8, 2025, 12.00),
(7, 5, 3, 8, 2025, 1.00),
(8, 5, 4, 8, 2025, 10.00),
(9, 5, 1, 8, 2025, 30.00),
(10, 6, 3, 8, 2025, 900.00),
(11, 6, 4, 8, 2025, 300.00),
(12, 6, 1, 8, 2025, 700.00),
(13, 7, 3, 8, 2025, 0.00),
(14, 7, 4, 8, 2025, 0.00),
(15, 7, 1, 8, 2025, 0.00),
(22, 8, 4, 8, 2025, 690.00),
(23, 8, 3, 8, 2025, 1.00),
(24, 10, 3, 8, 2025, 0.00),
(25, 10, 4, 8, 2025, 0.00),
(26, 10, 1, 8, 2025, 0.00),
(27, 11, 3, 8, 2025, 0.00),
(28, 11, 4, 8, 2025, 0.00),
(29, 11, 1, 8, 2025, 0.00),
(30, 12, 3, 8, 2025, 0.00),
(31, 12, 4, 8, 2025, 0.00),
(32, 12, 1, 8, 2025, 0.00),
(33, 13, 3, 8, 2025, 0.00),
(34, 13, 4, 8, 2025, 0.00),
(35, 13, 1, 8, 2025, 0.00),
(36, 14, 3, 8, 2025, 0.00),
(37, 14, 4, 8, 2025, 0.00),
(38, 14, 1, 8, 2025, 0.00),
(39, 15, 3, 8, 2025, 0.00),
(40, 15, 4, 8, 2025, 0.00),
(41, 15, 1, 8, 2025, 0.00),
(42, 16, 3, 8, 2025, 0.00),
(43, 16, 4, 8, 2025, 0.00),
(44, 16, 1, 8, 2025, 0.00),
(45, 17, 3, 8, 2025, 0.00),
(46, 17, 4, 8, 2025, 0.00),
(47, 17, 1, 8, 2025, 0.00),
(48, 18, 3, 8, 2025, 0.00),
(49, 18, 4, 8, 2025, 0.00),
(50, 18, 1, 8, 2025, 0.00),
(51, 19, 3, 8, 2025, 0.00),
(52, 19, 4, 8, 2025, 0.00),
(53, 19, 1, 8, 2025, 0.00),
(54, 20, 3, 8, 2025, 0.00),
(55, 20, 4, 8, 2025, 0.00),
(56, 20, 1, 8, 2025, 0.00),
(57, 21, 3, 8, 2025, 0.00),
(58, 21, 4, 8, 2025, 0.00),
(59, 21, 1, 8, 2025, 0.00),
(60, 20, 4, 9, 2025, 20.00),
(61, 20, 3, 9, 2025, 1.00),
(62, 20, 1, 9, 2025, 20.00),
(63, 22, 3, 8, 2025, 0.00),
(64, 22, 4, 8, 2025, 0.00),
(65, 22, 1, 8, 2025, 0.00),
(66, 23, 3, 8, 2025, 0.00),
(67, 23, 4, 8, 2025, 0.00),
(68, 23, 1, 8, 2025, 0.00),
(69, 22, 4, 9, 2025, 20.00),
(70, 22, 1, 9, 2025, 20.00),
(71, 22, 3, 9, 2025, 1.00),
(72, 22, 4, 10, 2025, 30.00),
(73, 22, 1, 10, 2025, 30.00),
(74, 22, 3, 10, 2025, 1.00),
(75, 22, 4, 11, 2025, 50.00),
(76, 22, 1, 11, 2025, 50.00),
(77, 22, 3, 11, 2025, 2.00),
(78, 20, 4, 11, 2025, 30.00),
(79, 20, 1, 11, 2025, 30.00),
(80, 20, 3, 11, 2025, 1.00),
(81, 24, 3, 8, 2025, 0.00),
(82, 24, 4, 8, 2025, 0.00),
(83, 24, 1, 8, 2025, 0.00),
(84, 25, 3, 8, 2025, 0.00),
(85, 25, 4, 8, 2025, 0.00),
(86, 25, 1, 8, 2025, 0.00),
(87, 24, 4, 9, 2025, 30.00),
(88, 24, 1, 9, 2025, 30.00),
(89, 24, 3, 9, 2025, 2.00),
(90, 26, 3, 8, 2025, 2.00),
(91, 26, 4, 8, 2025, 50.00),
(92, 26, 1, 8, 2025, 50.00),
(93, 27, 3, 8, 2025, 0.00),
(94, 27, 4, 8, 2025, 0.00),
(95, 27, 1, 8, 2025, 0.00),
(96, 26, 4, 9, 2025, 50.00),
(97, 26, 1, 9, 2025, 50.00),
(98, 26, 3, 9, 2025, 2.00),
(99, 28, 3, 8, 2025, 2.00),
(100, 28, 4, 8, 2025, 50.00),
(101, 28, 1, 8, 2025, 50.00),
(102, 29, 3, 8, 2025, 0.00),
(103, 29, 4, 8, 2025, 0.00),
(104, 29, 1, 8, 2025, 0.00),
(105, 30, 3, 8, 2025, 1.00),
(106, 30, 4, 8, 2025, 50.00),
(107, 30, 1, 8, 2025, 50.00),
(108, 30, 4, 9, 2025, 50.00),
(109, 30, 1, 9, 2025, 50.00),
(110, 30, 3, 9, 2025, 1.00),
(111, 28, 4, 9, 2025, 50.00),
(112, 28, 1, 9, 2025, 50.00),
(113, 28, 3, 9, 2025, 2.00),
(114, 28, 4, 10, 2025, 50.00),
(115, 28, 1, 10, 2025, 50.00),
(116, 28, 3, 10, 2025, 2.00),
(117, 28, 4, 11, 2025, 50.00),
(118, 28, 1, 11, 2025, 50.00),
(119, 28, 3, 11, 2025, 2.00),
(120, 28, 4, 12, 2025, 50.00),
(121, 28, 1, 12, 2025, 50.00),
(122, 28, 3, 12, 2025, 2.00),
(123, 28, 4, 1, 2026, 50.00),
(124, 28, 1, 1, 2026, 50.00),
(125, 28, 3, 1, 2026, 2.00),
(126, 31, 3, 8, 2025, 1.00),
(127, 31, 4, 8, 2025, 50.00),
(128, 31, 1, 8, 2025, 50.00),
(129, 31, 4, 9, 2025, 50.00),
(130, 31, 1, 9, 2025, 50.00),
(131, 31, 3, 9, 2025, 1.00),
(132, 31, 4, 10, 2025, 50.00),
(133, 31, 1, 10, 2025, 50.00),
(134, 31, 3, 10, 2025, 1.00),
(135, 21, 4, 10, 2025, 50.00),
(136, 21, 1, 10, 2025, 50.00),
(137, 21, 3, 10, 2025, 1.00),
(138, 21, 4, 11, 2025, 50.00),
(139, 21, 1, 11, 2025, 50.00),
(140, 21, 3, 11, 2025, 1.00),
(141, 21, 4, 12, 2025, 50.00),
(142, 21, 1, 12, 2025, 50.00),
(143, 21, 3, 12, 2025, 1.00),
(144, 31, 4, 11, 2025, 50.00),
(145, 31, 1, 11, 2025, 50.00),
(146, 31, 3, 11, 2025, 1.00),
(147, 31, 4, 12, 2025, 50.00),
(148, 31, 1, 12, 2025, 50.00),
(149, 31, 3, 12, 2025, 1.00);

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
(1, 1, 1, '2025-08-13', '2025-08-13'),
(2, 1, 1, '2025-08-13', '2025-08-18'),
(3, 3, 3, '2025-08-13', '2025-08-18'),
(4, 7, 4, '2025-08-13', '2025-08-18'),
(5, 6, 5, '2025-08-13', '2025-08-18'),
(6, 1, 1, '2025-08-18', '2025-08-19'),
(7, 3, 3, '2025-08-18', '2025-08-19'),
(8, 7, 4, '2025-08-18', '2025-08-19'),
(9, 6, 4, '2025-08-18', '2025-08-19'),
(10, 8, 1, '2025-08-19', '2025-08-20'),
(11, 9, 3, '2025-08-19', '2025-08-19'),
(12, 10, 3, '2025-08-19', '2025-08-19'),
(13, 9, 7, '2025-08-19', '2025-08-19'),
(14, 10, 7, '2025-08-19', '2025-08-19'),
(15, 7, 7, '2025-08-19', '2025-08-20'),
(16, 6, 7, '2025-08-19', '2025-08-20'),
(17, 9, 5, '2025-08-19', '2025-08-19'),
(18, 10, 5, '2025-08-19', '2025-08-20'),
(19, 9, 5, '2025-08-19', '2025-08-20'),
(20, 1, 3, '2025-08-19', '2025-08-21'),
(21, 3, 3, '2025-08-19', NULL),
(22, 7, 8, '2025-08-20', '2025-08-20'),
(23, 6, 8, '2025-08-20', '2025-08-20'),
(24, 7, 4, '2025-08-20', NULL),
(25, 6, 4, '2025-08-20', NULL),
(26, 9, 5, '2025-08-20', '2025-08-20'),
(27, 10, 5, '2025-08-20', '2025-08-20'),
(28, 9, 7, '2025-08-20', NULL),
(29, 10, 7, '2025-08-20', NULL),
(30, 8, 1, '2025-08-20', NULL),
(31, 1, 5, '2025-08-21', NULL);

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
(3, 'tan', '$2a$10$cUQIyY26eooXrtcXKPsbkeqtWJhasAUDR78cCBMiJ6e33iTB8k5Cm', 'Đặng Văn Tân', '0838671892', 'tan@gmail.com', 'Bình Định', 'USER', '2025-08-13 08:13:05'),
(4, 'nhat', '$2a$10$.fNsVSyOym4nnEYj86mq9.MbH/Od9iV/G9YlxUDv1D/ygZjwHfnli', 'Lê Đình Nhật', '0947248279', 'nhat@gmail.com', 'Bình Định', 'ADMIN', '2025-08-13 08:14:16'),
(6, 'thuy', '$2a$10$e4m1P8DAQ34r/XQAvb8JVOYtyI4GwT1TL.slLg6UypP7287mrw3NW', 'Nguyễn Thị Thúy', '09472847562', 'thuy@gmail.com', 'Bình Định', 'USER', '2025-08-13 14:43:57'),
(7, 'ngan', '$2a$10$dBZZ74lBxxB2PkzHFk2LA.x2fRpsUM1imqfrvZ35jxAElmFolHinq', 'Ngô Thị Kim Ngân', '0394726492', 'ngan@gmail.com', 'Quy Nhơn', 'USER', '2025-08-13 14:44:49'),
(8, 'test1', '$2a$10$0iDNW7Lp.i8cVKrHz1zWAecbj/ONPwiwaVsbDjIocuy22HL9W1QTC', 'test1', '0385746583', 'test1@example.com', 'Quy Nhơn', 'USER', '2025-08-19 12:15:23'),
(9, 'test2', '$2a$10$f3YggE5.SfkhO.al1kpbTuxF8H0SegRZqnm/J2nUCDkxvBMke1t0G', 'test2', '0947362746', 'test2@example.com', 'Quy Nhơn', 'USER', '2025-08-19 12:16:11'),
(10, 'test3', '$2a$10$.VMfGc0/5vZLyvOK21Rl4OXntMrHrLTwQ8uP2nL.ynyNSDLhaUHTy', 'test3', '0947364857', 'test3@example.com', 'Bình Định', 'USER', '2025-08-19 12:17:00');

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
  MODIFY `cost_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `invoice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `meter_readings`
--
ALTER TABLE `meter_readings`
  MODIFY `reading_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;

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
  MODIFY `service_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `service_usage`
--
ALTER TABLE `service_usage`
  MODIFY `usage_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=150;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `tenant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

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

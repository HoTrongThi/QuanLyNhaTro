-- SQL script to create meter_readings table
-- Run this script to add meter reading functionality to your database

-- Create meter_readings table
CREATE TABLE `meter_readings` (
  `reading_id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `reading` decimal(12,2) NOT NULL,
  `reading_date` date NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`reading_id`),
  KEY `tenant_id` (`tenant_id`),
  KEY `service_id` (`service_id`),
  KEY `idx_tenant_service_period` (`tenant_id`, `service_id`, `month`, `year`),
  CONSTRAINT `meter_readings_ibfk_1` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`tenant_id`) ON DELETE CASCADE,
  CONSTRAINT `meter_readings_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`service_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Add index for better performance
CREATE INDEX `idx_reading_date` ON `meter_readings` (`reading_date`);
CREATE INDEX `idx_period` ON `meter_readings` (`year`, `month`);

-- Note: This table will store meter readings for services like electricity and water
-- The 'reading' field stores the actual meter reading value
-- Consumption will be calculated as: current_reading - previous_reading
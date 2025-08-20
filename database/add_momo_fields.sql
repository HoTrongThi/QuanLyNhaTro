-- Add MoMo payment fields to invoices table
ALTER TABLE invoices 
ADD COLUMN momo_qr_code_url VARCHAR(500) NULL COMMENT 'MoMo QR Code URL',
ADD COLUMN momo_order_id VARCHAR(100) NULL COMMENT 'MoMo Order ID',
ADD COLUMN momo_request_id VARCHAR(100) NULL COMMENT 'MoMo Request ID',
ADD COLUMN momo_payment_status ENUM('PENDING', 'PAID', 'FAILED') NULL COMMENT 'MoMo Payment Status';

-- Add index for MoMo order lookup
CREATE INDEX idx_invoices_momo_order_id ON invoices(momo_order_id);
CREATE INDEX idx_invoices_momo_request_id ON invoices(momo_request_id);

-- Optional: Create MoMo payment logs table for tracking
CREATE TABLE IF NOT EXISTS momo_payment_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    order_id VARCHAR(100) NOT NULL,
    request_id VARCHAR(100) NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    response_data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE,
    INDEX idx_momo_logs_invoice_id (invoice_id),
    INDEX idx_momo_logs_order_id (order_id),
    INDEX idx_momo_logs_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
package dao;

import model.Invoice;
import org.springframework.stereotype.Repository;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Invoice Data Access Object
 * Handles database operations for invoices/bills
 */
@Repository
public class InvoiceDAO {
    
    /**
     * Create/Generate invoice
     */
    /**
     * Create a new invoice
     */
    public boolean createInvoice(Invoice invoice) {
        String sql = "INSERT INTO invoices (tenant_id, month, year, room_price, service_total, additional_total, total_amount, status, " +
                    "momo_qr_code_url, momo_order_id, momo_request_id, momo_payment_status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, invoice.getTenantId());
            pstmt.setInt(2, invoice.getMonth());
            pstmt.setInt(3, invoice.getYear());
            pstmt.setBigDecimal(4, invoice.getRoomPrice());
            pstmt.setBigDecimal(5, invoice.getServiceTotal());
            pstmt.setBigDecimal(6, invoice.getAdditionalTotal());
            pstmt.setBigDecimal(7, invoice.getTotalAmount());
            pstmt.setString(8, invoice.getStatus());
            pstmt.setString(9, invoice.getMomoQrCodeUrl());
            pstmt.setString(10, invoice.getMomoOrderId());
            pstmt.setString(11, invoice.getMomoRequestId());
            pstmt.setString(12, invoice.getMomoPaymentStatus());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                // Get the generated invoice ID
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    invoice.setInvoiceId(generatedKeys.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error creating invoice: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Update MoMo payment information
     */
    public boolean updateMoMoPaymentInfo(int invoiceId, String qrCodeUrl, String orderId, String requestId, String paymentStatus) {
        String sql = "UPDATE invoices SET momo_qr_code_url = ?, momo_order_id = ?, momo_request_id = ?, momo_payment_status = ? WHERE invoice_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, qrCodeUrl);
            pstmt.setString(2, orderId);
            pstmt.setString(3, requestId);
            pstmt.setString(4, paymentStatus);
            pstmt.setInt(5, invoiceId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating MoMo payment info: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update MoMo payment status only
     */
    public boolean updateMoMoPaymentStatus(String orderId, String paymentStatus) {
        String sql = "UPDATE invoices SET momo_payment_status = ? WHERE momo_order_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, paymentStatus);
            pstmt.setString(2, orderId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating MoMo payment status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update invoice status
     */
    public boolean updateInvoiceStatus(int invoiceId, String status) {
        String sql = "UPDATE invoices SET status = ? WHERE invoice_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            pstmt.setInt(2, invoiceId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating invoice status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get invoice by ID
     */
    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, i.service_total, " +
                    "i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "i.momo_qr_code_url, i.momo_order_id, i.momo_request_id, i.momo_payment_status, " +
                    "u.full_name as tenant_name, u.phone as user_phone, u.email as user_email, " +
                    "r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE i.invoice_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, invoiceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setMomoQrCodeUrl(rs.getString("momo_qr_code_url"));
                invoice.setMomoOrderId(rs.getString("momo_order_id"));
                invoice.setMomoRequestId(rs.getString("momo_request_id"));
                invoice.setMomoPaymentStatus(rs.getString("momo_payment_status"));
                invoice.setTenantName(rs.getString("tenant_name"));
                invoice.setUserPhone(rs.getString("user_phone"));
                invoice.setUserEmail(rs.getString("user_email"));
                invoice.setRoomName(rs.getString("room_name"));
                return invoice;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoice by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all invoices
     */
    public List<Invoice> getAllInvoices() {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, " +
                    "i.service_total, i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "u.full_name, u.phone, u.email, r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "ORDER BY i.year DESC, i.month DESC, r.room_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setTenantName(rs.getString("full_name"));
                invoice.setUserPhone(rs.getString("phone"));
                invoice.setUserEmail(rs.getString("email"));
                invoice.setRoomName(rs.getString("room_name"));
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all invoices: " + e.getMessage());
            e.printStackTrace();
        }
        
        return invoices;
    }
    
    /**
     * Get invoices for a specific tenant (for user view)
     */
    public List<Invoice> getInvoicesByTenant(int tenantId) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, " +
                    "i.service_total, i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "u.full_name, u.phone, u.email, r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE i.tenant_id = ? " +
                    "ORDER BY i.year DESC, i.month DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setTenantName(rs.getString("full_name"));
                invoice.setUserPhone(rs.getString("phone"));
                invoice.setUserEmail(rs.getString("email"));
                invoice.setRoomName(rs.getString("room_name"));
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoices by tenant: " + e.getMessage());
            e.printStackTrace();
        }
        
        return invoices;
    }
    
    /**
     * Get invoices by user ID (for regular users)
     */
    public List<Invoice> getInvoicesByUserId(int userId) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, " +
                    "i.service_total, i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "u.full_name, u.phone, u.email, r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.user_id = ? " +
                    "ORDER BY i.year DESC, i.month DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setTenantName(rs.getString("full_name"));
                invoice.setUserPhone(rs.getString("phone"));
                invoice.setUserEmail(rs.getString("email"));
                invoice.setRoomName(rs.getString("room_name"));
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoices by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return invoices;
    }
    
    /**
     * Delete invoice
     */
    public boolean deleteInvoice(int invoiceId) {
        String sql = "DELETE FROM invoices WHERE invoice_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, invoiceId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting invoice: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if invoice exists for tenant and period
     */
    public boolean invoiceExistsForPeriod(int tenantId, int month, int year) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE tenant_id = ? AND month = ? AND year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking invoice existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if invoice exists for room and period
     */
    public boolean invoiceExistsForRoomAndPeriod(int roomId, int month, int year) {
        String sql = "SELECT COUNT(*) FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "WHERE t.room_id = ? AND i.month = ? AND i.year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking invoice existence for room: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get total invoice count
     */
    public int getTotalInvoiceCount() {
        String sql = "SELECT COUNT(*) FROM invoices";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total invoice count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get unpaid invoice count
     */
    public int getUnpaidInvoiceCount() {
        String sql = "SELECT COUNT(*) FROM invoices WHERE status = 'UNPAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting unpaid invoice count: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get total revenue from paid invoices
     */
    public BigDecimal getTotalRevenue() {
        String sql = "SELECT SUM(total_amount) FROM invoices WHERE status = 'PAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal(1);
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting total revenue: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get revenue by month and year
     */
    public BigDecimal getRevenueByPeriod(int month, int year) {
        String sql = "SELECT SUM(total_amount) FROM invoices WHERE month = ? AND year = ? AND status = 'PAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal(1);
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting revenue by period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get revenue by year
     */
    public BigDecimal getRevenueByYear(int year) {
        String sql = "SELECT SUM(total_amount) FROM invoices WHERE year = ? AND status = 'PAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal revenue = rs.getBigDecimal(1);
                return revenue != null ? revenue : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting revenue by year: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get invoice count by period
     */
    public int getInvoiceCountByPeriod(int month, int year) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE month = ? AND year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoice count by period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get paid invoice count by period
     */
    public int getPaidInvoiceCountByPeriod(int month, int year) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE month = ? AND year = ? AND status = 'PAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting paid invoice count by period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get invoice count by year
     */
    public int getInvoiceCountByYear(int year) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoice count by year: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get paid invoice count by year
     */
    public int getPaidInvoiceCountByYear(int year) {
        String sql = "SELECT COUNT(*) FROM invoices WHERE year = ? AND status = 'PAID'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting paid invoice count by year: " + e.getMessage());
            e.printStackTrace();
        }
        
        return 0;
    }
    
    /**
     * Get limited invoices by tenant ID (for user dashboard)
     */
    public List<Invoice> getInvoicesByTenantId(int tenantId, int limit) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, " +
                    "i.service_total, i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "u.full_name, u.phone, u.email, r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE i.tenant_id = ? " +
                    "ORDER BY i.year DESC, i.month DESC " +
                    "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setTenantName(rs.getString("full_name"));
                invoice.setUserPhone(rs.getString("phone"));
                invoice.setUserEmail(rs.getString("email"));
                invoice.setRoomName(rs.getString("room_name"));
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoices by tenant ID with limit: " + e.getMessage());
            e.printStackTrace();
        }
        
        return invoices;
    }
    
    /**
     * Get recent invoices (for dashboard)
     */
    public List<Invoice> getRecentInvoices(int limit) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, " +
                    "i.service_total, i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "u.full_name, u.phone, u.email, r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "ORDER BY i.created_at DESC " +
                    "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setTenantName(rs.getString("full_name"));
                invoice.setUserPhone(rs.getString("phone"));
                invoice.setUserEmail(rs.getString("email"));
                invoice.setRoomName(rs.getString("room_name"));
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting recent invoices: " + e.getMessage());
            e.printStackTrace();
        }
        
        return invoices;
    }
    
    /**
     * Get invoices by period
     */
    public List<Invoice> getInvoicesByPeriod(int month, int year) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, " +
                    "i.service_total, i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "u.full_name, u.phone, u.email, r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE i.month = ? AND i.year = ? " +
                    "ORDER BY i.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setTenantName(rs.getString("full_name"));
                invoice.setUserPhone(rs.getString("phone"));
                invoice.setUserEmail(rs.getString("email"));
                invoice.setRoomName(rs.getString("room_name"));
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoices by period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return invoices;
    }
    
    /**
     * Get invoices by room ID (for room-based billing)
     */
    public List<Invoice> getInvoicesByRoomId(int roomId) {
        List<Invoice> invoices = new ArrayList<>();
        String sql = "SELECT i.invoice_id, i.tenant_id, i.month, i.year, i.room_price, " +
                    "i.service_total, i.additional_total, i.total_amount, i.status, i.created_at, " +
                    "u.full_name, u.phone, u.email, r.room_name " +
                    "FROM invoices i " +
                    "JOIN tenants t ON i.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.room_id = ? " +
                    "ORDER BY i.year DESC, i.month DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getInt("invoice_id"));
                invoice.setTenantId(rs.getInt("tenant_id"));
                invoice.setMonth(rs.getInt("month"));
                invoice.setYear(rs.getInt("year"));
                invoice.setRoomPrice(rs.getBigDecimal("room_price"));
                invoice.setServiceTotal(rs.getBigDecimal("service_total"));
                invoice.setAdditionalTotal(rs.getBigDecimal("additional_total"));
                invoice.setTotalAmount(rs.getBigDecimal("total_amount"));
                invoice.setStatus(rs.getString("status"));
                invoice.setCreatedAt(rs.getTimestamp("created_at"));
                invoice.setTenantName(rs.getString("full_name"));
                invoice.setUserPhone(rs.getString("phone"));
                invoice.setUserEmail(rs.getString("email"));
                invoice.setRoomName(rs.getString("room_name"));
                invoices.add(invoice);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting invoices by room ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return invoices;
    }
    
}

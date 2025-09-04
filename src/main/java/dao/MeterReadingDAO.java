package dao;

import model.MeterReading;
import org.springframework.stereotype.Repository;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp Data Access Object cho Chỉ số Công tơ
 * Xử lý tất cả các thao tác cơ sở dữ liệu cho chỉ số công tơ
 * Bao gồm ghi nhận chỉ số điện, nước và tính toán tiêu thụ
 * Hỗ trợ khởi tạo chỉ số ban đầu và theo dõi lịch sử
 * Tự động tính toán lượng tiêu thụ dựa trên chỉ số trước
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Repository
public class MeterReadingDAO {
    
    // ==================== CÁC PHƯƠNG THỨC CRUD CƠ BẢN ====================
    
    /**
     * Thêm bản ghi chỉ số công tơ
     * Ghi nhận chỉ số điện, nước của người thuê trong tháng
     * 
     * @param reading đối tượng chứa thông tin chỉ số công tơ
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean addMeterReading(MeterReading reading) {
        String sql = "INSERT INTO meter_readings (tenant_id, service_id, reading, reading_date, month, year) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reading.getTenantId());
            pstmt.setInt(2, reading.getServiceId());
            pstmt.setBigDecimal(3, reading.getReading());
            pstmt.setDate(4, reading.getReadingDate());
            pstmt.setInt(5, reading.getMonth());
            pstmt.setInt(6, reading.getYear());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding meter reading: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update meter reading record
     */
    public boolean updateMeterReading(MeterReading reading) {
        String sql = "UPDATE meter_readings SET reading = ?, reading_date = ? WHERE reading_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBigDecimal(1, reading.getReading());
            pstmt.setDate(2, reading.getReadingDate());
            pstmt.setInt(3, reading.getReadingId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating meter reading: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update meter reading by tenant, service, month, year
     * This is more reliable than using reading_id
     */
    public boolean updateMeterReadingByPeriod(int tenantId, int serviceId, int month, int year, 
                                             BigDecimal newReading, Date readingDate) {
        String sql = "UPDATE meter_readings SET reading = ?, reading_date = ? " +
                    "WHERE tenant_id = ? AND service_id = ? AND month = ? AND year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setBigDecimal(1, newReading);
            pstmt.setDate(2, readingDate);
            pstmt.setInt(3, tenantId);
            pstmt.setInt(4, serviceId);
            pstmt.setInt(5, month);
            pstmt.setInt(6, year);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating meter reading by period: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get meter reading by ID
     */
    public MeterReading getMeterReadingById(int readingId) {
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE mr.reading_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, readingId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                return reading;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting meter reading by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get latest meter reading for a tenant and service
     */
    public MeterReading getLatestMeterReading(int tenantId, int serviceId) {
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE mr.tenant_id = ? AND mr.service_id = ? " +
                    "ORDER BY mr.year DESC, mr.month DESC, mr.created_at DESC " +
                    "LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, serviceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                return reading;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting latest meter reading: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get meter reading for specific tenant, service and period
     */
    public MeterReading getMeterReadingByTenantServiceAndPeriod(int tenantId, int serviceId, int month, int year) {
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE mr.tenant_id = ? AND mr.service_id = ? AND mr.month = ? AND mr.year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, serviceId);
            pstmt.setInt(3, month);
            pstmt.setInt(4, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                return reading;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting meter reading by tenant, service and period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get previous meter reading for calculation
     */
    public MeterReading getPreviousMeterReading(int tenantId, int serviceId, int month, int year) {
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE mr.tenant_id = ? AND mr.service_id = ? " +
                    "AND (mr.year < ? OR (mr.year = ? AND mr.month < ?)) " +
                    "ORDER BY mr.year DESC, mr.month DESC, mr.created_at DESC " +
                    "LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, serviceId);
            pstmt.setInt(3, year);
            pstmt.setInt(4, year);
            pstmt.setInt(5, month);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                return reading;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting previous meter reading: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all meter readings for a tenant
     */
    public List<MeterReading> getMeterReadingsByTenant(int tenantId) {
        List<MeterReading> readings = new ArrayList<>();
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE mr.tenant_id = ? " +
                    "ORDER BY mr.year DESC, mr.month DESC, s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                readings.add(reading);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting meter readings by tenant: " + e.getMessage());
            e.printStackTrace();
        }
        
        return readings;
    }
    
    /**
     * Get all meter readings
     */
    public List<MeterReading> getAllMeterReadings() {
        List<MeterReading> readings = new ArrayList<>();
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "ORDER BY mr.year DESC, mr.month DESC, r.room_name, s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                readings.add(reading);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all meter readings: " + e.getMessage());
            e.printStackTrace();
        }
        
        return readings;
    }
    
    /**
     * Delete meter reading by ID
     */
    public boolean deleteMeterReading(int readingId) {
        String sql = "DELETE FROM meter_readings WHERE reading_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, readingId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting meter reading: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if meter reading exists for tenant, service, and period
     */
    public boolean meterReadingExists(int tenantId, int serviceId, int month, int year) {
        String sql = "SELECT COUNT(*) FROM meter_readings WHERE tenant_id = ? AND service_id = ? AND month = ? AND year = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, serviceId);
            pstmt.setInt(3, month);
            pstmt.setInt(4, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking meter reading existence: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Initialize meter readings for a new tenant with initial readings
     */
    public boolean initializeMeterReadingsForTenant(int tenantId, List<Integer> serviceIds, 
                                                   List<BigDecimal> initialReadings, 
                                                   Date readingDate, int month, int year) {
        if (serviceIds == null || initialReadings == null || 
            serviceIds.size() != initialReadings.size()) {
            return false;
        }
        
        String sql = "INSERT INTO meter_readings (tenant_id, service_id, reading, reading_date, month, year) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false); // Start transaction
            
            for (int i = 0; i < serviceIds.size(); i++) {
                Integer serviceId = serviceIds.get(i);
                BigDecimal initialReading = initialReadings.get(i);
                
                // Only add if reading doesn't exist and initial reading is provided
                if (!meterReadingExists(tenantId, serviceId, month, year) && initialReading != null) {
                    pstmt.setInt(1, tenantId);
                    pstmt.setInt(2, serviceId);
                    pstmt.setBigDecimal(3, initialReading);
                    pstmt.setDate(4, readingDate);
                    pstmt.setInt(5, month);
                    pstmt.setInt(6, year);
                    pstmt.addBatch();
                }
            }
            
            int[] results = pstmt.executeBatch();
            conn.commit(); // Commit transaction
            
            return true;
            
        } catch (SQLException e) {
            System.err.println("Error initializing meter readings for tenant: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Calculate consumption based on current and previous readings
     */
    public BigDecimal calculateConsumption(int tenantId, int serviceId, int month, int year) {
        MeterReading currentReading = getMeterReadingByTenantServiceAndPeriod(tenantId, serviceId, month, year);
        MeterReading previousReading = getPreviousMeterReading(tenantId, serviceId, month, year);
        
        if (currentReading != null && previousReading != null) {
            return currentReading.getReading().subtract(previousReading.getReading());
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Get initial meter reading for a room and service
     * This gets the earliest meter reading for any tenant in the room for the specified service
     */
    public MeterReading getInitialMeterReadingForRoom(int roomId, int serviceId) {
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.room_id = ? AND mr.service_id = ? " +
                    "ORDER BY mr.year ASC, mr.month ASC, mr.created_at ASC " +
                    "LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            pstmt.setInt(2, serviceId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                return reading;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting initial meter reading for room: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all meter readings for a period
     */
    public List<MeterReading> getMeterReadingsByPeriod(int month, int year) {
        List<MeterReading> readings = new ArrayList<>();
        String sql = "SELECT mr.reading_id, mr.tenant_id, mr.service_id, mr.reading, mr.reading_date, " +
                    "mr.month, mr.year, mr.created_at, " +
                    "s.service_name, s.unit, u.full_name, r.room_name " +
                    "FROM meter_readings mr " +
                    "JOIN services s ON mr.service_id = s.service_id " +
                    "JOIN tenants t ON mr.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE mr.month = ? AND mr.year = ? " +
                    "ORDER BY r.room_name, s.service_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, month);
            pstmt.setInt(2, year);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                MeterReading reading = new MeterReading();
                reading.setReadingId(rs.getInt("reading_id"));
                reading.setTenantId(rs.getInt("tenant_id"));
                reading.setServiceId(rs.getInt("service_id"));
                reading.setReading(rs.getBigDecimal("reading"));
                reading.setReadingDate(rs.getDate("reading_date"));
                reading.setMonth(rs.getInt("month"));
                reading.setYear(rs.getInt("year"));
                reading.setCreatedAt(rs.getTimestamp("created_at"));
                reading.setServiceName(rs.getString("service_name"));
                reading.setServiceUnit(rs.getString("unit"));
                reading.setTenantName(rs.getString("full_name"));
                reading.setRoomName(rs.getString("room_name"));
                readings.add(reading);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting meter readings by period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return readings;
    }
}
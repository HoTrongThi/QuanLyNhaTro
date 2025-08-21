package dao;

import model.AdditionalCost;
import org.springframework.stereotype.Repository;
import util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * AdditionalCost Data Access Object
 * Handles database operations for additional/incidental costs
 */
@Repository
public class AdditionalCostDAO {
    
    /**
     * Add additional cost record
     */
    public boolean addAdditionalCost(AdditionalCost cost) {
        String sql = "INSERT INTO additional_costs (tenant_id, description, amount, date) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cost.getTenantId());
            pstmt.setString(2, cost.getDescription());
            pstmt.setBigDecimal(3, cost.getAmount());
            pstmt.setDate(4, new java.sql.Date(cost.getDate().getTime()));
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding additional cost: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update additional cost record
     */
    public boolean updateAdditionalCost(AdditionalCost cost) {
        String sql = "UPDATE additional_costs SET description = ?, amount = ?, date = ? WHERE cost_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, cost.getDescription());
            pstmt.setBigDecimal(2, cost.getAmount());
            pstmt.setDate(3, new java.sql.Date(cost.getDate().getTime()));
            pstmt.setInt(4, cost.getCostId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating additional cost: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get additional cost by ID
     */
    public AdditionalCost getAdditionalCostById(int costId) {
        String sql = "SELECT ac.cost_id, ac.tenant_id, ac.description, ac.amount, ac.date, " +
                    "u.full_name, r.room_name " +
                    "FROM additional_costs ac " +
                    "JOIN tenants t ON ac.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE ac.cost_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, costId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                AdditionalCost cost = new AdditionalCost();
                cost.setCostId(rs.getInt("cost_id"));
                cost.setTenantId(rs.getInt("tenant_id"));
                cost.setDescription(rs.getString("description"));
                cost.setAmount(rs.getBigDecimal("amount"));
                cost.setDate(rs.getDate("date"));
                cost.setTenantName(rs.getString("full_name"));
                cost.setRoomName(rs.getString("room_name"));
                return cost;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting additional cost by ID: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get all additional costs for a specific tenant and period
     */
    public List<AdditionalCost> getAdditionalCostsByTenantAndPeriod(int tenantId, int month, int year) {
        List<AdditionalCost> costList = new ArrayList<>();
        String sql = "SELECT ac.cost_id, ac.tenant_id, ac.description, ac.amount, ac.date, " +
                    "u.full_name, r.room_name " +
                    "FROM additional_costs ac " +
                    "JOIN tenants t ON ac.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE ac.tenant_id = ? AND MONTH(ac.date) = ? AND YEAR(ac.date) = ? " +
                    "ORDER BY ac.date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AdditionalCost cost = new AdditionalCost();
                cost.setCostId(rs.getInt("cost_id"));
                cost.setTenantId(rs.getInt("tenant_id"));
                cost.setDescription(rs.getString("description"));
                cost.setAmount(rs.getBigDecimal("amount"));
                cost.setDate(rs.getDate("date"));
                cost.setTenantName(rs.getString("full_name"));
                cost.setRoomName(rs.getString("room_name"));
                costList.add(cost);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting additional costs by tenant and period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return costList;
    }
    
    /**
     * Get all additional costs for a specific room and period
     */
    public List<AdditionalCost> getAdditionalCostsByRoomAndPeriod(int roomId, int month, int year) {
        List<AdditionalCost> costList = new ArrayList<>();
        String sql = "SELECT ac.cost_id, ac.tenant_id, ac.description, ac.amount, ac.date, " +
                    "u.full_name, r.room_name " +
                    "FROM additional_costs ac " +
                    "JOIN tenants t ON ac.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE t.room_id = ? AND MONTH(ac.date) = ? AND YEAR(ac.date) = ? " +
                    "ORDER BY ac.date DESC, u.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AdditionalCost cost = new AdditionalCost();
                cost.setCostId(rs.getInt("cost_id"));
                cost.setTenantId(rs.getInt("tenant_id"));
                cost.setDescription(rs.getString("description"));
                cost.setAmount(rs.getBigDecimal("amount"));
                cost.setDate(rs.getDate("date"));
                cost.setTenantName(rs.getString("full_name"));
                cost.setRoomName(rs.getString("room_name"));
                costList.add(cost);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting additional costs by room and period: " + e.getMessage());
            e.printStackTrace();
        }
        
        return costList;
    }
    
    /**
     * Get all additional costs
     */
    public List<AdditionalCost> getAllAdditionalCosts() {
        List<AdditionalCost> costList = new ArrayList<>();
        String sql = "SELECT ac.cost_id, ac.tenant_id, ac.description, ac.amount, ac.date, " +
                    "u.full_name, r.room_name " +
                    "FROM additional_costs ac " +
                    "JOIN tenants t ON ac.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "ORDER BY ac.date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                AdditionalCost cost = new AdditionalCost();
                cost.setCostId(rs.getInt("cost_id"));
                cost.setTenantId(rs.getInt("tenant_id"));
                cost.setDescription(rs.getString("description"));
                cost.setAmount(rs.getBigDecimal("amount"));
                cost.setDate(rs.getDate("date"));
                cost.setTenantName(rs.getString("full_name"));
                cost.setRoomName(rs.getString("room_name"));
                costList.add(cost);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all additional costs: " + e.getMessage());
            e.printStackTrace();
        }
        
        return costList;
    }
    
    /**
     * Delete additional cost record
     */
    public boolean deleteAdditionalCost(int costId) {
        String sql = "DELETE FROM additional_costs WHERE cost_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, costId);
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting additional cost: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Calculate total additional cost for a tenant and period
     */
    public BigDecimal calculateAdditionalTotal(int tenantId, int month, int year) {
        String sql = "SELECT SUM(amount) as total " +
                    "FROM additional_costs " +
                    "WHERE tenant_id = ? AND MONTH(date) = ? AND YEAR(date) = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating additional total: " + e.getMessage());
            e.printStackTrace();
        }
        
        return BigDecimal.ZERO;
    }
    
    /**
     * Calculate total additional cost for a room and period
     */
    public BigDecimal calculateAdditionalTotalByRoom(int roomId, int month, int year) {
        String sql = "SELECT SUM(ac.amount) as total " +
                    "FROM additional_costs ac " +
                    "JOIN tenants t ON ac.tenant_id = t.tenant_id " +
                    "WHERE t.room_id = ? AND MONTH(ac.date) = ? AND YEAR(ac.date) = ?";
        

        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, roomId);
            pstmt.setInt(2, month);
            pstmt.setInt(3, year);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");

                return total != null ? total : BigDecimal.ZERO;
            }
            
        } catch (SQLException e) {
            System.err.println("Error calculating additional total by room: " + e.getMessage());
            e.printStackTrace();
        }
        

        return BigDecimal.ZERO;
    }
    
    /**
     * Get additional costs for a specific tenant
     */
    public List<AdditionalCost> getAdditionalCostsByTenant(int tenantId) {
        List<AdditionalCost> costList = new ArrayList<>();
        String sql = "SELECT ac.cost_id, ac.tenant_id, ac.description, ac.amount, ac.date, " +
                    "u.full_name, r.room_name " +
                    "FROM additional_costs ac " +
                    "JOIN tenants t ON ac.tenant_id = t.tenant_id " +
                    "JOIN users u ON t.user_id = u.user_id " +
                    "JOIN rooms r ON t.room_id = r.room_id " +
                    "WHERE ac.tenant_id = ? " +
                    "ORDER BY ac.date DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, tenantId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                AdditionalCost cost = new AdditionalCost();
                cost.setCostId(rs.getInt("cost_id"));
                cost.setTenantId(rs.getInt("tenant_id"));
                cost.setDescription(rs.getString("description"));
                cost.setAmount(rs.getBigDecimal("amount"));
                cost.setDate(rs.getDate("date"));
                cost.setTenantName(rs.getString("full_name"));
                cost.setRoomName(rs.getString("room_name"));
                costList.add(cost);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting additional costs by tenant: " + e.getMessage());
            e.printStackTrace();
        }
        
        return costList;
    }
}

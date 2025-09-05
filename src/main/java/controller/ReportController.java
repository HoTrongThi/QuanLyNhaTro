package controller;

import dao.*;
import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.*;
/**
 * Controller Báo cáo và Thống kê với Admin Data Isolation
 * Xử lý báo cáo tổng hợp và dashboard phân tích
 * Bao gồm thống kê doanh thu, tỷ lệ lấp đầy và biểu đồ theo tháng
 * Hiển thị dữ liệu thời gian thực và xu hướng kinh doanh
 * Mỗi Admin chỉ thấy báo cáo của phạm vi quản lý của mình
 * Super Admin thấy báo cáo tổng hợp toàn hệ thống
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 2.0 - Admin Isolation
 * @since 2025
 */
@Controller
@RequestMapping("/admin")
public class ReportController {
    
    // ==================== CÁC THUỘC TÍNH DAO ====================
    
    /** DAO quản lý hóa đơn */
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    /** DAO quản lý người thuê */
    @Autowired
    private TenantDAO tenantDAO;
    
    /** DAO quản lý phòng trọ */
    @Autowired
    private RoomDAO roomDAO;
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra quyền truy cập của quản trị viên
     * Đảm bảo chỉ có admin mới có thể xem báo cáo
     * 
     * @param session HTTP Session chứa thông tin người dùng
     * @return null nếu có quyền truy cập, redirect URL nếu không có quyền
     */
    private String checkAdminAccess(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            return "redirect:/login";
        }
        
        // Kiểm tra quyền admin
        if (!user.isAdmin()) {
            return "redirect:/access-denied";
        }
        
        return null; // Có quyền truy cập
    }
    
    /**
     * Lấy Admin ID từ session cho data isolation
     */
    private Integer getAdminId(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null && user.isSuperAdmin()) {
            return null; // Super Admin thấy tất cả
        }
        return user != null ? user.getUserId() : null;
    }
    
    /**
     * Show reports and statistics dashboard
     */
    @GetMapping("/reports")
    public String showReportsPage(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        Integer adminId = getAdminId(session);
        
        // Get current month and year for default filtering
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);
        
        // Overall Statistics
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Báo cáo & Thống kê");
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("currentYear", currentYear);
        
        // Basic counts with admin isolation
        model.addAttribute("totalRooms", roomDAO.getTotalRoomCountByAdmin(adminId));
        model.addAttribute("occupiedRooms", roomDAO.getOccupiedRoomCountByAdmin(adminId));
        model.addAttribute("totalTenants", tenantDAO.getActiveTenantCountByAdmin(adminId));
        
        // Financial overview (current month) with admin isolation
        BigDecimal currentMonthRevenue = invoiceDAO.getRevenueByPeriodAndAdmin(currentMonth, currentYear, adminId);
        BigDecimal totalRevenue = invoiceDAO.getTotalRevenueByAdmin(adminId);
        int totalInvoices = invoiceDAO.getTotalInvoiceCount();
        int unpaidInvoices = invoiceDAO.getUnpaidInvoiceCountByAdmin(adminId);
        
        model.addAttribute("currentMonthRevenue", currentMonthRevenue != null ? currentMonthRevenue : BigDecimal.ZERO);
        model.addAttribute("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
        model.addAttribute("totalInvoices", totalInvoices);
        model.addAttribute("unpaidInvoices", unpaidInvoices);
        model.addAttribute("paidInvoices", totalInvoices - unpaidInvoices);
        
        // Occupancy rate with admin isolation
        int totalRooms = roomDAO.getTotalRoomCountByAdmin(adminId);
        int occupiedRooms = roomDAO.getOccupiedRoomCountByAdmin(adminId);
        double occupancyRate = totalRooms > 0 ? (double) occupiedRooms / totalRooms * 100 : 0;
        model.addAttribute("occupancyRate", Math.round(occupancyRate * 100.0) / 100.0);
        
        // Monthly revenue chart data (last 12 months)
        List<String> monthLabels = new ArrayList<>();
        List<BigDecimal> monthlyRevenues = new ArrayList<>();
        
        Calendar chartCal = Calendar.getInstance();
        chartCal.add(Calendar.MONTH, -11); // Start from 11 months ago
        
        for (int i = 0; i < 12; i++) {
            int month = chartCal.get(Calendar.MONTH) + 1;
            int year = chartCal.get(Calendar.YEAR);
            
            monthLabels.add(String.format("%02d/%d", month, year));
            BigDecimal revenue = invoiceDAO.getRevenueByPeriodAndAdmin(month, year, adminId);
            monthlyRevenues.add(revenue != null ? revenue : BigDecimal.ZERO);
            
            chartCal.add(Calendar.MONTH, 1);
        }
        
        model.addAttribute("monthLabels", monthLabels);
        model.addAttribute("monthlyRevenues", monthlyRevenues);
        
        
        // Recent activity (latest invoices) with admin isolation
        List<Invoice> recentInvoices = invoiceDAO.getRecentInvoicesByAdmin(5, adminId);
        model.addAttribute("recentInvoices", recentInvoices);
        
        return "admin/reports";
    }
    
    
}

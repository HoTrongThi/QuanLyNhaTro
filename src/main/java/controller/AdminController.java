package controller;

import dao.RoomDAO;
import dao.InvoiceDAO;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Calendar;

/**
 * Controller quản trị hệ thống với Admin Data Isolation
 * Xử lý các chức năng dành riêng cho quản trị viên
 * Bao gồm dashboard, thống kê và kiểm soát truy cập dựa trên vai trò
 * Đảm bảo chỉ có admin mới có thể truy cập các tính năng quản lý
 * Mỗi Admin chỉ thấy thống kê của phạm vi quản lý của mình
 * Super Admin thấy thống kê tổng hợp toàn hệ thống
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 2.0 - Admin Isolation
 * @since 2025
 */
@Controller
@RequestMapping("/admin")
public class AdminController {
    
    // ==================== CÁC THUỘC TÍNH DAO ====================
    
    /** DAO quản lý phòng - dùng cho thống kê dashboard */
    @Autowired
    private RoomDAO roomDAO;
    
    /** DAO quản lý hóa đơn - dùng cho thống kê doanh thu và nợ */
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra quyền truy cập của quản trị viên
     * Đảm bảo chỉ có người dùng đã đăng nhập và có vai trò admin mới truy cập được
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
     * Super Admin trả về null (thấy tất cả)
     * Admin thường trả về user_id của mình
     * 
     * @param session HTTP Session
     * @return Admin ID hoặc null cho Super Admin
     */
    private Integer getAdminId(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null && user.isSuperAdmin()) {
            return null; // Super Admin thấy tất cả
        }
        return user != null ? user.getUserId() : null;
    }
    
    // ==================== CÁC PHƯƠNG THỨC XỬ LÝ TRANG ====================
    
    /**
     * Hiển thị trang Dashboard quản trị
     * Cung cấp tổng quan về hệ thống với các thống kê quan trọng
     * Bao gồm thống kê phòng, người thuê và doanh thu
     * 
     * @param session HTTP Session để kiểm tra quyền
     * @param model Model để truyền dữ liệu đến view
     * @return tên view dashboard hoặc redirect URL
     */
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        // Kiểm tra quyền truy cập
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        Integer adminId = getAdminId(session);
        
        // Lấy thống kê phòng theo admin
        int totalRooms = roomDAO.getTotalRoomCountByAdmin(adminId);       // Tổng số phòng
        int availableRooms = roomDAO.getAvailableRoomCountByAdmin(adminId); // Phòng còn trống
        int occupiedRooms = roomDAO.getOccupiedRoomCountByAdmin(adminId);   // Phòng đã thuê
        
        // Lấy thống kê doanh thu theo admin
        BigDecimal totalRevenue = invoiceDAO.getTotalRevenueByAdmin(adminId); // Tổng doanh thu
        
        // Lấy doanh thu tháng hiện tại
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1;
        int currentYear = cal.get(Calendar.YEAR);
        BigDecimal currentMonthRevenue = invoiceDAO.getRevenueByPeriodAndAdmin(currentMonth, currentYear, adminId);
        
        // Lấy thống kê hóa đơn và nợ theo admin
        int unpaidInvoices = invoiceDAO.getUnpaidInvoiceCountByAdmin(adminId); // Số hóa đơn chưa thanh toán
        
        // Đếm số phòng có nợ (phòng có hóa đơn chưa thanh toán)
        int roomsWithDebt = invoiceDAO.getRoomsWithUnpaidBillsByAdmin(adminId);
        
        // Truyền dữ liệu đến view
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Bảng điều khiển Quản trị");
        
        // Thống kê phòng
        model.addAttribute("totalRooms", totalRooms);
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("occupiedRooms", occupiedRooms);
        
        // Thống kê doanh thu
        model.addAttribute("totalRevenue", totalRevenue != null ? totalRevenue : BigDecimal.ZERO);
        model.addAttribute("currentMonthRevenue", currentMonthRevenue != null ? currentMonthRevenue : BigDecimal.ZERO);
        
        // Thống kê nợ và hóa đơn
        model.addAttribute("unpaidInvoices", unpaidInvoices);
        model.addAttribute("roomsWithDebt", roomsWithDebt);
        
        return "admin/dashboard";
    }
    
    
    /**
     * Invoice Management
     */
    @GetMapping("/invoices")
    public String manageInvoices(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Quản lý Hóa đơn");
        
        return "admin/invoices";
    }
    
    /**
     * Redirect to Reports
     */
    @GetMapping("/reports-redirect")
    public String redirectToReports() {
        return "redirect:/admin/reports";
    }
}

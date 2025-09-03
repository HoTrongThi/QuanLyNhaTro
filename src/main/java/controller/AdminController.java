package controller;

import dao.RoomDAO;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

/**
 * Controller quản trị hệ thống
 * Xử lý các chức năng dành riêng cho quản trị viên
 * Bao gồm dashboard, thống kê và kiểm soát truy cập dựa trên vai trò
 * Đảm bảo chỉ có admin mới có thể truy cập các tính năng quản lý
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Controller
@RequestMapping("/admin")
public class AdminController {
    
    // ==================== CÁC THUỘC TÍNH DAO ====================
    
    /** DAO quản lý phòng - dùng cho thống kê dashboard */
    @Autowired
    private RoomDAO roomDAO;
    
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
        
        // Lấy thống kê phòng
        int totalRooms = roomDAO.getTotalRoomCount();       // Tổng số phòng
        int availableRooms = roomDAO.getAvailableRoomCount(); // Phòng còn trống
        int occupiedRooms = roomDAO.getOccupiedRoomCount();   // Phòng đã thuê
        
        // Truyền dữ liệu đến view
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Bảng điều khiển Quản trị");
        model.addAttribute("totalRooms", totalRooms);
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("occupiedRooms", occupiedRooms);
        
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

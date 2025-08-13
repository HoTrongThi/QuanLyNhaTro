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
 * Admin Controller
 * Handles admin-specific functionality with role-based access control
 */
@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private RoomDAO roomDAO;
    
    /**
     * Check if user is admin, redirect to login if not authenticated or not admin
     */
    private String checkAdminAccess(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        if (!user.isAdmin()) {
            return "redirect:/access-denied";
        }
        
        return null; // Access granted
    }
    
    /**
     * Admin Dashboard
     */
    @GetMapping("/dashboard")
    public String adminDashboard(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Get room statistics
        int totalRooms = roomDAO.getTotalRoomCount();
        int availableRooms = roomDAO.getAvailableRoomCount();
        int occupiedRooms = roomDAO.getOccupiedRoomCount();
        
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

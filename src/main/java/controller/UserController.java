package controller;

import dao.TenantDAO;
import dao.RoomDAO;
import dao.ServiceDAO;
import dao.ServiceUsageDAO;
import dao.InvoiceDAO;
import model.User;
import model.Tenant;
import model.Room;
import model.Service;
import model.ServiceUsage;
import model.Invoice;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.*;
import java.math.BigDecimal;

/**
 * Controller cho Người dùng thường
 * Xử lý các chức năng dành riêng cho người dùng thường (không phải admin)
 * Bao gồm dashboard, xem thông tin phòng, hóa đơn và lịch sử thanh toán
 * Kiểm soát truy cập dựa trên vai trò và trạng thái đăng nhập
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Controller
@RequestMapping("/user")
public class UserController {
    
    // ==================== CÁC THUỘC TÍNH DAO ====================
    
    /** DAO quản lý người thuê */
    @Autowired
    private TenantDAO tenantDAO;
    
    /** DAO quản lý phòng trọ */
    @Autowired
    private RoomDAO roomDAO;
    
    /** DAO quản lý dịch vụ */
    @Autowired
    private ServiceDAO serviceDAO;
    
    /** DAO quản lý sử dụng dịch vụ */
    @Autowired
    private ServiceUsageDAO serviceUsageDAO;
    
    /** DAO quản lý hóa đơn */
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra quyền truy cập của người dùng thường
     * Đảm bảo chỉ có người dùng thường (không phải admin) mới truy cập được
     * Nếu là admin sẽ chuyển hướng đến trang quản trị
     * 
     * @param session HTTP Session chứa thông tin người dùng
     * @return null nếu có quyền truy cập, redirect URL nếu không có quyền
     */
    private String checkUserAccess(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            return "redirect:/login";
        }
        
        // Nếu là admin thì chuyển đến trang quản trị
        if (user.isAdmin()) {
            return "redirect:/admin/dashboard";
        }
        
        return null; // Có quyền truy cập
    }
    
    /**
     * User Dashboard
     */
    @GetMapping("/dashboard")
    public String userDashboard(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Get current tenant information if user is a tenant
        Tenant currentTenant = tenantDAO.getActiveTenantByUserId(user.getUserId());
        
        // Get unpaid bills count for dashboard
        int unpaidBillsCount = 0;
        if (currentTenant != null) {
            List<Invoice> allInvoices = getInvoicesForUser(user);
            for (Invoice invoice : allInvoices) {
                if (!"PAID".equals(invoice.getStatus())) {
                    unpaidBillsCount++;
                }
            }
        }
        
        model.addAttribute("user", user);
        model.addAttribute("currentTenant", currentTenant);
        model.addAttribute("unpaidBillsCount", unpaidBillsCount);
        model.addAttribute("pageTitle", "Bảng điều khiển Người dùng");
        
        return "user/dashboard";
    }
    
    
    /**
     * View Room Information
     */
    @GetMapping("/room")
    public String viewRoom(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Get current tenant information if user is a tenant
        Tenant currentTenant = tenantDAO.getActiveTenantByUserId(user.getUserId());
        
        if (currentTenant != null) {
            // Get detailed room information
            Room roomDetails = roomDAO.getRoomById(currentTenant.getRoomId());
            
            // Get services available for this room
            List<Service> roomServices = serviceDAO.getServicesByRoomId(currentTenant.getRoomId());
            
            // Get recent invoices for this tenant
            List<Invoice> recentInvoices = invoiceDAO.getInvoicesByTenantId(currentTenant.getTenantId(), 5);
            
            // Calculate monthly service cost from recent usage
            List<ServiceUsage> serviceUsages = serviceUsageDAO.getServiceUsageByTenantId(currentTenant.getTenantId());
            double monthlyServiceCost = 0;
            for (ServiceUsage usage : serviceUsages) {
                if (usage.getTotalCost() != null) {
                    monthlyServiceCost += usage.getTotalCost().doubleValue();
                } else {
                    usage.calculateTotalCost();
                    if (usage.getTotalCost() != null) {
                        monthlyServiceCost += usage.getTotalCost().doubleValue();
                    }
                }
            }
            
            model.addAttribute("roomDetails", roomDetails);
            model.addAttribute("roomServices", roomServices);
            model.addAttribute("recentInvoices", recentInvoices);
            model.addAttribute("monthlyServiceCost", monthlyServiceCost);
            
            // Calculate total monthly cost properly with BigDecimal
            java.math.BigDecimal roomPrice = currentTenant.getRoomPrice() != null ? currentTenant.getRoomPrice() : java.math.BigDecimal.ZERO;
            java.math.BigDecimal serviceCost = java.math.BigDecimal.valueOf(monthlyServiceCost);
            java.math.BigDecimal totalMonthlyCost = roomPrice.add(serviceCost);
            model.addAttribute("totalMonthlyCost", totalMonthlyCost);
        }
        
        model.addAttribute("user", user);
        model.addAttribute("currentTenant", currentTenant);
        model.addAttribute("pageTitle", "Thông tin Phòng trọ");
        
        return "user/room";
    }
    
    /**
     * View Invoices
     */
    @GetMapping("/invoices")
    public String viewInvoices(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Hóa đơn của tôi");
        
        return "user/invoices";
    }
    
    /**
     * View Service Usage
     */
    @GetMapping("/services")
    public String viewServices(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Sử dụng Dịch vụ");
        
        return "user/services";
    }
    
    /**
     * Payment History
     */
    @GetMapping("/payments")
    public String paymentHistory(HttpSession session, Model model,
            @RequestParam(value = "year", required = false) Integer filterYear) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Get all invoices for this user's room (room-based billing)
        List<Invoice> allInvoices = getInvoicesForUser(user);
        
        // Lọc hóa đơn dựa trên các tham số
        List<Invoice> payments = new ArrayList<>();
        java.math.BigDecimal totalPaid = java.math.BigDecimal.ZERO;
        java.math.BigDecimal totalUnpaid = java.math.BigDecimal.ZERO;
        int paidCount = 0;
        int unpaidCount = 0;
        
        // Tính toán số liệu thống kê cho tất cả các hóa đơn (không có bộ lọc cho số liệu thống kê tổng thể)
        for (Invoice invoice : allInvoices) {
            if ("PAID".equals(invoice.getStatus())) {
                totalPaid = totalPaid.add(invoice.getTotalAmount());
                paidCount++;
            } else {
                totalUnpaid = totalUnpaid.add(invoice.getTotalAmount());
                unpaidCount++;
            }
        }
        
        // Lọc hóa đơn để hiển thị - chỉ hiển thị hóa đơn ĐÃ THANH TOÁN (lịch sử thanh toán)
        for (Invoice invoice : allInvoices) {
            // Chỉ bao gồm hóa đơn ĐÃ THANH TOÁN cho lịch sử thanh toán
            if (!"PAID".equals(invoice.getStatus())) {
                continue;
            }
            
            // Áp dụng bộ lọc năm nếu được chỉ định
            if (filterYear != null && invoice.getYear() != filterYear) {
                continue;
            }
            
            // Thêm vào danh sách thanh toán để hiển thị
            payments.add(invoice);
        }
        
        // Nhận những năm duy nhất cho danh sách thả xuống bộ lọc
        Set<Integer> availableYears = new HashSet<>();
        for (Invoice invoice : allInvoices) {
            availableYears.add(invoice.getYear());
        }
        List<Integer> yearsList = new ArrayList<>(availableYears);
        Collections.sort(yearsList, Collections.reverseOrder());
        
        // Nhận thông tin về người thuê hiện tại
        Tenant currentTenant = tenantDAO.getActiveTenantByUserId(user.getUserId());
        
        model.addAttribute("user", user);
        model.addAttribute("currentTenant", currentTenant);
        model.addAttribute("payments", payments);
        model.addAttribute("totalPaid", totalPaid);
        model.addAttribute("totalUnpaid", totalUnpaid);
        model.addAttribute("paidCount", paidCount);
        model.addAttribute("unpaidCount", unpaidCount);
        model.addAttribute("availableYears", yearsList);
        model.addAttribute("filterYear", filterYear);
        model.addAttribute("pageTitle", "Lịch sử Thanh toán");
        
        return "user/payments";
    }
    
    /**
     * Helper method to get invoices for a user (room-based)
     */
    private List<Invoice> getInvoicesForUser(User user) {
        // Get user's active tenant record to find their room
        Tenant activeTenant = tenantDAO.getActiveTenantByUserId(user.getUserId());
        
        if (activeTenant != null) {
            // Get all invoices for the room (room-based billing)
            return invoiceDAO.getInvoicesByRoomId(activeTenant.getRoomId());
        } else {
            // Fallback: get invoices by user ID for legacy support
            return invoiceDAO.getInvoicesByUserId(user.getUserId());
        }
    }
}

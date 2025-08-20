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
 * User Controller
 * Handles user-specific functionality with role-based access control
 */
@Controller
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    private TenantDAO tenantDAO;
    
    @Autowired
    private RoomDAO roomDAO;
    
    @Autowired
    private ServiceDAO serviceDAO;
    
    @Autowired
    private ServiceUsageDAO serviceUsageDAO;
    
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    /**
     * Check if user is authenticated regular user, redirect if not authenticated or if admin
     */
    private String checkUserAccess(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        if (user.isAdmin()) {
            return "redirect:/admin/dashboard";
        }
        
        return null; // Access granted
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
        
        model.addAttribute("user", user);
        model.addAttribute("currentTenant", currentTenant);
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
        
        // Filter invoices based on parameters
        List<Invoice> payments = new ArrayList<>();
        java.math.BigDecimal totalPaid = java.math.BigDecimal.ZERO;
        java.math.BigDecimal totalUnpaid = java.math.BigDecimal.ZERO;
        int paidCount = 0;
        int unpaidCount = 0;
        
        // Calculate statistics for all invoices (without filters for overall stats)
        for (Invoice invoice : allInvoices) {
            if ("PAID".equals(invoice.getStatus())) {
                totalPaid = totalPaid.add(invoice.getTotalAmount());
                paidCount++;
            } else {
                totalUnpaid = totalUnpaid.add(invoice.getTotalAmount());
                unpaidCount++;
            }
        }
        
        // Filter invoices for display - only show PAID invoices (payment history)
        for (Invoice invoice : allInvoices) {
            // Only include PAID invoices for payment history
            if (!"PAID".equals(invoice.getStatus())) {
                continue;
            }
            
            // Apply year filter if specified
            if (filterYear != null && invoice.getYear() != filterYear) {
                continue;
            }
            
            // Add to payments list for display
            payments.add(invoice);
        }
        
        // Get unique years for filter dropdown
        Set<Integer> availableYears = new HashSet<>();
        for (Invoice invoice : allInvoices) {
            availableYears.add(invoice.getYear());
        }
        List<Integer> yearsList = new ArrayList<>(availableYears);
        Collections.sort(yearsList, Collections.reverseOrder());
        
        // Get current tenant info for context
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

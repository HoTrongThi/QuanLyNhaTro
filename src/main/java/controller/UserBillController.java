package controller;

import dao.InvoiceDAO;
import dao.ServiceUsageDAO;
import dao.AdditionalCostDAO;
import dao.TenantDAO;
import model.Invoice;
import model.ServiceUsage;
import model.AdditionalCost;
import model.User;
import model.Tenant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * User Bill Controller
 * Allows regular users to view their own bills and invoice details
 */
@Controller
@RequestMapping("/user")
public class UserBillController {
    
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    @Autowired
    private ServiceUsageDAO serviceUsageDAO;
    
    @Autowired
    private AdditionalCostDAO additionalCostDAO;
    
    @Autowired
    private TenantDAO tenantDAO;
    
    /**
     * Check if user is logged in
     */
    private String checkUserAccess(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            return "redirect:/login";
        }
        
        return null; // Access granted
    }
    
    /**
     * Show user's bills/invoices
     */
    @GetMapping("/bills")
    public String showUserBills(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Invoice> invoices = getInvoicesForUser(user);
        
        // Calculate statistics for all invoices
        java.math.BigDecimal totalPaid = java.math.BigDecimal.ZERO;
        java.math.BigDecimal totalUnpaid = java.math.BigDecimal.ZERO;
        int paidCount = 0;
        int unpaidCount = 0;
        
        for (Invoice invoice : invoices) {
            if ("PAID".equals(invoice.getStatus())) {
                totalPaid = totalPaid.add(invoice.getTotalAmount());
                paidCount++;
            } else {
                totalUnpaid = totalUnpaid.add(invoice.getTotalAmount());
                unpaidCount++;
            }
        }
        
        // Get current tenant info for context
        Tenant currentTenant = tenantDAO.getActiveTenantByUserId(user.getUserId());
        
        model.addAttribute("user", user);
        model.addAttribute("currentTenant", currentTenant);
        model.addAttribute("invoices", invoices);
        model.addAttribute("totalPaid", totalPaid);
        model.addAttribute("totalUnpaid", totalUnpaid);
        model.addAttribute("paidCount", paidCount);
        model.addAttribute("unpaidCount", unpaidCount);
        model.addAttribute("pageTitle", "Hóa đơn của tôi");
        
        return "user/bills";
    }
    
    /**
     * View invoice details for regular user
     */
    @GetMapping("/bills/view/{id}")
    public String viewUserInvoice(@PathVariable int id,
                                 HttpSession session,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        Invoice invoice = invoiceDAO.getInvoiceById(id);
        
        if (invoice == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy hóa đơn");
            return "redirect:/user/bills";
        }
        
        // Check if this invoice belongs to the current user
        // Check if this invoice belongs to the current user (room-based)
        boolean belongsToUser = canUserAccessInvoice(user, id);

        
        if (!belongsToUser) {
            redirectAttributes.addFlashAttribute("error", "Bạn không có quyền xem hóa đơn này");
            return "redirect:/user/bills";
        }
        
        // Get detailed breakdowns
        List<ServiceUsage> serviceUsages = getServiceUsagesForInvoice(invoice);
        List<AdditionalCost> additionalCosts = getAdditionalCostsForInvoice(invoice);
        
        model.addAttribute("user", user);
        model.addAttribute("invoice", invoice);
        model.addAttribute("serviceUsages", serviceUsages);
        model.addAttribute("additionalCosts", additionalCosts);
        model.addAttribute("pageTitle", "Chi tiết Hóa đơn - " + invoice.getFormattedPeriod());
        
        // Get tenant information to find room and all tenants in room
        Tenant invoiceTenant = tenantDAO.getTenantById(invoice.getTenantId());
        List<Tenant> tenantsInRoom = null;
        
        if (invoiceTenant != null) {
            tenantsInRoom = tenantDAO.getTenantsByRoomId(invoiceTenant.getRoomId());
        }
        
        model.addAttribute("invoiceTenant", invoiceTenant);
        model.addAttribute("tenantsInRoom", tenantsInRoom);
        
        return "user/bill-detail";
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
    
    /**
     * Helper method to check if user can access an invoice (room-based)
     */
    private boolean canUserAccessInvoice(User user, int invoiceId) {
        List<Invoice> userInvoices = getInvoicesForUser(user);
        return userInvoices.stream()
                .anyMatch(inv -> inv.getInvoiceId() == invoiceId);
    }
    
    /**
     * Helper method to get service usages for an invoice (room-based)
     */
    private List<ServiceUsage> getServiceUsagesForInvoice(Invoice invoice) {
        Tenant tenant = tenantDAO.getTenantById(invoice.getTenantId());
        
        if (tenant != null) {
            return serviceUsageDAO.getServiceUsageByRoomAndPeriod(
                tenant.getRoomId(), invoice.getMonth(), invoice.getYear()
            );
        } else {
            // Fallback for legacy invoices
            return serviceUsageDAO.getServiceUsageByTenantAndPeriod(
                invoice.getTenantId(), invoice.getMonth(), invoice.getYear()
            );
        }
    }
    
    /**
     * Helper method to get additional costs for an invoice (room-based)
     */
    private List<AdditionalCost> getAdditionalCostsForInvoice(Invoice invoice) {
        Tenant tenant = tenantDAO.getTenantById(invoice.getTenantId());
        
        if (tenant != null) {
            return additionalCostDAO.getAdditionalCostsByRoomAndPeriod(
                tenant.getRoomId(), invoice.getMonth(), invoice.getYear()
            );
        } else {
            // Fallback for legacy invoices
            return additionalCostDAO.getAdditionalCostsByTenantAndPeriod(
                invoice.getTenantId(), invoice.getMonth(), invoice.getYear()
            );
        }
    }
}

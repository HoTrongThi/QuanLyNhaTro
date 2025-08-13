package controller;

import dao.InvoiceDAO;
import dao.ServiceUsageDAO;
import dao.AdditionalCostDAO;
import model.Invoice;
import model.ServiceUsage;
import model.AdditionalCost;
import model.User;
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
        List<Invoice> invoices = invoiceDAO.getInvoicesByUserId(user.getUserId());
        
        model.addAttribute("user", user);
        model.addAttribute("invoices", invoices);
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
        List<Invoice> userInvoices = invoiceDAO.getInvoicesByUserId(user.getUserId());
        boolean belongsToUser = userInvoices.stream()
                .anyMatch(inv -> inv.getInvoiceId() == id);
        
        if (!belongsToUser) {
            redirectAttributes.addFlashAttribute("error", "Bạn không có quyền xem hóa đơn này");
            return "redirect:/user/bills";
        }
        
        // Get detailed breakdowns
        List<ServiceUsage> serviceUsages = serviceUsageDAO.getServiceUsageByTenantAndPeriod(
            invoice.getTenantId(), invoice.getMonth(), invoice.getYear()
        );
        List<AdditionalCost> additionalCosts = additionalCostDAO.getAdditionalCostsByTenantAndPeriod(
            invoice.getTenantId(), invoice.getMonth(), invoice.getYear()
        );
        
        model.addAttribute("user", user);
        model.addAttribute("invoice", invoice);
        model.addAttribute("serviceUsages", serviceUsages);
        model.addAttribute("additionalCosts", additionalCosts);
        model.addAttribute("pageTitle", "Chi tiết Hóa đơn - " + invoice.getFormattedPeriod());
        
        return "user/bill-detail";
    }
}

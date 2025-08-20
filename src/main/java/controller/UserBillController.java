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
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
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
            
            // Calculate days information for prorated pricing display
            int daysInMonth = getDaysInMonth(invoice.getMonth(), invoice.getYear());
            int daysStayed = calculateDaysStayed(tenantsInRoom, invoice.getMonth(), invoice.getYear());
            Date earliestStartDate = getEarliestStartDate(tenantsInRoom, invoice.getMonth(), invoice.getYear());
            
            // Calculate what the full room price would be
            BigDecimal fullRoomPrice = calculateFullRoomPrice(invoice, tenantsInRoom, daysInMonth, daysStayed);
            boolean isProrated = daysStayed < daysInMonth;
            
            model.addAttribute("daysInMonth", daysInMonth);
            model.addAttribute("daysStayed", daysStayed);
            model.addAttribute("earliestStartDate", earliestStartDate);
            model.addAttribute("fullRoomPrice", fullRoomPrice);
            model.addAttribute("isProrated", isProrated);
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
     * Get number of days in a specific month and year
     */
    private int getDaysInMonth(int month, int year) {
        java.time.YearMonth yearMonth = java.time.YearMonth.of(year, month);
        return yearMonth.lengthOfMonth();
    }
    
    /**
     * Calculate the number of days stayed in the billing month
     */
    private int calculateDaysStayed(List<Tenant> tenantsInRoom, int month, int year) {
        if (tenantsInRoom == null || tenantsInRoom.isEmpty()) {
            return getDaysInMonth(month, year);
        }
        
        int daysInMonth = getDaysInMonth(month, year);
        Date earliestStartDate = getEarliestStartDate(tenantsInRoom, month, year);
        
        if (earliestStartDate == null) {
            return daysInMonth; // Full month
        }
        
        java.time.LocalDate startLocalDate = earliestStartDate.toLocalDate();
        java.time.LocalDate endOfMonth = java.time.LocalDate.of(year, month, daysInMonth);
        
        // Calculate days from start date to end of month (inclusive)
        int daysStayed = (int) java.time.temporal.ChronoUnit.DAYS.between(startLocalDate, endOfMonth) + 1;
        
        // Ensure we don't count more days than in the month
        daysStayed = Math.min(daysStayed, daysInMonth);
        daysStayed = Math.max(daysStayed, 1); // At least 1 day
        
        return daysStayed;
    }
    
    /**
     * Get the earliest start date among tenants for the billing month
     */
    private Date getEarliestStartDate(List<Tenant> tenantsInRoom, int month, int year) {
        if (tenantsInRoom == null || tenantsInRoom.isEmpty()) {
            return null;
        }
        
        Date earliestStartDate = null;
        
        for (Tenant tenant : tenantsInRoom) {
            Date startDate = tenant.getStartDate();
            if (startDate != null) {
                java.time.LocalDate startLocalDate = startDate.toLocalDate();
                if (startLocalDate.getYear() == year && startLocalDate.getMonthValue() == month) {
                    // Tenant started in this billing month
                    if (earliestStartDate == null || startDate.before(earliestStartDate)) {
                        earliestStartDate = startDate;
                    }
                } else if (startLocalDate.isBefore(java.time.LocalDate.of(year, month, 1))) {
                    // Tenant started before this month, so they should pay for the full month
                    earliestStartDate = Date.valueOf(java.time.LocalDate.of(year, month, 1));
                    break; // No need to check further, full month applies
                }
            }
        }
        
        return earliestStartDate;
    }
    
    /**
     * Calculate what the full room price would be (reverse calculation from prorated price)
     */
    private BigDecimal calculateFullRoomPrice(Invoice invoice, List<Tenant> tenantsInRoom, int daysInMonth, int daysStayed) {
        if (daysStayed >= daysInMonth) {
            // Full month, so current room price is the full price
            return invoice.getRoomPrice();
        }
        
        // Prorated month, calculate full price from prorated price
        // proratedPrice = fullPrice * (daysStayed / daysInMonth)
        // fullPrice = proratedPrice * (daysInMonth / daysStayed)
        BigDecimal proratedPrice = invoice.getRoomPrice();
        BigDecimal fullPrice = proratedPrice.multiply(new BigDecimal(daysInMonth))
                                           .divide(new BigDecimal(daysStayed), 2, java.math.RoundingMode.HALF_UP);
        
        return fullPrice;
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
     * Helper method to get service usages for an invoice (room-based, aggregated)
     */
    private List<ServiceUsage> getServiceUsagesForInvoice(Invoice invoice) {
        Tenant tenant = tenantDAO.getTenantById(invoice.getTenantId());
        
        if (tenant != null) {
            // Get all service usages for the room and aggregate by service
            List<ServiceUsage> roomUsages = serviceUsageDAO.getServiceUsageByRoomAndPeriod(
                tenant.getRoomId(), invoice.getMonth(), invoice.getYear()
            );
            
            return aggregateServiceUsagesByService(roomUsages);
        } else {
            // Fallback for legacy invoices
            return serviceUsageDAO.getServiceUsageByTenantAndPeriod(
                invoice.getTenantId(), invoice.getMonth(), invoice.getYear()
            );
        }
    }
    
    /**
     * Aggregate service usages by service to avoid duplicates
     * Combines multiple tenant usages for the same service into one record
     */
    private List<ServiceUsage> aggregateServiceUsagesByService(List<ServiceUsage> usages) {
        if (usages == null || usages.isEmpty()) {
            return new ArrayList<>();
        }
        
        // Group by service ID and aggregate quantities
        java.util.Map<Integer, ServiceUsage> serviceMap = new java.util.HashMap<>();
        
        for (ServiceUsage usage : usages) {
            int serviceId = usage.getServiceId();
            
            if (serviceMap.containsKey(serviceId)) {
                // Service already exists, add to quantity and recalculate total cost
                ServiceUsage existing = serviceMap.get(serviceId);
                BigDecimal newQuantity = existing.getQuantity().add(usage.getQuantity());
                existing.setQuantity(newQuantity);
                existing.calculateTotalCost();
            } else {
                // New service, create a copy and add to map
                ServiceUsage aggregated = new ServiceUsage();
                aggregated.setUsageId(usage.getUsageId()); // Keep first usage ID for reference
                aggregated.setTenantId(usage.getTenantId()); // Keep first tenant ID for reference
                aggregated.setServiceId(usage.getServiceId());
                aggregated.setMonth(usage.getMonth());
                aggregated.setYear(usage.getYear());
                aggregated.setQuantity(usage.getQuantity());
                aggregated.setServiceName(usage.getServiceName());
                aggregated.setServiceUnit(usage.getServiceUnit());
                aggregated.setPricePerUnit(usage.getPricePerUnit());
                aggregated.setTenantName("Tất cả người thuê"); // Indicate it's aggregated
                aggregated.setRoomName(usage.getRoomName());
                aggregated.calculateTotalCost();
                
                serviceMap.put(serviceId, aggregated);
            }
        }
        
        // Convert map values to list and sort by service name
        List<ServiceUsage> result = new ArrayList<>(serviceMap.values());
        result.sort((a, b) -> a.getServiceName().compareToIgnoreCase(b.getServiceName()));
        
        return result;
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

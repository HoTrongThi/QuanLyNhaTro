package controller;

import dao.*;
import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.Calendar;
import java.util.List;

/**
 * Bill Management Controller
 * Handles service bills, total bills, and invoice operations
 */
@Controller
@RequestMapping("/admin")
public class BillController {
    
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    @Autowired
    private ServiceUsageDAO serviceUsageDAO;
    
    @Autowired
    private AdditionalCostDAO additionalCostDAO;
    
    @Autowired
    private TenantDAO tenantDAO;
    
    @Autowired
    private ServiceDAO serviceDAO;
    
    @Autowired
    private RoomDAO roomDAO;
    
    /**
     * Check if user is admin
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
     * Show bills management page
     */
    @GetMapping("/bills")
    public String showBillsPage(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Invoice> invoices = invoiceDAO.getAllInvoices();
        
        model.addAttribute("user", user);
        model.addAttribute("invoices", invoices);
        model.addAttribute("pageTitle", "Quản lý Hóa đơn");
        model.addAttribute("totalInvoices", invoiceDAO.getTotalInvoiceCount());
        model.addAttribute("unpaidInvoices", invoiceDAO.getUnpaidInvoiceCount());
        model.addAttribute("totalRevenue", invoiceDAO.getTotalRevenue());
        
        return "admin/bills";
    }
    
    /**
     * Show service usage management page
     */
    @GetMapping("/service-usage")
    public String showServiceUsagePage(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<ServiceUsage> usageList = serviceUsageDAO.getAllServiceUsage();
        
        model.addAttribute("user", user);
        model.addAttribute("serviceUsages", usageList);
        model.addAttribute("pageTitle", "Quản lý Sử dụng Dịch vụ");
        
        return "admin/service-usage";
    }
    
    /**
     * Show add service usage form
     */
    @GetMapping("/service-usage/add")
    public String showAddServiceUsageForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Tenant> tenants = tenantDAO.getAllTenants();
        List<Service> services = serviceDAO.getAllServices();
        
        // Get current month and year for default values
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH is 0-based
        int currentYear = cal.get(Calendar.YEAR);
        
        model.addAttribute("user", user);
        model.addAttribute("serviceUsage", new ServiceUsage());
        model.addAttribute("tenants", tenants);
        model.addAttribute("services", services);
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("currentYear", currentYear);
        model.addAttribute("pageTitle", "Nhập Sử dụng Dịch vụ");
        model.addAttribute("action", "add");
        
        return "admin/service-usage-form";
    }
    
    /**
     * Process add service usage
     */
    @PostMapping("/service-usage/add")
    public String processAddServiceUsage(@ModelAttribute ServiceUsage serviceUsage,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Validate input
        String validationError = validateServiceUsage(serviceUsage, true);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/service-usage/add";
        }
        
        // Check if service usage already exists for this tenant, service, and period
        if (serviceUsageDAO.serviceUsageExists(serviceUsage.getTenantId(), serviceUsage.getServiceId(),
                                             serviceUsage.getMonth(), serviceUsage.getYear())) {
            redirectAttributes.addFlashAttribute("error", "Đã có dữ liệu sử dụng dịch vụ cho kỳ này");
            return "redirect:/admin/service-usage/add";
        }
        
        // Add service usage
        boolean success = serviceUsageDAO.addServiceUsage(serviceUsage);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Thêm dữ liệu sử dụng dịch vụ thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Thêm dữ liệu sử dụng dịch vụ thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/service-usage";
    }
    
    /**
     * Show edit service usage form
     */
    @GetMapping("/service-usage/edit/{id}")
    public String showEditServiceUsageForm(@PathVariable int id,
                                         HttpSession session,
                                         Model model,
                                         RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        ServiceUsage serviceUsage = serviceUsageDAO.getServiceUsageById(id);
        if (serviceUsage == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy dữ liệu sử dụng dịch vụ");
            return "redirect:/admin/service-usage";
        }
        
        User user = (User) session.getAttribute("user");
        List<Tenant> tenants = tenantDAO.getAllTenants();
        List<Service> services = serviceDAO.getAllServices();
        
        model.addAttribute("user", user);
        model.addAttribute("serviceUsage", serviceUsage);
        model.addAttribute("tenants", tenants);
        model.addAttribute("services", services);
        model.addAttribute("pageTitle", "Chỉnh sửa Sử dụng Dịch vụ");
        model.addAttribute("action", "edit");
        
        return "admin/service-usage-form";
    }
    
    /**
     * Process edit service usage
     */
    @PostMapping("/service-usage/edit/{id}")
    public String processEditServiceUsage(@PathVariable int id,
                                        @ModelAttribute ServiceUsage serviceUsage,
                                        HttpSession session,
                                        RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Verify service usage exists
        ServiceUsage existingUsage = serviceUsageDAO.getServiceUsageById(id);
        if (existingUsage == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy dữ liệu sử dụng dịch vụ");
            return "redirect:/admin/service-usage";
        }
        
        // Validate input
        String validationError = validateServiceUsage(serviceUsage, false);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/service-usage/edit/" + id;
        }
        
        // Set usage ID
        serviceUsage.setUsageId(id);
        
        // Update service usage
        boolean success = serviceUsageDAO.updateServiceUsage(serviceUsage);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Cập nhật dữ liệu sử dụng dịch vụ thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Cập nhật dữ liệu sử dụng dịch vụ thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/service-usage";
    }
    
    /**
     * Delete service usage
     */
    @PostMapping("/service-usage/delete/{id}")
    public String deleteServiceUsage(@PathVariable int id,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        ServiceUsage serviceUsage = serviceUsageDAO.getServiceUsageById(id);
        if (serviceUsage == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy dữ liệu sử dụng dịch vụ");
            return "redirect:/admin/service-usage";
        }
        
        boolean success = serviceUsageDAO.deleteServiceUsage(id);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Xóa dữ liệu sử dụng dịch vụ thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Xóa dữ liệu sử dụng dịch vụ thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/service-usage";
    }
    
    /**
     * Show generate bill form (Step 1: Select tenant and period)
     */
    @GetMapping("/bills/generate")
    public String showGenerateBillForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Tenant> tenants = tenantDAO.getAllTenants();
        
        // Get current month and year for default values
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH is 0-based
        int currentYear = cal.get(Calendar.YEAR);
        
        model.addAttribute("user", user);
        model.addAttribute("tenants", tenants);
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("currentYear", currentYear);
        model.addAttribute("pageTitle", "Tạo Hóa đơn - Chọn người thuê");
        
        return "admin/generate-bill";
    }
    
    /**
     * Show service usage input form (Step 2: Enter service quantities)
     */
    @PostMapping("/bills/generate/services")
    public String showServiceUsageForm(@RequestParam int tenantId,
                                     @RequestParam int month,
                                     @RequestParam int year,
                                     HttpSession session,
                                     Model model,
                                     RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Validate input
        if (month < 1 || month > 12 || year < 2000 || year > 2100) {
            redirectAttributes.addFlashAttribute("error", "Tháng và năm không hợp lệ");
            return "redirect:/admin/bills/generate";
        }
        
        // Check if invoice already exists for this period
        if (invoiceDAO.invoiceExistsForPeriod(tenantId, month, year)) {
            redirectAttributes.addFlashAttribute("error", "Đã có hóa đơn cho kỳ này");
            return "redirect:/admin/bills/generate";
        }
        
        // Get tenant information
        Tenant tenant = tenantDAO.getTenantById(tenantId);
        if (tenant == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người thuê");
            return "redirect:/admin/bills/generate";
        }
        
        // Get room information
        Room room = roomDAO.getRoomById(tenant.getRoomId());
        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
            return "redirect:/admin/bills/generate";
        }
        
        // Get all available services (simplified to avoid potential database issues)
        List<Service> services = serviceDAO.getAllServices();
        
        // TODO: Later, we can implement tenant-specific services once the basic flow works
        // List<Service> servicesUsedByTenant = serviceDAO.getServicesUsedByTenant(tenantId);
        // if (!servicesUsedByTenant.isEmpty()) {
        //     services = servicesUsedByTenant;
        // }
        
        // Get existing service usages for this tenant and period
        List<ServiceUsage> existingUsages = serviceUsageDAO.getServiceUsageByTenantAndPeriod(tenantId, month, year);
        
        // Get additional costs for this tenant and period
        List<AdditionalCost> additionalCosts = additionalCostDAO.getAdditionalCostsByTenantAndPeriod(tenantId, month, year);
        BigDecimal additionalTotal = additionalCosts.stream()
                .map(AdditionalCost::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("tenant", tenant);
        model.addAttribute("room", room);
        model.addAttribute("services", services);
        model.addAttribute("existingUsages", existingUsages);
        model.addAttribute("additionalCosts", additionalCosts);
        model.addAttribute("additionalTotal", additionalTotal);
        model.addAttribute("tenantId", tenantId);
        model.addAttribute("month", month);
        model.addAttribute("year", year);
        model.addAttribute("pageTitle", "Tạo Hóa đơn - Nhập sử dụng dịch vụ");
        
        return "admin/generate-bill-services";
    }
    
    /**
     * Process service usage and generate final bill (Step 3: Create bill with service quantities)
     */
    @PostMapping("/bills/generate/final")
    public String generateBillWithServices(@RequestParam int tenantId,
                                         @RequestParam int month,
                                         @RequestParam int year,
                                         @RequestParam(required = false) List<Integer> serviceIds,
                                         @RequestParam(required = false) List<String> quantities,
                                         HttpSession session,
                                         RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        try {
            // Validate basic input
            if (month < 1 || month > 12 || year < 2000 || year > 2100) {
                redirectAttributes.addFlashAttribute("error", "Tháng và năm không hợp lệ");
                return "redirect:/admin/bills/generate";
            }
            
            // Check if invoice already exists for this period
            if (invoiceDAO.invoiceExistsForPeriod(tenantId, month, year)) {
                redirectAttributes.addFlashAttribute("error", "Đã có hóa đơn cho kỳ này");
                return "redirect:/admin/bills/generate";
            }
            
            // Get tenant and room information
            Tenant tenant = tenantDAO.getTenantById(tenantId);
            if (tenant == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người thuê");
                return "redirect:/admin/bills/generate";
            }
            
            Room room = roomDAO.getRoomById(tenant.getRoomId());
            if (room == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
                return "redirect:/admin/bills/generate";
            }
            
            // Process service usage data
            if (serviceIds != null && quantities != null && serviceIds.size() == quantities.size()) {
                for (int i = 0; i < serviceIds.size(); i++) {
                    int serviceId = serviceIds.get(i);
                    String quantityStr = quantities.get(i);
                    
                    if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                        try {
                            BigDecimal quantity = new BigDecimal(quantityStr.trim());
                            
                            // Check if service usage already exists
                            if (serviceUsageDAO.serviceUsageExists(tenantId, serviceId, month, year)) {
                                // Update existing usage
                                ServiceUsage existingUsage = serviceUsageDAO.getServiceUsageByTenantAndPeriod(tenantId, month, year)
                                    .stream()
                                    .filter(usage -> usage.getServiceId() == serviceId)
                                    .findFirst()
                                    .orElse(null);
                                
                                if (existingUsage != null) {
                                    existingUsage.setQuantity(quantity);
                                    serviceUsageDAO.updateServiceUsage(existingUsage);
                                }
                            } else {
                                // Create new usage record
                                ServiceUsage newUsage = new ServiceUsage(tenantId, serviceId, month, year, quantity);
                                serviceUsageDAO.addServiceUsage(newUsage);
                            }
                        } catch (NumberFormatException e) {
                            redirectAttributes.addFlashAttribute("error", "Số lượng sử dụng dịch vụ không hợp lệ: " + quantityStr);
                            return "redirect:/admin/bills/generate";
                        }
                    }
                }
            }
            
            // Calculate totals after updating service usage
            BigDecimal roomPrice = room.getPrice();
            BigDecimal serviceTotal = serviceUsageDAO.calculateServiceTotal(tenantId, month, year);
            BigDecimal additionalTotal = additionalCostDAO.calculateAdditionalTotal(tenantId, month, year);
            
            // Ensure no nulls in calculations
            roomPrice = roomPrice != null ? roomPrice : BigDecimal.ZERO;
            serviceTotal = serviceTotal != null ? serviceTotal : BigDecimal.ZERO;
            additionalTotal = additionalTotal != null ? additionalTotal : BigDecimal.ZERO;
            
            BigDecimal totalAmount = roomPrice.add(serviceTotal).add(additionalTotal);
            
            // Create invoice
            Invoice invoice = new Invoice(tenantId, month, year, roomPrice, serviceTotal, additionalTotal, totalAmount);
            invoice.setStatus("UNPAID");
            
            boolean success = invoiceDAO.createInvoice(invoice);
            
            if (success) {
                redirectAttributes.addFlashAttribute("success", 
                    "Tạo hóa đơn thành công! Tổng tiền: " + totalAmount.toString() + " VND");
            } else {
                redirectAttributes.addFlashAttribute("error", "Tạo hóa đơn thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/bills/generate";
        }
        
        return "redirect:/admin/bills";
    }
    
    /**
     * Generate bill for tenant (Legacy method - kept for backwards compatibility)
     */
    @PostMapping("/bills/generate")
    public String generateBill(@RequestParam int tenantId,
                             @RequestParam int month,
                             @RequestParam int year,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Validate input
        if (month < 1 || month > 12 || year < 2000 || year > 2100) {
            redirectAttributes.addFlashAttribute("error", "Tháng và năm không hợp lệ");
            return "redirect:/admin/bills/generate";
        }
        
        // Check if invoice already exists for this period
        if (invoiceDAO.invoiceExistsForPeriod(tenantId, month, year)) {
            redirectAttributes.addFlashAttribute("error", "Đã có hóa đơn cho kỳ này");
            return "redirect:/admin/bills/generate";
        }
        
        // Get tenant information
        Tenant tenant = tenantDAO.getTenantById(tenantId);
        if (tenant == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người thuê");
            return "redirect:/admin/bills/generate";
        }
        
        // Get room price
        Room room = roomDAO.getRoomById(tenant.getRoomId());
        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
            return "redirect:/admin/bills/generate";
        }
        
        // Calculate totals
        BigDecimal roomPrice = room.getPrice();
        BigDecimal serviceTotal = serviceUsageDAO.calculateServiceTotal(tenantId, month, year);
        BigDecimal additionalTotal = additionalCostDAO.calculateAdditionalTotal(tenantId, month, year);
        
        // Ensure no nulls in calculations
        roomPrice = roomPrice != null ? roomPrice : BigDecimal.ZERO;
        serviceTotal = serviceTotal != null ? serviceTotal : BigDecimal.ZERO;
        additionalTotal = additionalTotal != null ? additionalTotal : BigDecimal.ZERO;
        
        BigDecimal totalAmount = roomPrice.add(serviceTotal).add(additionalTotal);
        
        // Create invoice
        Invoice invoice = new Invoice(tenantId, month, year, roomPrice, serviceTotal, additionalTotal, totalAmount);
        invoice.setStatus("UNPAID");
        
        boolean success = invoiceDAO.createInvoice(invoice);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Tạo hóa đơn thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Tạo hóa đơn thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/bills";
    }
    
    /**
     * View invoice details
     */
    @GetMapping("/bills/view/{id}")
    public String viewInvoice(@PathVariable int id,
                            HttpSession session,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Invoice invoice = invoiceDAO.getInvoiceById(id);
        if (invoice == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy hóa đơn");
            return "redirect:/admin/bills";
        }
        
        User user = (User) session.getAttribute("user");
        
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
        
        return "admin/bill-detail";
    }
    
    /**
     * Update invoice status (mark as paid/unpaid)
     */
    @PostMapping("/bills/update-status/{id}")
    public String updateInvoiceStatus(@PathVariable int id,
                                    @RequestParam String status,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Invoice invoice = invoiceDAO.getInvoiceById(id);
        if (invoice == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy hóa đơn");
            return "redirect:/admin/bills";
        }
        
        if (!"PAID".equals(status) && !"UNPAID".equals(status)) {
            redirectAttributes.addFlashAttribute("error", "Trạng thái không hợp lệ");
            return "redirect:/admin/bills/view/" + id;
        }
        
        boolean success = invoiceDAO.updateInvoiceStatus(id, status);
        
        if (success) {
            String statusText = "PAID".equals(status) ? "Đã thanh toán" : "Chưa thanh toán";
            redirectAttributes.addFlashAttribute("success", "Cập nhật trạng thái thành " + statusText + " thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Cập nhật trạng thái thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/bills/view/" + id;
    }
    
    /**
     * Delete invoice
     */
    @PostMapping("/bills/delete/{id}")
    public String deleteInvoice(@PathVariable int id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Invoice invoice = invoiceDAO.getInvoiceById(id);
        if (invoice == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy hóa đơn");
            return "redirect:/admin/bills";
        }
        
        boolean success = invoiceDAO.deleteInvoice(id);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Xóa hóa đơn thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Xóa hóa đơn thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/bills";
    }
    
    /**
     * Validate service usage data
     */
    private String validateServiceUsage(ServiceUsage serviceUsage, boolean isNew) {
        if (serviceUsage.getTenantId() <= 0) {
            return "Vui lòng chọn người thuê";
        }
        
        if (serviceUsage.getServiceId() <= 0) {
            return "Vui lòng chọn dịch vụ";
        }
        
        if (serviceUsage.getMonth() < 1 || serviceUsage.getMonth() > 12) {
            return "Tháng không hợp lệ";
        }
        
        if (serviceUsage.getYear() < 2000 || serviceUsage.getYear() > 2100) {
            return "Năm không hợp lệ";
        }
        
        if (serviceUsage.getQuantity() == null || serviceUsage.getQuantity().compareTo(BigDecimal.ZERO) < 0) {
            return "Số lượng sử dụng phải lớn hơn hoặc bằng 0";
        }
        
        return null; // Valid
    }
}

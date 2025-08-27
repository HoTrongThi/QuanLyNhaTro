package controller;

import dao.*;
import model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.ArrayList;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    
    @Autowired
    private MeterReadingDAO meterReadingDAO;
    
    @Autowired
    private MoMoDAO moMoDAO;
    
    @Autowired
    private GmailDAO gmailDAO;
    
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
        
        // For each invoice, get the room information and tenants count
        for (Invoice invoice : invoices) {
            // Get tenant information to find room
            Tenant tenant = tenantDAO.getTenantById(invoice.getTenantId());
            if (tenant != null) {
                // Get all tenants in the same room
                List<Tenant> tenantsInRoom = tenantDAO.getTenantsByRoomId(tenant.getRoomId());
                // Set additional info for display
                invoice.setTenantsCount(tenantsInRoom.size());
            }
        }
        
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
     * Show generate bill form (Step 1: Select room and period)
     */
    @GetMapping("/bills/generate")
    public String showGenerateBillForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Room> rooms = roomDAO.getAllRooms();
        
        // Get current month and year for default values
        Calendar cal = Calendar.getInstance();
        int currentMonth = cal.get(Calendar.MONTH) + 1; // Calendar.MONTH is 0-based
        int currentYear = cal.get(Calendar.YEAR);
        
        model.addAttribute("user", user);
        model.addAttribute("rooms", rooms);
        model.addAttribute("currentMonth", currentMonth);
        model.addAttribute("currentYear", currentYear);
        model.addAttribute("pageTitle", "Tạo Hóa đơn - Chọn phòng");
        
        return "admin/generate-bill";
    }
    
    /**
     * Show service usage input form (Step 2: Enter service quantities)
     */
    @PostMapping("/bills/generate/services")
    public String showServiceUsageForm(@RequestParam int roomId,
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
        
        // Get room information
        Room room = roomDAO.getRoomById(roomId);
        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
            return "redirect:/admin/bills/generate";
        }
        
        // Check if invoice already exists for this room and period
        if (invoiceDAO.invoiceExistsForRoomAndPeriod(roomId, month, year)) {
            redirectAttributes.addFlashAttribute("error", "Đã có hóa đơn cho phòng này trong kỳ này");
            return "redirect:/admin/bills/generate";
        }
        
        // Get tenants in this room
        List<Tenant> tenantsInRoom = tenantDAO.getTenantsByRoomId(roomId);
        
        // Calculate prorated room price for display
        BigDecimal fullRoomPrice = room.getPrice();
        BigDecimal proratedRoomPrice = calculateProratedRoomPrice(fullRoomPrice, tenantsInRoom, month, year);
        
        // Calculate days information for display
        int daysInMonth = getDaysInMonth(month, year);
        int daysStayed = calculateDaysStayed(tenantsInRoom, month, year);
        Date earliestStartDate = getEarliestStartDate(tenantsInRoom, month, year);
        
        // Get all available services (simplified to avoid potential database issues)
        List<Service> services = serviceDAO.getAllServices();
        
        // TODO: Later, we can implement room-specific services once the basic flow works
        // List<Service> servicesUsedByRoom = serviceDAO.getServicesUsedByRoom(roomId);
        // if (!servicesUsedByRoom.isEmpty()) {
        //     services = servicesUsedByRoom;
        // }
        
        // Get existing service usages for this room and period
        List<ServiceUsage> existingUsages = serviceUsageDAO.getServiceUsageByRoomAndPeriod(roomId, month, year);
        
        // Get additional costs for this room and period
        List<AdditionalCost> additionalCosts = additionalCostDAO.getAdditionalCostsByRoomAndPeriod(roomId, month, year);
        BigDecimal additionalTotal = additionalCosts.stream()
                .map(AdditionalCost::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("room", room);
        model.addAttribute("fullRoomPrice", fullRoomPrice);
        model.addAttribute("proratedRoomPrice", proratedRoomPrice);
        model.addAttribute("isProrated", proratedRoomPrice.compareTo(fullRoomPrice) < 0);
        model.addAttribute("daysInMonth", daysInMonth);
        model.addAttribute("daysStayed", daysStayed);
        model.addAttribute("earliestStartDate", earliestStartDate);
        model.addAttribute("tenantsInRoom", tenantsInRoom);
        model.addAttribute("services", services);
        model.addAttribute("existingUsages", existingUsages);
        model.addAttribute("additionalCosts", additionalCosts);
        model.addAttribute("additionalTotal", additionalTotal);
        model.addAttribute("roomId", roomId);
        model.addAttribute("month", month);
        model.addAttribute("year", year);
        model.addAttribute("pageTitle", "Tạo Hóa đơn - Nhập sử dụng dịch vụ");
        
        return "admin/generate-bill-services";
    }
    
    /**
     * Process service usage and generate final bill (Step 3: Create bill with service quantities)
     */
    @PostMapping("/bills/generate/final")
    public String generateBillWithServices(@RequestParam int roomId,
                                         @RequestParam int month,
                                         @RequestParam int year,
                                         @RequestParam(required = false) List<Integer> serviceIds,
                                         @RequestParam(required = false) List<String> currentReadings,
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
            
            // Check if invoice already exists for this room and period
            if (invoiceDAO.invoiceExistsForRoomAndPeriod(roomId, month, year)) {
                redirectAttributes.addFlashAttribute("error", "Đã có hóa đơn cho phòng này trong kỳ này");
                return "redirect:/admin/bills/generate";
            }
            
            // Get room information
            Room room = roomDAO.getRoomById(roomId);
            if (room == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
                return "redirect:/admin/bills/generate";
            }
            
            // Get tenants in this room
            List<Tenant> tenantsInRoom = tenantDAO.getTenantsByRoomId(roomId);
            if (tenantsInRoom.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Không có người thuê nào trong phòng này");
                return "redirect:/admin/bills/generate";
            }
            
            // Process meter readings for electricity and water services
            // For room-based billing, we'll use the first tenant (by ID) for meter readings
            // This must match the logic in ServiceUsageDAO.calculateServiceTotalByRoom()
            int representativeTenantId = tenantsInRoom.stream()
                .mapToInt(Tenant::getTenantId)
                .min()
                .orElse(0);
            
            if (representativeTenantId == 0) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người thuê đại diện cho phòng này");
                return "redirect:/admin/bills/generate";
            }
            
            if (serviceIds != null && currentReadings != null) {
                // Process meter readings - match services that have meters with readings
                int readingIndex = 0;
                for (int i = 0; i < serviceIds.size(); i++) {
                    int serviceId = serviceIds.get(i);
                    
                    // Check if this service uses meter readings (electricity, water)
                    Service service = serviceDAO.getServiceById(serviceId);
                    if (service != null) {
                        String serviceName = service.getServiceName().toLowerCase();
                        boolean hasMeter = serviceName.contains("điện") || serviceName.contains("nước") || 
                                          serviceName.contains("electric") || serviceName.contains("water");
                        
                        if (hasMeter && readingIndex < currentReadings.size()) {
                            String currentReadingStr = currentReadings.get(readingIndex);
                            readingIndex++; // Increment for next meter service
                            
                            if (currentReadingStr != null && !currentReadingStr.trim().isEmpty()) {
                                try {
                                    BigDecimal currentReading = new BigDecimal(currentReadingStr.trim());
                                    
                                    // Get previous meter reading (using representative tenant)
                                    MeterReading previousReading = meterReadingDAO.getPreviousMeterReading(representativeTenantId, serviceId, month, year);
                                    BigDecimal previousReadingValue = BigDecimal.ZERO;
                                    
                                    if (previousReading != null) {
                                        previousReadingValue = previousReading.getReading();
                                    } else {
                                        // If no previous reading found, check for initial reading in the same period
                                        // This handles new tenants who have initial readings for their first month
                                        MeterReading initialReading = meterReadingDAO.getMeterReadingByTenantServiceAndPeriod(
                                            representativeTenantId, serviceId, month, year);
                                        if (initialReading != null) {
                                            // Use initial reading as the starting point
                                            previousReadingValue = initialReading.getReading();
                                        }
                                    }
                                    
                                    // Calculate consumption
                                    BigDecimal consumption = currentReading.subtract(previousReadingValue);
                                    if (consumption.compareTo(BigDecimal.ZERO) < 0) {
                                        consumption = BigDecimal.ZERO; // Prevent negative consumption
                                    }
                                    
                                    // Save current meter reading (using representative tenant)
                                    Date currentDate = Date.valueOf(java.time.LocalDate.now());
                                    MeterReading newReading = new MeterReading(representativeTenantId, serviceId, currentReading, currentDate, month, year);
                                    
                                    // Check if meter reading already exists for this period
                                    if (meterReadingDAO.meterReadingExists(representativeTenantId, serviceId, month, year)) {
                                        // Update existing reading
                                        MeterReading existingReading = meterReadingDAO.getMeterReadingByTenantServiceAndPeriod(representativeTenantId, serviceId, month, year);
                                        if (existingReading != null) {
                                            existingReading.setReading(currentReading);
                                            existingReading.setReadingDate(currentDate);
                                            meterReadingDAO.updateMeterReading(existingReading);
                                        }
                                    } else {
                                        // Add new meter reading
                                        meterReadingDAO.addMeterReading(newReading);
                                    }
                                    
                                    // Update or create service usage record with calculated consumption (using representative tenant)
                                    if (serviceUsageDAO.serviceUsageExists(representativeTenantId, serviceId, month, year)) {
                                        // Update existing usage
                                        ServiceUsage existingUsage = serviceUsageDAO.getServiceUsageByTenantAndPeriod(representativeTenantId, month, year)
                                            .stream()
                                            .filter(usage -> usage.getServiceId() == serviceId)
                                            .findFirst()
                                            .orElse(null);
                                        
                                        if (existingUsage != null) {
                                            existingUsage.setQuantity(consumption);
                                            serviceUsageDAO.updateServiceUsage(existingUsage);
                                        }
                                    } else {
                                        // Create new usage record
                                        ServiceUsage newUsage = new ServiceUsage(representativeTenantId, serviceId, month, year, consumption);
                                        serviceUsageDAO.addServiceUsage(newUsage);
                                    }
                                    
                                } catch (NumberFormatException e) {
                                    redirectAttributes.addFlashAttribute("error", "Chỉ số công tơ không hợp lệ: " + currentReadingStr);
                                    return "redirect:/admin/bills/generate";
                                }
                            }
                        }
                    }
                }
            }
            
            // Process quantities for other services (Internet, parking, etc.)
            if (serviceIds != null && quantities != null) {
                // Process quantities - match by index
                int maxIndex = Math.min(serviceIds.size(), quantities.size());
                for (int i = 0; i < maxIndex; i++) {
                    int serviceId = serviceIds.get(i);
                    String quantityStr = (i < quantities.size()) ? quantities.get(i) : null;
                    
                    // Check if this service doesn't use meter readings
                    Service service = serviceDAO.getServiceById(serviceId);
                    if (service != null) {
                        String serviceName = service.getServiceName().toLowerCase();
                        boolean hasMeter = serviceName.contains("điện") || serviceName.contains("nước") || 
                                          serviceName.contains("electric") || serviceName.contains("water");
                        
                        if (!hasMeter && quantityStr != null && !quantityStr.trim().isEmpty()) {
                            try {
                                BigDecimal quantity = new BigDecimal(quantityStr.trim());
                                
                                // Update or create service usage record with quantity (using representative tenant)
                                if (serviceUsageDAO.serviceUsageExists(representativeTenantId, serviceId, month, year)) {
                                    // Update existing usage
                                    ServiceUsage existingUsage = serviceUsageDAO.getServiceUsageByTenantAndPeriod(representativeTenantId, month, year)
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
                                    ServiceUsage newUsage = new ServiceUsage(representativeTenantId, serviceId, month, year, quantity);
                                    serviceUsageDAO.addServiceUsage(newUsage);
                                }
                                
                            } catch (NumberFormatException e) {
                                redirectAttributes.addFlashAttribute("error", "Số lượng dịch vụ không hợp lệ: " + quantityStr);
                                return "redirect:/admin/bills/generate";
                            }
                        }
                    }
                }
            }
            
            // Calculate totals after updating service usage - now room-based
            BigDecimal fullRoomPrice = room.getPrice();
            
            // Calculate prorated room price based on actual days stayed
            BigDecimal roomPrice = calculateProratedRoomPrice(fullRoomPrice, tenantsInRoom, month, year);
            
            BigDecimal serviceTotal = serviceUsageDAO.calculateServiceTotalByRoom(roomId, month, year);
            BigDecimal additionalTotal = additionalCostDAO.calculateAdditionalTotalByRoom(roomId, month, year);
            
            // Ensure no nulls in calculations
            roomPrice = roomPrice != null ? roomPrice : BigDecimal.ZERO;
            serviceTotal = serviceTotal != null ? serviceTotal : BigDecimal.ZERO;
            additionalTotal = additionalTotal != null ? additionalTotal : BigDecimal.ZERO;
            
            BigDecimal totalAmount = roomPrice.add(serviceTotal).add(additionalTotal);
            
            // Create invoice using the representative tenant (representing the room)
            Invoice invoice = new Invoice(representativeTenantId, month, year, roomPrice, serviceTotal, additionalTotal, totalAmount);
            invoice.setStatus("UNPAID");
            
            boolean success = invoiceDAO.createInvoice(invoice);
            
            if (success) {
                // Generate MoMo QR Code after successful invoice creation
                try {
                    String orderInfo = "Thanh toán hóa đơn phòng " + room.getRoomName() + " - " + 
                                     String.format("%02d/%d", month, year);
                    
                    MoMoResponse moMoResponse = moMoDAO.createQRCode(invoice.getInvoiceId(), totalAmount, orderInfo);
                    
                    if (moMoResponse.isSuccess() && moMoResponse.hasQrCode()) {
                        // Update invoice with MoMo information
                        invoiceDAO.updateMoMoPaymentInfo(
                            invoice.getInvoiceId(),
                            moMoResponse.getQrCodeUrl(),
                            moMoResponse.getOrderId(),
                            moMoResponse.getRequestId(),
                            "PENDING"
                        );
                    }
                } catch (Exception e) {
                    System.err.println("Error creating MoMo QR Code: " + e.getMessage());
                    // Don't fail the invoice creation if MoMo fails
                }
                
                // Send Email notifications to all tenants in the room with QR code
                try {
                    String period = String.format("%02d/%d", month, year);
                    String formattedAmount = String.format("%,.0f", totalAmount.doubleValue());
                    
                    // Get QR code URL from the created invoice
                    String qrCodeUrl = null;
                    try {
                        Invoice createdInvoice = invoiceDAO.getInvoiceById(invoice.getInvoiceId());
                        if (createdInvoice != null && createdInvoice.getMomoQrCodeUrl() != null) {
                            qrCodeUrl = createdInvoice.getMomoQrCodeUrl();
                        }
                    } catch (Exception e) {
                        System.err.println("Error getting QR code URL: " + e.getMessage());
                    }
                    
                    int emailSuccessCount = 0;
                    
                    for (Tenant tenant : tenantsInRoom) {
                        if (tenant.getEmail() != null && !tenant.getEmail().trim().isEmpty()) {
                            boolean emailSuccess = gmailDAO.sendInvoiceNotificationWithQR(
                                tenant.getEmail(),
                                tenant.getFullName(),
                                room.getRoomName(),
                                period,
                                formattedAmount,
                                qrCodeUrl
                            );
                            
                            if (emailSuccess) {
                                emailSuccessCount++;
                            }
                        }
                    }
                    
                } catch (Exception e) {
                    System.err.println("Error sending Email notifications: " + e.getMessage());
                    // Don't fail the invoice creation if Email fails
                }
                
                String tenantNames = tenantsInRoom.stream()
                    .map(Tenant::getFullName)
                    .reduce((a, b) -> a + ", " + b)
                    .orElse("Không xác định");
                
                // Check if room price was prorated
                String priceInfo = "";
                if (roomPrice.compareTo(fullRoomPrice) < 0) {
                    priceInfo = " (Tiền phòng đã được tính theo tỷ lệ ngày ở thực tế)";
                }
                
                // Build success message with SMS info
                StringBuilder successMessage = new StringBuilder();
                successMessage.append("Tạo hóa đơn thành công cho phòng ").append(room.getRoomName())
                             .append(" (").append(tenantNames).append(")! Tổng tiền: ")
                             .append(String.format("%,.0f", totalAmount.doubleValue())).append(" VNĐ")
                             .append(priceInfo);
                
                // Add Email notification info if any Email was attempted
                try {
                    int tenantsWithEmail = (int) tenantsInRoom.stream()
                        .filter(t -> t.getEmail() != null && !t.getEmail().trim().isEmpty())
                        .count();
                    
                    if (tenantsWithEmail > 0) {
                        successMessage.append(" Đã gửi thông báo Email tới ")
                                     .append(tenantsWithEmail).append(" người thuê");
                        
                        // Check if QR code was included
                        try {
                            Invoice createdInvoice = invoiceDAO.getInvoiceById(invoice.getInvoiceId());
                            if (createdInvoice != null && createdInvoice.getMomoQrCodeUrl() != null && !createdInvoice.getMomoQrCodeUrl().trim().isEmpty()) {
                                successMessage.append(" (bao gồm mã QR MoMo)");
                            }
                        } catch (Exception e) {
                            // Ignore QR check error
                        }
                        
                        successMessage.append(".");
                    }
                } catch (Exception e) {
                    // Ignore Email count error
                }
                
                redirectAttributes.addFlashAttribute("success", successMessage.toString());
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
        BigDecimal fullRoomPrice = room.getPrice();
        
        // Calculate prorated room price for this tenant
        List<Tenant> singleTenantList = new ArrayList<>();
        singleTenantList.add(tenant);
        BigDecimal roomPrice = calculateProratedRoomPrice(fullRoomPrice, singleTenantList, month, year);
        
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
        
        // Get tenant information to find room
        Tenant tenant = tenantDAO.getTenantById(invoice.getTenantId());
        if (tenant == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin người thuê");
            return "redirect:/admin/bills";
        }
        
        // Get all tenants in the same room for room-based billing
        List<Tenant> tenantsInRoom = tenantDAO.getTenantsByRoomId(tenant.getRoomId());
        
        // Get detailed breakdowns - now room-based and aggregated
        List<ServiceUsage> roomUsages = serviceUsageDAO.getServiceUsageByRoomAndPeriod(
            tenant.getRoomId(), invoice.getMonth(), invoice.getYear()
        );
        List<ServiceUsage> serviceUsages = aggregateServiceUsagesByService(roomUsages);
        
        List<AdditionalCost> additionalCosts = additionalCostDAO.getAdditionalCostsByRoomAndPeriod(
            tenant.getRoomId(), invoice.getMonth(), invoice.getYear()
        );
        
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
        
        model.addAttribute("user", user);
        model.addAttribute("invoice", invoice);
        model.addAttribute("tenant", tenant);
        model.addAttribute("tenantsInRoom", tenantsInRoom);
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
     * Get previous meter reading for AJAX call using JSP
     */
    @GetMapping("/api/meter-readings/previous")
    public String getPreviousMeterReadingJsp(@RequestParam int roomId,
                                             @RequestParam int serviceId,
                                             @RequestParam int month,
                                             @RequestParam int year,
                                             HttpSession session,
                                             Model model) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            model.addAttribute("error", "Access denied");
            return "admin/previous-meter-reading";
        }
        
        try {
            // Get tenants in this room
            List<Tenant> tenantsInRoom = tenantDAO.getTenantsByRoomId(roomId);
            
            if (tenantsInRoom.isEmpty()) {
                model.addAttribute("error", "No tenants in room");
                return "admin/previous-meter-reading";
            }
            
            // Try to find previous meter reading from any tenant in the room
            MeterReading previousReading = null;
            String foundTenantInfo = "";
            
            // First, try the representative tenant (minimum tenant ID) for consistency
            int representativeTenantId = tenantsInRoom.stream()
                .mapToInt(Tenant::getTenantId)
                .min()
                .orElse(0);
            
            // Try to get previous reading from earlier periods
            previousReading = meterReadingDAO.getPreviousMeterReading(representativeTenantId, serviceId, month, year);
            
            if (previousReading != null) {
                foundTenantInfo = "from representative tenant " + representativeTenantId;
            } else {
                // If not found, try all tenants in the room for previous periods
                for (Tenant tenant : tenantsInRoom) {
                    previousReading = meterReadingDAO.getPreviousMeterReading(tenant.getTenantId(), serviceId, month, year);
                    if (previousReading != null) {
                        foundTenantInfo = "from tenant " + tenant.getTenantId() + " (" + tenant.getFullName() + ")";
                        break;
                    }
                }
                
                // If still no previous reading found, check if this is the first month for new tenants
                // Look for initial reading in the same period (for new tenants)
                if (previousReading == null) {
                    // Try to find initial reading for the same period from any tenant in the room
                    // This handles the case where tenant moved in during the current month
                    for (Tenant tenant : tenantsInRoom) {
                        MeterReading initialReading = meterReadingDAO.getMeterReadingByTenantServiceAndPeriod(
                            tenant.getTenantId(), serviceId, month, year);
                        if (initialReading != null) {
                            // Use this as "previous" reading (it's actually the initial reading for this period)
                            previousReading = initialReading;
                            foundTenantInfo = "initial reading for " + month + "/" + year + " from tenant " + tenant.getTenantId() + " (" + tenant.getFullName() + ")";
                            break;
                        }
                    }
                }
            }
            
            if (previousReading != null) {
                model.addAttribute("previousReading", previousReading);
            }
            // No previous reading found - JSP will handle this case
            
            return "admin/previous-meter-reading";
            
        } catch (Exception e) {
            System.err.println("Error getting previous meter reading: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Error retrieving previous reading: " + e.getMessage());
            return "admin/previous-meter-reading";
        }
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
    
    /**
     * Calculate prorated room price based on actual days stayed in the month
     * For tenants who moved in during the month, only charge for days actually stayed
     */
    private BigDecimal calculateProratedRoomPrice(BigDecimal fullRoomPrice, List<Tenant> tenantsInRoom, int month, int year) {
        if (tenantsInRoom == null || tenantsInRoom.isEmpty()) {
            return BigDecimal.ZERO;
        }
        
        // Get the number of days in the billing month
        int daysInMonth = getDaysInMonth(month, year);
        
        // Find the earliest start date among all tenants in the room for this month
        Date earliestStartDate = null;
        boolean needsProration = false;
        
        for (Tenant tenant : tenantsInRoom) {
            Date startDate = tenant.getStartDate();
            if (startDate != null) {
                // Check if tenant started in this month/year
                java.time.LocalDate startLocalDate = startDate.toLocalDate();
                if (startLocalDate.getYear() == year && startLocalDate.getMonthValue() == month) {
                    // Tenant started in this billing month - needs proration
                    needsProration = true;
                    if (earliestStartDate == null || startDate.before(earliestStartDate)) {
                        earliestStartDate = startDate;
                    }
                } else if (startLocalDate.isBefore(java.time.LocalDate.of(year, month, 1))) {
                    // Tenant started before this month - no proration needed for this tenant
                    // Continue checking other tenants
                }
            }
        }
        
        // If no tenant started in this month, charge full month
        if (!needsProration || earliestStartDate == null) {
            return fullRoomPrice;
        }
        
        // Calculate the number of days to charge
        java.time.LocalDate startLocalDate = earliestStartDate.toLocalDate();
        java.time.LocalDate endOfMonth = java.time.LocalDate.of(year, month, daysInMonth);
        
        // Calculate days from start date to end of month (inclusive)
        int daysToCharge = (int) java.time.temporal.ChronoUnit.DAYS.between(startLocalDate, endOfMonth) + 1;
        
        // Ensure we don't charge for more days than in the month
        daysToCharge = Math.min(daysToCharge, daysInMonth);
        daysToCharge = Math.max(daysToCharge, 1); // At least 1 day
        
        // If charging for full month, return full price to avoid rounding errors
        if (daysToCharge >= daysInMonth) {
            return fullRoomPrice;
        }
        
        // Calculate prorated amount
        BigDecimal dailyRate = fullRoomPrice.divide(new BigDecimal(daysInMonth), 2, java.math.RoundingMode.HALF_UP);
        BigDecimal proratedAmount = dailyRate.multiply(new BigDecimal(daysToCharge));
        
        return proratedAmount;
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
            return 0;
        }
        
        int daysInMonth = getDaysInMonth(month, year);
        
        // Check if any tenant started in this month
        boolean anyTenantStartedThisMonth = false;
        Date earliestStartDate = null;
        
        for (Tenant tenant : tenantsInRoom) {
            Date startDate = tenant.getStartDate();
            if (startDate != null) {
                java.time.LocalDate startLocalDate = startDate.toLocalDate();
                if (startLocalDate.getYear() == year && startLocalDate.getMonthValue() == month) {
                    anyTenantStartedThisMonth = true;
                    if (earliestStartDate == null || startDate.before(earliestStartDate)) {
                        earliestStartDate = startDate;
                    }
                }
            }
        }
        
        // If no tenant started in this month, they stayed the full month
        if (!anyTenantStartedThisMonth || earliestStartDate == null) {
            return daysInMonth;
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
     * Only returns a date if a tenant actually started in this month
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
                }
                // If tenant started before this month, we don't set earliestStartDate
                // because they should pay for the full month (no proration needed)
            }
        }
        
        return earliestStartDate;
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
        Map<Integer, ServiceUsage> serviceMap = new HashMap<>();
        
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
}

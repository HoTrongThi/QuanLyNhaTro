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
 * Controller quản lý Hóa đơn
 * Xử lý các chức năng liên quan đến hóa đơn, sử dụng dịch vụ và thanh toán
 * Bao gồm tạo hóa đơn, quản lý sử dụng dịch vụ, tích hợp MoMo và gửi email
 * Hỗ trợ tính toán tiền phòng theo tỷ lệ ngày ở thực tế
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Controller
@RequestMapping("/admin")
public class BillController {
    
    // ==================== CÁC THUỘC TÍNH DAO ====================
    
    /** DAO quản lý hóa đơn */
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    /** DAO quản lý sử dụng dịch vụ */
    @Autowired
    private ServiceUsageDAO serviceUsageDAO;
    
    /** DAO quản lý chi phí phát sinh */
    @Autowired
    private AdditionalCostDAO additionalCostDAO;
    
    /** DAO quản lý người thuê */
    @Autowired
    private TenantDAO tenantDAO;
    
    /** DAO quản lý dịch vụ */
    @Autowired
    private ServiceDAO serviceDAO;
    
    /** DAO quản lý phòng */
    @Autowired
    private RoomDAO roomDAO;
    
    /** DAO quản lý chỉ số công tơ */
    @Autowired
    private MeterReadingDAO meterReadingDAO;
    
    /** DAO tích hợp thanh toán MoMo */
    @Autowired
    private MoMoDAO moMoDAO;
    
    /** DAO gửi email thông báo */
    @Autowired
    private GmailDAO gmailDAO;
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra quyền truy cập của quản trị viên
     * Đảm bảo chỉ có admin mới có thể truy cập các chức năng quản lý hóa đơn
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
    
    // ==================== CÁC PHƯƠNG THỨC HIỂN THỊ TRANG ====================
    
    /**
     * Hiển thị trang quản lý hóa đơn
     * Liệt kê tất cả hóa đơn với thông tin chi tiết và thống kê
     * Hiển thị số lượng người thuê trong mỗi phòng
     * 
     * @param session HTTP Session để kiểm tra quyền
     * @param model Model để truyền dữ liệu đến view
     * @return tên view hoặc redirect URL
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
     * Hiển thị biểu mẫu tạo hóa đơn (Bước 1: Chọn phòng và thời gian)
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
     * Hiển thị biểu mẫu nhập liệu sử dụng dịch vụ (Bước 2: Nhập số lượng dịch vụ)
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
        
        // Tính giá phòng theo tỷ lệ:
        BigDecimal fullRoomPrice = room.getPrice();
        BigDecimal proratedRoomPrice = calculateProratedRoomPrice(fullRoomPrice, tenantsInRoom, month, year);
        
        // Tính toán thông tin ngày để hiển thị
        int daysInMonth = getDaysInMonth(month, year);
        int daysStayed = calculateDaysStayed(tenantsInRoom, month, year);
        Date earliestStartDate = getEarliestStartDate(tenantsInRoom, month, year);
        
        // Get all available services (simplified to avoid potential database issues)
        List<Service> services = serviceDAO.getAllServices();
        
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
     * Xử lý việc sử dụng dịch vụ và tạo hóa đơn cuối cùng (Bước 3: Tạo hóa đơn với số lượng dịch vụ)
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
            
            // Kiểm tra xem hóa đơn đã tồn tại cho phòng và thời gian này chưa
            if (invoiceDAO.invoiceExistsForRoomAndPeriod(roomId, month, year)) {
                redirectAttributes.addFlashAttribute("error", "Đã có hóa đơn cho phòng này trong kỳ này");
                return "redirect:/admin/bills/generate";
            }
            
            // Lấy thông tin phòng
            Room room = roomDAO.getRoomById(roomId);
            if (room == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
                return "redirect:/admin/bills/generate";
            }
            
            // Lấy người thuê trong phòng này
            List<Tenant> tenantsInRoom = tenantDAO.getTenantsByRoomId(roomId);
            if (tenantsInRoom.isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Không có người thuê nào trong phòng này");
                return "redirect:/admin/bills/generate";
            }
            
            // Xử lý số đọc đồng hồ điện và nước
            // Đối với thanh toán theo phòng, sẽ sử dụng người thuê đầu tiên (theo ID) để đọc số đọc đồng hồ
            // Điều này phải khớp với logic trong ServiceUsageDAO.calculateServiceTotalByRoom()
            int representativeTenantId = tenantsInRoom.stream()
                .mapToInt(Tenant::getTenantId)
                .min()
                .orElse(0);
            
            if (representativeTenantId == 0) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người thuê đại diện cho phòng này");
                return "redirect:/admin/bills/generate";
            }
            
            if (serviceIds != null && currentReadings != null) {
                // Quy trình đọc đồng hồ đo - kết hợp các dịch vụ có đồng hồ đo với các số đọc
                int readingIndex = 0;
                for (int i = 0; i < serviceIds.size(); i++) {
                    int serviceId = serviceIds.get(i);
                    
                    // Kiểm tra xem dịch vụ này có sử dụng đồng hồ đo (điện, nước) không
                    Service service = serviceDAO.getServiceById(serviceId);
                    if (service != null) {
                        String serviceName = service.getServiceName().toLowerCase();
                        boolean hasMeter = serviceName.contains("điện") || serviceName.contains("nước") || 
                                          serviceName.contains("electric") || serviceName.contains("water");
                        
                        if (hasMeter && readingIndex < currentReadings.size()) {
                            String currentReadingStr = currentReadings.get(readingIndex);
                            readingIndex++; // Tăng giá cho dịch vụ đồng hồ đo tiếp theo
                            
                            if (currentReadingStr != null && !currentReadingStr.trim().isEmpty()) {
                                try {
                                    BigDecimal currentReading = new BigDecimal(currentReadingStr.trim());
                                    
                                    // Nhận số đọc đồng hồ trước đó (sử dụng đại diện người thuê nhà)
                                    MeterReading previousReading = meterReadingDAO.getPreviousMeterReading(representativeTenantId, serviceId, month, year);
                                    BigDecimal previousReadingValue = BigDecimal.ZERO;
                                    
                                    if (previousReading != null) {
                                        previousReadingValue = previousReading.getReading();
                                    } else {
                                    	// Nếu không tìm thấy số liệu đọc trước đó, hãy kiểm tra số liệu đọc ban đầu trong cùng khoảng thời gian
                                    	// Điều này áp dụng cho những người thuê nhà mới có số liệu đọc ban đầu trong tháng đầu tiên
                                        MeterReading initialReading = meterReadingDAO.getMeterReadingByTenantServiceAndPeriod(
                                            representativeTenantId, serviceId, month, year);
                                        if (initialReading != null) {
                                        	// Sử dụng số đọc ban đầu làm điểm khởi đầu
                                            previousReadingValue = initialReading.getReading();
                                        }
                                    }
                                    
                                    // Tính toán mức tiêu thụ
                                    BigDecimal consumption = currentReading.subtract(previousReadingValue);
                                    if (consumption.compareTo(BigDecimal.ZERO) < 0) {
                                        consumption = BigDecimal.ZERO; // Ngăn chặn tiêu thụ tiêu cực
                                    }
                                    
                                    // Lưu số đọc đồng hồ hiện tại (sử dụng người thuê nhà đại diện)
                                    Date currentDate = Date.valueOf(java.time.LocalDate.now());
                                    MeterReading newReading = new MeterReading(representativeTenantId, serviceId, currentReading, currentDate, month, year);
                                    
                                    // Kiểm tra xem số đọc đồng hồ đã tồn tại trong khoảng thời gian này chưa
                                    if (meterReadingDAO.meterReadingExists(representativeTenantId, serviceId, month, year)) {
                                        // Cập nhật bản đọc hiện có
                                        MeterReading existingReading = meterReadingDAO.getMeterReadingByTenantServiceAndPeriod(representativeTenantId, serviceId, month, year);
                                        if (existingReading != null) {
                                            existingReading.setReading(currentReading);
                                            existingReading.setReadingDate(currentDate);
                                            meterReadingDAO.updateMeterReading(existingReading);
                                        }
                                    } else {
                                        // Thêm số đọc đồng hồ mới
                                        meterReadingDAO.addMeterReading(newReading);
                                    }
                                    
                                    // Cập nhật hoặc tạo hồ sơ sử dụng dịch vụ với mức tiêu thụ đã tính toán (sử dụng đối tượng thuê đại diện)
                                    if (serviceUsageDAO.serviceUsageExists(representativeTenantId, serviceId, month, year)) {
                                        // Cập nhật số lượng sử dụng hiện tại
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
                                        // Tạo bản ghi sử dụng mới
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
            
            // Xử lý số lượng cho các dịch vụ khác (Internet, parking, etc.)
            if (serviceIds != null && quantities != null) {
                // Số lượng - khớp theo chỉ số
                int maxIndex = Math.min(serviceIds.size(), quantities.size());
                for (int i = 0; i < maxIndex; i++) {
                    int serviceId = serviceIds.get(i);
                    String quantityStr = (i < quantities.size()) ? quantities.get(i) : null;
                    
                    // Kiểm tra xem dịch vụ này có sử dụng số đọc đồng hồ không
                    Service service = serviceDAO.getServiceById(serviceId);
                    if (service != null) {
                        String serviceName = service.getServiceName().toLowerCase();
                        boolean hasMeter = serviceName.contains("điện") || serviceName.contains("nước") || 
                                          serviceName.contains("electric") || serviceName.contains("water");
                        
                        if (!hasMeter && quantityStr != null && !quantityStr.trim().isEmpty()) {
                            try {
                                BigDecimal quantity = new BigDecimal(quantityStr.trim());
                                
                                // Cập nhật hoặc tạo hồ sơ sử dụng dịch vụ với số lượng (sử dụng người thuê đại diện)
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
            
            // Tính tổng số sau khi cập nhật mức sử dụng dịch vụ - hiện tại dựa trên phòng
            BigDecimal fullRoomPrice = room.getPrice();
            
            // Tính giá phòng theo tỷ lệ dựa trên số ngày lưu trú thực tế
            BigDecimal roomPrice = calculateProratedRoomPrice(fullRoomPrice, tenantsInRoom, month, year);
            
            BigDecimal serviceTotal = serviceUsageDAO.calculateServiceTotalByRoom(roomId, month, year);
            BigDecimal additionalTotal = additionalCostDAO.calculateAdditionalTotalByRoom(roomId, month, year);
            
            // Đảm bảo không có giá trị null trong phép tính
            roomPrice = roomPrice != null ? roomPrice : BigDecimal.ZERO;
            serviceTotal = serviceTotal != null ? serviceTotal : BigDecimal.ZERO;
            additionalTotal = additionalTotal != null ? additionalTotal : BigDecimal.ZERO;
            
            BigDecimal totalAmount = roomPrice.add(serviceTotal).add(additionalTotal);
            
            // Tạo hóa đơn bằng cách sử dụng người thuê đại diện (đại diện cho phòng)
            Invoice invoice = new Invoice(representativeTenantId, month, year, roomPrice, serviceTotal, additionalTotal, totalAmount);
            invoice.setStatus("UNPAID");
            
            boolean success = invoiceDAO.createInvoice(invoice);
            
            if (success) {
                // Tạo mã QR MoMo sau khi tạo hóa đơn thành công
                try {
                    String orderInfo = "Thanh toán hóa đơn phòng " + room.getRoomName() + " - " + 
                                     String.format("%02d/%d", month, year);
                    
                    MoMoResponse moMoResponse = moMoDAO.createQRCode(invoice.getInvoiceId(), totalAmount, orderInfo);
                    
                    if (moMoResponse.isSuccess() && moMoResponse.hasQrCode()) {
                        // Cập nhật hóa đơn bằng thông tin MoMo
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
                    // Thông báo nếu tạo QR MoMo thất bại
                }
                
                // Gửi thông báo qua Email đến tất cả người thuê phòng bằng mã QR
                try {
                    String period = String.format("%02d/%d", month, year);
                    String formattedAmount = String.format("%,.0f", totalAmount.doubleValue());
                    
                    // Nhận URL mã QR từ hóa đơn đã tạo
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
                    
                    // Gửi email cho tất cả tenant trong phòng
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
                    // Đừng để việc tạo hóa đơn thất bại nếu Email không thành công
                }
                
                String tenantNames = tenantsInRoom.stream()
                    .map(Tenant::getFullName)
                    .reduce((a, b) -> a + ", " + b)
                    .orElse("Không xác định");
                
                // Kiểm tra xem giá phòng có được tính theo tỷ lệ không
                String priceInfo = "";
                if (roomPrice.compareTo(fullRoomPrice) < 0) {
                    priceInfo = " (Tiền phòng đã được tính theo tỷ lệ ngày ở thực tế)";
                }
                
                // Xây dựng tin nhắn thành công với thông tin SMS
                StringBuilder successMessage = new StringBuilder();
                successMessage.append("Tạo hóa đơn thành công cho phòng ").append(room.getRoomName())
                             .append(" (").append(tenantNames).append(")! Tổng tiền: ")
                             .append(String.format("%,.0f", totalAmount.doubleValue())).append(" VNĐ")
                             .append(priceInfo);
                
                // Thêm thông tin thông báo qua Email nếu có Email nào được thử
                try {
                    int tenantsWithEmail = (int) tenantsInRoom.stream()
                        .filter(t -> t.getEmail() != null && !t.getEmail().trim().isEmpty())
                        .count();
                    
                    if (tenantsWithEmail > 0) {
                        successMessage.append(" Đã gửi thông báo Email tới ")
                                     .append(tenantsWithEmail).append(" người thuê");
                        
                        // Kiểm tra xem mã QR đã được bao gồm chưa
                        try {
                            Invoice createdInvoice = invoiceDAO.getInvoiceById(invoice.getInvoiceId());
                            if (createdInvoice != null && createdInvoice.getMomoQrCodeUrl() != null && !createdInvoice.getMomoQrCodeUrl().trim().isEmpty()) {
                                successMessage.append(" (bao gồm mã QR MoMo)");
                            }
                        } catch (Exception e) {
                            // Bỏ qua lỗi kiểm tra QR
                        }
                        
                        successMessage.append(".");
                    }
                } catch (Exception e) {
                    // Bỏ qua lỗi số lượng Email
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
        
        // Kiểm tra xem hóa đơn đã tồn tại cho kỳ này chưa
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
        
        // Tính giá phòng theo tỷ lệ cho người thuê này
        List<Tenant> singleTenantList = new ArrayList<>();
        singleTenantList.add(tenant);
        BigDecimal roomPrice = calculateProratedRoomPrice(fullRoomPrice, singleTenantList, month, year);
        
        BigDecimal serviceTotal = serviceUsageDAO.calculateServiceTotal(tenantId, month, year);
        BigDecimal additionalTotal = additionalCostDAO.calculateAdditionalTotal(tenantId, month, year);
        
        // Đảm bảo không có giá trị null trong phép tính
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
        
        // Đưa tất cả người thuê vào cùng một phòng để thanh toán theo phòng
        List<Tenant> tenantsInRoom = tenantDAO.getTenantsByRoomId(tenant.getRoomId());
        
        // Nhận thông tin chi tiết - hiện đã được tổng hợp và phân loại theo phòng
        List<ServiceUsage> roomUsages = serviceUsageDAO.getServiceUsageByRoomAndPeriod(
            tenant.getRoomId(), invoice.getMonth(), invoice.getYear()
        );
        List<ServiceUsage> serviceUsages = aggregateServiceUsagesByService(roomUsages);
        
        List<AdditionalCost> additionalCosts = additionalCostDAO.getAdditionalCostsByRoomAndPeriod(
            tenant.getRoomId(), invoice.getMonth(), invoice.getYear()
        );
        
        // Tính toán thông tin ngày để hiển thị giá theo tỷ lệ
        int daysInMonth = getDaysInMonth(invoice.getMonth(), invoice.getYear());
        int daysStayed = calculateDaysStayed(tenantsInRoom, invoice.getMonth(), invoice.getYear());
        Date earliestStartDate = getEarliestStartDate(tenantsInRoom, invoice.getMonth(), invoice.getYear());
        
        // Tính toán giá phòng đầy đủ sẽ là bao nhiêu
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
     * Lấy số đọc đồng hồ trước đó cho lệnh gọi AJAX bằng JSP
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
            
            // Cố gắng tìm số đọc đồng hồ trước đó của bất kỳ người thuê nhà nào trong phòng
            MeterReading previousReading = null;
            String foundTenantInfo = "";
            
            // Đầu tiên, hãy thử người thuê đại diện (ID người thuê tối thiểu) để đảm bảo tính nhất quán
            int representativeTenantId = tenantsInRoom.stream()
                .mapToInt(Tenant::getTenantId)
                .min()
                .orElse(0);
            
            // Cố gắng lấy thông tin đọc trước từ các giai đoạn trước
            previousReading = meterReadingDAO.getPreviousMeterReading(representativeTenantId, serviceId, month, year);
            
            if (previousReading != null) {
                foundTenantInfo = "from representative tenant " + representativeTenantId;
            } else {
                // Nếu không tìm thấy, hãy thử tất cả người thuê phòng trong các kỳ trước
                for (Tenant tenant : tenantsInRoom) {
                    previousReading = meterReadingDAO.getPreviousMeterReading(tenant.getTenantId(), serviceId, month, year);
                    if (previousReading != null) {
                        foundTenantInfo = "from tenant " + tenant.getTenantId() + " (" + tenant.getFullName() + ")";
                        break;
                    }
                }
                
                // Nếu vẫn không tìm thấy số liệu trước đó, hãy kiểm tra xem đây có phải là tháng đầu tiên cho người thuê mới không.
                // Tìm số liệu ban đầu trong cùng kỳ (cho người thuê mới)
                if (previousReading == null) {
                    // Cố gắng tìm số liệu ban đầu cho cùng kỳ từ bất kỳ người thuê nào trong phòng
                	// Điều này xử lý trường hợp người thuê chuyển đến trong tháng hiện tại
                    for (Tenant tenant : tenantsInRoom) {
                        MeterReading initialReading = meterReadingDAO.getMeterReadingByTenantServiceAndPeriod(
                            tenant.getTenantId(), serviceId, month, year);
                        if (initialReading != null) {
                            // Sử dụng phần này như bài đọc "trước" (thực ra đây là bài đọc đầu tiên cho giai đoạn này)
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
            // Không tìm thấy tài liệu đọc trước đó - JSP sẽ xử lý trường hợp này
            
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
     * Tính giá phòng theo tỷ lệ dựa trên số ngày lưu trú thực tế trong tháng
     * Đối với khách thuê chuyển đến trong tháng, chỉ tính phí theo số ngày thực tế lưu trú
     */
    private BigDecimal calculateProratedRoomPrice(BigDecimal fullRoomPrice, List<Tenant> tenantsInRoom, int month, int year) {
        if (tenantsInRoom == null || tenantsInRoom.isEmpty()) {
            return BigDecimal.ZERO;
        }
        
        // Lấy số ngày trong tháng thanh toán
        int daysInMonth = getDaysInMonth(month, year);
        
        // Tìm ngày bắt đầu sớm nhất trong số tất cả người thuê phòng trong tháng này
        Date earliestStartDate = null;
        boolean needsProration = false;
        
        for (Tenant tenant : tenantsInRoom) {
            Date startDate = tenant.getStartDate();
            if (startDate != null) {
                // Kiểm tra xem người thuê nhà đã bắt đầu vào tháng/năm này chưa
                java.time.LocalDate startLocalDate = startDate.toLocalDate();
                if (startLocalDate.getYear() == year && startLocalDate.getMonthValue() == month) {
                    // Người thuê nhà bắt đầu vào tháng thanh toán này - cần được phân bổ
                    needsProration = true;
                    if (earliestStartDate == null || startDate.before(earliestStartDate)) {
                        earliestStartDate = startDate;
                    }
                } else if (startLocalDate.isBefore(java.time.LocalDate.of(year, month, 1))) {
                    // Người thuê đã bắt đầu trước tháng này - không cần tính tỷ lệ cho người thuê này
                	// Tiếp tục kiểm tra những người thuê khác
                }
            }
        }
        
        // Nếu không có người thuê nào bắt đầu trong tháng này, tính phí toàn bộ tháng
        if (!needsProration || earliestStartDate == null) {
            return fullRoomPrice;
        }
        
        // Tính toán số ngày cần tính phí
        java.time.LocalDate startLocalDate = earliestStartDate.toLocalDate();
        java.time.LocalDate endOfMonth = java.time.LocalDate.of(year, month, daysInMonth);
        
        // Tính số ngày từ ngày bắt đầu đến ngày kết thúc tháng
        int daysToCharge = (int) java.time.temporal.ChronoUnit.DAYS.between(startLocalDate, endOfMonth) + 1;
        
        // Đảm bảo không tính phí cho nhiều ngày hơn trong tháng
        daysToCharge = Math.min(daysToCharge, daysInMonth);
        daysToCharge = Math.max(daysToCharge, 1); // Ít nhất 1 ngày
        
        // Nếu tính phí cho cả tháng, hãy trả lại giá đầy đủ để tránh lỗi làm tròn
        if (daysToCharge >= daysInMonth) {
            return fullRoomPrice;
        }
        
        // Tính toán số tiền được chia theo tỷ lệ
        BigDecimal dailyRate = fullRoomPrice.divide(new BigDecimal(daysInMonth), 2, java.math.RoundingMode.HALF_UP);
        BigDecimal proratedAmount = dailyRate.multiply(new BigDecimal(daysToCharge));
        
        return proratedAmount;
    }
    
    /**
     * Lấy số ngày trong một tháng và năm cụ thể
     */
    private int getDaysInMonth(int month, int year) {
        java.time.YearMonth yearMonth = java.time.YearMonth.of(year, month);
        return yearMonth.lengthOfMonth();
    }
    
    /**
     * Tính số ngày lưu trú trong tháng thanh toán
     */
    private int calculateDaysStayed(List<Tenant> tenantsInRoom, int month, int year) {
        if (tenantsInRoom == null || tenantsInRoom.isEmpty()) {
            return 0;
        }
        
        int daysInMonth = getDaysInMonth(month, year);
        
        // Kiểm tra xem có người thuê nhà nào bắt đầu vào tháng này không
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
        
        // Nếu không có người thuê nhà nào bắt đầu vào tháng này, họ sẽ ở lại cả tháng
        if (!anyTenantStartedThisMonth || earliestStartDate == null) {
            return daysInMonth;
        }
        
        java.time.LocalDate startLocalDate = earliestStartDate.toLocalDate();
        java.time.LocalDate endOfMonth = java.time.LocalDate.of(year, month, daysInMonth);
        
        // Tính số ngày từ ngày bắt đầu đến ngày kết thúc tháng
        int daysStayed = (int) java.time.temporal.ChronoUnit.DAYS.between(startLocalDate, endOfMonth) + 1;
        
        // Đảm bảo chúng ta không tính nhiều ngày hơn trong tháng
        daysStayed = Math.min(daysStayed, daysInMonth);
        daysStayed = Math.max(daysStayed, 1); // Ít nhất 1 ngày
        
        return daysStayed;
    }
    
    /**
     * Lấy ngày bắt đầu sớm nhất trong số những người thuê nhà cho tháng thanh toán
     * Chỉ trả về ngày nếu người thuê nhà thực sự bắt đầu trong tháng này
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
                    // Người thuê nhà bắt đầu vào tháng thanh toán này
                    if (earliestStartDate == null || startDate.before(earliestStartDate)) {
                        earliestStartDate = startDate;
                    }
                }
                // Nếu người thuê bắt đầu trước tháng này, chúng tôi không đặt earlierStartDate
                // vì họ phải trả tiền cho cả tháng (không cần chia nhỏ theo tỷ lệ)
            }
        }
        
        return earliestStartDate;
    }
    
    /**
     * Tổng hợp việc sử dụng dịch vụ theo từng dịch vụ để tránh trùng lặp
     * Kết hợp nhiều cách sử dụng của cùng một dịch vụ thành một bản ghi
     */
    private List<ServiceUsage> aggregateServiceUsagesByService(List<ServiceUsage> usages) {
        if (usages == null || usages.isEmpty()) {
            return new ArrayList<>();
        }
        
        // Nhóm theo ID dịch vụ và tổng số lượng
        Map<Integer, ServiceUsage> serviceMap = new HashMap<>();
        
        for (ServiceUsage usage : usages) {
            int serviceId = usage.getServiceId();
            
            if (serviceMap.containsKey(serviceId)) {
                // Dịch vụ đã tồn tại, thêm vào số lượng và tính toán lại tổng chi phí
                ServiceUsage existing = serviceMap.get(serviceId);
                BigDecimal newQuantity = existing.getQuantity().add(usage.getQuantity());
                existing.setQuantity(newQuantity);
                existing.calculateTotalCost();
            } else {
                // Dịch vụ mới, tạo bản sao và thêm vào bản đồ
                ServiceUsage aggregated = new ServiceUsage();
                aggregated.setUsageId(usage.getUsageId()); // Giữ lại ID sử dụng đầu tiên để tham khảo
                aggregated.setTenantId(usage.getTenantId()); // Giữ lại ID người thuê đầu tiên để tham khảo
                aggregated.setServiceId(usage.getServiceId());
                aggregated.setMonth(usage.getMonth());
                aggregated.setYear(usage.getYear());
                aggregated.setQuantity(usage.getQuantity());
                aggregated.setServiceName(usage.getServiceName());
                aggregated.setServiceUnit(usage.getServiceUnit());
                aggregated.setPricePerUnit(usage.getPricePerUnit());
                aggregated.setTenantName("Tất cả người thuê"); // Chỉ ra nó được tổng hợp
                aggregated.setRoomName(usage.getRoomName());
                aggregated.calculateTotalCost();
                
                serviceMap.put(serviceId, aggregated);
            }
        }
        
        // Chuyển đổi giá trị bản đồ thành danh sách và sắp xếp theo tên dịch vụ
        List<ServiceUsage> result = new ArrayList<>(serviceMap.values());
        result.sort((a, b) -> a.getServiceName().compareToIgnoreCase(b.getServiceName()));
        
        return result;
    }
    
    /**
     * Tính toán giá phòng đầy đủ sẽ là bao nhiêu (tính ngược lại từ giá theo tỷ lệ)
     */
    private BigDecimal calculateFullRoomPrice(Invoice invoice, List<Tenant> tenantsInRoom, int daysInMonth, int daysStayed) {
        if (daysStayed >= daysInMonth) {
            // Cả tháng, vì vậy giá phòng hiện tại là giá đầy đủ
            return invoice.getRoomPrice();
        }
        
        // Tháng tính theo tỷ lệ, tính giá đầy đủ từ giá tính theo tỷ lệ
        // proratedPrice = fullPrice * (ngày lưu trú / ngày trong tháng)
        // fullPrice = proratedPrice * (ngày trong tháng / ngày lưu trú)
        BigDecimal proratedPrice = invoice.getRoomPrice();
        BigDecimal fullPrice = proratedPrice.multiply(new BigDecimal(daysInMonth))
                                           .divide(new BigDecimal(daysStayed), 2, java.math.RoundingMode.HALF_UP);
        
        return fullPrice;
    }
}

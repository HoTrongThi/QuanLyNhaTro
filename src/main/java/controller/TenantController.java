package controller;

import dao.TenantDAO;
import dao.UserDAO;
import dao.ServiceDAO;
import dao.ServiceUsageDAO;
import dao.MeterReadingDAO;
import model.Tenant;
import model.User;
import model.Room;
import model.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Tenant Management Controller
 * Handles tenant assignments and user profile management
 */
@Controller
@RequestMapping("/admin")
public class TenantController {
    
    @Autowired
    private TenantDAO tenantDAO;
    
    @Autowired
    private UserDAO userDAO;
    
    @Autowired
    private ServiceDAO serviceDAO;
    
    @Autowired
    private ServiceUsageDAO serviceUsageDAO;
    
    @Autowired
    private MeterReadingDAO meterReadingDAO;
    
    /**
     * Check if service requires meter reading (electricity/water)
     */
    private boolean isServiceWithMeter(int serviceId) {
        // Check service names from database to determine if it needs meter
        try {
            Service service = serviceDAO.getServiceById(serviceId);
            if (service != null) {
                String serviceName = service.getServiceName().toLowerCase();
                return serviceName.contains("điện") || serviceName.contains("nước") || 
                       serviceName.contains("electric") || serviceName.contains("water");
            }
        } catch (Exception e) {
            // Log error but continue with fallback
        }
        
        // Fallback to hard-coded IDs for common services
        return serviceId == 1 || serviceId == 2 || serviceId == 4;
    }
    
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
        
        return null;
    }
    
    /**
     * Show tenants management page
     */
    @GetMapping("/tenants")
    public String showTenantsPage(HttpSession session, Model model,
                                 @RequestParam(value = "search", required = false) String search,
                                 @RequestParam(value = "status", required = false, defaultValue = "all") String status) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Tenant> tenants;
        
        // Handle search and filter functionality
        if (search != null && !search.trim().isEmpty()) {
            tenants = tenantDAO.searchTenants(search.trim());
            model.addAttribute("searchTerm", search.trim());
        } else if ("active".equals(status)) {
            tenants = tenantDAO.getActiveTenants();
        } else {
            tenants = tenantDAO.getAllTenants();
        }
        
        // Get tenant services for display
        Map<Integer, String> tenantServicesMap = new HashMap<>();
        Map<Integer, Integer> roomTenantCounts = new HashMap<>();
        
        for (Tenant tenant : tenants) {
            String services = tenantDAO.getTenantServicesDisplay(tenant.getTenantId());
            tenantServicesMap.put(tenant.getTenantId(), services);
            
            // Get room tenant count if not already calculated
            if (!roomTenantCounts.containsKey(tenant.getRoomId())) {
                int count = tenantDAO.getRoomTenantCount(tenant.getRoomId());
                roomTenantCounts.put(tenant.getRoomId(), count);
            }
        }
        
        model.addAttribute("user", user);
        model.addAttribute("tenants", tenants);
        model.addAttribute("tenantServicesMap", tenantServicesMap);
        model.addAttribute("roomTenantCounts", roomTenantCounts);
        model.addAttribute("pageTitle", "Quản lý Thuê trọ");
        model.addAttribute("selectedStatus", status);
        model.addAttribute("totalTenants", tenantDAO.getTotalTenantCount());
        model.addAttribute("activeTenants", tenantDAO.getActiveTenantCount());
        model.addAttribute("inactiveTenants", tenantDAO.getInactiveTenantCount());
        
        return "admin/tenants";
    }
    
    /**
     * Show add tenant form
     */
    @GetMapping("/tenants/add")
    public String showAddTenantForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<User> availableUsers = tenantDAO.getAvailableUsers();
        List<Room> availableRooms = tenantDAO.getAvailableRooms();
        List<Service> availableServices = serviceDAO.getAllServices();
        
        model.addAttribute("user", user);
        model.addAttribute("tenant", new Tenant());
        model.addAttribute("availableUsers", availableUsers);
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("availableServices", availableServices);
        model.addAttribute("pageTitle", "Thêm Thuê trọ mới");
        model.addAttribute("action", "add");
        
        return "admin/tenant-form";
    }
    
    /**
     * Process add tenant
     */
    @PostMapping("/tenants/add")
    public String processAddTenant(@RequestParam("userId") int userId,
                                  @RequestParam("roomId") int roomId,
                                  @RequestParam("startDate") String startDate,
                                  @RequestParam(value = "serviceIds", required = false) List<Integer> serviceIds,
                                  @RequestParam(value = "initialReadings", required = false) List<String> initialReadings,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        try {
            // Validate inputs
            if (userId <= 0 || roomId <= 0 || startDate == null || startDate.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng điền đầy đủ thông tin");
                return "redirect:/admin/tenants/add";
            }
            
            // Validate that room has space (max 4 tenants)
            int currentTenantCount = tenantDAO.getRoomTenantCount(roomId);
            if (currentTenantCount >= 4) {
                redirectAttributes.addFlashAttribute("error", "Phòng này đã đủ 4 người thuê!");
                return "redirect:/admin/tenants/add";
            }
            
            // Validate date format
            Date parsedDate;
            try {
                parsedDate = Date.valueOf(startDate);
            } catch (IllegalArgumentException e) {
                redirectAttributes.addFlashAttribute("error", "Định dạng ngày không hợp lệ");
                return "redirect:/admin/tenants/add";
            }
            
            // Create tenant
            Tenant tenant = new Tenant();
            tenant.setUserId(userId);
            tenant.setRoomId(roomId);
            tenant.setStartDate(parsedDate);
            
            boolean success = tenantDAO.addTenant(tenant);
            
            if (success) {
                // Get the newly created tenant to assign services
                if (serviceIds != null && !serviceIds.isEmpty()) {
                    // Get the active tenant we just created
                    Tenant newTenant = tenantDAO.getActiveTenantByUserId(userId);
                    if (newTenant != null) {
                        int tenantId = newTenant.getTenantId();
                        
                        // Get current month and year for initial service assignments
                        LocalDate now = LocalDate.now();
                        int currentMonth = now.getMonthValue();
                        int currentYear = now.getYear();
                        
                        // Process initial meter readings if provided
                        boolean meterReadingsInitialized = true;
                        
                        if (initialReadings != null && !initialReadings.isEmpty()) {
                            // Filter out empty readings and match with services that have meters
                            List<Integer> meterServiceIds = new ArrayList<>();
                            List<BigDecimal> meterReadings = new ArrayList<>();
                            
                            int readingIndex = 0;
                            for (Integer serviceId : serviceIds) {
                                boolean needsMeter = isServiceWithMeter(serviceId);
                                
                                if (needsMeter && readingIndex < initialReadings.size()) {
                                    String readingStr = initialReadings.get(readingIndex);
                                    
                                    if (readingStr != null && !readingStr.trim().isEmpty()) {
                                        try {
                                            BigDecimal reading = new BigDecimal(readingStr.trim());
                                            meterServiceIds.add(serviceId);
                                            meterReadings.add(reading);
                                        } catch (NumberFormatException e) {
                                            // Invalid number format - skip this reading
                                        }
                                    }
                                    readingIndex++;
                                }
                            }
                            
                            // Initialize meter readings only for services that have meters
                            if (!meterServiceIds.isEmpty() && !meterReadings.isEmpty()) {
                                Date startDateParsed = Date.valueOf(startDate);
                                meterReadingsInitialized = meterReadingDAO.initializeMeterReadingsForTenant(
                                    tenantId, meterServiceIds, meterReadings, startDateParsed, currentMonth, currentYear
                                );
                            }
                        }
                        
                        // Assign selected services with 0 quantity for current month (for backward compatibility)
                        boolean servicesAssigned = serviceUsageDAO.initializeServicesForTenant(tenantId, serviceIds, currentMonth, currentYear);
                        
                        if (servicesAssigned && meterReadingsInitialized) {
                            redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ, gán dịch vụ và khởi tạo chỉ số công tơ thành công!");
                        } else if (servicesAssigned) {
                            redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ và gán dịch vụ thành công!");
                        } else {
                            redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ thành công nhưng có lỗi khi gán dịch vụ!");
                        }
                    } else {
                        redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ thành công!");
                    }
                } else {
                    redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ thành công!");
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Thêm thuê trọ thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return "redirect:/admin/tenants";
    }
    
    /**
     * View tenant details
     */
    @GetMapping("/tenants/view/{id}")
    public String viewTenant(@PathVariable int id,
                           HttpSession session,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Tenant tenant = tenantDAO.getTenantById(id);
        if (tenant == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin thuê trọ");
            return "redirect:/admin/tenants";
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("tenant", tenant);
        model.addAttribute("pageTitle", "Chi tiết Thuê trọ: " + tenant.getFullName());
        
        return "admin/tenant-detail";
    }
    
    /**
     * End tenant lease
     */
    @PostMapping("/tenants/end/{id}")
    public String endTenantLease(@PathVariable int id,
                               @RequestParam(value = "endDate", required = false) String endDate,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        try {
            Tenant tenant = tenantDAO.getTenantById(id);
            if (tenant == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin thuê trọ");
                return "redirect:/admin/tenants";
            }
            
            if (!tenant.isActive()) {
                redirectAttributes.addFlashAttribute("error", "Hợp đồng thuê đã kết thúc");
                return "redirect:/admin/tenants";
            }
            
            // Use provided end date or current date
            Date leaseEndDate;
            if (endDate != null && !endDate.trim().isEmpty()) {
                leaseEndDate = Date.valueOf(endDate);
            } else {
                leaseEndDate = Date.valueOf(LocalDate.now());
            }
            
            boolean success = tenantDAO.endTenantLease(id, leaseEndDate);
            
            if (success) {
                redirectAttributes.addFlashAttribute("success", "Kết thúc hợp đồng thuê thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Kết thúc hợp đồng thuê thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return "redirect:/admin/tenants";
    }
    
    /**
     * Show change room form
     */
    @GetMapping("/tenants/change-room/{id}")
    public String showChangeRoomForm(@PathVariable int id,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Tenant tenant = tenantDAO.getTenantById(id);
        if (tenant == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin thuê trọ");
            return "redirect:/admin/tenants";
        }
        
        if (!tenant.isActive()) {
            redirectAttributes.addFlashAttribute("error", "Chỉ có thể đổi phòng cho hợp đồng đang hoạt động");
            return "redirect:/admin/tenants";
        }
        
        User user = (User) session.getAttribute("user");
        List<Room> availableRooms = tenantDAO.getAvailableRooms();
        
        model.addAttribute("user", user);
        model.addAttribute("tenant", tenant);
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("pageTitle", "Đổi phòng: " + tenant.getFullName());
        
        return "admin/change-room-form";
    }
    
    /**
     * Process change room
     */
    @PostMapping("/tenants/change-room/{id}")
    public String processChangeRoom(@PathVariable int id,
                                  @RequestParam("newRoomId") int newRoomId,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        try {
            Tenant tenant = tenantDAO.getTenantById(id);
            if (tenant == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin thuê trọ");
                return "redirect:/admin/tenants";
            }
            
            if (!tenant.isActive()) {
                redirectAttributes.addFlashAttribute("error", "Chỉ có thể đổi phòng cho hợp đồng đang hoạt động");
                return "redirect:/admin/tenants";
            }
            
            if (tenant.getRoomId() == newRoomId) {
                redirectAttributes.addFlashAttribute("error", "Phòng mới không thể trùng với phòng hiện tại");
                return "redirect:/admin/tenants/change-room/" + id;
            }
            
            boolean success = tenantDAO.updateTenantRoom(id, newRoomId);
            
            if (success) {
                redirectAttributes.addFlashAttribute("success", "Đổi phòng thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Đổi phòng thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return "redirect:/admin/tenants";
    }
}

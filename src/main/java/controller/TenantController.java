package controller;

import dao.TenantDAO;
import dao.UserDAO;
import dao.ServiceDAO;
import dao.ServiceUsageDAO;
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
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

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
        
        // Create a map to store tenant services display information
        java.util.Map<Integer, String> tenantServicesMap = new java.util.HashMap<>();
        for (Tenant tenant : tenants) {
            String servicesDisplay = tenantDAO.getTenantServicesDisplay(tenant.getTenantId());
            tenantServicesMap.put(tenant.getTenantId(), servicesDisplay);
        }
        
        model.addAttribute("user", user);
        model.addAttribute("tenants", tenants);
        model.addAttribute("tenantServicesMap", tenantServicesMap);
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
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        try {
            // Enhanced logging for debugging
            System.out.println("=== DEBUG: Adding Tenant ===");
            System.out.println("User ID: " + userId);
            System.out.println("Room ID: " + roomId);
            System.out.println("Start Date: " + startDate);
            System.out.println("Selected Services: " + serviceIds);
            
            // Validate inputs
            if (userId <= 0 || roomId <= 0 || startDate == null || startDate.trim().isEmpty()) {
                System.out.println("DEBUG: Validation failed - missing required fields");
                redirectAttributes.addFlashAttribute("error", "Vui lòng nhập đầy đủ thông tin");
                return "redirect:/admin/tenants/add";
            }
            
            // Check if user is already a tenant
            if (tenantDAO.isUserCurrentlyTenant(userId)) {
                System.out.println("DEBUG: User is already a tenant");
                redirectAttributes.addFlashAttribute("error", "Người dùng này đã là khách thuê");
                return "redirect:/admin/tenants/add";
            }
            
            // Validate date format
            Date parsedDate;
            try {
                parsedDate = Date.valueOf(startDate);
                System.out.println("DEBUG: Date parsed successfully: " + parsedDate);
            } catch (IllegalArgumentException e) {
                System.out.println("DEBUG: Date parsing failed: " + e.getMessage());
                redirectAttributes.addFlashAttribute("error", "Định dạng ngày không hợp lệ");
                return "redirect:/admin/tenants/add";
            }
            
            // Create tenant
            Tenant tenant = new Tenant();
            tenant.setUserId(userId);
            tenant.setRoomId(roomId);
            tenant.setStartDate(parsedDate);
            
            System.out.println("DEBUG: Tenant object created: " + tenant.toString());
            
            boolean success = tenantDAO.addTenant(tenant);
            System.out.println("DEBUG: Add tenant result: " + success);
            
            if (success) {
                // Get the newly created tenant to assign services
                if (serviceIds != null && !serviceIds.isEmpty()) {
                    // Get the active tenant we just created
                    Tenant newTenant = tenantDAO.getActiveTenantByUserId(userId);
                    if (newTenant != null) {
                        int tenantId = newTenant.getTenantId();
                        System.out.println("DEBUG: Found tenant ID: " + tenantId);
                        
                        // Get current month and year for initial service assignments
                        LocalDate now = LocalDate.now();
                        int currentMonth = now.getMonthValue();
                        int currentYear = now.getYear();
                        
                        // Assign selected services with 0 quantity for current month
                        boolean servicesAssigned = serviceUsageDAO.initializeServicesForTenant(tenantId, serviceIds, currentMonth, currentYear);
                        System.out.println("DEBUG: Services assigned: " + servicesAssigned);
                        
                        if (servicesAssigned) {
                            redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ và gán dịch vụ thành công!");
                        } else {
                            redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ thành công nhưng có lỗi khi gán dịch vụ!");
                        }
                    } else {
                        System.out.println("DEBUG: Could not find newly created tenant");
                        redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ thành công!");
                    }
                } else {
                    redirectAttributes.addFlashAttribute("success", "Thêm thuê trọ thành công!");
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Thêm thuê trọ thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            System.err.println("DEBUG: Exception occurred: " + e.getMessage());
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

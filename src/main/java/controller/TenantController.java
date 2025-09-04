package controller;

import dao.TenantDAO;
import dao.UserDAO;
import dao.ServiceDAO;
import dao.ServiceUsageDAO;
import dao.MeterReadingDAO;
import dao.RoomDAO;
import model.Tenant;
import model.User;
import model.Room;
import model.Service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.scheduling.annotation.Scheduled;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller quản lý Người thuê
 * Xử lý phân công người thuê và quản lý hồ sơ người dùng
 * Bao gồm thêm người thuê, kết thúc hợp đồng, chuyển phòng và gán dịch vụ
 * Tự động khởi tạo chỉ số công tơ và sử dụng dịch vụ ban đầu
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Controller
@RequestMapping("/admin")
public class TenantController {
    
    // ==================== CÁC THUỘC TÍNH DAO ====================
    
    /** DAO quản lý người thuê */
    @Autowired
    private TenantDAO tenantDAO;
    
    /** DAO quản lý người dùng */
    @Autowired
    private UserDAO userDAO;
    
    /** DAO quản lý dịch vụ */
    @Autowired
    private ServiceDAO serviceDAO;
    
    /** DAO quản lý sử dụng dịch vụ */
    @Autowired
    private ServiceUsageDAO serviceUsageDAO;
    
    /** DAO quản lý chỉ số công tơ */
    @Autowired
    private MeterReadingDAO meterReadingDAO;
    
    /** DAO quản lý phòng */
    @Autowired
    private RoomDAO roomDAO;
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra dịch vụ có cần ghi chỉ số công tơ hay không
     * Dựa trên tên dịch vụ để xác định (điện, nước)
     * 
     * @param serviceId ID dịch vụ cần kiểm tra
     * @return true nếu dịch vụ cần công tơ, false nếu không
     */
    private boolean isServiceWithMeter(int serviceId) {
        // Kiểm tra tên dịch vụ từ database để xác định có cần công tơ hay không
        try {
            Service service = serviceDAO.getServiceById(serviceId);
            if (service != null) {
                String serviceName = service.getServiceName().toLowerCase();
                // Kiểm tra các từ khóa liên quan đến điện và nước
                return serviceName.contains("điện") || serviceName.contains("nước") || 
                       serviceName.contains("electric") || serviceName.contains("water");
            }
        } catch (Exception e) {
            // Ghi log lỗi nhưng tiếp tục với phương án dự phòng
        }
        
        // Phương án dự phòng: sử dụng ID cố định cho các dịch vụ phổ biến
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
     * Show tenants management page (Room-based view)
     */
    @GetMapping("/tenants")
    public String showTenantsPage(HttpSession session, Model model,
                                 @RequestParam(value = "search", required = false) String search) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Room> rooms;
        
        // Handle search functionality - only show AVAILABLE and OCCUPIED rooms
        if (search != null && !search.trim().isEmpty()) {
            rooms = roomDAO.searchRoomsForTenantManagement(search.trim());
            model.addAttribute("searchTerm", search.trim());
        } else {
            rooms = roomDAO.getRoomsForTenantManagement();
        }
        
        // Prepare room-based data
        Map<Integer, List<Tenant>> roomTenantsMap = new HashMap<>();
        Map<Integer, Integer> roomTenantCounts = new HashMap<>();
        Map<Integer, List<String>> roomServicesMap = new HashMap<>();
        
        for (Room room : rooms) {
            // Get active tenants for this room
            List<Tenant> roomTenants = tenantDAO.getActiveTenantsByRoomId(room.getRoomId());
            
            // Add payment status for the room (not individual tenants)
            String roomPaymentStatus = tenantDAO.getRoomPaymentStatus(room.getRoomId());
            room.setPaymentStatus(roomPaymentStatus);
            
            // Debug log
            System.out.println("[DEBUG] Room " + room.getRoomName() + " (ID: " + room.getRoomId() + ") payment status: " + roomPaymentStatus);
            
            // If room has unpaid bills, get the detailed list
            if (roomPaymentStatus != null && roomPaymentStatus.startsWith("UNPAID:")) {
                List<String> unpaidPeriods = tenantDAO.getRoomUnpaidPeriods(room.getRoomId());
                room.setUnpaidPeriods(unpaidPeriods);
                System.out.println("[DEBUG] Room unpaid periods: " + unpaidPeriods);
            }
            
            roomTenantsMap.put(room.getRoomId(), roomTenants);
            roomTenantCounts.put(room.getRoomId(), roomTenants.size());
            
            // Get services for this room (from first tenant if any)
            List<String> roomServices = new ArrayList<>();
            if (!roomTenants.isEmpty()) {
                // Get services from the first tenant (assuming all tenants in same room have same services)
                String servicesDisplay = tenantDAO.getTenantServicesDisplay(roomTenants.get(0).getTenantId());
                if (servicesDisplay != null && !servicesDisplay.equals("Không có dịch vụ")) {
                    // Split services by comma and clean up
                    String[] serviceArray = servicesDisplay.split(",");
                    for (String service : serviceArray) {
                        roomServices.add(service.trim());
                    }
                }
            }
            roomServicesMap.put(room.getRoomId(), roomServices);
        }
        
        model.addAttribute("user", user);
        model.addAttribute("rooms", rooms);
        model.addAttribute("roomTenantsMap", roomTenantsMap);
        model.addAttribute("roomTenantCounts", roomTenantCounts);
        model.addAttribute("roomServicesMap", roomServicesMap);
        model.addAttribute("pageTitle", "Quản lý Thuê trọ");
        model.addAttribute("totalTenants", tenantDAO.getTotalTenantCount());
        model.addAttribute("activeTenants", tenantDAO.getActiveTenantCount());
        model.addAttribute("inactiveTenants", tenantDAO.getInactiveTenantCount());
        
        return "admin/tenants";
    }
    
    /**
     * Show add tenant form
     */
    @GetMapping("/tenants/add")
    public String showAddTenantForm(HttpSession session, Model model,
                                   @RequestParam(value = "roomId", required = false) Integer roomId) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<User> availableUsers = tenantDAO.getAvailableUsers();
        List<Room> availableRooms = tenantDAO.getAvailableRooms();
        List<Service> availableServices = serviceDAO.getAllServices();
        
        // If roomId is provided, set it as selected
        Room selectedRoom = null;
        if (roomId != null) {
            selectedRoom = roomDAO.getRoomById(roomId);
        }
        
        model.addAttribute("user", user);
        model.addAttribute("tenant", new Tenant());
        model.addAttribute("availableUsers", availableUsers);
        model.addAttribute("availableRooms", availableRooms);
        model.addAttribute("availableServices", availableServices);
        model.addAttribute("selectedRoom", selectedRoom);
        model.addAttribute("pageTitle", "Thêm Thuê trọ mới");
        model.addAttribute("action", "add");
        
        return "admin/tenant-form";
    }
    
    /**
     * Process add tenant
     */
    @PostMapping("/tenants/add")
    public String processAddTenant(@RequestParam("userIds") List<Integer> userIds,
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
            if (userIds == null || userIds.isEmpty() || roomId <= 0 || startDate == null || startDate.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng điền đầy đủ thông tin");
                return "redirect:/admin/tenants/add";
            }
            
            // Validate user count
            if (userIds.size() > 4) {
                redirectAttributes.addFlashAttribute("error", "Không thể thêm quá 4 người vào một phòng!");
                return "redirect:/admin/tenants/add";
            }
            
            // Validate that room has space for all selected users
            int currentTenantCount = tenantDAO.getRoomTenantCount(roomId);
            if (currentTenantCount + userIds.size() > 4) {
                redirectAttributes.addFlashAttribute("error", 
                    String.format("Phòng này chỉ còn %d chỗ trống, không thể thêm %d người!", 
                                 4 - currentTenantCount, userIds.size()));
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
            
            // Create multiple tenants
            List<Tenant> createdTenants = new ArrayList<>();
            boolean allSuccess = true;
            
            for (Integer userId : userIds) {
                Tenant tenant = new Tenant();
                tenant.setUserId(userId);
                tenant.setRoomId(roomId);
                tenant.setStartDate(parsedDate);
                
                boolean success = tenantDAO.addTenant(tenant);
                if (success) {
                    // Get the newly created tenant
                    Tenant newTenant = tenantDAO.getActiveTenantByUserId(userId);
                    if (newTenant != null) {
                        createdTenants.add(newTenant);
                    }
                } else {
                    allSuccess = false;
                    break;
                }
            }
            
            if (allSuccess && !createdTenants.isEmpty()) {
                // Assign services to all created tenants
                if (serviceIds != null && !serviceIds.isEmpty()) {
                    // Get current month and year for initial service assignments
                    LocalDate now = LocalDate.now();
                    int currentMonth = now.getMonthValue();
                    int currentYear = now.getYear();
                    
                    boolean allServicesAssigned = true;
                    boolean allMeterReadingsInitialized = true;
                    
                    // Process initial meter readings if provided (shared for all tenants)
                    List<Integer> meterServiceIds = new ArrayList<>();
                    List<BigDecimal> meterReadings = new ArrayList<>();
                    
                    if (initialReadings != null && !initialReadings.isEmpty()) {
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
                    }
                    
                    // Assign services and meter readings to each tenant
                    for (Tenant tenant : createdTenants) {
                        int tenantId = tenant.getTenantId();
                        
                        // Assign services
                        boolean servicesAssigned = serviceUsageDAO.initializeServicesForTenant(tenantId, serviceIds, currentMonth, currentYear);
                        if (!servicesAssigned) {
                            allServicesAssigned = false;
                        }
                        
                        // Initialize meter readings if available
                        if (!meterServiceIds.isEmpty() && !meterReadings.isEmpty()) {
                            Date startDateParsed = Date.valueOf(startDate);
                            boolean meterReadingsInitialized = meterReadingDAO.initializeMeterReadingsForTenant(
                                tenantId, meterServiceIds, meterReadings, startDateParsed, currentMonth, currentYear
                            );
                            if (!meterReadingsInitialized) {
                                allMeterReadingsInitialized = false;
                            }
                        }
                    }
                    
                    // Generate success message
                    String successMessage;
                    if (createdTenants.size() == 1) {
                        if (allServicesAssigned && allMeterReadingsInitialized) {
                            successMessage = "Thêm thuê trọ, gán dịch vụ và khởi tạo chỉ số công tơ thành công!";
                        } else if (allServicesAssigned) {
                            successMessage = "Thêm thuê trọ và gán dịch vụ thành công!";
                        } else {
                            successMessage = "Thêm thuê trọ thành công nhưng có lỗi khi gán dịch vụ!";
                        }
                    } else {
                        if (allServicesAssigned && allMeterReadingsInitialized) {
                            successMessage = String.format("Thêm %d người thuê trọ, gán dịch vụ và khởi tạo chỉ số công tơ thành công!", createdTenants.size());
                        } else if (allServicesAssigned) {
                            successMessage = String.format("Thêm %d người thuê trọ và gán dịch vụ thành công!", createdTenants.size());
                        } else {
                            successMessage = String.format("Thêm %d người thuê trọ thành công nhưng có lỗi khi gán dịch vụ!", createdTenants.size());
                        }
                    }
                    redirectAttributes.addFlashAttribute("success", successMessage);
                } else {
                    // No services selected
                    String successMessage;
                    if (createdTenants.size() == 1) {
                        successMessage = "Thêm thuê trọ thành công!";
                    } else {
                        successMessage = String.format("Thêm %d người thuê trọ thành công!", createdTenants.size());
                    }
                    redirectAttributes.addFlashAttribute("success", successMessage);
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
     * View room details (room-based view)
     */
    @GetMapping("/tenants/view/{id}")
    public String viewRoomDetails(@PathVariable int id,
                                HttpSession session,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Get tenant to find room ID
        Tenant tenant = tenantDAO.getTenantById(id);
        if (tenant == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin thuê trọ");
            return "redirect:/admin/tenants";
        }
        
        // Get room information
        Room room = roomDAO.getRoomById(tenant.getRoomId());
        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin phòng");
            return "redirect:/admin/tenants";
        }
        
        // Get all tenants in this room
        List<Tenant> roomTenants = tenantDAO.getActiveTenantsByRoomId(tenant.getRoomId());
        
        // Add payment status for the room
        String roomPaymentStatus = tenantDAO.getRoomPaymentStatus(room.getRoomId());
        room.setPaymentStatus(roomPaymentStatus);
        
        // If room has unpaid bills, get the detailed list
        if (roomPaymentStatus != null && roomPaymentStatus.startsWith("UNPAID:")) {
            List<String> unpaidPeriods = tenantDAO.getRoomUnpaidPeriods(room.getRoomId());
            room.setUnpaidPeriods(unpaidPeriods);
        }
        
        // Get services for this room
        List<String> roomServices = new ArrayList<>();
        if (!roomTenants.isEmpty()) {
            String servicesDisplay = tenantDAO.getTenantServicesDisplay(roomTenants.get(0).getTenantId());
            if (servicesDisplay != null && !servicesDisplay.equals("Không có dịch vụ")) {
                String[] serviceArray = servicesDisplay.split(",");
                for (String service : serviceArray) {
                    roomServices.add(service.trim());
                }
            }
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("room", room);
        model.addAttribute("roomTenants", roomTenants);
        model.addAttribute("roomServices", roomServices);
        model.addAttribute("tenantCount", roomTenants.size());
        model.addAttribute("pageTitle", "Chi tiết Phòng: " + room.getRoomName());
        
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
            
            // Check if end date is in the future
            LocalDate endLocalDate = leaseEndDate.toLocalDate();
            LocalDate today = LocalDate.now();
            boolean isScheduledTermination = endLocalDate.isAfter(today);
            
            boolean success = tenantDAO.endTenantLease(id, leaseEndDate);
            
            if (success) {
                if (isScheduledTermination) {
                    redirectAttributes.addFlashAttribute("success", 
                        "Lên lịch kết thúc hợp đồng thành công! Hợp đồng sẽ tự động kết thúc vào ngày " + leaseEndDate.toString());
                } else {
                    redirectAttributes.addFlashAttribute("success", "Kết thúc hợp đồng thuê thành công!");
                }
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
    
    // ==================== SCHEDULED TASKS ====================
    
    /**
     * Tác vụ chạy hàng ngày vào 00:01 để kiểm tra và xử lý các hợp đồng kết thúc
     * Tìm tất cả tenant có end_date = hôm nay và cập nhật trạng thái phòng
     * 
     * Cron expression: "0 1 0 * * ?" = giây 0, phút 1, giờ 0, mọi ngày, mọi tháng, mọi năm
     */
    @Scheduled(cron = "0 1 0 * * ?")
    public void processExpiredLeases() {
        try {
            System.out.println("[SCHEDULED] Starting daily lease expiration check...");
            
            // Lấy danh sách tenant kết thúc hôm nay
            List<Tenant> expiredTenants = tenantDAO.getTenantsEndingToday();
            
            if (expiredTenants.isEmpty()) {
                System.out.println("[SCHEDULED] No leases expiring today.");
                return;
            }
            
            System.out.println("[SCHEDULED] Found " + expiredTenants.size() + " lease(s) expiring today.");
            
            // Xử lý từng tenant
            for (Tenant tenant : expiredTenants) {
                try {
                    processExpiredTenant(tenant);
                } catch (Exception e) {
                    System.err.println("[SCHEDULED] Error processing tenant " + tenant.getTenantId() + ": " + e.getMessage());
                    e.printStackTrace();
                }
            }
            
            System.out.println("[SCHEDULED] Completed daily lease expiration check.");
            
        } catch (Exception e) {
            System.err.println("[SCHEDULED] Error in processExpiredLeases: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * Xử lý một tenant cụ thể khi hợp đồng kết thúc
     * Cập nhật trạng thái phòng dựa trên số tenant còn lại
     * 
     * @param tenant tenant cần xử lý
     */
    private void processExpiredTenant(Tenant tenant) {
        System.out.println("[SCHEDULED] Processing expired lease for tenant: " + 
                          tenant.getFullName() + " (ID: " + tenant.getTenantId() + ") in room " + tenant.getRoomName());
        
        // Lấy số lượng tenant còn lại trong phòng (sau khi tenant này kết thúc)
        int remainingTenants = tenantDAO.getRoomTenantCount(tenant.getRoomId());
        
        // Log thông tin
        System.out.println("[SCHEDULED] Room " + tenant.getRoomName() + " will have " + 
                          remainingTenants + " tenant(s) after expiration.");
        
        // Trạng thái phòng sẽ được cập nhật tự động bởi logic trong TenantDAO
        // khi getRoomTenantCount() được gọi với logic mới (end_date IS NULL OR end_date > CURRENT_DATE)
        
        System.out.println("[SCHEDULED] Successfully processed expired lease for tenant " + tenant.getTenantId());
    }
}

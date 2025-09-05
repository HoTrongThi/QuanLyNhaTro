package controller;

import dao.SuperAdminDAO;
import dao.UserDAO;
import model.User;
import model.AdminManagement;
import model.AdminAuditLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.util.Random;

/**
 * Controller quản trị cấp cao (Super Admin)
 * Xử lý các chức năng dành riêng cho Super Admin
 * Bao gồm quản lý admin, thống kê hệ thống và audit log
 * Đảm bảo chỉ có Super Admin mới có thể truy cập
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Controller
@RequestMapping("/super-admin")
public class SuperAdminController {
    
    // ==================== CÁC THUỘC TÍNH DAO ====================
    
    /** DAO quản lý Super Admin */
    @Autowired
    private SuperAdminDAO superAdminDAO;
    
    /** DAO quản lý User */
    @Autowired
    private UserDAO userDAO;
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra quyền truy cập của Super Admin
     * Đảm bảo chỉ có người dùng đã đăng nhập và có vai trò Super Admin mới truy cập được
     * 
     * @param session HTTP Session chứa thông tin người dùng
     * @return null nếu có quyền truy cập, redirect URL nếu không có quyền
     */
    private String checkSuperAdminAccess(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        // Kiểm tra đăng nhập
        if (user == null) {
            return "redirect:/login";
        }
        
        // Kiểm tra quyền Super Admin
        if (!"SUPER_ADMIN".equals(user.getRole())) {
            return "redirect:/access-denied";
        }
        
        return null; // Có quyền truy cập
    }
    
    /**
     * Lấy IP address từ request
     * @param request HTTP request
     * @return IP address
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }
    
    // ==================== CÁC PHƯƠNG THỨC XỬ LÝ TRANG ====================
    
    /**
     * Hiển thị trang Dashboard Super Admin
     * Cung cấp tổng quan về toàn bộ hệ thống
     * Bao gồm thống kê admin, người dùng, phòng và doanh thu
     * 
     * @param session HTTP Session để kiểm tra quyền
     * @param model Model để truyền dữ liệu đến view
     * @return tên view dashboard hoặc redirect URL
     */
    @GetMapping("/dashboard")
    public String superAdminDashboard(HttpSession session, Model model) {
        // Kiểm tra quyền truy cập
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Lấy thống kê hệ thống
        Map<String, Object> systemStats = superAdminDAO.getSystemStats();
        
        // Lấy danh sách admin được quản lý
        List<AdminManagement> managedAdmins = superAdminDAO.getAllManagedAdmins(user.getUserId());
        
        // Lấy log hoạt động gần đây
        List<AdminAuditLog> recentLogs = superAdminDAO.getAuditLogs(user.getUserId(), 10);
        
        // Truyền dữ liệu đến view
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Bảng điều khiển Super Admin");
        model.addAttribute("systemStats", systemStats);
        model.addAttribute("managedAdmins", managedAdmins);
        model.addAttribute("recentLogs", recentLogs);
        
        return "super-admin/dashboard";
    }
    
    /**
     * Hiển thị trang quản lý Admin
     * Liệt kê tất cả admin trong hệ thống với thông tin quản lý
     * 
     * @param session HTTP Session để kiểm tra quyền
     * @param model Model để truyền dữ liệu đến view
     * @return tên view quản lý admin hoặc redirect URL
     */
    @GetMapping("/admins")
    public String manageAdmins(HttpSession session, Model model) {
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Lấy danh sách tất cả admin
        List<User> allAdmins = superAdminDAO.getAllAdmins();
        
        // Lấy danh sách admin được quản lý bởi Super Admin này
        List<AdminManagement> managedAdmins = superAdminDAO.getAllManagedAdmins(user.getUserId());
        
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Quản lý Admin");
        model.addAttribute("allAdmins", allAdmins);
        model.addAttribute("managedAdmins", managedAdmins);
        
        return "super-admin/admins";
    }
    
    /**
     * Hiển thị form thêm Admin mới
     * 
     * @param session HTTP Session để kiểm tra quyền
     * @param model Model để truyền dữ liệu đến view
     * @return tên view form thêm admin hoặc redirect URL
     */
    @GetMapping("/admins/add")
    public String showAddAdminForm(HttpSession session, Model model) {
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Thêm Admin mới");
        model.addAttribute("admin", new User());
        model.addAttribute("action", "add");
        
        return "super-admin/admin-form";
    }
    
    /**
     * Xử lý thêm Admin mới
     * 
     * @param admin thông tin admin mới
     * @param session HTTP Session
     * @param request HTTP Request để lấy IP
     * @param redirectAttributes để truyền thông báo
     * @return redirect URL
     */
    @PostMapping("/admins/add")
    public String addAdmin(@ModelAttribute User admin,
                          HttpSession session,
                          HttpServletRequest request,
                          RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User superAdmin = (User) session.getAttribute("user");
        String ipAddress = getClientIpAddress(request);
        
        // Validate input
        String validationError = validateAdminInput(admin, true);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/super-admin/admins/add";
        }
        
        // Kiểm tra username đã tồn tại
        if (userDAO.usernameExists(admin.getUsername())) {
            redirectAttributes.addFlashAttribute("error", "Tên đăng nhập đã tồn tại");
            return "redirect:/super-admin/admins/add";
        }
        
        // Kiểm tra email đã tồn tại
        if (userDAO.emailExists(admin.getEmail())) {
            redirectAttributes.addFlashAttribute("error", "Email đã tồn tại");
            return "redirect:/super-admin/admins/add";
        }
        
        // Tạo admin mới
        boolean success = superAdminDAO.createAdmin(admin, superAdmin.getUserId(), ipAddress);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", 
                "Tạo Admin mới thành công! Username: " + admin.getUsername());
        } else {
            redirectAttributes.addFlashAttribute("error", "Tạo Admin thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/super-admin/admins";
    }
    
    /**
     * Hiển thị form chỉnh sửa Admin
     * 
     * @param adminId ID admin cần chỉnh sửa
     * @param session HTTP Session
     * @param model Model
     * @param redirectAttributes để truyền thông báo lỗi
     * @return tên view form hoặc redirect URL
     */
    @GetMapping("/admins/edit/{adminId}")
    public String showEditAdminForm(@PathVariable int adminId,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User admin = userDAO.getUserById(adminId);
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy Admin");
            return "redirect:/super-admin/admins";
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Chỉnh sửa Admin");
        model.addAttribute("admin", admin);
        model.addAttribute("action", "edit");
        
        return "super-admin/admin-form";
    }
    
    /**
     * Xử lý cập nhật thông tin Admin
     * 
     * @param adminId ID admin
     * @param admin thông tin admin cập nhật
     * @param session HTTP Session
     * @param request HTTP Request
     * @param redirectAttributes để truyền thông báo
     * @return redirect URL
     */
    @PostMapping("/admins/edit/{adminId}")
    public String updateAdmin(@PathVariable int adminId,
                             @ModelAttribute User admin,
                             HttpSession session,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User superAdmin = (User) session.getAttribute("user");
        String ipAddress = getClientIpAddress(request);
        
        // Kiểm tra admin tồn tại
        User existingAdmin = userDAO.getUserById(adminId);
        if (existingAdmin == null || !"ADMIN".equals(existingAdmin.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy Admin");
            return "redirect:/super-admin/admins";
        }
        
        // Validate input
        String validationError = validateAdminInput(admin, false);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/super-admin/admins/edit/" + adminId;
        }
        
        // Kiểm tra email đã tồn tại cho user khác
        if (userDAO.emailExistsForOtherUser(admin.getEmail(), adminId)) {
            redirectAttributes.addFlashAttribute("error", "Email đã tồn tại");
            return "redirect:/super-admin/admins/edit/" + adminId;
        }
        
        // Set ID và cập nhật
        admin.setUserId(adminId);
        boolean success = superAdminDAO.updateAdmin(admin, superAdmin.getUserId(), ipAddress);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Cập nhật thông tin Admin thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Cập nhật thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/super-admin/admins";
    }
    
    /**
     * Reset mật khẩu Admin
     * 
     * @param adminId ID admin
     * @param session HTTP Session
     * @param request HTTP Request
     * @param redirectAttributes để truyền thông báo
     * @return redirect URL
     */
    @PostMapping("/admins/reset-password/{adminId}")
    public String resetAdminPassword(@PathVariable int adminId,
                                    HttpSession session,
                                    HttpServletRequest request,
                                    RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User superAdmin = (User) session.getAttribute("user");
        String ipAddress = getClientIpAddress(request);
        
        // Kiểm tra admin tồn tại
        User admin = userDAO.getUserById(adminId);
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy Admin");
            return "redirect:/super-admin/admins";
        }
        
        // Tạo mật khẩu mới ngẫu nhiên
        String newPassword = generateRandomPassword();
        
        boolean success = superAdminDAO.resetAdminPassword(adminId, newPassword, superAdmin.getUserId(), ipAddress);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", 
                "Reset mật khẩu thành công! Mật khẩu mới: " + newPassword + 
                " (Vui lòng thông báo cho Admin và yêu cầu đổi mật khẩu)");
        } else {
            redirectAttributes.addFlashAttribute("error", "Reset mật khẩu thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/super-admin/admins";
    }
    
    /**
     * Tạm khóa Admin
     * 
     * @param adminId ID admin
     * @param reason lý do tạm khóa
     * @param session HTTP Session
     * @param request HTTP Request
     * @param redirectAttributes để truyền thông báo
     * @return redirect URL
     */
    @PostMapping("/admins/suspend/{adminId}")
    public String suspendAdmin(@PathVariable int adminId,
                              @RequestParam(required = false) String reason,
                              HttpSession session,
                              HttpServletRequest request,
                              RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User superAdmin = (User) session.getAttribute("user");
        String ipAddress = getClientIpAddress(request);
        
        // Kiểm tra admin tồn tại
        User admin = userDAO.getUserById(adminId);
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy Admin");
            return "redirect:/super-admin/admins";
        }
        
        String suspendReason = (reason != null && !reason.trim().isEmpty()) ? 
            reason.trim() : "Tạm khóa bởi Super Admin";
        
        boolean success = superAdminDAO.suspendAdmin(adminId, superAdmin.getUserId(), suspendReason, ipAddress);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Tạm khóa Admin thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Tạm khóa thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/super-admin/admins";
    }
    
    /**
     * Kích hoạt Admin
     * 
     * @param adminId ID admin
     * @param session HTTP Session
     * @param request HTTP Request
     * @param redirectAttributes để truyền thông báo
     * @return redirect URL
     */
    @PostMapping("/admins/activate/{adminId}")
    public String activateAdmin(@PathVariable int adminId,
                               HttpSession session,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User superAdmin = (User) session.getAttribute("user");
        String ipAddress = getClientIpAddress(request);
        
        // Kiểm tra admin tồn tại
        User admin = userDAO.getUserById(adminId);
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy Admin");
            return "redirect:/super-admin/admins";
        }
        
        boolean success = superAdminDAO.activateAdmin(adminId, superAdmin.getUserId(), ipAddress);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Kích hoạt Admin thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Kích hoạt thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/super-admin/admins";
    }
    
    /**
     * Xóa Admin (soft delete)
     * 
     * @param adminId ID admin
     * @param session HTTP Session
     * @param request HTTP Request
     * @param redirectAttributes để truyền thông báo
     * @return redirect URL
     */
    @PostMapping("/admins/delete/{adminId}")
    public String deleteAdmin(@PathVariable int adminId,
                             HttpSession session,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User superAdmin = (User) session.getAttribute("user");
        String ipAddress = getClientIpAddress(request);
        
        // Kiểm tra admin tồn tại
        User admin = userDAO.getUserById(adminId);
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy Admin");
            return "redirect:/super-admin/admins";
        }
        
        boolean success = superAdminDAO.deleteAdmin(adminId, superAdmin.getUserId(), ipAddress);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Xóa Admin thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Xóa Admin thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/super-admin/admins";
    }
    
    /**
     * Hiển thị trang Audit Log
     * 
     * @param session HTTP Session
     * @param model Model
     * @param limit số lượng log hiển thị
     * @return tên view audit log hoặc redirect URL
     */
    @GetMapping("/audit-logs")
    public String showAuditLogs(HttpSession session,
                               Model model,
                               @RequestParam(defaultValue = "50") int limit) {
        
        String accessCheck = checkSuperAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Lấy audit logs (null để lấy tất cả, hoặc user.getUserId() để lấy của Super Admin này)
        List<AdminAuditLog> auditLogs = superAdminDAO.getAuditLogs(null, limit);
        
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Nhật ký hoạt động");
        model.addAttribute("auditLogs", auditLogs);
        model.addAttribute("limit", limit);
        
        return "super-admin/audit-logs";
    }
    

    
    // ==================== CÁC PHƯƠNG THỨC VALIDATION ====================
    
    /**
     * Validate thông tin admin input
     * 
     * @param admin thông tin admin
     * @param isNew có phải admin mới không
     * @return thông báo lỗi hoặc null nếu hợp lệ
     */
    private String validateAdminInput(User admin, boolean isNew) {
        if (admin.getFullName() == null || admin.getFullName().trim().isEmpty()) {
            return "Họ tên không được để trống";
        }
        
        if (admin.getEmail() == null || admin.getEmail().trim().isEmpty()) {
            return "Email không được để trống";
        }
        
        if (!isValidEmail(admin.getEmail())) {
            return "Email không hợp lệ";
        }
        
        if (isNew) {
            if (admin.getUsername() == null || admin.getUsername().trim().isEmpty()) {
                return "Tên đăng nhập không được để trống";
            }
            
            if (admin.getUsername().length() < 3) {
                return "Tên đăng nhập phải có ít nhất 3 ký tự";
            }
            
            if (admin.getPassword() == null || admin.getPassword().trim().isEmpty()) {
                return "Mật khẩu không được để trống";
            }
            
            if (admin.getPassword().length() < 6) {
                return "Mật khẩu phải có ít nhất 6 ký tự";
            }
        }
        
        return null; // Hợp lệ
    }
    
    /**
     * Kiểm tra email hợp lệ
     * 
     * @param email email cần kiểm tra
     * @return true nếu hợp lệ
     */
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$");
    }
    
    /**
     * Tạo mật khẩu ngẫu nhiên
     * 
     * @return mật khẩu ngẫu nhiên
     */
    private String generateRandomPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder password = new StringBuilder();
        Random random = new Random();
        
        for (int i = 0; i < 8; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
}
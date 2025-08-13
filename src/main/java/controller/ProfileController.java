package controller;

import dao.UserDAO;
import dao.TenantDAO;
import model.User;
import model.Tenant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

/**
 * Profile Controller
 * Handles user profile management for regular users
 */
@Controller
@RequestMapping("/user/profile")
public class ProfileController {
    
    @Autowired
    private UserDAO userDAO;
    
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
        
        return null;
    }
    
    /**
     * Show user profile page
     */
    @GetMapping("")
    public String showProfile(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        // Get current tenant info if user is a tenant
        Tenant currentTenant = null;
        if ("USER".equals(user.getRole())) {
            currentTenant = tenantDAO.getActiveTenantByUserId(user.getUserId());
        }
        
        model.addAttribute("user", user);
        model.addAttribute("currentTenant", currentTenant);
        model.addAttribute("pageTitle", "Thông tin cá nhân");
        
        return "profile/profile";
    }
    
    /**
     * Show edit profile form
     */
    @GetMapping("/edit")
    public String showEditProfileForm(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Chỉnh sửa thông tin cá nhân");
        
        return "profile/edit-profile";
    }
    
    /**
     * Process profile update
     */
    @PostMapping("/edit")
    public String processProfileUpdate(@ModelAttribute User updatedUser,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        try {
            // Validate input
            String validationError = validateProfileUpdate(updatedUser, currentUser.getUserId());
            if (validationError != null) {
                redirectAttributes.addFlashAttribute("error", validationError);
                return "redirect:/user/profile/edit";
            }
            
            // Update user information
            updatedUser.setUserId(currentUser.getUserId());
            boolean success = userDAO.updateUserProfile(updatedUser);
            
            if (success) {
                // Update session with new user info
                User refreshedUser = userDAO.getUserById(currentUser.getUserId());
                session.setAttribute("user", refreshedUser);
                
                redirectAttributes.addFlashAttribute("success", "Cập nhật thông tin cá nhân thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Cập nhật thông tin thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return "redirect:/user/profile";
    }
    
    /**
     * Show change password form
     */
    @GetMapping("/change-password")
    public String showChangePasswordForm(HttpSession session, Model model) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Đổi mật khẩu");
        
        return "profile/change-password";
    }
    
    /**
     * Process password change
     */
    @PostMapping("/change-password")
    public String processPasswordChange(@RequestParam("currentPassword") String currentPassword,
                                      @RequestParam("newPassword") String newPassword,
                                      @RequestParam("confirmPassword") String confirmPassword,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        try {
            // Validate passwords
            String validationError = validatePasswordChange(currentPassword, newPassword, confirmPassword, currentUser.getUserId());
            if (validationError != null) {
                redirectAttributes.addFlashAttribute("error", validationError);
                return "redirect:/user/profile/change-password";
            }
            
            // Update password
            boolean success = userDAO.updateUserPassword(currentUser.getUserId(), newPassword);
            
            if (success) {
                redirectAttributes.addFlashAttribute("success", "Đổi mật khẩu thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return "redirect:/user/profile";
    }
    
    /**
     * Show rental history for tenant users
     */
    @GetMapping("/rental-history")
    public String showRentalHistory(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
        String accessCheck = checkUserAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        if (!"USER".equals(user.getRole())) {
            redirectAttributes.addFlashAttribute("error", "Tính năng này chỉ dành cho người dùng thường");
            return "redirect:/user/profile";
        }
        
        // Get current tenant info
        Tenant currentTenant = tenantDAO.getActiveTenantByUserId(user.getUserId());
        
        model.addAttribute("user", user);
        model.addAttribute("currentTenant", currentTenant);
        model.addAttribute("pageTitle", "Lịch sử thuê trọ");
        
        return "profile/rental-history";
    }
    
    // Validation methods
    private String validateProfileUpdate(User user, int currentUserId) {
        if (user.getFullName() == null || user.getFullName().trim().isEmpty()) {
            return "Họ tên không được để trống";
        }
        
        if (user.getFullName().trim().length() > 100) {
            return "Họ tên không được vượt quá 100 ký tự";
        }
        
        if (user.getPhone() != null && !user.getPhone().trim().isEmpty()) {
            if (user.getPhone().trim().length() > 15) {
                return "Số điện thoại không được vượt quá 15 ký tự";
            }
            // Basic phone validation
            if (!user.getPhone().matches("^[0-9+\\-\\s()]+$")) {
                return "Số điện thoại không hợp lệ";
            }
        }
        
        if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
            if (user.getEmail().trim().length() > 100) {
                return "Email không được vượt quá 100 ký tự";
            }
            // Basic email validation
            if (!user.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                return "Email không hợp lệ";
            }
            // Check if email exists for other user
            if (userDAO.emailExistsForOtherUser(user.getEmail().trim(), currentUserId)) {
                return "Email này đã được sử dụng bởi tài khoản khác";
            }
        }
        
        if (user.getAddress() != null && user.getAddress().length() > 255) {
            return "Địa chỉ không được vượt quá 255 ký tự";
        }
        
        return null; // Valid
    }
    
    private String validatePasswordChange(String currentPassword, String newPassword, String confirmPassword, int userId) {
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            return "Vui lòng nhập mật khẩu hiện tại";
        }
        
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return "Vui lòng nhập mật khẩu mới";
        }
        
        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            return "Vui lòng xác nhận mật khẩu mới";
        }
        
        if (newPassword.length() < 6) {
            return "Mật khẩu mới phải có ít nhất 6 ký tự";
        }
        
        if (!newPassword.equals(confirmPassword)) {
            return "Mật khẩu mới và xác nhận mật khẩu không khớp";
        }
        
        // Verify current password
        if (!userDAO.verifyPassword(userId, currentPassword)) {
            return "Mật khẩu hiện tại không đúng";
        }
        
        if (currentPassword.equals(newPassword)) {
            return "Mật khẩu mới phải khác mật khẩu hiện tại";
        }
        
        return null; // Valid
    }
}

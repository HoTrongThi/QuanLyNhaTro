package controller;

import dao.UserDAO;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Admin User Management Controller
 * Handles admin functionality for managing system users
 */
@Controller
@RequestMapping("/admin")
public class AdminUserController {
    
    @Autowired
    private UserDAO userDAO;
    
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
     * Show users management page
     */
    @GetMapping("/users")
    public String showUsersPage(HttpSession session, Model model,
                               @RequestParam(value = "search", required = false) String search,
                               @RequestParam(value = "role", required = false, defaultValue = "all") String role) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<User> users;
        
        // Handle search and filter functionality
        if (search != null && !search.trim().isEmpty()) {
            users = userDAO.searchUsers(search.trim());
            model.addAttribute("searchTerm", search.trim());
        } else {
            users = userDAO.getAllUsers();
        }
        
        // Filter by role if specified
        if (!"all".equals(role)) {
            users = users.stream()
                    .filter(u -> role.equalsIgnoreCase(u.getRole()))
                    .collect(java.util.stream.Collectors.toList());
        }
        
        model.addAttribute("user", user);
        model.addAttribute("users", users);
        model.addAttribute("pageTitle", "Quản lý Người dùng");
        model.addAttribute("selectedRole", role);
        model.addAttribute("totalUsers", userDAO.getTotalUserCount());
        model.addAttribute("regularUsers", userDAO.getRegularUserCount());
        model.addAttribute("adminUsers", userDAO.getAdminUserCount());
        model.addAttribute("activeTenantsCount", userDAO.getActiveTenantsCount());
        
        return "admin/users";
    }
    
    /**
     * View user details
     */
    @GetMapping("/users/view/{id}")
    public String viewUser(@PathVariable int id,
                          HttpSession session,
                          Model model,
                          RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User targetUser = userDAO.getUserById(id);
        if (targetUser == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin người dùng");
            return "redirect:/admin/users";
        }
        
        User user = (User) session.getAttribute("user");
        boolean canDelete = userDAO.canDeleteUser(id);
        
        model.addAttribute("user", user);
        model.addAttribute("targetUser", targetUser);
        model.addAttribute("canDelete", canDelete);
        model.addAttribute("pageTitle", "Chi tiết Người dùng: " + targetUser.getFullName());
        
        return "admin/user-detail";
    }
    
    /**
     * Delete user
     */
    @PostMapping("/users/delete/{id}")
    public String deleteUser(@PathVariable int id,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        try {
            User targetUser = userDAO.getUserById(id);
            if (targetUser == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy thông tin người dùng");
                return "redirect:/admin/users";
            }
            
            // Prevent deleting admin users
            if ("ADMIN".equals(targetUser.getRole())) {
                redirectAttributes.addFlashAttribute("error", "Không thể xóa tài khoản quản trị viên");
                return "redirect:/admin/users";
            }
            
            // Check if user can be deleted
            if (!userDAO.canDeleteUser(id)) {
                redirectAttributes.addFlashAttribute("error", "Không thể xóa người dùng này. Người dùng hiện đang thuê trọ.");
                return "redirect:/admin/users";
            }
            
            boolean success = userDAO.deleteUser(id);
            
            if (success) {
                redirectAttributes.addFlashAttribute("success", "Xóa người dùng thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Xóa người dùng thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            System.err.println("Error deleting user: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return "redirect:/admin/users";
    }
    
    /**
     * Add new user form
     */
    @GetMapping("/users/add")
    public String showAddUserForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("newUser", new User());
        model.addAttribute("pageTitle", "Thêm Người dùng mới");
        model.addAttribute("action", "add");
        
        return "admin/user-form";
    }
    
    /**
     * Process add user
     */
    @PostMapping("/users/add")
    public String processAddUser(@ModelAttribute("newUser") User newUser,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        try {
            // Validate input
            if (newUser.getUsername() == null || newUser.getUsername().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập không được để trống");
                return "redirect:/admin/users/add";
            }
            
            if (newUser.getPassword() == null || newUser.getPassword().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Mật khẩu không được để trống");
                return "redirect:/admin/users/add";
            }
            
            if (newUser.getFullName() == null || newUser.getFullName().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Họ tên không được để trống");
                return "redirect:/admin/users/add";
            }
            
            if (newUser.getEmail() == null || newUser.getEmail().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Email không được để trống");
                return "redirect:/admin/users/add";
            }
            
            // Check if username already exists
            if (userDAO.usernameExists(newUser.getUsername())) {
                redirectAttributes.addFlashAttribute("error", "Tên đăng nhập đã tồn tại");
                return "redirect:/admin/users/add";
            }
            
            // Check if email already exists
            if (userDAO.emailExists(newUser.getEmail())) {
                redirectAttributes.addFlashAttribute("error", "Email đã tồn tại");
                return "redirect:/admin/users/add";
            }
            
            // Set default role if not specified
            if (newUser.getRole() == null || newUser.getRole().trim().isEmpty()) {
                newUser.setRole("USER");
            }
            
            boolean success = userDAO.registerUser(newUser);
            
            if (success) {
                redirectAttributes.addFlashAttribute("success", "Thêm người dùng thành công!");
                return "redirect:/admin/users";
            } else {
                redirectAttributes.addFlashAttribute("error", "Thêm người dùng thất bại. Vui lòng thử lại.");
                return "redirect:/admin/users/add";
            }
            
        } catch (Exception e) {
            System.err.println("Error adding user: " + e.getMessage());
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/users/add";
        }
    }
}

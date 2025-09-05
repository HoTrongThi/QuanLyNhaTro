package controller;

import dao.UserDAO;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

/**
 * Controller xử lý xác thực người dùng (Đã cập nhật với Super Admin)
 * Quản lý các chức năng đăng nhập, đăng xuất và điều hướng trang chủ
 * Xử lý việc phân quyền dựa trên vai trò người dùng (Super Admin/Admin/User)
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 2.0
 * @since 2025
 */
@Controller
public class AuthController {
    
    // ==================== CÁC THUỘC TÍNH ====================
    
    /** DAO để thao tác với dữ liệu người dùng */
    @Autowired
    private UserDAO userDAO;
    
    // ==================== CÁC PHƯƠNG THỨC XỬ LÝ TRANG ====================
    
    /**
     * Hiển thị trang đăng nhập
     * Kiểm tra nếu người dùng đã đăng nhập thì chuyển hướng đến dashboard tương ứng
     * 
     * @param model Model để truyền dữ liệu đến view
     * @param session HTTP Session để kiểm tra trạng thái đăng nhập
     * @return tên view hoặc redirect URL
     */
    @GetMapping("/login")
    public String showLoginPage(Model model, HttpSession session) {
        // Kiểm tra nếu đã đăng nhập thì chuyển hướng đến dashboard
        if (session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            return redirectToDashboard(user);
        }
        
        // Thêm đối tượng User rỗng vào model cho form đăng nhập
        model.addAttribute("user", new User());
        return "auth/login"; // Trả về trang đăng nhập
    }
    
    /**
     * Xử lý quá trình đăng nhập
     * Kiểm tra thông tin đăng nhập và tạo session cho người dùng
     * Phân quyền và chuyển hướng dựa trên vai trò người dùng
     * 
     * @param username tên đăng nhập từ form
     * @param password mật khẩu từ form
     * @param session HTTP Session để lưu thông tin người dùng
     * @param redirectAttributes để truyền thông báo qua redirect
     * @return redirect URL dựa trên kết quả đăng nhập
     */
    @PostMapping("/login")
    public String processLogin(@RequestParam String username, 
                             @RequestParam String password,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        
        // Kiểm tra tính hợp lệ của dữ liệu đầu vào
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu");
            return "redirect:/login";
        }
        
        // Thử đăng nhập với thông tin đã nhập
        User user = userDAO.loginUser(username.trim(), password);
        
        if (user != null) {
            // Đăng nhập thành công - tạo session
            session.setAttribute("user", user);                    // Lưu đối tượng user
            session.setAttribute("username", user.getUsername());   // Lưu tên đăng nhập
            session.setAttribute("fullName", user.getFullName());   // Lưu họ tên
            session.setAttribute("role", user.getRole());           // Lưu vai trò
            
            // Thêm thông báo chào mừng
            String welcomeMessage = getWelcomeMessage(user);
            redirectAttributes.addFlashAttribute("success", welcomeMessage);
            
            // Chuyển hướng dựa trên vai trò
            return redirectToDashboard(user);
        } else {
            // Đăng nhập thất bại
            redirectAttributes.addFlashAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác");
            return "redirect:/login";
        }
    }
    
    /**
     * Xử lý đăng xuất
     * Hủy bỏ toàn bộ session và chuyển hướng về trang đăng nhập
     * 
     * @param session HTTP Session cần hủy bỏ
     * @param redirectAttributes để truyền thông báo thành công
     * @return redirect đến trang đăng nhập
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        // Lấy thông tin user trước khi hủy session (để hiển thị thông báo)
        User user = (User) session.getAttribute("user");
        String logoutMessage = "Đăng xuất thành công";
        
        if (user != null) {
            logoutMessage = "Tạm biệt " + user.getFullName() + "! Đăng xuất thành công.";
        }
        
        // Hủy bỏ toàn bộ session (xóa tất cả thông tin đăng nhập)
        session.invalidate();
        
        // Thêm thông báo thành công
        redirectAttributes.addFlashAttribute("success", logoutMessage);
        
        // Chuyển hướng về trang đăng nhập
        return "redirect:/login";
    }
    
    /**
     * Xử lý trang chủ - điều hướng dựa trên trạng thái đăng nhập
     * Nếu chưa đăng nhập thì chuyển đến trang đăng nhập
     * Nếu đã đăng nhập thì chuyển đến dashboard tương ứng
     * 
     * @param session HTTP Session để kiểm tra trạng thái đăng nhập
     * @return redirect URL phù hợp
     */
    @GetMapping("/")
    public String home(HttpSession session) {
        // Lấy thông tin người dùng từ session
        User user = (User) session.getAttribute("user");
        
        // Nếu đã đăng nhập thì chuyển đến dashboard tương ứng
        if (user != null) {
            return redirectToDashboard(user);
        }
        
        // Chưa đăng nhập thì chuyển đến trang đăng nhập
        return "redirect:/login";
    }
    
    /**
     * Xử lý trang access denied
     * Hiển thị khi người dùng không có quyền truy cập
     * 
     * @param model Model để truyền dữ liệu
     * @param session HTTP Session
     * @return tên view access denied
     */
    @GetMapping("/access-denied")
    public String accessDenied(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        model.addAttribute("user", user);
        model.addAttribute("pageTitle", "Truy cập bị từ chối");
        return "error/access-denied";
    }
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Chuyển hướng đến dashboard phù hợp dựa trên vai trò
     * 
     * @param user đối tượng User
     * @return redirect URL
     */
    private String redirectToDashboard(User user) {
        if ("SUPER_ADMIN".equals(user.getRole())) {
            return "redirect:/super-admin/dashboard";  // Super Admin đến trang quản trị cấp cao
        } else if ("ADMIN".equals(user.getRole())) {
            return "redirect:/admin/dashboard";        // Admin đến trang quản trị
        } else {
            return "redirect:/user/dashboard";         // User thường đến trang cá nhân
        }
    }
    
    /**
     * Tạo thông báo chào mừng dựa trên vai trò
     * 
     * @param user đối tượng User
     * @return thông báo chào mừng
     */
    private String getWelcomeMessage(User user) {
        String roleDisplay = getRoleDisplayName(user.getRole());
        return "Chào mừng " + roleDisplay + " " + user.getFullName() + "!";
    }
    
    /**
     * Lấy tên hiển thị của vai trò
     */
    private String getRoleDisplayName(String role) {
        switch (role) {
            case "SUPER_ADMIN": return "Super Admin";
            case "ADMIN": return "Quản trị viên";
            case "USER": return "Người dùng";
            default: return "Người dùng";
        }
    }
    
    /**
     * Kiểm tra quyền truy cập Super Admin
     * 
     * @param session HTTP Session
     * @return true nếu có quyền Super Admin
     */
    public static boolean isSuperAdminLoggedIn(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "SUPER_ADMIN".equals(user.getRole());
    }
    
    /**
     * Kiểm tra quyền truy cập Admin (bao gồm Super Admin)
     * 
     * @param session HTTP Session
     * @return true nếu có quyền Admin hoặc Super Admin
     */
    public static boolean isAdminLoggedIn(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && ("ADMIN".equals(user.getRole()) || "SUPER_ADMIN".equals(user.getRole()));
    }
    
    /**
     * Kiểm tra người dùng đã đăng nhập
     * 
     * @param session HTTP Session
     * @return true nếu đã đăng nhập
     */
    public static boolean isUserLoggedIn(HttpSession session) {
        return session.getAttribute("user") != null;
    }
    
    /**
     * Lấy thông tin user từ session
     * 
     * @param session HTTP Session
     * @return đối tượng User hoặc null
     */
    public static User getCurrentUser(HttpSession session) {
        return (User) session.getAttribute("user");
    }
}
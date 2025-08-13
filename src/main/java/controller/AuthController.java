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
 * Authentication Controller
 * Handles user registration, login, and logout
 */
@Controller
public class AuthController {
    
    @Autowired
    private UserDAO userDAO;
    
    /**
     * Show login page
     */
    @GetMapping("/login")
    public String showLoginPage(Model model, HttpSession session) {
        // Redirect to dashboard if already logged in
        if (session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/user/dashboard";
            }
        }
        
        model.addAttribute("user", new User());
        return "auth/login";
    }
    
    /**
     * Process login
     */
    @PostMapping("/login")
    public String processLogin(@RequestParam String username, 
                             @RequestParam String password,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu");
            return "redirect:/login";
        }
        
        // Attempt login
        User user = userDAO.loginUser(username.trim(), password);
        
        if (user != null) {
            // Login successful
            session.setAttribute("user", user);
            session.setAttribute("username", user.getUsername());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole());
            
            // Redirect based on role
            if (user.isAdmin()) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/user/dashboard";
            }
        } else {
            // Login failed
            redirectAttributes.addFlashAttribute("error", "Tên đăng nhập hoặc mật khẩu không chính xác");
            return "redirect:/login";
        }
    }
    
    
    /**
     * Process logout
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("success", "Đăng xuất thành công");
        return "redirect:/login";
    }
    
    /**
     * Home page redirect
     */
    @GetMapping("/")
    public String home(HttpSession session) {
        User user = (User) session.getAttribute("user");
        
        if (user != null) {
            if (user.isAdmin()) {
                return "redirect:/admin/dashboard";
            } else {
                return "redirect:/user/dashboard";
            }
        }
        
        return "redirect:/login";
    }
}

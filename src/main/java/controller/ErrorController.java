package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Error Controller
 * Handles error pages and access denied scenarios
 */
@Controller
public class ErrorController {
    
    /**
     * Access Denied Page
     */
    @GetMapping("/access-denied")
    public String accessDenied(Model model) {
        model.addAttribute("pageTitle", "Truy cập bị từ chối");
        model.addAttribute("errorTitle", "Truy cập bị từ chối");
        model.addAttribute("errorMessage", "Bạn không có quyền truy cập vào trang này.");
        
        return "error/access-denied";
    }
    
    /**
     * 404 Error Page
     */
    @GetMapping("/error/404")
    public String error404(Model model) {
        model.addAttribute("pageTitle", "Không tìm thấy trang");
        model.addAttribute("errorTitle", "404 - Không tìm thấy trang");
        model.addAttribute("errorMessage", "Trang bạn đang tìm kiếm không tồn tại.");
        
        return "error/404";
    }
    
    /**
     * 500 Error Page
     */
    @GetMapping("/error/500")
    public String error500(Model model) {
        model.addAttribute("pageTitle", "Lỗi máy chủ");
        model.addAttribute("errorTitle", "500 - Lỗi máy chủ nội bộ");
        model.addAttribute("errorMessage", "Đã xảy ra lỗi máy chủ. Vui lòng thử lại sau.");
        
        return "error/500";
    }
}

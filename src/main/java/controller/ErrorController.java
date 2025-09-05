package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller Xử lý Lỗi
 * Xử lý các trang lỗi hệ thống
 * Bao gồm lỗi 404 (không tìm thấy trang) và 500 (lỗi máy chủ)
 * Hiển thị thông báo lỗi thân thiện với người dùng
 * 
 * Lưu ý: Trang access-denied được xử lý bởi AuthController
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Controller
public class ErrorController {
    
    // ==================== CÁC TRANG LỖI ====================
    
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

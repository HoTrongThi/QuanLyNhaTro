package controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Controller Xử lý Lỗi
 * Xử lý các trang lỗi và tình huống bị từ chối truy cập
 * Bao gồm lỗi 404 (không tìm thấy trang), 500 (lỗi máy chủ) và access denied
 * Hiển thị thông báo lỗi thân thiện với người dùng
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Controller
public class ErrorController {
    
    // ==================== CÁC TRANG LỖI ====================
    
    /**
     * Trang Từ chối Truy cập
     * Hiển thị khi người dùng không có quyền truy cập tài nguyên
     * 
     * @param model Model để truyền dữ liệu đến view
     * @return tên view của trang access denied
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

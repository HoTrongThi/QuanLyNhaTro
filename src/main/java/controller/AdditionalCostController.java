package controller;

import dao.AdditionalCostDAO;
import dao.TenantDAO;
import model.AdditionalCost;
import model.Tenant;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Additional Cost Management Controller
 * Handles additional/incidental costs for tenants
 */
@Controller
@RequestMapping("/admin")
public class AdditionalCostController {
    
    @Autowired
    private AdditionalCostDAO additionalCostDAO;
    
    @Autowired
    private TenantDAO tenantDAO;
    
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
        
        return null; // Access granted
    }
    
    /**
     * Show additional costs management page
     */
    @GetMapping("/additional-costs")
    public String showAdditionalCostsPage(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<AdditionalCost> costs = additionalCostDAO.getAllAdditionalCosts();
        
        model.addAttribute("user", user);
        model.addAttribute("additionalCosts", costs);
        model.addAttribute("pageTitle", "Quản lý Chi phí phát sinh");
        
        return "admin/additional-costs";
    }
    
    /**
     * Show add additional cost form
     */
    @GetMapping("/additional-costs/add")
    public String showAddAdditionalCostForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Tenant> tenants = tenantDAO.getActiveTenants();
        
        model.addAttribute("user", user);
        model.addAttribute("additionalCost", new AdditionalCost());
        model.addAttribute("tenants", tenants);
        model.addAttribute("pageTitle", "Thêm Chi phí phát sinh");
        model.addAttribute("action", "add");
        
        return "admin/additional-cost-form";
    }
    
    /**
     * Process add additional cost
     */
    @PostMapping("/additional-costs/add")
    public String processAddAdditionalCost(@ModelAttribute AdditionalCost additionalCost,
                                         @RequestParam String dateString,
                                         HttpSession session,
                                         RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Parse date
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date date = dateFormat.parse(dateString);
            additionalCost.setDate(date);
        } catch (ParseException e) {
            redirectAttributes.addFlashAttribute("error", "Định dạng ngày không hợp lệ");
            return "redirect:/admin/additional-costs/add";
        }
        
        // Validate input
        String validationError = validateAdditionalCost(additionalCost);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/additional-costs/add";
        }
        
        // Clean data
        additionalCost.setDescription(additionalCost.getDescription().trim());
        
        // Add additional cost
        boolean success = additionalCostDAO.addAdditionalCost(additionalCost);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Thêm chi phí phát sinh thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Thêm chi phí phát sinh thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/additional-costs";
    }
    
    /**
     * Show edit additional cost form
     */
    @GetMapping("/additional-costs/edit/{id}")
    public String showEditAdditionalCostForm(@PathVariable int id,
                                           HttpSession session,
                                           Model model,
                                           RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        AdditionalCost additionalCost = additionalCostDAO.getAdditionalCostById(id);
        if (additionalCost == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy chi phí phát sinh");
            return "redirect:/admin/additional-costs";
        }
        
        User user = (User) session.getAttribute("user");
        List<Tenant> tenants = tenantDAO.getActiveTenants();
        
        // Format date for form
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String formattedDate = dateFormat.format(additionalCost.getDate());
        
        model.addAttribute("user", user);
        model.addAttribute("additionalCost", additionalCost);
        model.addAttribute("tenants", tenants);
        model.addAttribute("formattedDate", formattedDate);
        model.addAttribute("pageTitle", "Chỉnh sửa Chi phí phát sinh");
        model.addAttribute("action", "edit");
        
        return "admin/additional-cost-form";
    }
    
    /**
     * Process edit additional cost
     */
    @PostMapping("/additional-costs/edit/{id}")
    public String processEditAdditionalCost(@PathVariable int id,
                                          @ModelAttribute AdditionalCost additionalCost,
                                          @RequestParam String dateString,
                                          HttpSession session,
                                          RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Verify additional cost exists
        AdditionalCost existingCost = additionalCostDAO.getAdditionalCostById(id);
        if (existingCost == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy chi phí phát sinh");
            return "redirect:/admin/additional-costs";
        }
        
        // Parse date
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date date = dateFormat.parse(dateString);
            additionalCost.setDate(date);
        } catch (ParseException e) {
            redirectAttributes.addFlashAttribute("error", "Định dạng ngày không hợp lệ");
            return "redirect:/admin/additional-costs/edit/" + id;
        }
        
        // Validate input
        String validationError = validateAdditionalCost(additionalCost);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/additional-costs/edit/" + id;
        }
        
        // Set cost ID and clean data
        additionalCost.setCostId(id);
        additionalCost.setDescription(additionalCost.getDescription().trim());
        
        // Update additional cost
        boolean success = additionalCostDAO.updateAdditionalCost(additionalCost);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Cập nhật chi phí phát sinh thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Cập nhật chi phí phát sinh thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/additional-costs";
    }
    
    /**
     * Delete additional cost
     */
    @PostMapping("/additional-costs/delete/{id}")
    public String deleteAdditionalCost(@PathVariable int id,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        AdditionalCost additionalCost = additionalCostDAO.getAdditionalCostById(id);
        if (additionalCost == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy chi phí phát sinh");
            return "redirect:/admin/additional-costs";
        }
        
        boolean success = additionalCostDAO.deleteAdditionalCost(id);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Xóa chi phí phát sinh thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Xóa chi phí phát sinh thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/additional-costs";
    }
    
    /**
     * View additional cost details
     */
    @GetMapping("/additional-costs/view/{id}")
    public String viewAdditionalCost(@PathVariable int id,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        AdditionalCost additionalCost = additionalCostDAO.getAdditionalCostById(id);
        if (additionalCost == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy chi phí phát sinh");
            return "redirect:/admin/additional-costs";
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("additionalCost", additionalCost);
        model.addAttribute("pageTitle", "Chi tiết Chi phí phát sinh");
        
        return "admin/additional-cost-detail";
    }
    
    /**
     * Validate additional cost data
     */
    private String validateAdditionalCost(AdditionalCost additionalCost) {
        if (additionalCost.getTenantId() <= 0) {
            return "Vui lòng chọn người thuê";
        }
        
        if (additionalCost.getDescription() == null || additionalCost.getDescription().trim().isEmpty()) {
            return "Mô tả không được để trống";
        }
        
        if (additionalCost.getDescription().trim().length() > 255) {
            return "Mô tả không được vượt quá 255 ký tự";
        }
        
        if (additionalCost.getAmount() == null || additionalCost.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            return "Số tiền phải lớn hơn 0";
        }
        
        if (additionalCost.getDate() == null) {
            return "Ngày không được để trống";
        }
        
        // Check if date is not in the future
        Date now = new Date();
        if (additionalCost.getDate().after(now)) {
            return "Ngày không được trong tương lai";
        }
        
        return null; // Valid
    }
}

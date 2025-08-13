package controller;

import dao.ServiceDAO;
import model.Service;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.util.List;

/**
 * Service Management Controller
 * Handles service CRUD operations for admins
 */
@Controller
@RequestMapping("/admin")
public class ServiceController {
    
    @Autowired
    private ServiceDAO serviceDAO;
    
    /**
     * Check if user is admin, redirect to login if not authenticated or not admin
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
     * Show services management page
     */
    @GetMapping("/services")
    public String showServicesPage(HttpSession session, Model model,
                                  @RequestParam(value = "search", required = false) String search) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Service> services;
        
        // Handle search functionality
        if (search != null && !search.trim().isEmpty()) {
            services = serviceDAO.searchServicesByName(search.trim());
            model.addAttribute("searchTerm", search.trim());
        } else {
            services = serviceDAO.getAllServices();
        }
        
        model.addAttribute("user", user);
        model.addAttribute("services", services);
        model.addAttribute("pageTitle", "Quản lý Dịch vụ");
        model.addAttribute("totalServices", serviceDAO.getTotalServiceCount());
        
        return "admin/services";
    }
    
    /**
     * Show add service form
     */
    @GetMapping("/services/add")
    public String showAddServiceForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("service", new Service());
        model.addAttribute("pageTitle", "Thêm Dịch vụ mới");
        model.addAttribute("action", "add");
        
        return "admin/service-form";
    }
    
    /**
     * Process add service
     */
    @PostMapping("/services/add")
    public String processAddService(@ModelAttribute Service service,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Validate input
        String validationError = validateService(service, true);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/services/add";
        }
        
        // Check if service name already exists
        if (serviceDAO.serviceNameExists(service.getServiceName().trim())) {
            redirectAttributes.addFlashAttribute("error", "Tên dịch vụ đã tồn tại");
            return "redirect:/admin/services/add";
        }
        
        // Clean and set data
        service.setServiceName(service.getServiceName().trim());
        if (service.getUnit() != null) {
            service.setUnit(service.getUnit().trim());
        }
        
        // Add service
        boolean success = serviceDAO.addService(service);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Thêm dịch vụ thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Thêm dịch vụ thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/services";
    }
    
    /**
     * Show edit service form
     */
    @GetMapping("/services/edit/{id}")
    public String showEditServiceForm(@PathVariable int id,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Service service = serviceDAO.getServiceById(id);
        if (service == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy dịch vụ");
            return "redirect:/admin/services";
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("service", service);
        model.addAttribute("pageTitle", "Chỉnh sửa Dịch vụ: " + service.getServiceName());
        model.addAttribute("action", "edit");
        
        return "admin/service-form";
    }
    
    /**
     * Process edit service
     */
    @PostMapping("/services/edit/{id}")
    public String processEditService(@PathVariable int id,
                                   @ModelAttribute Service service,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Verify service exists
        Service existingService = serviceDAO.getServiceById(id);
        if (existingService == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy dịch vụ");
            return "redirect:/admin/services";
        }
        
        // Validate input
        String validationError = validateService(service, false);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/services/edit/" + id;
        }
        
        // Check if service name already exists (excluding current service)
        if (serviceDAO.serviceNameExists(service.getServiceName().trim(), id)) {
            redirectAttributes.addFlashAttribute("error", "Tên dịch vụ đã tồn tại");
            return "redirect:/admin/services/edit/" + id;
        }
        
        // Set service ID and clean data
        service.setServiceId(id);
        service.setServiceName(service.getServiceName().trim());
        if (service.getUnit() != null) {
            service.setUnit(service.getUnit().trim());
        }
        
        // Update service
        boolean success = serviceDAO.updateService(service);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Cập nhật dịch vụ thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Cập nhật dịch vụ thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/services";
    }
    
    /**
     * Delete service
     */
    @PostMapping("/services/delete/{id}")
    public String deleteService(@PathVariable int id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Service service = serviceDAO.getServiceById(id);
        if (service == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy dịch vụ");
            return "redirect:/admin/services";
        }
        
        // Check if service is in use
        if (serviceDAO.isServiceInUse(id)) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa dịch vụ đang được sử dụng");
            return "redirect:/admin/services";
        }
        
        boolean success = serviceDAO.deleteService(id);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Xóa dịch vụ thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Xóa dịch vụ thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/services";
    }
    
    /**
     * View service details
     */
    @GetMapping("/services/view/{id}")
    public String viewService(@PathVariable int id,
                            HttpSession session,
                            Model model,
                            RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Service service = serviceDAO.getServiceById(id);
        if (service == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy dịch vụ");
            return "redirect:/admin/services";
        }
        
        User user = (User) session.getAttribute("user");
        boolean canDelete = !serviceDAO.isServiceInUse(id);
        
        model.addAttribute("user", user);
        model.addAttribute("service", service);
        model.addAttribute("canDelete", canDelete);
        model.addAttribute("pageTitle", "Chi tiết Dịch vụ: " + service.getServiceName());
        
        return "admin/service-detail";
    }
    
    /**
     * Validate service data
     * @param service Service object to validate
     * @param isNew Whether this is a new service
     * @return Error message if validation fails, null if valid
     */
    private String validateService(Service service, boolean isNew) {
        // Check required fields
        if (service.getServiceName() == null || service.getServiceName().trim().isEmpty()) {
            return "Tên dịch vụ không được để trống";
        }
        
        if (service.getServiceName().trim().length() > 100) {
            return "Tên dịch vụ không được vượt quá 100 ký tự";
        }
        
        if (service.getPricePerUnit() == null || service.getPricePerUnit().compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá dịch vụ phải lớn hơn 0";
        }
        
        if (service.getUnit() != null && service.getUnit().trim().length() > 50) {
            return "Đơn vị không được vượt quá 50 ký tự";
        }
        
        return null; // Valid
    }
}

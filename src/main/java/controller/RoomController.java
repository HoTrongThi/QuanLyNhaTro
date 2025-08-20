package controller;

import dao.RoomDAO;
import model.Room;
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
 * Room Management Controller
 * Handles room CRUD operations for admins
 */
@Controller
@RequestMapping("/admin")
public class RoomController {
    
    @Autowired
    private RoomDAO roomDAO;
    
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
     * Show rooms management page
     */
    @GetMapping("/rooms")
    public String showRoomsPage(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        List<Room> rooms = roomDAO.getAllRooms();
        
        model.addAttribute("user", user);
        model.addAttribute("rooms", rooms);
        model.addAttribute("pageTitle", "Quản lý Phòng trọ");
        model.addAttribute("totalRooms", roomDAO.getTotalRoomCount());
        model.addAttribute("availableRooms", roomDAO.getAvailableRoomCount());
        model.addAttribute("occupiedRooms", roomDAO.getOccupiedRoomCount());
        
        return "admin/rooms";
    }
    
    /**
     * Show add room form
     */
    @GetMapping("/rooms/add")
    public String showAddRoomForm(HttpSession session, Model model) {
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("room", new Room());
        model.addAttribute("pageTitle", "Thêm Phòng mới");
        model.addAttribute("action", "add");
        
        return "admin/room-form";
    }
    
    /**
     * Process add room
     */
    @PostMapping("/rooms/add")
    public String processAddRoom(@ModelAttribute Room room,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Validate input
        String validationError = validateRoom(room, true);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/rooms/add";
        }
        
        // Check if room name already exists
        if (roomDAO.roomNameExists(room.getRoomName().trim())) {
            redirectAttributes.addFlashAttribute("error", "Tên phòng đã tồn tại");
            return "redirect:/admin/rooms/add";
        }
        
        // Set default values
        room.setRoomName(room.getRoomName().trim());
        if (room.getStatus() == null || room.getStatus().trim().isEmpty()) {
            room.setStatus("AVAILABLE");
        }
        if (room.getDescription() != null) {
            room.setDescription(room.getDescription().trim());
        }
        
        // Add room
        boolean success = roomDAO.addRoom(room);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Thêm phòng thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Thêm phòng thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/rooms";
    }
    
    /**
     * Show edit room form
     */
    @GetMapping("/rooms/edit/{id}")
    public String showEditRoomForm(@PathVariable int id,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Room room = roomDAO.getRoomById(id);
        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
            return "redirect:/admin/rooms";
        }
        
        User user = (User) session.getAttribute("user");
        
        model.addAttribute("user", user);
        model.addAttribute("room", room);
        model.addAttribute("pageTitle", "Chỉnh sửa Phòng: " + room.getRoomName());
        model.addAttribute("action", "edit");
        
        return "admin/room-form";
    }
    
    /**
     * Process edit room
     */
    @PostMapping("/rooms/edit/{id}")
    public String processEditRoom(@PathVariable int id,
                                 @ModelAttribute Room room,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        // Verify room exists
        Room existingRoom = roomDAO.getRoomById(id);
        if (existingRoom == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
            return "redirect:/admin/rooms";
        }
        
        // Validate input
        String validationError = validateRoom(room, false);
        if (validationError != null) {
            redirectAttributes.addFlashAttribute("error", validationError);
            return "redirect:/admin/rooms/edit/" + id;
        }
        
        // Check if room name already exists (excluding current room)
        if (roomDAO.roomNameExists(room.getRoomName().trim(), id)) {
            redirectAttributes.addFlashAttribute("error", "Tên phòng đã tồn tại");
            return "redirect:/admin/rooms/edit/" + id;
        }
        
        // Set room ID and clean data
        room.setRoomId(id);
        room.setRoomName(room.getRoomName().trim());
        if (room.getDescription() != null) {
            room.setDescription(room.getDescription().trim());
        }
        
        // Update room
        boolean success = roomDAO.updateRoom(room);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Cập nhật phòng thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Cập nhật phòng thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/rooms";
    }
    
    /**
     * Delete room
     */
    @PostMapping("/rooms/delete/{id}")
    public String deleteRoom(@PathVariable int id,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Room room = roomDAO.getRoomById(id);
        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
            return "redirect:/admin/rooms";
        }
        
        // Check if room can be deleted - active tenants
        if (roomDAO.isRoomOccupied(id)) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa phòng đang có người thuê. Vui lòng chuyển tất cả người thuê ra khỏi phòng trước.");
            return "redirect:/admin/rooms";
        }
        
        // Check if room has tenant history (including inactive tenants)
        if (roomDAO.hasRoomHistory(id)) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa phòng có lịch sử thuê trọ. Phòng này đã từng có người thuê nên không thể xóa để đảm bảo tính toàn vẹn dữ liệu.");
            return "redirect:/admin/rooms";
        }
        
        boolean success = roomDAO.deleteRoom(id);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Xóa phòng thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Xóa phòng thất bại. Vui lòng thử lại.");
        }
        
        return "redirect:/admin/rooms";
    }
    
    /**
     * View room details
     */
    @GetMapping("/rooms/view/{id}")
    public String viewRoom(@PathVariable int id,
                          HttpSession session,
                          Model model,
                          RedirectAttributes redirectAttributes) {
        
        String accessCheck = checkAdminAccess(session);
        if (accessCheck != null) {
            return accessCheck;
        }
        
        Room room = roomDAO.getRoomById(id);
        if (room == null) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy phòng");
            return "redirect:/admin/rooms";
        }
        
        User user = (User) session.getAttribute("user");
        // Room can only be deleted if it has no active tenants AND no tenant history
        boolean canDelete = !roomDAO.isRoomOccupied(id) && !roomDAO.hasRoomHistory(id);
        
        model.addAttribute("user", user);
        model.addAttribute("room", room);
        model.addAttribute("canDelete", canDelete);
        model.addAttribute("pageTitle", "Chi tiết Phòng: " + room.getRoomName());
        
        return "admin/room-detail";
    }
    
    /**
     * Validate room data
     * @param room Room object to validate
     * @param isNew Whether this is a new room
     * @return Error message if validation fails, null if valid
     */
    private String validateRoom(Room room, boolean isNew) {
        // Check required fields
        if (room.getRoomName() == null || room.getRoomName().trim().isEmpty()) {
            return "Tên phòng không được để trống";
        }
        
        if (room.getRoomName().trim().length() > 50) {
            return "Tên phòng không được vượt quá 50 ký tự";
        }
        
        if (room.getPrice() == null || room.getPrice().compareTo(BigDecimal.ZERO) <= 0) {
            return "Giá phòng phải lớn hơn 0";
        }
        
        if (room.getStatus() == null || room.getStatus().trim().isEmpty()) {
            return "Trạng thái phòng không được để trống";
        }
        
        if (!"AVAILABLE".equals(room.getStatus()) && !"OCCUPIED".equals(room.getStatus())) {
            return "Trạng thái phòng không hợp lệ";
        }
        
        if (room.getDescription() != null && room.getDescription().length() > 1000) {
            return "Mô tả không được vượt quá 1000 ký tự";
        }
        
        return null; // Valid
    }
}

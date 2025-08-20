package controller;

import dao.MessageDAO;
import model.Message;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * Message Controller
 * Handles messaging functionality between users and admins with role-based routing
 */
@Controller
public class MessageController {
    
    @Autowired
    private MessageDAO messageDAO;
    
    /**
     * Check if user is authenticated and has correct role
     */
    private String checkAuthentication(HttpSession session, String requiredRole) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (requiredRole != null && !requiredRole.equals(user.getRole())) {
            return "redirect:/access-denied";
        }
        return null;
    }
    
    // ADMIN ROUTES
    
    /**
     * Admin messages inbox
     */
    @GetMapping("/admin/messages")
    public String showAdminMessagesInbox(HttpSession session, Model model) {
        String authCheck = checkAuthentication(session, "ADMIN");
        if (authCheck != null) {
            return authCheck;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        // Get conversations/contacts
        List<User> contacts = messageDAO.getMessageContacts(currentUser.getUserId());
        
        // Get unread message count
        int unreadCount = messageDAO.getUnreadMessageCount(currentUser.getUserId());
        
        model.addAttribute("user", currentUser);
        model.addAttribute("contacts", contacts);
        model.addAttribute("unreadCount", unreadCount);
        model.addAttribute("pageTitle", "Tin nhắn");
        model.addAttribute("isAdmin", true);
        
        return "admin/messages";
    }
    
    /**
     * User messages inbox
     */
    @GetMapping("/user/messages")
    public String showUserMessagesInbox(HttpSession session, Model model) {
        String authCheck = checkAuthentication(session, "USER");
        if (authCheck != null) {
            return authCheck;
        }
        
        User currentUser = (User) session.getAttribute("user");
        
        // Get conversations/contacts
        List<User> contacts = messageDAO.getMessageContacts(currentUser.getUserId());
        
        // Get unread message count
        int unreadCount = messageDAO.getUnreadMessageCount(currentUser.getUserId());
        
        model.addAttribute("user", currentUser);
        model.addAttribute("contacts", contacts);
        model.addAttribute("unreadCount", unreadCount);
        model.addAttribute("pageTitle", "Tin nhắn");
        model.addAttribute("isAdmin", false);
        
        return "user/messages";
    }
    
    /**
     * Admin conversation with a specific user
     */
    @GetMapping("/admin/messages/conversation/{userId}")
    public String showAdminConversation(@PathVariable int userId,
                                       HttpSession session,
                                       Model model,
                                       RedirectAttributes redirectAttributes) {
        String authCheck = checkAuthentication(session, "ADMIN");
        if (authCheck != null) {
            return authCheck;
        }
        
        return showConversation(userId, session, model, redirectAttributes, true);
    }
    
    /**
     * User conversation with a specific user
     */
    @GetMapping("/user/messages/conversation/{userId}")
    public String showUserConversation(@PathVariable int userId,
                                      HttpSession session,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        String authCheck = checkAuthentication(session, "USER");
        if (authCheck != null) {
            return authCheck;
        }
        
        return showConversation(userId, session, model, redirectAttributes, false);
    }
    
    /**
     * Common conversation logic
     */
    private String showConversation(int userId, HttpSession session, Model model, 
                                   RedirectAttributes redirectAttributes, boolean isAdmin) {
        User currentUser = (User) session.getAttribute("user");
        
        // Get conversation messages
        List<Message> conversation = messageDAO.getConversation(currentUser.getUserId(), userId);
        
        // Mark messages as read
        messageDAO.markConversationAsRead(currentUser.getUserId(), userId);
        
        // Get other user info (for display)
        User otherUser = null;
        if (!conversation.isEmpty()) {
            Message firstMessage = conversation.get(0);
            otherUser = new User();
            if (firstMessage.getSenderId() == currentUser.getUserId()) {
                otherUser.setUserId(userId);
                otherUser.setFullName(firstMessage.getReceiverName());
                otherUser.setRole(firstMessage.getReceiverRole());
            } else {
                otherUser.setUserId(userId);
                otherUser.setFullName(firstMessage.getSenderName());
                otherUser.setRole(firstMessage.getSenderRole());
            }
        }
        
        model.addAttribute("user", currentUser);
        model.addAttribute("conversation", conversation);
        model.addAttribute("otherUser", otherUser);
        model.addAttribute("otherUserId", userId);
        model.addAttribute("pageTitle", "Cuộc trò chuyện với " + (otherUser != null ? otherUser.getFullName() : ""));
        model.addAttribute("isAdmin", isAdmin);
        
        return "messages/conversation";
    }
    
    /**
     * Send a new message (both admin and user)
     */
    @PostMapping("/admin/messages/send")
    public String sendAdminMessage(@RequestParam int receiverId,
                                  @RequestParam String content,
                                  @RequestParam(required = false) String returnTo,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        String authCheck = checkAuthentication(session, "ADMIN");
        if (authCheck != null) {
            return authCheck;
        }
        
        return sendMessage(receiverId, content, returnTo, session, redirectAttributes, true);
    }
    
    @PostMapping("/user/messages/send")
    public String sendUserMessage(@RequestParam int receiverId,
                                 @RequestParam String content,
                                 @RequestParam(required = false) String returnTo,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        String authCheck = checkAuthentication(session, "USER");
        if (authCheck != null) {
            return authCheck;
        }
        
        return sendMessage(receiverId, content, returnTo, session, redirectAttributes, false);
    }
    
    /**
     * Common send message logic
     */
    private String sendMessage(int receiverId, String content, String returnTo,
                              HttpSession session, RedirectAttributes redirectAttributes, boolean isAdmin) {
        User currentUser = (User) session.getAttribute("user");
        
        // Validate input
        if (content == null || content.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Nội dung tin nhắn không được để trống");
            String redirectPath = isAdmin ? "/admin/messages/conversation/" : "/user/messages/conversation/";
            return "redirect:" + redirectPath + receiverId;
        }
        
        if (content.trim().length() > 1000) {
            redirectAttributes.addFlashAttribute("error", "Nội dung tin nhắn không được vượt quá 1000 ký tự");
            String redirectPath = isAdmin ? "/admin/messages/conversation/" : "/user/messages/conversation/";
            return "redirect:" + redirectPath + receiverId;
        }
        
        // Create and send message
        Message message = new Message(currentUser.getUserId(), receiverId, content.trim());
        boolean success = messageDAO.sendMessage(message);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Gửi tin nhắn thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Gửi tin nhắn thất bại. Vui lòng thử lại.");
        }
        
        // Redirect back to conversation or inbox
        if ("inbox".equals(returnTo)) {
            return isAdmin ? "redirect:/admin/messages" : "redirect:/user/messages";
        } else {
            String redirectPath = isAdmin ? "/admin/messages/conversation/" : "/user/messages/conversation/";
            return "redirect:" + redirectPath + receiverId;
        }
    }
    
    /**
     * Show compose message form for admins
     */
    @GetMapping("/admin/messages/compose")
    public String showAdminComposeForm(HttpSession session, Model model) {
        String authCheck = checkAuthentication(session, "ADMIN");
        if (authCheck != null) {
            return authCheck;
        }
        
        User currentUser = (User) session.getAttribute("user");
        // Get all users with USER role for admin to message
        List<User> recipients = messageDAO.getAllUsers();
        
        model.addAttribute("user", currentUser);
        model.addAttribute("recipients", recipients);
        model.addAttribute("pageTitle", "Soạn tin nhắn");
        model.addAttribute("isAdmin", true);
        
        return "admin/messages-compose";
    }
    
    /**
     * Show compose message form for users
     */
    @GetMapping("/user/messages/compose")
    public String showUserComposeForm(HttpSession session, Model model) {
        String authCheck = checkAuthentication(session, "USER");
        if (authCheck != null) {
            return authCheck;
        }
        
        User currentUser = (User) session.getAttribute("user");
        List<User> recipients = messageDAO.getAllAdmins();
        
        model.addAttribute("user", currentUser);
        model.addAttribute("recipients", recipients);
        model.addAttribute("pageTitle", "Soạn tin nhắn");
        model.addAttribute("isAdmin", false);
        
        return "user/messages-compose";
    }
    
    /**
     * Process compose message form for admins
     */
    @PostMapping("/admin/messages/compose")
    public String processAdminCompose(@RequestParam int receiverId,
                                     @RequestParam String content,
                                     HttpSession session,
                                     RedirectAttributes redirectAttributes) {
        String authCheck = checkAuthentication(session, "ADMIN");
        if (authCheck != null) {
            return authCheck;
        }
        
        return processCompose(receiverId, content, session, redirectAttributes, true);
    }
    
    /**
     * Process compose message form for users
     */
    @PostMapping("/user/messages/compose")
    public String processUserCompose(@RequestParam int receiverId,
                                    @RequestParam String content,
                                    HttpSession session,
                                    RedirectAttributes redirectAttributes) {
        String authCheck = checkAuthentication(session, "USER");
        if (authCheck != null) {
            return authCheck;
        }
        
        return processCompose(receiverId, content, session, redirectAttributes, false);
    }
    
    /**
     * Common compose logic
     */
    private String processCompose(int receiverId, String content, HttpSession session, 
                                 RedirectAttributes redirectAttributes, boolean isAdmin) {
        User currentUser = (User) session.getAttribute("user");
        
        // Validate input
        if (content == null || content.trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Nội dung tin nhắn không được để trống");
            return isAdmin ? "redirect:/admin/messages/compose" : "redirect:/user/messages/compose";
        }
        
        if (content.trim().length() > 1000) {
            redirectAttributes.addFlashAttribute("error", "Nội dung tin nhắn không được vượt quá 1000 ký tự");
            return isAdmin ? "redirect:/admin/messages/compose" : "redirect:/user/messages/compose";
        }
        
        // Create and send message
        Message message = new Message(currentUser.getUserId(), receiverId, content.trim());
        boolean success = messageDAO.sendMessage(message);
        
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Gửi tin nhắn thành công!");
            String conversationPath = isAdmin ? "/admin/messages/conversation/" : "/user/messages/conversation/";
            return "redirect:" + conversationPath + receiverId;
        } else {
            redirectAttributes.addFlashAttribute("error", "Gửi tin nhắn thất bại. Vui lòng thử lại.");
            return isAdmin ? "redirect:/admin/messages/compose" : "redirect:/user/messages/compose";
        }
    }
    
    /**
     * Get unread message count (AJAX endpoint) - for both admin and user
     */
    @GetMapping("/admin/messages/unread-count")
    @ResponseBody
    public String getAdminUnreadCount(HttpSession session) {
        String authCheck = checkAuthentication(session, "ADMIN");
        if (authCheck != null) {
            return "{\"success\": false, \"message\": \"Not authenticated\"}";
        }
        
        User currentUser = (User) session.getAttribute("user");
        int unreadCount = messageDAO.getUnreadMessageCount(currentUser.getUserId());
        
        return "{\"success\": true, \"count\": " + unreadCount + "}";
    }
    
    @GetMapping("/user/messages/unread-count")
    @ResponseBody
    public String getUserUnreadCount(HttpSession session) {
        String authCheck = checkAuthentication(session, "USER");
        if (authCheck != null) {
            return "{\"success\": false, \"message\": \"Not authenticated\"}";
        }
        
        User currentUser = (User) session.getAttribute("user");
        int unreadCount = messageDAO.getUnreadMessageCount(currentUser.getUserId());
        
        return "{\"success\": true, \"count\": " + unreadCount + "}";
    }
}

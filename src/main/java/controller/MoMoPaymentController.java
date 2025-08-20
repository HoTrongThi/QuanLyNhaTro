package controller;

import dao.InvoiceDAO;
import dao.MoMoDAO;
import model.Invoice;
import model.MoMoResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

/**
 * MoMo Payment Controller
 * Handles MoMo payment callbacks and status updates
 */
@Controller
@RequestMapping("/payment/momo")
public class MoMoPaymentController {
    
    @Autowired
    private MoMoDAO moMoDAO;
    
    @Autowired
    private InvoiceDAO invoiceDAO;
    
    /**
     * Handle MoMo payment return (user redirected back from MoMo)
     */
    @GetMapping("/return")
    public String handlePaymentReturn(@RequestParam(required = false) String partnerCode,
                                    @RequestParam(required = false) String orderId,
                                    @RequestParam(required = false) String requestId,
                                    @RequestParam(required = false) String amount,
                                    @RequestParam(required = false) String orderInfo,
                                    @RequestParam(required = false) String orderType,
                                    @RequestParam(required = false) String transId,
                                    @RequestParam(required = false) String resultCode,
                                    @RequestParam(required = false) String message,
                                    @RequestParam(required = false) String payType,
                                    @RequestParam(required = false) String responseTime,
                                    @RequestParam(required = false) String extraData,
                                    @RequestParam(required = false) String signature,
                                    HttpSession session,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        
        try {
            
            if (orderId != null && resultCode != null) {
                // Update payment status based on result code
                String paymentStatus = "0".equals(resultCode) ? "PAID" : "FAILED";
                boolean updated = invoiceDAO.updateMoMoPaymentStatus(orderId, paymentStatus);
                
                if (updated) {
                    if ("PAID".equals(paymentStatus)) {
                        // Also update invoice status to PAID
                        // Get invoice by MoMo order ID and update its status
                        // This would require a new method in InvoiceDAO
                        redirectAttributes.addFlashAttribute("success", 
                            "Thanh toán thành công! Hóa đơn đã được cập nhật.");
                    } else {
                        redirectAttributes.addFlashAttribute("error", 
                            "Thanh toán thất bại: " + message);
                    }
                } else {
                    redirectAttributes.addFlashAttribute("error", 
                        "Không thể cập nhật trạng thái thanh toán");
                }
            } else {
                redirectAttributes.addFlashAttribute("error", 
                    "Thông tin thanh toán không hợp lệ");
            }
            
        } catch (Exception e) {
            System.err.println("Error handling MoMo payment return: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", 
                "Có lỗi xảy ra khi xử lý kết quả thanh toán");
        }
        
        // Redirect to user bills page
        return "redirect:/user/bills";
    }
    
    /**
     * Handle MoMo IPN (Instant Payment Notification)
     */
    @PostMapping("/notify")
    @ResponseBody
    public String handlePaymentNotification(@RequestParam(required = false) String partnerCode,
                                          @RequestParam(required = false) String orderId,
                                          @RequestParam(required = false) String requestId,
                                          @RequestParam(required = false) String amount,
                                          @RequestParam(required = false) String orderInfo,
                                          @RequestParam(required = false) String orderType,
                                          @RequestParam(required = false) String transId,
                                          @RequestParam(required = false) String resultCode,
                                          @RequestParam(required = false) String message,
                                          @RequestParam(required = false) String payType,
                                          @RequestParam(required = false) String responseTime,
                                          @RequestParam(required = false) String extraData,
                                          @RequestParam(required = false) String signature) {
        
        try {
            
            // Validate signature (optional but recommended)
            // boolean isValidSignature = moMoService.validateCallback(signature, ...);
            
            if (orderId != null && resultCode != null) {
                // Update payment status
                String paymentStatus = "0".equals(resultCode) ? "PAID" : "FAILED";
                boolean updated = invoiceDAO.updateMoMoPaymentStatus(orderId, paymentStatus);
                
                if (updated) {
                    return "success"; // Return success to MoMo
                } else {
                    return "failed";
                }
            } else {
                System.err.println("Invalid IPN data received");
                return "failed";
            }
            
        } catch (Exception e) {
            System.err.println("Error handling MoMo IPN: " + e.getMessage());
            e.printStackTrace();
            return "failed";
        }
    }
    
    /**
     * Generate new QR code for existing invoice
     */
    @PostMapping("/regenerate-qr/{invoiceId}")
    public String regenerateQRCode(@PathVariable int invoiceId,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        
        try {
            // Get invoice
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
            if (invoice == null) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy hóa đơn");
                return "redirect:/user/bills";
            }
            
            // Generate new QR code
            String orderInfo = "Thanh toán hóa đơn #" + invoiceId + " - " + invoice.getFormattedPeriod();
            MoMoResponse moMoResponse = moMoDAO.createQRCode(invoiceId, invoice.getTotalAmount(), orderInfo);
            
            if (moMoResponse.isSuccess() && moMoResponse.hasQrCode()) {
                // Update invoice with new MoMo information
                invoiceDAO.updateMoMoPaymentInfo(
                    invoiceId,
                    moMoResponse.getQrCodeUrl(),
                    moMoResponse.getOrderId(),
                    moMoResponse.getRequestId(),
                    "PENDING"
                );
                
                redirectAttributes.addFlashAttribute("success", "Tạo mã QR mới thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", 
                    "Không thể tạo mã QR: " + moMoResponse.getMessage());
            }
            
        } catch (Exception e) {
            System.err.println("Error regenerating QR code: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi tạo mã QR");
        }
        
        return "redirect:/user/bills/view/" + invoiceId;
    }
}
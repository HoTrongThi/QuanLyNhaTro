package dao;

import com.fasterxml.jackson.databind.ObjectMapper;
import config.MoMoConfig;
import model.MoMoRequest;
import model.MoMoResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.math.BigDecimal;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.Duration;
import java.util.UUID;

/**
 * Lớp Data Access Object cho Thanh toán MoMo
 * Xử lý việc tạo QR code và xử lý thanh toán MoMo
 * Tích hợp với MoMo Sandbox API để tạo QR code và kiểm tra trạng thái thanh toán
 * Hỗ trợ tạo chữ ký bảo mật HMAC SHA256 và validation callback
 * Tự động chuyển đổi deep link thành QR image URL
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Repository
public class MoMoDAO {
    
    // ==================== CÁC THUỘC TÍNH ====================
    
    /** Cấu hình MoMo - chứa thông tin xác thực và đường dẫn API */
    @Autowired
    private MoMoConfig moMoConfig;
    
    /** HTTP Client để gửi request đến MoMo API */
    private final HttpClient httpClient;
    
    /** Object Mapper để chuyển đổi JSON */
    private final ObjectMapper objectMapper;
    
    // ==================== CONSTRUCTOR ====================
    
    /**
     * Constructor khởi tạo MoMoDAO
     * Thiết lập HTTP Client với timeout 30 giây và Object Mapper
     */
    public MoMoDAO() {
        // Khởi tạo HTTP Client với timeout 30 giây
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();
        // Khởi tạo Object Mapper cho việc xử lý JSON
        this.objectMapper = new ObjectMapper();
    }
    
    // ==================== CÁC PHƯƠNG THỨC CÔNG KHAI ====================
    
    /**
     * Tạo mã QR MoMo cho thanh toán hóa đơn
     * Gửi yêu cầu đến MoMo API để tạo QR code cho việc thanh toán
     * Tự động chuyển đổi deep link thành QR image URL nếu cần
     * 
     * @param invoiceId ID của hóa đơn cần thanh toán
     * @param amount số tiền cần thanh toán
     * @param orderInfo thông tin đơn hàng
     * @return MoMoResponse chứa thông tin QR code và trạng thái
     */
    public MoMoResponse createQRCode(int invoiceId, BigDecimal amount, String orderInfo) {
        try {
            // Generate unique IDs
            String requestId = generateRequestId();
            String orderId = "INV_" + invoiceId + "_" + System.currentTimeMillis();
            
            // Format amount as integer (MoMo requires integer amount)
            String amountStr = String.valueOf(amount.longValue());
            
            // Create signature
            String signature = createSignature(requestId, orderId, amountStr, orderInfo);
            
            // Create request object manually to ensure correct format
            MoMoRequest request = new MoMoRequest();
            request.setPartnerCode(moMoConfig.getPartnerCode());
            request.setRequestId(requestId);
            request.setAmount(amountStr);
            request.setOrderId(orderId);
            request.setOrderInfo(orderInfo);
            request.setRedirectUrl(moMoConfig.getReturnUrl());
            request.setIpnUrl(moMoConfig.getNotifyUrl());
            request.setRequestType(moMoConfig.getRequestTypeQR());
            request.setExtraData("");
            request.setLang("vi");
            request.setAutoCapture("true");
            request.setSignature(signature);
            
            // Convert to JSON
            String requestBody = objectMapper.writeValueAsString(request);
            
            // Create HTTP request
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(moMoConfig.getCreateQrEndpoint()))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();
            
            // Send request
            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            
            // Parse response
            MoMoResponse moMoResponse = objectMapper.readValue(response.body(), MoMoResponse.class);
            
            // Nếu thành công và có QR code URL
            if (moMoResponse.isSuccess() && moMoResponse.getQrCodeUrl() != null) {
                String qrUrl = moMoResponse.getQrCodeUrl();
                // Kiểm tra nếu là deep link (momo://)
                if (qrUrl.startsWith("momo://")) {
                    // Chuyển đổi deep link thành QR image URL
                    try {
                        String encodedData = java.net.URLEncoder.encode(qrUrl, "UTF-8");
                        String qrImageUrl = "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=" + encodedData;
                        moMoResponse.setQrCodeUrl(qrImageUrl);
                    } catch (Exception e) {
                        System.err.println("Error generating QR image URL: " + e.getMessage());
                    }
                }
            }
            
            return moMoResponse;
            
        } catch (Exception e) {
            System.err.println("Error creating MoMo QR code: " + e.getMessage());
            e.printStackTrace();
            
            // Return error response
            MoMoResponse errorResponse = new MoMoResponse();
            errorResponse.setResultCode("99");
            errorResponse.setMessage("Error creating QR code: " + e.getMessage());
            return errorResponse;
        }
    }
    
    /**
     * Query payment status
     */
    public MoMoResponse queryPaymentStatus(String orderId, String requestId) {
        try {
            // Create signature for query
            String signature = createQuerySignature(orderId, requestId);
            
            // Create query request
            String requestBody = String.format(
                "{\"partnerCode\":\"%s\",\"requestId\":\"%s\",\"orderId\":\"%s\",\"signature\":\"%s\",\"lang\":\"%s\"}",
                moMoConfig.getPartnerCode(),
                requestId,
                orderId,
                signature,
                moMoConfig.getLang()
            );
            
            // Create HTTP request
            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(moMoConfig.getQueryEndpoint()))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();
            
            // Send request
            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());
            
            // Parse response
            return objectMapper.readValue(response.body(), MoMoResponse.class);
            
        } catch (Exception e) {
            System.err.println("Error querying MoMo payment status: " + e.getMessage());
            e.printStackTrace();
            
            // Return error response
            MoMoResponse errorResponse = new MoMoResponse();
            errorResponse.setResultCode("99");
            errorResponse.setMessage("Error querying payment status: " + e.getMessage());
            return errorResponse;
        }
    }
    
    /**
     * Create signature for payment request
     */
    private String createSignature(String requestId, String orderId, String amount, String orderInfo) {
        try {
            // MoMo signature format: accessKey + amount + extraData + ipnUrl + orderId + orderInfo + partnerCode + redirectUrl + requestId + requestType
            String rawSignature = String.format(
                "accessKey=%s&amount=%s&extraData=%s&ipnUrl=%s&orderId=%s&orderInfo=%s&partnerCode=%s&redirectUrl=%s&requestId=%s&requestType=%s",
                moMoConfig.getAccessKey(),
                amount,
                "", // extraData is empty
                moMoConfig.getNotifyUrl(),
                orderId,
                orderInfo,
                moMoConfig.getPartnerCode(),
                moMoConfig.getReturnUrl(),
                requestId,
                moMoConfig.getRequestTypeQR()
            );
            
            return hmacSHA256(rawSignature, moMoConfig.getSecretKey());
            
        } catch (Exception e) {
            System.err.println("Error creating signature: " + e.getMessage());
            e.printStackTrace();
            return "";
        }
    }
    
    /**
     * Create signature for query request
     */
    private String createQuerySignature(String orderId, String requestId) {
        try {
            String rawSignature = String.format(
                "accessKey=%s&orderId=%s&partnerCode=%s&requestId=%s",
                moMoConfig.getAccessKey(),
                orderId,
                moMoConfig.getPartnerCode(),
                requestId
            );
            
            return hmacSHA256(rawSignature, moMoConfig.getSecretKey());
            
        } catch (Exception e) {
            System.err.println("Error creating query signature: " + e.getMessage());
            return "";
        }
    }
    
    /**
     * Generate HMAC SHA256 signature
     */
    private String hmacSHA256(String data, String key) throws NoSuchAlgorithmException, InvalidKeyException {
        Mac mac = Mac.getInstance("HmacSHA256");
        SecretKeySpec secretKeySpec = new SecretKeySpec(key.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        mac.init(secretKeySpec);
        byte[] hash = mac.doFinal(data.getBytes(StandardCharsets.UTF_8));
        
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        
        return hexString.toString();
    }
    
    /**
     * Generate unique request ID
     */
    private String generateRequestId() {
        return UUID.randomUUID().toString().replace("-", ""); // Chuyển UUID thành chuỗi dạng chuẩn (36 ký tự, gồm 32 hex + 4 dấu -)
    }
    
    /**
     * Validate MoMo callback signature
     */
    public boolean validateCallback(String signature, String... params) {
        try {
            String rawSignature = String.join("&", params);
            String expectedSignature = hmacSHA256(rawSignature, moMoConfig.getSecretKey());
            return signature.equals(expectedSignature);
        } catch (Exception e) {
            System.err.println("Error validating callback signature: " + e.getMessage());
            return false;
        }
    }
}
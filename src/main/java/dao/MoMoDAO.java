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
 * MoMo Payment Data Access Object
 * Handles MoMo QR code generation and payment processing
 */
@Repository
public class MoMoDAO {
    
    @Autowired
    private MoMoConfig moMoConfig;
    
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    
    public MoMoDAO() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Create MoMo QR code for invoice payment
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
            
            // If successful but qrCodeUrl is a deep link, generate QR image URL
            if (moMoResponse.isSuccess() && moMoResponse.getQrCodeUrl() != null) {
                String qrUrl = moMoResponse.getQrCodeUrl();
                if (qrUrl.startsWith("momo://")) {
                    // Generate QR code image from deep link using external service
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
        return UUID.randomUUID().toString().replace("-", "");
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
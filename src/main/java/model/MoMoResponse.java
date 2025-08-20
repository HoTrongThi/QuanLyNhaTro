package model;

/**
 * MoMo Payment Response Model
 */
public class MoMoResponse {
    private String partnerCode;
    private String requestId;
    private String orderId;
    private String amount;
    private String responseTime;
    private String message;
    private String resultCode;
    private String payUrl;
    private String qrCodeUrl;
    private String deeplink;
    private String deeplinkMiniApp;
    
    // Constructors
    public MoMoResponse() {}
    
    // Getters and Setters
    public String getPartnerCode() {
        return partnerCode;
    }
    
    public void setPartnerCode(String partnerCode) {
        this.partnerCode = partnerCode;
    }
    
    public String getRequestId() {
        return requestId;
    }
    
    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
    
    public String getOrderId() {
        return orderId;
    }
    
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
    
    public String getAmount() {
        return amount;
    }
    
    public void setAmount(String amount) {
        this.amount = amount;
    }
    
    public String getResponseTime() {
        return responseTime;
    }
    
    public void setResponseTime(String responseTime) {
        this.responseTime = responseTime;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getResultCode() {
        return resultCode;
    }
    
    public void setResultCode(String resultCode) {
        this.resultCode = resultCode;
    }
    
    public String getPayUrl() {
        return payUrl;
    }
    
    public void setPayUrl(String payUrl) {
        this.payUrl = payUrl;
    }
    
    public String getQrCodeUrl() {
        return qrCodeUrl;
    }
    
    public void setQrCodeUrl(String qrCodeUrl) {
        this.qrCodeUrl = qrCodeUrl;
    }
    
    public String getDeeplink() {
        return deeplink;
    }
    
    public void setDeeplink(String deeplink) {
        this.deeplink = deeplink;
    }
    
    public String getDeeplinkMiniApp() {
        return deeplinkMiniApp;
    }
    
    public void setDeeplinkMiniApp(String deeplinkMiniApp) {
        this.deeplinkMiniApp = deeplinkMiniApp;
    }
    
    // Helper methods
    public boolean isSuccess() {
        return "0".equals(resultCode);
    }
    
    public boolean hasQrCode() {
        return qrCodeUrl != null && !qrCodeUrl.trim().isEmpty();
    }
    
    @Override
    public String toString() {
        return "MoMoResponse{" +
                "partnerCode='" + partnerCode + '\'' +
                ", requestId='" + requestId + '\'' +
                ", orderId='" + orderId + '\'' +
                ", amount='" + amount + '\'' +
                ", resultCode='" + resultCode + '\'' +
                ", message='" + message + '\'' +
                ", qrCodeUrl='" + qrCodeUrl + '\'' +
                '}';
    }
}
package model;

/**
 * Lớp Model cho Yêu cầu Thanh toán MoMo
 * Đại diện cho dữ liệu gửi đến MoMo API để tạo giao dịch thanh toán
 * Chứa tất cả thông tin cần thiết để khởi tạo thanh toán qua MoMo
 * Bao gồm thông tin đối tác, đơn hàng, số tiền và chữ ký bảo mật
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class MoMoRequest {
    
    // ==================== THÔNG TIN ĐỐI TÁC ====================
    
    /** Mã đối tác MoMo (Partner Code) */
    private String partnerCode;
    
    /** Tên đối tác */
    private String partnerName;
    
    /** Mã cửa hàng */
    private String storeId;
    
    // ==================== THÔNG TIN GIAO DỊCH ====================
    
    /** Mã yêu cầu duy nhất (Request ID) */
    private String requestId;
    
    /** Số tiền thanh toán (VNĐ) */
    private String amount;
    
    /** Mã đơn hàng duy nhất (Order ID) */
    private String orderId;
    
    /** Thông tin đơn hàng (mô tả thanh toán) */
    private String orderInfo;
    
    // ==================== THÔNG TIN CALLBACK ====================
    
    /** URL chuyển hướng sau khi thanh toán */
    private String redirectUrl;
    
    /** URL nhận thông báo kết quả thanh toán (IPN) */
    private String ipnUrl;
    
    // ==================== CÀI ĐẶT GIAO DỊCH ====================
    
    /** Ngôn ngữ hiển thị (vi: tiếng Việt, en: tiếng Anh) */
    private String lang;
    
    /** Loại yêu cầu thanh toán (captureWallet, payWithATM, v.v.) */
    private String requestType;
    
    /** Tự động capture giao dịch (true/false) */
    private String autoCapture;
    
    /** Dữ liệu bổ sung (thường để trống) */
    private String extraData;
    
    /** Chữ ký bảo mật (HMAC SHA256) */
    private String signature;
    
    // ==================== CÁC CONSTRUCTOR ====================
    
    /**
     * Constructor mặc định
     */
    public MoMoRequest() {}
    
    /**
     * Constructor để tạo yêu cầu thanh toán MoMo
     * Tự động thiết lập các giá trị mặc định cho ngôn ngữ, autoCapture và extraData
     * 
     * @param partnerCode mã đối tác MoMo
     * @param requestId mã yêu cầu duy nhất
     * @param amount số tiền thanh toán
     * @param orderId mã đơn hàng
     * @param orderInfo thông tin đơn hàng
     * @param redirectUrl URL chuyển hướng
     * @param ipnUrl URL nhận thông báo
     * @param requestType loại yêu cầu
     * @param signature chữ ký bảo mật
     */
    public MoMoRequest(String partnerCode, String requestId, String amount, String orderId, 
                      String orderInfo, String redirectUrl, String ipnUrl, String requestType, String signature) {
        this.partnerCode = partnerCode;
        this.requestId = requestId;
        this.amount = amount;
        this.orderId = orderId;
        this.orderInfo = orderInfo;
        this.redirectUrl = redirectUrl;
        this.ipnUrl = ipnUrl;
        this.requestType = requestType;
        this.signature = signature;
        
        // Thiết lập giá trị mặc định
        this.lang = "vi";           // Tiếng Việt
        this.autoCapture = "true";  // Tự động capture
        this.extraData = "";        // Không có dữ liệu bổ sung
    }
    
    // Getters and Setters
    public String getPartnerCode() {
        return partnerCode;
    }
    
    public void setPartnerCode(String partnerCode) {
        this.partnerCode = partnerCode;
    }
    
    public String getPartnerName() {
        return partnerName;
    }
    
    public void setPartnerName(String partnerName) {
        this.partnerName = partnerName;
    }
    
    public String getStoreId() {
        return storeId;
    }
    
    public void setStoreId(String storeId) {
        this.storeId = storeId;
    }
    
    public String getRequestId() {
        return requestId;
    }
    
    public void setRequestId(String requestId) {
        this.requestId = requestId;
    }
    
    public String getAmount() {
        return amount;
    }
    
    public void setAmount(String amount) {
        this.amount = amount;
    }
    
    public String getOrderId() {
        return orderId;
    }
    
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
    
    public String getOrderInfo() {
        return orderInfo;
    }
    
    public void setOrderInfo(String orderInfo) {
        this.orderInfo = orderInfo;
    }
    
    public String getRedirectUrl() {
        return redirectUrl;
    }
    
    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }
    
    public String getIpnUrl() {
        return ipnUrl;
    }
    
    public void setIpnUrl(String ipnUrl) {
        this.ipnUrl = ipnUrl;
    }
    
    public String getLang() {
        return lang;
    }
    
    public void setLang(String lang) {
        this.lang = lang;
    }
    
    public String getRequestType() {
        return requestType;
    }
    
    public void setRequestType(String requestType) {
        this.requestType = requestType;
    }
    
    public String getAutoCapture() {
        return autoCapture;
    }
    
    public void setAutoCapture(String autoCapture) {
        this.autoCapture = autoCapture;
    }
    
    public String getExtraData() {
        return extraData;
    }
    
    public void setExtraData(String extraData) {
        this.extraData = extraData;
    }
    
    public String getSignature() {
        return signature;
    }
    
    public void setSignature(String signature) {
        this.signature = signature;
    }
}
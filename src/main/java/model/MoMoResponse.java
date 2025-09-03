package model;

/**
 * Lớp Model cho Phản hồi Thanh toán MoMo
 * Đại diện cho dữ liệu trả về từ MoMo API sau khi tạo giao dịch
 * Chứa thông tin kết quả giao dịch, URL thanh toán và QR code
 * Hỗ trợ kiểm tra trạng thái thành công và xử lý các loại link thanh toán
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
public class MoMoResponse {
    
    // ==================== THÔNG TIN CƠ BẢN ====================
    
    /** Mã đối tác MoMo (trả về từ API) */
    private String partnerCode;
    
    /** Mã yêu cầu duy nhất (trả về từ API) */
    private String requestId;
    
    /** Mã đơn hàng (trả về từ API) */
    private String orderId;
    
    /** Số tiền giao dịch (VNĐ) */
    private String amount;
    
    /** Thời gian phản hồi từ MoMo */
    private String responseTime;
    
    // ==================== KẾT QUẢ GIAO DỊCH ====================
    
    /** Thông báo kết quả (thành công hoặc lỗi) */
    private String message;
    
    /** Mã kết quả (0: thành công, khác 0: lỗi) */
    private String resultCode;
    
    // ==================== CÁC LIÊN KẾT THANH TOÁN ====================
    
    /** URL trang thanh toán MoMo (web) */
    private String payUrl;
    
    /** URL hình ảnh QR code để quét thanh toán */
    private String qrCodeUrl;
    
    /** Deep link mở ứng dụng MoMo */
    private String deeplink;
    
    /** Deep link mở MoMo Mini App */
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
    
    // ==================== CÁC PHƯƠNG THỨC TIỆN ÍCH ====================
    
    /**
     * Kiểm tra giao dịch có thành công hay không
     * Dựa trên mã kết quả từ MoMo (0 = thành công)
     * 
     * @return true nếu giao dịch thành công, false nếu thất bại
     */
    public boolean isSuccess() {
        return "0".equals(resultCode);
    }
    
    /**
     * Kiểm tra có QR code để thanh toán hay không
     * 
     * @return true nếu có URL QR code hợp lệ, false nếu không
     */
    public boolean hasQrCode() {
        return qrCodeUrl != null && !qrCodeUrl.trim().isEmpty();
    }
    
    /**
     * Kiểm tra có deep link để mở app MoMo hay không
     * 
     * @return true nếu có deep link hợp lệ, false nếu không
     */
    public boolean hasDeeplink() {
        return deeplink != null && !deeplink.trim().isEmpty();
    }
    
    /**
     * Kiểm tra có URL thanh toán web hay không
     * 
     * @return true nếu có pay URL hợp lệ, false nếu không
     */
    public boolean hasPayUrl() {
        return payUrl != null && !payUrl.trim().isEmpty();
    }
    
    /**
     * Lấy thông báo lỗi hoặc thành công bằng tiếng Việt
     * 
     * @return thông báo đã được dịch
     */
    public String getVietnameseMessage() {
        if (isSuccess()) {
            return "Tạo giao dịch thành công";
        } else {
            // Trả về message gốc hoặc thông báo lỗi chung
            return message != null && !message.trim().isEmpty() ? message : "Có lỗi xảy ra khi tạo giao dịch";
        }
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
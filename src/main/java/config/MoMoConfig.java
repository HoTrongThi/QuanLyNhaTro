package config;

import org.springframework.stereotype.Component;

/**
 * Lớp cấu hình thanh toán MoMo
 * Chứa tất cả thông tin cần thiết để tích hợp với MoMo Sandbox
 * Bao gồm thông tin xác thực, đường dẫn API và các tham số cấu hình
 * 
 * @author Hệ thống Quản lý Phòng trọ
 * @version 1.0
 * @since 2025
 */
@Component
public class MoMoConfig {
    
    // ==================== THÔNG TIN XÁC THỰC MOMO SANDBOX ====================
    
    /** Mã đối tác MoMo (Partner Code) */
    public static final String PARTNER_CODE = "MOMO";
    
    /** Khóa truy cập MoMo (Access Key) */
    public static final String ACCESS_KEY = "F8BBA842ECF85";
    
    /** Khóa bí mật MoMo (Secret Key) - dùng để tạo chữ ký */
    public static final String SECRET_KEY = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    
    // ==================== ĐƯỜNG DẪN API MOMO SANDBOX ====================
    
    /** Đường dẫn API tạo QR code thanh toán */
    public static final String CREATE_QR_ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";
    
    /** Đường dẫn API truy vấn trạng thái thanh toán */
    public static final String QUERY_ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/query";
    
    // ==================== ĐƯỜNG DẪN ỨNG DỤNG ====================
    
    /** URL trở về sau khi thanh toán thành công (Return URL) */
    public static final String RETURN_URL = "http://localhost:8080/QuanLyPhongTro/payment/momo/return";
    
    /** URL nhận thông báo từ MoMo (IPN - Instant Payment Notification) */
    public static final String NOTIFY_URL = "http://localhost:8080/QuanLyPhongTro/payment/momo/notify";
    
    // ==================== LOẠI YÊU CẦU THANH TOÁN ====================
    
    /** Loại thanh toán: Thanh toán qua ví MoMo */
    public static final String REQUEST_TYPE_CAPTURE_WALLET = "captureWallet";
    
    /** Loại thanh toán: Thanh toán qua thẻ ATM */
    public static final String REQUEST_TYPE_PAY_WITH_ATM = "payWithATM";
    
    /** Loại thanh toán: Thanh toán qua QR code */
    public static final String REQUEST_TYPE_QR_CODE = "payWithMethod";
    
    // ==================== CÁC HẰNG SỐ KHÁC ====================
    
    /** Ngôn ngữ hiển thị (tiếng Việt) */
    public static final String LANG = "vi";
    
    /** Thời gian hết hạn của giao dịch (phút) */
    public static final long EXPIRE_TIME = 15;
    
    // ==================== CÁC PHƯƠNG THỨC GETTER ====================
    
    /**
     * Lấy mã đối tác MoMo
     * @return mã đối tác
     */
    public String getPartnerCode() {
        return PARTNER_CODE;
    }
    
    /**
     * Lấy khóa truy cập MoMo
     * @return khóa truy cập
     */
    public String getAccessKey() {
        return ACCESS_KEY;
    }
    
    /**
     * Lấy khóa bí mật MoMo
     * @return khóa bí mật
     */
    public String getSecretKey() {
        return SECRET_KEY;
    }
    
    /**
     * Lấy đường dẫn API tạo QR code
     * @return URL API tạo QR
     */
    public String getCreateQrEndpoint() {
        return CREATE_QR_ENDPOINT;
    }
    
    /**
     * Lấy đường dẫn API truy vấn trạng thái
     * @return URL API truy vấn
     */
    public String getQueryEndpoint() {
        return QUERY_ENDPOINT;
    }
    
    /**
     * Lấy URL trở về sau thanh toán
     * @return Return URL
     */
    public String getReturnUrl() {
        return RETURN_URL;
    }
    
    /**
     * Lấy URL nhận thông báo từ MoMo
     * @return Notify URL (IPN)
     */
    public String getNotifyUrl() {
        return NOTIFY_URL;
    }
    
    /**
     * Lấy loại yêu cầu thanh toán QR
     * @return loại request cho QR code
     */
    public String getRequestTypeQR() {
        return REQUEST_TYPE_CAPTURE_WALLET;
    }
    
    /**
     * Lấy ngôn ngữ hiển thị
     * @return mã ngôn ngữ
     */
    public String getLang() {
        return LANG;
    }
    
    /**
     * Lấy thời gian hết hạn giao dịch
     * @return thời gian hết hạn (phút)
     */
    public long getExpireTime() {
        return EXPIRE_TIME;
    }
}
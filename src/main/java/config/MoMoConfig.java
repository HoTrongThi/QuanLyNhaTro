package config;

import org.springframework.stereotype.Component;

/**
 * MoMo Payment Configuration
 * Contains MoMo Sandbox credentials and endpoints
 */
@Component
public class MoMoConfig {
    
    // MoMo Sandbox Credentials
    public static final String PARTNER_CODE = "MOMO";
    public static final String ACCESS_KEY = "F8BBA842ECF85";
    public static final String SECRET_KEY = "K951B6PE1waDMi640xX08PD3vg6EkVlz";
    
    // MoMo Sandbox Endpoints
    public static final String CREATE_QR_ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/create";
    public static final String QUERY_ENDPOINT = "https://test-payment.momo.vn/v2/gateway/api/query";
    
    // Application URLs (you should change these to your actual domain)
    public static final String RETURN_URL = "http://localhost:8080/QuanLyPhongTro/payment/momo/return";
    public static final String NOTIFY_URL = "http://localhost:8080/QuanLyPhongTro/payment/momo/notify";
    
    // Request Types
    public static final String REQUEST_TYPE_CAPTURE_WALLET = "captureWallet";
    public static final String REQUEST_TYPE_PAY_WITH_ATM = "payWithATM";
    public static final String REQUEST_TYPE_QR_CODE = "payWithMethod";
    
    // Other constants
    public static final String LANG = "vi";
    public static final long EXPIRE_TIME = 15; // minutes
    
    public String getPartnerCode() {
        return PARTNER_CODE;
    }
    
    public String getAccessKey() {
        return ACCESS_KEY;
    }
    
    public String getSecretKey() {
        return SECRET_KEY;
    }
    
    public String getCreateQrEndpoint() {
        return CREATE_QR_ENDPOINT;
    }
    
    public String getQueryEndpoint() {
        return QUERY_ENDPOINT;
    }
    
    public String getReturnUrl() {
        return RETURN_URL;
    }
    
    public String getNotifyUrl() {
        return NOTIFY_URL;
    }
    
    public String getRequestTypeQR() {
        return REQUEST_TYPE_CAPTURE_WALLET;
    }
    
    public String getLang() {
        return LANG;
    }
    
    public long getExpireTime() {
        return EXPIRE_TIME;
    }
}
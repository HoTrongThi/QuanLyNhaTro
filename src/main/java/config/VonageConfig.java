package config;

import org.springframework.stereotype.Component;

/**
 * Vonage SMS Configuration
 */
@Component
public class VonageConfig {
    
    // Vonage API Credentials
    public static final String API_KEY = "e629bf4e";
    public static final String API_SECRET = "2qDF7TGahR4x4e0z";
    
    // SMS Configuration
    public static final String FROM_NUMBER = "QuanLyPhongTro"; // Brand name or phone number
    public static final String SMS_ENDPOINT = "https://rest.nexmo.com/sms/json";
    
    // SMS Templates
    public static final String INVOICE_CREATED_TEMPLATE = 
        "Thong bao hoa don moi!\n" +
        "Phong: %s\n" +
        "Ky: %s\n" +
        "Tong tien: %s VND\n" +
        "Vui long xem chi tiet trong he thong.\n" +
        "Cam on ban!";
    
    // Getters
    public String getApiKey() {
        return API_KEY;
    }
    
    public String getApiSecret() {
        return API_SECRET;
    }
    
    public String getFromNumber() {
        return FROM_NUMBER;
    }
    
    public String getSmsEndpoint() {
        return SMS_ENDPOINT;
    }
    
    public String getInvoiceCreatedTemplate() {
        return INVOICE_CREATED_TEMPLATE;
    }
}
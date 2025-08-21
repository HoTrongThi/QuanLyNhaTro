package model;

/**
 * Vonage SMS Request Model
 */
public class VonageSmsRequest {
    private String from;
    private String to;
    private String text;
    private String api_key;
    private String api_secret;
    
    // Constructors
    public VonageSmsRequest() {}
    
    public VonageSmsRequest(String from, String to, String text, String apiKey, String apiSecret) {
        this.from = from;
        this.to = to;
        this.text = text;
        this.api_key = apiKey;
        this.api_secret = apiSecret;
    }
    
    // Getters and Setters
    public String getFrom() {
        return from;
    }
    
    public void setFrom(String from) {
        this.from = from;
    }
    
    public String getTo() {
        return to;
    }
    
    public void setTo(String to) {
        this.to = to;
    }
    
    public String getText() {
        return text;
    }
    
    public void setText(String text) {
        this.text = text;
    }
    
    public String getApi_key() {
        return api_key;
    }
    
    public void setApi_key(String api_key) {
        this.api_key = api_key;
    }
    
    public String getApi_secret() {
        return api_secret;
    }
    
    public void setApi_secret(String api_secret) {
        this.api_secret = api_secret;
    }
}
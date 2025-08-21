package dao;

import com.fasterxml.jackson.databind.ObjectMapper;
import config.VonageConfig;
import model.VonageSmsRequest;
import model.VonageSmsResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

/**
 * Vonage SMS Data Access Object
 * Handles SMS sending via Vonage API
 */
@Repository
public class VonageSmsDAO {
    
    @Autowired
    private VonageConfig vonageConfig;
    
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    
    public VonageSmsDAO() {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(30))
                .build();
        this.objectMapper = new ObjectMapper();
    }
    
    /**
     * Send SMS using Vonage API
     */
    public VonageSmsResponse sendSms(String toNumber, String message) {
        try {
            // Format phone number (ensure it starts with country code)
            String formattedNumber = formatPhoneNumber(toNumber);
            
            // Create request parameters as form data
            String formData = String.format(
                "from=%s&to=%s&text=%s&api_key=%s&api_secret=%s",
                URLEncoder.encode(vonageConfig.getFromNumber(), StandardCharsets.UTF_8),
                URLEncoder.encode(formattedNumber, StandardCharsets.UTF_8),
                URLEncoder.encode(message, StandardCharsets.UTF_8),
                URLEncoder.encode(vonageConfig.getApiKey(), StandardCharsets.UTF_8),
                URLEncoder.encode(vonageConfig.getApiSecret(), StandardCharsets.UTF_8)
            );
            
            // Create HTTP request
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(vonageConfig.getSmsEndpoint()))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(formData))
                    .build();
            
            // Send request
            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            
            // Parse response
            VonageSmsResponse smsResponse = objectMapper.readValue(response.body(), VonageSmsResponse.class);
            
            return smsResponse;
            
        } catch (Exception e) {
            System.err.println("Error sending SMS: " + e.getMessage());
            e.printStackTrace();
            
            // Return error response
            VonageSmsResponse errorResponse = new VonageSmsResponse();
            errorResponse.setMessageCount("0");
            return errorResponse;
        }
    }
    
    /**
     * Send invoice notification SMS
     */
    public boolean sendInvoiceNotification(String toNumber, String roomName, String period, String totalAmount) {
        try {
            // Format message using template
            String message = String.format(
                vonageConfig.getInvoiceCreatedTemplate(),
                roomName,
                period,
                totalAmount
            );
            
            // Send SMS
            VonageSmsResponse response = sendSms(toNumber, message);
            
            // Check if successful
            return response.isSuccess();
            
        } catch (Exception e) {
            System.err.println("Error sending invoice notification: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Format phone number to international format
     * Assumes Vietnamese phone numbers if no country code provided
     */
    private String formatPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return phoneNumber;
        }
        
        // Remove all non-digit characters
        String cleaned = phoneNumber.replaceAll("[^0-9]", "");
        
        // If already has country code (starts with 84), return as is
        if (cleaned.startsWith("84")) {
            return cleaned;
        }
        
        // If starts with 0, replace with 84 (Vietnam country code)
        if (cleaned.startsWith("0")) {
            return "84" + cleaned.substring(1);
        }
        
        // If doesn't start with 0 or 84, assume it's missing leading 0
        // Add Vietnam country code
        return "84" + cleaned;
    }
    
    /**
     * Validate phone number format
     */
    public boolean isValidPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return false;
        }
        
        String formatted = formatPhoneNumber(phoneNumber);
        
        // Vietnamese phone numbers should be 11-12 digits with country code
        return formatted.matches("^84[0-9]{9,10}$");
    }
    
    /**
     * Send test SMS
     */
    public VonageSmsResponse sendTestSms(String toNumber) {
        String testMessage = "Test SMS from Quan Ly Phong Tro system. If you receive this, SMS integration is working!";
        return sendSms(toNumber, testMessage);
    }
}
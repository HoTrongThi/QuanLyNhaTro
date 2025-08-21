package model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * Vonage SMS Response Model
 */
public class VonageSmsResponse {
    
    @JsonProperty("message-count")
    private String messageCount;
    
    @JsonProperty("messages")
    private List<SmsMessage> messages;
    
    // Constructors
    public VonageSmsResponse() {}
    
    // Getters and Setters
    public String getMessageCount() {
        return messageCount;
    }
    
    public void setMessageCount(String messageCount) {
        this.messageCount = messageCount;
    }
    
    public List<SmsMessage> getMessages() {
        return messages;
    }
    
    public void setMessages(List<SmsMessage> messages) {
        this.messages = messages;
    }
    
    // Helper methods
    public boolean isSuccess() {
        if (messages != null && !messages.isEmpty()) {
            return "0".equals(messages.get(0).getStatus());
        }
        return false;
    }
    
    public String getErrorText() {
        if (messages != null && !messages.isEmpty()) {
            return messages.get(0).getErrorText();
        }
        return "Unknown error";
    }
    
    // Inner class for SMS Message
    public static class SmsMessage {
        private String to;
        private String status;
        
        @JsonProperty("message-id")
        private String messageId;
        
        @JsonProperty("error-text")
        private String errorText;
        
        @JsonProperty("remaining-balance")
        private String remainingBalance;
        
        @JsonProperty("message-price")
        private String messagePrice;
        
        @JsonProperty("network")
        private String network;
        
        // Constructors
        public SmsMessage() {}
        
        // Getters and Setters
        public String getTo() {
            return to;
        }
        
        public void setTo(String to) {
            this.to = to;
        }
        
        public String getStatus() {
            return status;
        }
        
        public void setStatus(String status) {
            this.status = status;
        }
        
        public String getMessageId() {
            return messageId;
        }
        
        public void setMessageId(String messageId) {
            this.messageId = messageId;
        }
        
        public String getErrorText() {
            return errorText;
        }
        
        public void setErrorText(String errorText) {
            this.errorText = errorText;
        }
        
        public String getRemainingBalance() {
            return remainingBalance;
        }
        
        public void setRemainingBalance(String remainingBalance) {
            this.remainingBalance = remainingBalance;
        }
        
        public String getMessagePrice() {
            return messagePrice;
        }
        
        public void setMessagePrice(String messagePrice) {
            this.messagePrice = messagePrice;
        }
        
        public String getNetwork() {
            return network;
        }
        
        public void setNetwork(String network) {
            this.network = network;
        }
    }
    
    @Override
    public String toString() {
        return "VonageSmsResponse{" +
                "messageCount='" + messageCount + '\'' +
                ", messages=" + messages +
                '}';
    }
}
package com.grownited.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "payment.razorpay")
public class RazorpayGatewayProperties {

    private String keyId;
    private String keySecret;
    private String webhookSecret;
    private String currency = "INR";
    private String baseUrl = "https://api.razorpay.com/v1";
    private String checkoutScriptUrl = "https://checkout.razorpay.com/v1/checkout.js";

    public String getKeyId() {
        return keyId;
    }

    public void setKeyId(String keyId) {
        this.keyId = keyId;
    }

    public String getKeySecret() {
        return keySecret;
    }

    public void setKeySecret(String keySecret) {
        this.keySecret = keySecret;
    }

    public String getWebhookSecret() {
        return webhookSecret;
    }

    public void setWebhookSecret(String webhookSecret) {
        this.webhookSecret = webhookSecret;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getCheckoutScriptUrl() {
        return checkoutScriptUrl;
    }

    public void setCheckoutScriptUrl(String checkoutScriptUrl) {
        this.checkoutScriptUrl = checkoutScriptUrl;
    }
}
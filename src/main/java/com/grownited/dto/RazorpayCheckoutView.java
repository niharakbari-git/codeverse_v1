package com.grownited.dto;

public class RazorpayCheckoutView {

    private Integer applicationId;
    private Integer transactionId;
    private Integer hackathonId;
    private String hackathonTitle;
    private String teamName;
    private String participantName;
    private String keyId;
    private String orderId;
    private String currency;
    private Integer amountPaise;
    private String amountDisplay;
    private String receipt;
    private String verifyUrl;
    private String webhookUrl;
    private String cancelUrl;
    private String checkoutScriptUrl;

    public Integer getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Integer applicationId) {
        this.applicationId = applicationId;
    }

    public Integer getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(Integer transactionId) {
        this.transactionId = transactionId;
    }

    public Integer getHackathonId() {
        return hackathonId;
    }

    public void setHackathonId(Integer hackathonId) {
        this.hackathonId = hackathonId;
    }

    public String getHackathonTitle() {
        return hackathonTitle;
    }

    public void setHackathonTitle(String hackathonTitle) {
        this.hackathonTitle = hackathonTitle;
    }

    public String getTeamName() {
        return teamName;
    }

    public void setTeamName(String teamName) {
        this.teamName = teamName;
    }

    public String getParticipantName() {
        return participantName;
    }

    public void setParticipantName(String participantName) {
        this.participantName = participantName;
    }

    public String getKeyId() {
        return keyId;
    }

    public void setKeyId(String keyId) {
        this.keyId = keyId;
    }

    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public Integer getAmountPaise() {
        return amountPaise;
    }

    public void setAmountPaise(Integer amountPaise) {
        this.amountPaise = amountPaise;
    }

    public String getAmountDisplay() {
        return amountDisplay;
    }

    public void setAmountDisplay(String amountDisplay) {
        this.amountDisplay = amountDisplay;
    }

    public String getReceipt() {
        return receipt;
    }

    public void setReceipt(String receipt) {
        this.receipt = receipt;
    }

    public String getVerifyUrl() {
        return verifyUrl;
    }

    public void setVerifyUrl(String verifyUrl) {
        this.verifyUrl = verifyUrl;
    }

    public String getWebhookUrl() {
        return webhookUrl;
    }

    public void setWebhookUrl(String webhookUrl) {
        this.webhookUrl = webhookUrl;
    }

    public String getCancelUrl() {
        return cancelUrl;
    }

    public void setCancelUrl(String cancelUrl) {
        this.cancelUrl = cancelUrl;
    }

    public String getCheckoutScriptUrl() {
        return checkoutScriptUrl;
    }

    public void setCheckoutScriptUrl(String checkoutScriptUrl) {
        this.checkoutScriptUrl = checkoutScriptUrl;
    }
}
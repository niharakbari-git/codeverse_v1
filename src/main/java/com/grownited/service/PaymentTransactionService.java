package com.grownited.service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Service;

import com.grownited.entity.PaymentTransactionEntity;
import com.grownited.repository.PaymentTransactionRepository;

@Service
public class PaymentTransactionService {

    private final PaymentTransactionRepository paymentTransactionRepository;

    public PaymentTransactionService(PaymentTransactionRepository paymentTransactionRepository) {
        this.paymentTransactionRepository = paymentTransactionRepository;
    }

    public PaymentTransactionEntity startTransaction(Integer applicationId, Double amount, String idempotencyKey) {
        String key = idempotencyKey == null || idempotencyKey.isBlank()
                ? UUID.randomUUID().toString()
                : idempotencyKey.trim();

        Optional<PaymentTransactionEntity> existing = paymentTransactionRepository.findByIdempotencyKey(key);
        if (existing.isPresent()) {
            return existing.get();
        }

        PaymentTransactionEntity transaction = new PaymentTransactionEntity();
        transaction.setApplicationId(applicationId);
        transaction.setAmount(amount);
        transaction.setStatus("PENDING");
        transaction.setIdempotencyKey(key);
        transaction.setWebhookVerified(false);
        transaction.setCreatedAt(LocalDateTime.now());
        transaction.setUpdatedAt(LocalDateTime.now());
        return paymentTransactionRepository.save(transaction);
    }

    public Optional<PaymentTransactionEntity> findByGatewayOrderId(String gatewayOrderId) {
        if (gatewayOrderId == null || gatewayOrderId.isBlank()) {
            return Optional.empty();
        }
        return paymentTransactionRepository.findByGatewayOrderId(gatewayOrderId.trim());
    }

    public Optional<PaymentTransactionEntity> findByGatewayTransactionId(String gatewayTransactionId) {
        if (gatewayTransactionId == null || gatewayTransactionId.isBlank()) {
            return Optional.empty();
        }
        return paymentTransactionRepository.findByGatewayTransactionId(gatewayTransactionId.trim());
    }

    public PaymentTransactionEntity linkOrder(PaymentTransactionEntity transaction, String gatewayOrderId,
            String currency, String message) {
        transaction.setGatewayOrderId(gatewayOrderId);
        transaction.setCurrency(currency);
        transaction.setResponseMessage(message);
        transaction.setUpdatedAt(LocalDateTime.now());
        return paymentTransactionRepository.save(transaction);
    }

    public PaymentTransactionEntity markSuccess(PaymentTransactionEntity transaction, String gatewayTransactionId,
            String message) {
        transaction.setStatus("SUCCESS");
        transaction.setGatewayTransactionId(gatewayTransactionId);
        transaction.setResponseMessage(message);
        transaction.setWebhookVerified(true);
        transaction.setUpdatedAt(LocalDateTime.now());
        return paymentTransactionRepository.save(transaction);
    }

    public PaymentTransactionEntity markCheckoutSuccess(PaymentTransactionEntity transaction, String gatewayTransactionId,
            String gatewaySignature, String message) {
        transaction.setStatus("SUCCESS");
        transaction.setGatewayTransactionId(gatewayTransactionId);
        transaction.setGatewaySignature(gatewaySignature);
        transaction.setResponseMessage(message);
        transaction.setWebhookVerified(true);
        transaction.setUpdatedAt(LocalDateTime.now());
        return paymentTransactionRepository.save(transaction);
    }

    public PaymentTransactionEntity markFailure(PaymentTransactionEntity transaction, String message) {
        transaction.setStatus("FAILED");
        transaction.setResponseMessage(message);
        transaction.setUpdatedAt(LocalDateTime.now());
        return paymentTransactionRepository.save(transaction);
    }
}
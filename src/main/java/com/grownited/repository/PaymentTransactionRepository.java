package com.grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.PaymentTransactionEntity;

@Repository
public interface PaymentTransactionRepository extends JpaRepository<PaymentTransactionEntity, Integer> {

    Optional<PaymentTransactionEntity> findByIdempotencyKey(String idempotencyKey);

    Optional<PaymentTransactionEntity> findByGatewayOrderId(String gatewayOrderId);

    Optional<PaymentTransactionEntity> findByGatewayTransactionId(String gatewayTransactionId);

    Optional<PaymentTransactionEntity> findFirstByApplicationIdOrderByCreatedAtDesc(Integer applicationId);

    List<PaymentTransactionEntity> findByApplicationIdOrderByCreatedAtDesc(Integer applicationId);

    void deleteByApplicationId(Integer applicationId);
}
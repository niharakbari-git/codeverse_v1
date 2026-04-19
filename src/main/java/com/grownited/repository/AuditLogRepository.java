package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.AuditLogEntity;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLogEntity, Integer> {

    List<AuditLogEntity> findByEntityTypeAndEntityIdOrderByTimestampDesc(String entityType, Integer entityId);
}
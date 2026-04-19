package com.grownited.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import com.grownited.entity.AuditLogEntity;
import com.grownited.repository.AuditLogRepository;

@Service
public class AuditLogService {

    private final AuditLogRepository auditLogRepository;

    public AuditLogService(AuditLogRepository auditLogRepository) {
        this.auditLogRepository = auditLogRepository;
    }

    public void log(String entityType, Integer entityId, String action, Integer changedBy, String oldValue,
            String newValue) {
        AuditLogEntity log = new AuditLogEntity();
        log.setEntityType(entityType);
        log.setEntityId(entityId);
        log.setAction(action);
        log.setChangedBy(changedBy);
        log.setOldValue(oldValue);
        log.setNewValue(newValue);
        log.setTimestamp(LocalDateTime.now());
        auditLogRepository.save(log);
    }

    public void logStatusChange(Integer applicationId, String oldStatus, String newStatus, Integer userId) {
        log("HACKATHON_APPLICATION", applicationId, "STATUS_CHANGE", userId, oldStatus, newStatus);
    }

    public void logScoreChange(Integer scoreId, Integer oldScore, Integer newScore, Integer userId) {
        log("JUDGE_SCORE", scoreId, "SCORE_CHANGE", userId,
                oldScore == null ? null : String.valueOf(oldScore),
                newScore == null ? null : String.valueOf(newScore));
    }

    public void logAssignmentChange(Integer assignmentId, String action, Integer userId, String details) {
        log("JUDGE_ASSIGNMENT", assignmentId, action, userId, null, details);
    }
}
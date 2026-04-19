package com.grownited.service;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.NotificationLogEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.NotificationLogRepository;
import com.grownited.repository.UserRepository;

@Service
public class NotificationService {

    private final NotificationLogRepository notificationLogRepository;
    private final UserRepository userRepository;
    private final MailerService mailerService;

    public NotificationService(NotificationLogRepository notificationLogRepository, UserRepository userRepository,
            MailerService mailerService) {
        this.notificationLogRepository = notificationLogRepository;
        this.userRepository = userRepository;
        this.mailerService = mailerService;
    }

    public void notifyApplicationStatusChange(HackathonApplicationEntity app, String newStatus) {
        if (app == null || app.getParticipantUserId() == null) {
            return;
        }
        createLog(app.getParticipantUserId(), "APP_STATUS_CHANGE", "IN_APP",
                "Your application status changed to " + newStatus + ".", app.getApplicationId());
        userRepository.findById(app.getParticipantUserId()).ifPresent(user -> sendOptionalMail(user,
                "CodeVerse - Application status updated",
                "<p>Your application status changed to <strong>" + newStatus + "</strong>.</p>"));
    }

    public void notifySubmissionReceived(HackathonApplicationEntity app, Integer versionNumber) {
        if (app == null || app.getParticipantUserId() == null) {
            return;
        }
        createLog(app.getParticipantUserId(), "SUBMISSION_RECEIVED", "IN_APP",
                "Submission version " + versionNumber + " was saved successfully.", app.getApplicationId());
    }

    public void notifyJudgeAssignment(Integer judgeUserId, Integer hackathonId, String hackathonTitle) {
        if (judgeUserId == null) {
            return;
        }
        createLog(judgeUserId, "JUDGE_ASSIGNED", "IN_APP",
                "You were assigned to judge " + hackathonTitle + ".", hackathonId);
    }

    public void notifyDeadlineReminder(Integer userId, Integer hackathonId, String hackathonTitle) {
        if (userId == null) {
            return;
        }
        createLog(userId, "DEADLINE_REMINDER", "IN_APP",
                "Reminder: submit work for " + hackathonTitle + " before the deadline.", hackathonId);
    }

    public void notifyScoreRecorded(Integer judgeUserId, Integer applicationId, String hackathonTitle) {
        if (judgeUserId == null) {
            return;
        }
        createLog(judgeUserId, "SCORE_RECORDED", "IN_APP",
                "Your score has been saved for " + hackathonTitle + ".", applicationId);
    }

    private void createLog(Integer userId, String type, String channel, String message, Integer relatedEntityId) {
        NotificationLogEntity log = new NotificationLogEntity();
        log.setUserId(userId);
        log.setType(type);
        log.setChannel(channel);
        log.setMessage(message);
        log.setRelatedEntityId(relatedEntityId);
        log.setSentAt(LocalDateTime.now());
        log.setDelivered(true);
        notificationLogRepository.save(log);
    }

    private void sendOptionalMail(UserEntity user, String subject, String body) {
        if (user.getEmail() != null && !user.getEmail().isBlank()) {
            mailerService.sendHtmlMail(user.getEmail(), subject, body);
        }
    }
}
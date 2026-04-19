package com.grownited.config;

import java.time.LocalDate;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.service.NotificationService;

@Component
public class DeadlineNotificationTask {

    private final HackathonRepository hackathonRepository;
    private final HackathonApplicationRepository hackathonApplicationRepository;
    private final NotificationService notificationService;

    public DeadlineNotificationTask(HackathonRepository hackathonRepository,
            HackathonApplicationRepository hackathonApplicationRepository, NotificationService notificationService) {
        this.hackathonRepository = hackathonRepository;
        this.hackathonApplicationRepository = hackathonApplicationRepository;
        this.notificationService = notificationService;
    }

    @Scheduled(cron = "0 0 9 * * *")
    public void remindUpcomingSubmissionDeadlines() {
        LocalDate today = LocalDate.now();
        List<HackathonEntity> hackathons = hackathonRepository.findAll();
        for (HackathonEntity hackathon : hackathons) {
            LocalDate deadline = hackathon.getSubmissionDeadline() != null ? hackathon.getSubmissionDeadline()
                    : hackathon.getRegistrationEndDate();
            if (deadline == null || !deadline.minusDays(1).isEqual(today)) {
                continue;
            }

            List<HackathonApplicationEntity> applications = hackathonApplicationRepository.findByHackathonId(hackathon.getHackathonId());
            for (HackathonApplicationEntity application : applications) {
                notificationService.notifyDeadlineReminder(application.getParticipantUserId(), hackathon.getHackathonId(), hackathon.getTitle());
            }
        }
    }
}
package com.grownited.config;

import java.time.LocalDate;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.grownited.entity.HackathonEntity;
import com.grownited.repository.HackathonRepository;
import com.grownited.util.HackathonStatusUtil;

@Component
public class HackathonLifecycleScheduler {

    private final HackathonRepository hackathonRepository;

    public HackathonLifecycleScheduler(HackathonRepository hackathonRepository) {
        this.hackathonRepository = hackathonRepository;
    }

    @Scheduled(fixedDelay = 3600000L)
    public void syncHackathonStatuses() {
        List<HackathonEntity> hackathons = hackathonRepository.findAll();
        boolean changed = false;
        LocalDate today = LocalDate.now();

        for (HackathonEntity hackathon : hackathons) {
            String resolvedStatus = HackathonStatusUtil.resolveStatus(hackathon, today);
            if (resolvedStatus != null && !resolvedStatus.equalsIgnoreCase(hackathon.getStatus())) {
                hackathon.setStatus(resolvedStatus);
                changed = true;
            }
        }

        if (changed) {
            hackathonRepository.saveAll(hackathons);
        }
    }
}
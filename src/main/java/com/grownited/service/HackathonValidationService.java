package com.grownited.service;

import java.time.LocalDate;

import org.springframework.stereotype.Service;

import com.grownited.entity.HackathonEntity;

@Service
public class HackathonValidationService {

    public boolean isValid(HackathonEntity hackathon) {
        if (hackathon == null) {
            return false;
        }
        if (isBlank(hackathon.getTitle()) || isBlank(hackathon.getDescription())) {
            return false;
        }
        if (hackathon.getMinTeamSize() == null || hackathon.getMaxTeamSize() == null
                || hackathon.getMinTeamSize() <= 0 || hackathon.getMaxTeamSize() <= 0
                || hackathon.getMinTeamSize() > hackathon.getMaxTeamSize()) {
            return false;
        }
        if (hackathon.getRegistrationStartDate() == null || hackathon.getRegistrationEndDate() == null
                || hackathon.getRegistrationStartDate().isAfter(hackathon.getRegistrationEndDate())) {
            return false;
        }
        if (hackathon.getEventStartDate() != null && hackathon.getEventEndDate() != null
                && hackathon.getEventStartDate().isAfter(hackathon.getEventEndDate())) {
            return false;
        }
        if (hackathon.getSubmissionDeadline() != null && hackathon.getRegistrationEndDate() != null
                && hackathon.getSubmissionDeadline().isBefore(hackathon.getRegistrationEndDate())) {
            return false;
        }
        return isPresent(hackathon.getProblemTitle())
                && isPresent(hackathon.getProblemStatement())
                && isPresent(hackathon.getProblemDeliverables());
    }

    public boolean isTeamSizeAllowed(Integer teamSize, Integer minTeamSize, Integer maxTeamSize) {
        if (teamSize == null || minTeamSize == null || maxTeamSize == null) {
            return false;
        }
        return teamSize >= minTeamSize && teamSize <= maxTeamSize;
    }

    public boolean canSubmit(LocalDate submissionDeadline, Integer gracePeriodHours, LocalDate nowDate) {
        if (submissionDeadline == null) {
            return true;
        }
        LocalDate referenceDate = nowDate == null ? LocalDate.now() : nowDate;
        return !referenceDate.isAfter(submissionDeadline.plusDays(Math.max(0, gracePeriodHours == null ? 0 : gracePeriodHours) / 24L));
    }

    private boolean isPresent(String value) {
        return value != null && !value.isBlank();
    }

    private boolean isBlank(String value) {
        return value == null || value.isBlank();
    }
}
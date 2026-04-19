package com.grownited.service;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDate;

import org.junit.jupiter.api.Test;

import com.grownited.entity.HackathonEntity;

class HackathonValidationServiceTests {

    private final HackathonValidationService validationService = new HackathonValidationService();

    @Test
    void validHackathonPassesValidation() {
        HackathonEntity hackathon = new HackathonEntity();
        hackathon.setTitle("HackVerse");
        hackathon.setDescription("Build something useful");
        hackathon.setMinTeamSize(1);
        hackathon.setMaxTeamSize(4);
        hackathon.setRegistrationStartDate(LocalDate.now());
        hackathon.setRegistrationEndDate(LocalDate.now().plusDays(7));
        hackathon.setProblemTitle("Problem");
        hackathon.setProblemStatement("Solve it");
        hackathon.setProblemDeliverables("Demo and code");

        assertTrue(validationService.isValid(hackathon));
    }

    @Test
    void invalidDateRangeFailsValidation() {
        HackathonEntity hackathon = new HackathonEntity();
        hackathon.setTitle("HackVerse");
        hackathon.setDescription("Build something useful");
        hackathon.setMinTeamSize(1);
        hackathon.setMaxTeamSize(4);
        hackathon.setRegistrationStartDate(LocalDate.now().plusDays(7));
        hackathon.setRegistrationEndDate(LocalDate.now());
        hackathon.setProblemTitle("Problem");
        hackathon.setProblemStatement("Solve it");
        hackathon.setProblemDeliverables("Demo and code");

        assertFalse(validationService.isValid(hackathon));
    }
}
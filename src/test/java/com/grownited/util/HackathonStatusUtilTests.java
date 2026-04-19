package com.grownited.util;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.LocalDate;

import org.junit.jupiter.api.Test;

import com.grownited.entity.HackathonEntity;

class HackathonStatusUtilTests {

    @Test
    void completedHackathonIsExpired() {
        HackathonEntity hackathon = new HackathonEntity();
        hackathon.setStatus("COMPLETED");

        assertTrue(HackathonStatusUtil.isExpired(hackathon, LocalDate.now()));
    }

    @Test
    void openRegistrationIsDetected() {
        HackathonEntity hackathon = new HackathonEntity();
        hackathon.setRegistrationStartDate(LocalDate.now().minusDays(1));
        hackathon.setRegistrationEndDate(LocalDate.now().plusDays(1));

        assertTrue(HackathonStatusUtil.isRegistrationOpen(hackathon, LocalDate.now()));
    }

    @Test
    void expiredRegistrationIsNotOpen() {
        HackathonEntity hackathon = new HackathonEntity();
        hackathon.setRegistrationStartDate(LocalDate.now().minusDays(4));
        hackathon.setRegistrationEndDate(LocalDate.now().minusDays(1));

        assertFalse(HackathonStatusUtil.isRegistrationOpen(hackathon, LocalDate.now()));
    }
}
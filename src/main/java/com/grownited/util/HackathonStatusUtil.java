package com.grownited.util;

import java.time.LocalDate;

import com.grownited.entity.HackathonEntity;

public final class HackathonStatusUtil {

    private HackathonStatusUtil() {
    }

    public static boolean isExpired(HackathonEntity hackathon, LocalDate today) {
        if (hackathon == null) {
            return true;
        }
        LocalDate referenceDate = today == null ? LocalDate.now() : today;
        if ("COMPLETED".equalsIgnoreCase(hackathon.getStatus())) {
            return true;
        }
        if (hackathon.getSubmissionDeadline() != null && referenceDate.isAfter(hackathon.getSubmissionDeadline())) {
            return true;
        }
        if (hackathon.getEventEndDate() != null && referenceDate.isAfter(hackathon.getEventEndDate())) {
            return true;
        }
        return hackathon.getRegistrationEndDate() != null && referenceDate.isAfter(hackathon.getRegistrationEndDate());
    }

    public static boolean isRegistrationOpen(HackathonEntity hackathon, LocalDate today) {
        if (hackathon == null || hackathon.getRegistrationStartDate() == null || hackathon.getRegistrationEndDate() == null) {
            return false;
        }
        LocalDate referenceDate = today == null ? LocalDate.now() : today;
        return !referenceDate.isBefore(hackathon.getRegistrationStartDate())
                && !referenceDate.isAfter(hackathon.getRegistrationEndDate())
                && !isExpired(hackathon, referenceDate);
    }

    public static boolean isLive(HackathonEntity hackathon, LocalDate today) {
        if (hackathon == null) {
            return false;
        }
        LocalDate referenceDate = today == null ? LocalDate.now() : today;
        if (hackathon.getEventStartDate() != null && hackathon.getEventEndDate() != null) {
            return !referenceDate.isBefore(hackathon.getEventStartDate()) && !referenceDate.isAfter(hackathon.getEventEndDate());
        }
        return "ONGOING".equalsIgnoreCase(hackathon.getStatus());
    }

    public static boolean isUpcoming(HackathonEntity hackathon, LocalDate today) {
        if (hackathon == null) {
            return false;
        }
        LocalDate referenceDate = today == null ? LocalDate.now() : today;
        return !isExpired(hackathon, referenceDate) && !isLive(hackathon, referenceDate);
    }

    public static String resolveStatus(HackathonEntity hackathon, LocalDate today) {
        if (hackathon == null) {
            return "UPCOMING";
        }
        LocalDate referenceDate = today == null ? LocalDate.now() : today;
        if (isExpired(hackathon, referenceDate)) {
            return "COMPLETED";
        }
        if (isLive(hackathon, referenceDate)) {
            return "ONGOING";
        }
        return "UPCOMING";
    }

    public static int resolveGracePeriodHours(HackathonEntity hackathon) {
        if (hackathon == null || hackathon.getGracePeriodHours() == null || hackathon.getGracePeriodHours() < 0) {
            return 0;
        }
        return hackathon.getGracePeriodHours();
    }
}
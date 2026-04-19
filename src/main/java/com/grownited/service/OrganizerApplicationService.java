package com.grownited.service;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.grownited.common.AppConstants;
import com.grownited.dto.OrganizerApplicationManageView;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.UserRepository;

@Service
public class OrganizerApplicationService {

    private static final Set<String> ALLOWED_STATUSES = Set.of("APPLIED", "SHORTLISTED", "REJECTED", "FINALIST", "WINNER");
    private static final Set<String> ALLOWED_PAYMENT_STATUSES = Set.of("PENDING", "PAID", "FAILED", "WAIVED");
    private static final Map<String, Set<String>> STATUS_TRANSITIONS = buildStatusTransitions();

    @Autowired
    private HackathonRepository hackathonRepository;

    @Autowired
    private HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuditLogService auditLogService;

    @Autowired
    private NotificationService notificationService;

    public List<HackathonEntity> getManageableHackathons(UserEntity currentUser) {
        if (AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole())) {
            return hackathonRepository.findAllByOrderByHackathonIdDesc();
        }
        return hackathonRepository.findByUserIdOrderByHackathonIdDesc(currentUser.getUserId());
    }

    public List<OrganizerApplicationManageView> getApplicationViews(Integer hackathonId, UserEntity currentUser) {
        List<OrganizerApplicationManageView> views = new ArrayList<>();
        if (hackathonId == null) {
            return views;
        }

        if (!canManageHackathon(hackathonId, currentUser)) {
            return views;
        }

        List<HackathonApplicationEntity> apps = hackathonApplicationRepository.findByHackathonId(hackathonId);
        for (HackathonApplicationEntity app : apps) {
            OrganizerApplicationManageView view = new OrganizerApplicationManageView();
            view.setApplication(app);
            Optional<UserEntity> opParticipant = userRepository.findById(app.getParticipantUserId());
            view.setParticipantName(opParticipant.map(p -> p.getFirstName() + " " + p.getLastName()).orElse("Unknown"));
            views.add(view);
        }
        return views;
    }

    public UpdateApplicationResult updateApplicationStatus(Integer applicationId, String status, String paymentStatus,
            UserEntity currentUser) {
        Optional<HackathonApplicationEntity> opApp = hackathonApplicationRepository.findById(applicationId);
        if (opApp.isEmpty()) {
            return UpdateApplicationResult.error("redirect:/organizer/applications?msg=Application+not+found&type=error");
        }

        HackathonApplicationEntity app = opApp.get();
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(app.getHackathonId());
        if (opHackathon.isEmpty()) {
            return UpdateApplicationResult.error("redirect:/organizer/applications?msg=Hackathon+not+found&type=error");
        }

        HackathonEntity hackathon = opHackathon.get();
        boolean isAdmin = AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole());
        boolean isOwner = hackathon.getUserId() != null && hackathon.getUserId().equals(currentUser.getUserId());
        if (!isAdmin && !isOwner) {
            return UpdateApplicationResult.error("redirect:/organizer/applications?hackathonId=" + app.getHackathonId()
                    + "&msg=Unauthorized+update+attempt&type=error");
        }

        String normalizedStatus = normalize(status);
        if (!ALLOWED_STATUSES.contains(normalizedStatus)) {
            return UpdateApplicationResult.error("redirect:/organizer/applications?hackathonId=" + app.getHackathonId()
                    + "&msg=Invalid+application+status&type=error");
        }

        String currentStatus = normalize(app.getStatus());
        if (!isValidTransition(currentStatus, normalizedStatus)) {
            return UpdateApplicationResult.error("redirect:/organizer/applications?hackathonId=" + app.getHackathonId()
                    + "&msg=Invalid+status+transition&type=error");
        }

        String oldStatus = app.getStatus();
        app.setStatus(normalizedStatus);

        if ("FREE".equalsIgnoreCase(hackathon.getPayment())) {
            app.setPaymentStatus("WAIVED");
        } else if (paymentStatus != null && !paymentStatus.isBlank()) {
            String normalizedPaymentStatus = normalize(paymentStatus);
            if (!ALLOWED_PAYMENT_STATUSES.contains(normalizedPaymentStatus)) {
                return UpdateApplicationResult.error("redirect:/organizer/applications?hackathonId=" + app.getHackathonId()
                        + "&msg=Invalid+payment+status&type=error");
            }
            app.setPaymentStatus(normalizedPaymentStatus);
        }
        hackathonApplicationRepository.save(app);
        auditLogService.logStatusChange(app.getApplicationId(), oldStatus, normalizedStatus, currentUser.getUserId());
        notificationService.notifyApplicationStatusChange(app, normalizedStatus);

        return UpdateApplicationResult.success("redirect:/organizer/applications?hackathonId=" + app.getHackathonId()
                + "&msg=Application+updated+successfully&type=success");
    }

    public static class UpdateApplicationResult {
        private final boolean success;
        private final String redirectPath;

        private UpdateApplicationResult(boolean success, String redirectPath) {
            this.success = success;
            this.redirectPath = redirectPath;
        }

        public static UpdateApplicationResult success(String redirectPath) {
            return new UpdateApplicationResult(true, redirectPath);
        }

        public static UpdateApplicationResult error(String redirectPath) {
            return new UpdateApplicationResult(false, redirectPath);
        }

        public boolean isSuccess() {
            return success;
        }

        public String getRedirectPath() {
            return redirectPath;
        }
    }

    private static String normalize(String value) {
        return value == null ? "" : value.trim().toUpperCase();
    }

    private boolean canManageHackathon(Integer hackathonId, UserEntity currentUser) {
        if (currentUser == null) {
            return false;
        }
        if (AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole())) {
            return true;
        }
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        return opHackathon.isPresent() && opHackathon.get().getUserId() != null
                && opHackathon.get().getUserId().equals(currentUser.getUserId());
    }

    private boolean isValidTransition(String currentStatus, String nextStatus) {
        if (nextStatus.equals(currentStatus)) {
            return true;
        }
        Set<String> allowedNext = STATUS_TRANSITIONS.get(currentStatus);
        return allowedNext != null && allowedNext.contains(nextStatus);
    }

    private static Map<String, Set<String>> buildStatusTransitions() {
        Map<String, Set<String>> transitions = new LinkedHashMap<>();
        transitions.put("APPLIED", Set.of("SHORTLISTED", "REJECTED"));
        transitions.put("SHORTLISTED", Set.of("FINALIST", "REJECTED"));
        transitions.put("FINALIST", Set.of("WINNER", "REJECTED"));
        transitions.put("REJECTED", Set.of());
        transitions.put("WINNER", Set.of());
        return transitions;
    }
}

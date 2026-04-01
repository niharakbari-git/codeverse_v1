package com.grownited.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

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

    @Autowired
    private HackathonRepository hackathonRepository;

    @Autowired
    private HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    private UserRepository userRepository;

    public List<HackathonEntity> getManageableHackathons(UserEntity currentUser) {
        if (AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole())) {
            return hackathonRepository.findAll();
        }
        return hackathonRepository.findByUserId(currentUser.getUserId());
    }

    public List<OrganizerApplicationManageView> getApplicationViews(Integer hackathonId) {
        List<OrganizerApplicationManageView> views = new ArrayList<>();
        if (hackathonId == null) {
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

        app.setStatus(status);
        if (paymentStatus != null && !paymentStatus.isBlank()) {
            app.setPaymentStatus(paymentStatus);
        }
        hackathonApplicationRepository.save(app);

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
}

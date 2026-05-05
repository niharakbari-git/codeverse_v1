package com.grownited.controller.organizer;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.grownited.common.AppConstants;
import com.grownited.dto.OrganizerApplicationManageView;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.JudgeAssignmentEntity;
import com.grownited.entity.JudgeScoreEntity;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.JudgeAssignmentRepository;
import com.grownited.repository.JudgeScoreRepository;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;
import com.grownited.repository.UserTypeRepository;
import com.grownited.service.AuthService;
import com.grownited.service.AuditLogService;
import com.grownited.service.NotificationService;
import com.grownited.service.OrganizerApplicationService;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrganizerController {

    @Autowired
    HackathonRepository hackathonRepository;

    @Autowired
    UserRepository userRepository;

    @Autowired
    JudgeAssignmentRepository judgeAssignmentRepository;

    @Autowired
    HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    JudgeScoreRepository judgeScoreRepository;

    @Autowired
    OrganizerApplicationService organizerApplicationService;

    @Autowired
    UserDetailRepository userDetailRepository;

    @Autowired
    UserTypeRepository userTypeRepository;

    @Autowired
    AuthService authService;

    @Autowired
    AuditLogService auditLogService;

    @Autowired
    NotificationService notificationService;

    @GetMapping("/organizer/judge-assignments")
    public String judgeAssignments(HttpSession session, Model model) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        List<HackathonEntity> myHackathons;
        if (AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole())) {
            myHackathons = hackathonRepository.findAllByOrderByHackathonIdDesc();
        } else {
            myHackathons = hackathonRepository.findByUserIdOrderByHackathonIdDesc(currentUser.getUserId());
        }

        List<UserEntity> judges = userRepository.findByRole("JUDGE");

        List<AssignmentView> assignmentViews = new ArrayList<>();
        for (HackathonEntity hackathon : myHackathons) {
            List<JudgeAssignmentEntity> assignments = judgeAssignmentRepository.findByHackathonId(hackathon.getHackathonId());
            for (JudgeAssignmentEntity assignment : assignments) {
                AssignmentView view = new AssignmentView();
                view.setHackathonTitle(hackathon.getTitle());
                view.setAssignedAt(assignment.getAssignedAt());
                Optional<UserEntity> opJudge = userRepository.findById(assignment.getJudgeUserId());
                view.setJudgeName(opJudge.map(j -> j.getFirstName() + " " + j.getLastName()).orElse("Unknown Judge"));
                assignmentViews.add(view);
            }
        }

        model.addAttribute("myHackathons", myHackathons);
        model.addAttribute("judges", judges);
        model.addAttribute("assignmentViews", assignmentViews);
        return "organizer/JudgeAssignments";
    }

    @PostMapping("/organizer/assign-judge")
    public String assignJudge(@RequestParam Integer hackathonId, @RequestParam Integer judgeUserId, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return "redirect:/organizer/judge-assignments?msg=Hackathon+not+found&type=error";
        }

        HackathonEntity hackathon = opHackathon.get();
        boolean isAdmin = AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole());
        boolean isOwner = hackathon.getUserId() != null && hackathon.getUserId().equals(currentUser.getUserId());
        if (!isAdmin && !isOwner) {
            return "redirect:/organizer/judge-assignments?msg=You+can+assign+judges+only+to+your+hackathons&type=error";
        }

        Optional<UserEntity> opJudge = userRepository.findById(judgeUserId);
        if (opJudge.isEmpty() || !AppConstants.ROLE_JUDGE.equalsIgnoreCase(opJudge.get().getRole())) {
            return "redirect:/organizer/judge-assignments?msg=Selected+user+is+not+a+judge&type=error";
        }

        return assignJudgeToHackathon(hackathon, opJudge.get().getUserId(), currentUser);
    }

    @PostMapping("/organizer/assign-judge-by-email")
    public String assignJudgeByEmail(@RequestParam Integer hackathonId, @RequestParam String judgeEmail, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return "redirect:/organizer/judge-assignments?msg=Hackathon+not+found&type=error";
        }

        HackathonEntity hackathon = opHackathon.get();
        boolean isAdmin = AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole());
        boolean isOwner = hackathon.getUserId() != null && hackathon.getUserId().equals(currentUser.getUserId());
        if (!isAdmin && !isOwner) {
            return "redirect:/organizer/judge-assignments?msg=You+can+assign+judges+only+to+your+hackathons&type=error";
        }

        if (judgeEmail == null || judgeEmail.isBlank()) {
            return "redirect:/organizer/judge-assignments?msg=Judge+email+is+required&type=error";
        }

        Optional<UserEntity> opTargetUser = userRepository.findByEmailIgnoreCase(judgeEmail.trim());
        if (opTargetUser.isEmpty()) {
            return "redirect:/organizer/judge-assignments?msg=No+account+found+with+that+email&type=error";
        }

        UserEntity targetUser = opTargetUser.get();
        String targetRole = AppConstants.normalizeRole(targetUser.getRole());

        if (AppConstants.ROLE_PARTICIPANT.equals(targetRole)) {
            targetUser.setRole(AppConstants.ROLE_JUDGE);
            userRepository.save(targetUser);
            promoteUserDetailTypeToJudge(targetUser.getUserId());
        } else if (!AppConstants.ROLE_JUDGE.equals(targetRole)) {
            return "redirect:/organizer/judge-assignments?msg=Only+participant+accounts+can+be+promoted+to+judge.+Admin+or+Organizer+cannot+be+changed&type=error";
        }

        return assignJudgeToHackathon(hackathon, targetUser.getUserId(), currentUser);
    }

    private void promoteUserDetailTypeToJudge(Integer userId) {
        Integer judgeUserTypeId = userTypeRepository.findByUserTypeIgnoreCase(AppConstants.ROLE_JUDGE)
                .map(ut -> ut.getUserTypeId())
                .orElse(null);

        if (judgeUserTypeId == null) {
            return;
        }

        UserDetailEntity userDetail = userDetailRepository.findByUserId(userId).orElseGet(() -> {
            UserDetailEntity created = new UserDetailEntity();
            created.setUserId(userId);
            return created;
        });
        userDetail.setUserTypeId(judgeUserTypeId);
        userDetailRepository.save(userDetail);
    }

    private String assignJudgeToHackathon(HackathonEntity hackathon, Integer judgeUserId, UserEntity assignedBy) {
        if (judgeAssignmentRepository.existsByHackathonIdAndJudgeUserId(hackathon.getHackathonId(), judgeUserId)) {
            return "redirect:/organizer/judge-assignments?msg=Judge+already+assigned&type=info";
        }

        JudgeAssignmentEntity assignment = new JudgeAssignmentEntity();
        assignment.setHackathonId(hackathon.getHackathonId());
        assignment.setJudgeUserId(judgeUserId);
        assignment.setAssignedByUserId(assignedBy.getUserId());
        assignment.setAssignedAt(LocalDate.now());
        judgeAssignmentRepository.save(assignment);
        auditLogService.logAssignmentChange(assignment.getJudgeAssignmentId(), "CREATE", assignedBy.getUserId(),
            "Judge=" + judgeUserId + ", Hackathon=" + hackathon.getHackathonId());
        notificationService.notifyJudgeAssignment(judgeUserId, hackathon.getHackathonId(), hackathon.getTitle());

        return "redirect:/organizer/judge-assignments?msg=Judge+assigned+successfully&type=success";
    }

    @GetMapping("/organizer/applications")
    public String organizerApplications(@RequestParam(required = false) Integer hackathonId, HttpSession session, Model model) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        List<HackathonEntity> myHackathons = organizerApplicationService.getManageableHackathons(currentUser);

        if (hackathonId == null && !myHackathons.isEmpty()) {
            hackathonId = myHackathons.get(0).getHackathonId();
        }

        List<OrganizerApplicationManageView> views = organizerApplicationService.getApplicationViews(hackathonId, currentUser);

        model.addAttribute("myHackathons", myHackathons);
        model.addAttribute("selectedHackathonId", hackathonId);
        model.addAttribute("applicationViews", views);
        return "organizer/Applications";
    }

    @PostMapping("/organizer/update-application-status")
    public String updateApplicationStatus(@RequestParam Integer applicationId, @RequestParam String status,
            @RequestParam(required = false) String paymentStatus, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        OrganizerApplicationService.UpdateApplicationResult result = organizerApplicationService
                .updateApplicationStatus(applicationId, status, paymentStatus, currentUser);
        return result.getRedirectPath();
    }

    @GetMapping("/organizer/results")
    public String organizerResults(@RequestParam(required = false) Integer hackathonId, HttpSession session, Model model) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        List<HackathonEntity> myHackathons = AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole())
            ? hackathonRepository.findAllByOrderByHackathonIdDesc()
            : hackathonRepository.findByUserIdOrderByHackathonIdDesc(currentUser.getUserId());

        if (hackathonId == null && !myHackathons.isEmpty()) {
            hackathonId = myHackathons.get(0).getHackathonId();
        }

        List<ResultView> resultViews = new ArrayList<>();
        if (hackathonId != null) {
            List<HackathonApplicationEntity> apps = hackathonApplicationRepository.findByHackathonId(hackathonId);
            for (HackathonApplicationEntity app : apps) {
                List<JudgeScoreEntity> scores = judgeScoreRepository.findByApplicationId(app.getApplicationId());
                double avg = scores.stream().mapToInt(s -> s.getScore() == null ? 0 : s.getScore()).average().orElse(0.0);
                ResultView r = new ResultView();
                r.setApplicationId(app.getApplicationId());
                Optional<UserEntity> opParticipant = userRepository.findById(app.getParticipantUserId());
                r.setParticipantName(opParticipant.map(p -> p.getFirstName() + " " + p.getLastName()).orElse("Unknown"));
                r.setStatus(app.getStatus());
                r.setAverageScore(avg);
                r.setScoreCount(scores.size());
                resultViews.add(r);
            }
            resultViews.sort((a, b) -> Double.compare(b.getAverageScore(), a.getAverageScore()));
        }

        model.addAttribute("myHackathons", myHackathons);
        model.addAttribute("selectedHackathonId", hackathonId);
        model.addAttribute("resultViews", resultViews);
        return "organizer/Results";
    }

    @GetMapping("/organizer/profile")
    public String organizerProfile(HttpSession session, Model model) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        model.addAttribute("profileUser", currentUser);
        model.addAttribute("profileUserDetail", userDetailRepository.findByUserId(currentUser.getUserId()).orElse(null));
        return "organizer/Profile";
    }

    @PostMapping("/organizer/profile/change-pfp")
    public String changeOrganizerProfilePicture(MultipartFile profilePic, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        AuthService.ProfilePictureUpdateResult result = authService.updateProfilePicture(currentUser.getUserId(), profilePic);
        if (result.isSuccessful()) {
            session.setAttribute(AppConstants.SESSION_USER, result.getUpdatedUser());
            return "redirect:/organizer/profile?msg=Profile+picture+updated+successfully&type=success";
        }
        return "redirect:/organizer/profile?msg=" + result.getMessage().replace(" ", "+") + "&type=error";
    }

    @PostMapping("/organizer/profile/remove-pfp")
    public String removeOrganizerProfilePicture(HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        AuthService.ProfilePictureUpdateResult result = authService.removeProfilePicture(currentUser.getUserId());
        if (result.isSuccessful()) {
            session.setAttribute(AppConstants.SESSION_USER, result.getUpdatedUser());
            return "redirect:/organizer/profile?msg=Profile+picture+removed+successfully&type=success";
        }
        return "redirect:/organizer/profile?msg=" + result.getMessage().replace(" ", "+") + "&type=error";
    }

    @PostMapping("/organizer/profile/change-password")
    public String changePassword(String currentPassword, String newPassword, String confirmPassword, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        String error = authService.changePassword(currentUser.getUserId(), currentPassword, newPassword, confirmPassword);
        if (error == null) {
            return "redirect:/organizer/profile?msg=Password+changed+successfully&type=success";
        }
        return "redirect:/organizer/profile?msg=" + error.replace(" ", "+") + "&type=error";
    }

    @PostMapping("/organizer/profile/update-details")
    public String updateOrganizerProfileDetails(String firstName, String lastName, String email, String gender, String birthYear,
            String contactNum, String qualification, String city, String state, String country,
            String linkedinUrl, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        String normalizedEmail = trimToNull(email);
        if (normalizedEmail == null) {
            return "redirect:/organizer/profile?msg=Email+is+required&type=error";
        }

        Optional<UserEntity> existingUser = userRepository.findByEmail(normalizedEmail);
        if (existingUser.isPresent() && !existingUser.get().getUserId().equals(currentUser.getUserId())) {
            return "redirect:/organizer/profile?msg=Email+already+exists.+Use+another+email&type=error";
        }

        currentUser.setFirstName(trimToNull(firstName));
        currentUser.setLastName(trimToNull(lastName));
        currentUser.setEmail(normalizedEmail);
        currentUser.setGender(trimToNull(gender));
        currentUser.setBirthYear(parseBirthYear(birthYear));

        currentUser.setContactNum(trimToNull(contactNum));
        userRepository.save(currentUser);

        UserDetailEntity userDetail = userDetailRepository.findByUserId(currentUser.getUserId()).orElseGet(() -> {
            UserDetailEntity created = new UserDetailEntity();
            created.setUserId(currentUser.getUserId());
            return created;
        });

        userDetail.setQualification(trimToNull(qualification));
        userDetail.setCity(trimToNull(city));
        userDetail.setState(trimToNull(state));
        userDetail.setCountry(trimToNull(country));
        userDetail.setLinkedinUrl(trimToNull(linkedinUrl));
        userDetailRepository.save(userDetail);

        session.setAttribute(AppConstants.SESSION_USER, currentUser);
        return "redirect:/organizer/profile?msg=Profile+updated+successfully&type=success";
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private Integer parseBirthYear(String value) {
        String trimmed = trimToNull(value);
        if (trimmed == null) {
            return null;
        }
        try {
            return Integer.parseInt(trimmed);
        } catch (NumberFormatException ex) {
            return null;
        }
    }

    public static class AssignmentView {
        private String hackathonTitle;
        private String judgeName;
        private LocalDate assignedAt;

        public String getHackathonTitle() {
            return hackathonTitle;
        }

        public void setHackathonTitle(String hackathonTitle) {
            this.hackathonTitle = hackathonTitle;
        }

        public String getJudgeName() {
            return judgeName;
        }

        public void setJudgeName(String judgeName) {
            this.judgeName = judgeName;
        }

        public LocalDate getAssignedAt() {
            return assignedAt;
        }

        public void setAssignedAt(LocalDate assignedAt) {
            this.assignedAt = assignedAt;
        }
    }

    public static class ResultView {
        private Integer applicationId;
        private String participantName;
        private String status;
        private double averageScore;
        private int scoreCount;

        public Integer getApplicationId() {
            return applicationId;
        }

        public void setApplicationId(Integer applicationId) {
            this.applicationId = applicationId;
        }

        public String getParticipantName() {
            return participantName;
        }

        public void setParticipantName(String participantName) {
            this.participantName = participantName;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public double getAverageScore() {
            return averageScore;
        }

        public void setAverageScore(double averageScore) {
            this.averageScore = averageScore;
        }

        public int getScoreCount() {
            return scoreCount;
        }

        public void setScoreCount(int scoreCount) {
            this.scoreCount = scoreCount;
        }
    }
}

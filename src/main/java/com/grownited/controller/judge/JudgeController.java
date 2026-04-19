package com.grownited.controller.judge;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.JudgeAssignmentEntity;
import com.grownited.entity.JudgeScoreEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.JudgeAssignmentRepository;
import com.grownited.repository.JudgeScoreRepository;
import com.grownited.repository.UserRepository;
import com.grownited.service.AuditLogService;
import com.grownited.service.NotificationService;

import jakarta.servlet.http.HttpSession;

@Controller
public class JudgeController {

    @Autowired
    JudgeAssignmentRepository judgeAssignmentRepository;

    @Autowired
    HackathonRepository hackathonRepository;

    @Autowired
    UserRepository userRepository;

    @Autowired
    HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    JudgeScoreRepository judgeScoreRepository;

    @Autowired
    AuditLogService auditLogService;

    @Autowired
    NotificationService notificationService;

    @GetMapping("/judge-dashboard")
    public String judgeDashboard(HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<JudgeAssignmentEntity> assignments = judgeAssignmentRepository.findByJudgeUserId(currentUser.getUserId());
        assignments.sort(Comparator.comparing(JudgeAssignmentEntity::getJudgeAssignmentId, Comparator.nullsLast(Comparator.naturalOrder())).reversed());
        long totalAssigned = assignments.size();

        List<JudgeScoreEntity> scores = judgeScoreRepository.findByJudgeUserId(currentUser.getUserId());
        long totalEvaluated = scores.size();

        long totalPendingAll = 0;
        
        List<JudgeTaskView> tasks = new ArrayList<>();

        for (JudgeAssignmentEntity assignment : assignments) {
            Optional<HackathonEntity> opHackathon = hackathonRepository.findById(assignment.getHackathonId());
            if (opHackathon.isEmpty()) continue;
            HackathonEntity h = opHackathon.get();

            List<HackathonApplicationEntity> apps = hackathonApplicationRepository.findByHackathonId(h.getHackathonId());
            long subs = apps.size();
            long evalCount = scores.stream().filter(s -> h.getHackathonId().equals(s.getHackathonId())).count();
            long pnd = Math.max(0, subs - evalCount);
            totalPendingAll += pnd;

            JudgeTaskView task = new JudgeTaskView();
            task.setHackathonId(h.getHackathonId());
            task.setHackathonTitle(h.getTitle());
            task.setTotalSubmissions(subs);
            task.setEvaluated(evalCount);
            task.setPending(pnd);
            tasks.add(task);
        }

        tasks.sort((left, right) -> right.getHackathonId().compareTo(left.getHackathonId()));

        model.addAttribute("totalAssigned", totalAssigned);
        model.addAttribute("totalEvaluated", totalEvaluated);
        model.addAttribute("totalPending", totalPendingAll);
        model.addAttribute("judgeTasks", tasks);

        return "judge/JudgeDashboard";
    }

    public static class JudgeTaskView {
        private Integer hackathonId;
        private String hackathonTitle;
        private Long totalSubmissions;
        private Long evaluated;
        private Long pending;

        public Integer getHackathonId() { return hackathonId; }
        public void setHackathonId(Integer hackathonId) { this.hackathonId = hackathonId; }
        public String getHackathonTitle() { return hackathonTitle; }
        public void setHackathonTitle(String hackathonTitle) { this.hackathonTitle = hackathonTitle; }
        public Long getTotalSubmissions() { return totalSubmissions; }
        public void setTotalSubmissions(Long totalSubmissions) { this.totalSubmissions = totalSubmissions; }
        public Long getEvaluated() { return evaluated; }
        public void setEvaluated(Long evaluated) { this.evaluated = evaluated; }
        public Long getPending() { return pending; }
        public void setPending(Long pending) { this.pending = pending; }
    }

    @GetMapping("/judge/my-assignments")
    public String myAssignments(HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<JudgeAssignmentEntity> assignments = judgeAssignmentRepository.findByJudgeUserId(currentUser.getUserId());
        assignments.sort(Comparator.comparing(JudgeAssignmentEntity::getJudgeAssignmentId, Comparator.nullsLast(Comparator.naturalOrder())).reversed());
        List<JudgeAssignmentView> views = new ArrayList<>();
        for (JudgeAssignmentEntity assignment : assignments) {
            JudgeAssignmentView view = new JudgeAssignmentView();
            Optional<HackathonEntity> opHackathon = hackathonRepository.findById(assignment.getHackathonId());
            view.setHackathonTitle(opHackathon.map(HackathonEntity::getTitle).orElse("Unknown Hackathon"));
            view.setAssignedAt(assignment.getAssignedAt());
            Optional<UserEntity> opOrganizer = userRepository.findById(assignment.getAssignedByUserId());
            view.setAssignedBy(opOrganizer.map(o -> o.getFirstName() + " " + o.getLastName()).orElse("Unknown"));
            views.add(view);
        }

        model.addAttribute("assignmentViews", views);
        return "judge/MyAssignments";
    }

    @GetMapping("/judge/scorecards")
    public String scorecards(@RequestParam(required = false) Integer hackathonId, HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        model.addAttribute("msg", session.getAttribute("judgeFlowMsg"));
        model.addAttribute("msgType", session.getAttribute("judgeFlowMsgType"));
        session.removeAttribute("judgeFlowMsg");
        session.removeAttribute("judgeFlowMsgType");

        List<JudgeAssignmentEntity> assignments = judgeAssignmentRepository.findByJudgeUserId(currentUser.getUserId());
        assignments.sort(Comparator.comparing(JudgeAssignmentEntity::getJudgeAssignmentId, Comparator.nullsLast(Comparator.naturalOrder())).reversed());
        List<HackathonEntity> assignedHackathons = new ArrayList<>();
        for (JudgeAssignmentEntity a : assignments) {
            hackathonRepository.findById(a.getHackathonId()).ifPresent(assignedHackathons::add);
        }

        assignedHackathons.sort((left, right) -> right.getHackathonId().compareTo(left.getHackathonId()));

        if (hackathonId == null && !assignedHackathons.isEmpty()) {
            hackathonId = assignedHackathons.get(0).getHackathonId();
        }

        if (hackathonId != null
                && !judgeAssignmentRepository.existsByHackathonIdAndJudgeUserId(hackathonId, currentUser.getUserId())) {
            if (!assignedHackathons.isEmpty()) {
                hackathonId = assignedHackathons.get(0).getHackathonId();
            } else {
                hackathonId = null;
            }
            model.addAttribute("msg", "You can only score hackathons assigned to you.");
            model.addAttribute("msgType", "error");
        }

        List<ScorecardView> scorecards = new ArrayList<>();
        if (hackathonId != null) {
            List<HackathonApplicationEntity> apps = hackathonApplicationRepository.findByHackathonId(hackathonId);
            for (HackathonApplicationEntity app : apps) {
                ScorecardView view = new ScorecardView();
                view.setApplication(app);
                Optional<UserEntity> opParticipant = userRepository.findById(app.getParticipantUserId());
                view.setParticipantName(opParticipant.map(p -> p.getFirstName() + " " + p.getLastName()).orElse("Unknown"));

                Optional<JudgeScoreEntity> opScore = judgeScoreRepository.findByApplicationIdAndJudgeUserId(
                        app.getApplicationId(), currentUser.getUserId());
                view.setGivenScore(opScore.map(JudgeScoreEntity::getScore).orElse(null));
                view.setIdeaScore(opScore.map(JudgeScoreEntity::getIdeaScore).orElse(null));
                view.setDesignScore(opScore.map(JudgeScoreEntity::getDesignScore).orElse(null));
                view.setExecutionScore(opScore.map(JudgeScoreEntity::getExecutionScore).orElse(null));
                view.setPitchScore(opScore.map(JudgeScoreEntity::getPitchScore).orElse(null));
                view.setRemarks(opScore.map(JudgeScoreEntity::getRemarks).orElse(""));
                scorecards.add(view);
            }
        }

        model.addAttribute("assignedHackathons", assignedHackathons);
        model.addAttribute("selectedHackathonId", hackathonId);
        model.addAttribute("scorecards", scorecards);
        return "judge/Scorecards";
    }

    @PostMapping("/judge/submit-score")
    public String submitScore(@RequestParam Integer applicationId, @RequestParam Integer hackathonId,
            @RequestParam Integer ideaScore, 
            @RequestParam Integer designScore, 
            @RequestParam Integer executionScore, 
            @RequestParam Integer pitchScore, 
            @RequestParam(required = false) String remarks, HttpSession session) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (!judgeAssignmentRepository.existsByHackathonIdAndJudgeUserId(hackathonId, currentUser.getUserId())) {
            session.setAttribute("judgeFlowMsg", "Unauthorized score attempt blocked.");
            session.setAttribute("judgeFlowMsgType", "error");
            return "redirect:/judge/scorecards";
        }

        Optional<HackathonApplicationEntity> opApp = hackathonApplicationRepository.findById(applicationId);
        if (opApp.isEmpty() || !hackathonId.equals(opApp.get().getHackathonId())) {
            session.setAttribute("judgeFlowMsg", "Application not found for selected hackathon.");
            session.setAttribute("judgeFlowMsgType", "error");
            return "redirect:/judge/scorecards?hackathonId=" + hackathonId;
        }

        int normalizedIdea = Math.max(0, Math.min(25, ideaScore));
        int normalizedDesign = Math.max(0, Math.min(25, designScore));
        int normalizedExec = Math.max(0, Math.min(25, executionScore));
        int normalizedPitch = Math.max(0, Math.min(25, pitchScore));
        int totalScore = normalizedIdea + normalizedDesign + normalizedExec + normalizedPitch;

        JudgeScoreEntity scoreEntity = judgeScoreRepository
                .findByApplicationIdAndJudgeUserId(applicationId, currentUser.getUserId())
                .orElseGet(JudgeScoreEntity::new);
        Integer oldScore = scoreEntity.getScore();
        scoreEntity.setApplicationId(applicationId);
        scoreEntity.setHackathonId(hackathonId);
        scoreEntity.setJudgeUserId(currentUser.getUserId());
        scoreEntity.setIdeaScore(normalizedIdea);
        scoreEntity.setDesignScore(normalizedDesign);
        scoreEntity.setExecutionScore(normalizedExec);
        scoreEntity.setPitchScore(normalizedPitch);
        scoreEntity.setScore(totalScore);
        scoreEntity.setRemarks(remarks == null ? "" : remarks.trim());
        scoreEntity.setScoredAt(LocalDate.now());
        judgeScoreRepository.save(scoreEntity);
        auditLogService.logScoreChange(scoreEntity.getJudgeScoreId(), oldScore, totalScore, currentUser.getUserId());
        hackathonRepository.findById(hackathonId).ifPresent(h -> notificationService.notifyScoreRecorded(currentUser.getUserId(), applicationId, h.getTitle()));

        session.setAttribute("judgeFlowMsg", "Score submitted successfully.");
        session.setAttribute("judgeFlowMsgType", "success");

        return "redirect:/judge/scorecards?hackathonId=" + hackathonId;
    }

    public static class JudgeAssignmentView {
        private String hackathonTitle;
        private String assignedBy;
        private java.time.LocalDate assignedAt;

        public String getHackathonTitle() {
            return hackathonTitle;
        }

        public void setHackathonTitle(String hackathonTitle) {
            this.hackathonTitle = hackathonTitle;
        }

        public String getAssignedBy() {
            return assignedBy;
        }

        public void setAssignedBy(String assignedBy) {
            this.assignedBy = assignedBy;
        }

        public java.time.LocalDate getAssignedAt() {
            return assignedAt;
        }

        public void setAssignedAt(java.time.LocalDate assignedAt) {
            this.assignedAt = assignedAt;
        }
    }

    public static class ScorecardView {
        private HackathonApplicationEntity application;
        private String participantName;
        private Integer givenScore;
        private Integer ideaScore;
        private Integer designScore;
        private Integer executionScore;
        private Integer pitchScore;
        private String remarks;

        public HackathonApplicationEntity getApplication() {
            return application;
        }

        public void setApplication(HackathonApplicationEntity application) {
            this.application = application;
        }

        public String getParticipantName() {
            return participantName;
        }

        public void setParticipantName(String participantName) {
            this.participantName = participantName;
        }

        public Integer getGivenScore() {
            return givenScore;
        }

        public void setGivenScore(Integer givenScore) {
            this.givenScore = givenScore;
        }

        public Integer getIdeaScore() { return ideaScore; }
        public void setIdeaScore(Integer ideaScore) { this.ideaScore = ideaScore; }

        public Integer getDesignScore() { return designScore; }
        public void setDesignScore(Integer designScore) { this.designScore = designScore; }

        public Integer getExecutionScore() { return executionScore; }
        public void setExecutionScore(Integer executionScore) { this.executionScore = executionScore; }

        public Integer getPitchScore() { return pitchScore; }
        public void setPitchScore(Integer pitchScore) { this.pitchScore = pitchScore; }

        public String getRemarks() {
            return remarks;
        }

        public void setRemarks(String remarks) {
            this.remarks = remarks;
        }
    }
}

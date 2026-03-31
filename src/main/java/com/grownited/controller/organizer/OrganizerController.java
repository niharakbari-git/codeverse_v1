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

import com.grownited.entity.HackathonEntity;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.JudgeAssignmentEntity;
import com.grownited.entity.JudgeScoreEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.JudgeAssignmentRepository;
import com.grownited.repository.JudgeScoreRepository;
import com.grownited.repository.UserRepository;

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

    @GetMapping("/organizer/judge-assignments")
    public String judgeAssignments(HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<HackathonEntity> myHackathons;
        if ("ADMIN".equalsIgnoreCase(currentUser.getRole())) {
            myHackathons = hackathonRepository.findAll();
        } else {
            myHackathons = hackathonRepository.findByUserId(currentUser.getUserId());
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
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (judgeAssignmentRepository.existsByHackathonIdAndJudgeUserId(hackathonId, judgeUserId)) {
            return "redirect:/organizer/judge-assignments";
        }

        JudgeAssignmentEntity assignment = new JudgeAssignmentEntity();
        assignment.setHackathonId(hackathonId);
        assignment.setJudgeUserId(judgeUserId);
        assignment.setAssignedByUserId(currentUser.getUserId());
        assignment.setAssignedAt(LocalDate.now());
        judgeAssignmentRepository.save(assignment);

        return "redirect:/organizer/judge-assignments";
    }

    @GetMapping("/organizer/applications")
    public String organizerApplications(@RequestParam(required = false) Integer hackathonId, HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<HackathonEntity> myHackathons = "ADMIN".equalsIgnoreCase(currentUser.getRole())
                ? hackathonRepository.findAll()
                : hackathonRepository.findByUserId(currentUser.getUserId());

        if (hackathonId == null && !myHackathons.isEmpty()) {
            hackathonId = myHackathons.get(0).getHackathonId();
        }

        List<ApplicationManageView> views = new ArrayList<>();
        if (hackathonId != null) {
            List<HackathonApplicationEntity> apps = hackathonApplicationRepository.findByHackathonId(hackathonId);
            for (HackathonApplicationEntity app : apps) {
                ApplicationManageView view = new ApplicationManageView();
                view.setApplication(app);
                Optional<UserEntity> opParticipant = userRepository.findById(app.getParticipantUserId());
                view.setParticipantName(opParticipant.map(p -> p.getFirstName() + " " + p.getLastName()).orElse("Unknown"));
                views.add(view);
            }
        }

        model.addAttribute("myHackathons", myHackathons);
        model.addAttribute("selectedHackathonId", hackathonId);
        model.addAttribute("applicationViews", views);
        return "organizer/Applications";
    }

    @PostMapping("/organizer/update-application-status")
    public String updateApplicationStatus(@RequestParam Integer applicationId, @RequestParam String status,
            @RequestParam(required = false) String paymentStatus, HttpSession session) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Optional<HackathonApplicationEntity> opApp = hackathonApplicationRepository.findById(applicationId);
        if (opApp.isPresent()) {
            HackathonApplicationEntity app = opApp.get();

            Optional<HackathonEntity> opHackathon = hackathonRepository.findById(app.getHackathonId());
            if (opHackathon.isEmpty()) {
                return "redirect:/organizer/applications?msg=Hackathon+not+found&type=error";
            }

            HackathonEntity hackathon = opHackathon.get();
            boolean isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRole());
            boolean isOwner = hackathon.getUserId() != null && hackathon.getUserId().equals(currentUser.getUserId());
            if (!isAdmin && !isOwner) {
                return "redirect:/organizer/applications?hackathonId=" + app.getHackathonId()
                        + "&msg=Unauthorized+update+attempt&type=error";
            }

            app.setStatus(status);
            if (paymentStatus != null && !paymentStatus.isBlank()) {
                app.setPaymentStatus(paymentStatus);
            }
            hackathonApplicationRepository.save(app);
            return "redirect:/organizer/applications?hackathonId=" + app.getHackathonId()
                    + "&msg=Application+updated+successfully&type=success";
        }
        return "redirect:/organizer/applications?msg=Application+not+found&type=error";
    }

    @GetMapping("/organizer/results")
    public String organizerResults(@RequestParam(required = false) Integer hackathonId, HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<HackathonEntity> myHackathons = "ADMIN".equalsIgnoreCase(currentUser.getRole())
                ? hackathonRepository.findAll()
                : hackathonRepository.findByUserId(currentUser.getUserId());

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

    public static class ApplicationManageView {
        private HackathonApplicationEntity application;
        private String participantName;

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

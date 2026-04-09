package com.grownited.controller.participant;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.common.AppConstants;
import com.grownited.dto.ParticipantApplicationView;
import com.grownited.dto.ParticipantTeamView;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.service.ParticipantTeamService;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class ParticipantWorkflowController {

    @Autowired
    HackathonRepository hackathonRepository;

    @Autowired
    HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    ParticipantTeamService participantTeamService;

    @GetMapping("/participant/team/new")
    public String newTeam(@RequestParam Integer hackathonId, Model model) {
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return "redirect:/participant/home";
        }

        model.addAttribute("hackathon", opHackathon.get());
        return "participant/NewTeam";
    }

    @PostMapping("/participant/team/create")
    public String createTeamAndApply(@RequestParam Integer hackathonId, @RequestParam String teamName, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }
        return participantTeamService.createTeamAndApply(hackathonId, teamName, currentUser);
    }

    @GetMapping("/participant/my-teams")
    public String myTeams(HttpSession session, Model model) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        List<ParticipantTeamView> teamViews = participantTeamService.getMyTeams(currentUser.getUserId());
        model.addAttribute("teamViews", teamViews);
        return "participant/MyTeams";
    }

    @PostMapping("/participant/team/add-member")
    public String addTeamMember(@RequestParam Integer teamId, @RequestParam String memberEmail, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        ParticipantTeamService.AddMemberResult addMemberResult = participantTeamService.addTeamMember(teamId,
                memberEmail, currentUser.getUserId());
        String type = addMemberResult.isSuccess() ? "success" : "error";
        return "redirect:/participant/my-teams?msg=" + addMemberResult.getMessage() + "&type=" + type;
    }

    @GetMapping("/participant/my-applications")
    public String myApplications(HttpSession session, Model model) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        List<ParticipantApplicationView> appViews = participantTeamService.getMyApplications(currentUser.getUserId());
        model.addAttribute("appViews", appViews);
        return "participant/MyApplications";
    }

    @PostMapping("/participant/application/submit-work")
    @Transactional
    public String submitWork(@RequestParam Integer applicationId, @RequestParam String submissionUrl, @RequestParam String submissionDescription, @RequestParam(required = false) String frontendGithubLink, @RequestParam(required = false) String backendGithubLink, HttpSession session) {
        UserEntity currentUser = SessionUserUtil.getCurrentUser(session);       
        if (currentUser == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        Optional<HackathonApplicationEntity> opApp = hackathonApplicationRepository.findById(applicationId);
        if (opApp.isEmpty()) {
            return "redirect:/participant/my-applications?msg=Application+not+found&type=error";
        }

        HackathonApplicationEntity app = opApp.get();
        if (!currentUser.getUserId().equals(app.getParticipantUserId())) {
            return "redirect:/participant/my-applications?msg=Unauthorized+application+update&type=error";
        }

        app.setSubmissionUrl(submissionUrl == null ? null : submissionUrl.trim());
        app.setSubmissionDescription(submissionDescription == null ? null : submissionDescription.trim());
        app.setFrontendGithubLink(frontendGithubLink == null || frontendGithubLink.isBlank() ? null : frontendGithubLink.trim());
        app.setBackendGithubLink(backendGithubLink == null || backendGithubLink.isBlank() ? null : backendGithubLink.trim());
        hackathonApplicationRepository.save(app);
        
        return "redirect:/participant/my-applications?msg=Work+submitted+successfully&type=success";
    }
}

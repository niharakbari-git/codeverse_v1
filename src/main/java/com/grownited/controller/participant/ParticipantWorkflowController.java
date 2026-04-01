package com.grownited.controller.participant;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.common.AppConstants;
import com.grownited.dto.ParticipantApplicationView;
import com.grownited.dto.ParticipantTeamView;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonRepository;
import com.grownited.service.ParticipantTeamService;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class ParticipantWorkflowController {

    @Autowired
    HackathonRepository hackathonRepository;

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
}

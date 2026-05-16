package com.grownited.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.common.AppConstants;
import com.grownited.entity.HackathonEntity;
import com.grownited.service.ScoreboardService;
import com.grownited.service.ScoreboardService.ScoreboardEntry;
import com.grownited.util.HackathonStatusUtil;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class ScoreboardController {

    @Autowired
    com.grownited.repository.HackathonRepository hackathonRepository;

    @Autowired
    ScoreboardService scoreboardService;

    @GetMapping("/results/history")
    public String completedHackathons(HttpSession session, Model model) {
        if (SessionUserUtil.getCurrentUser(session) == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        List<HackathonEntity> completed = hackathonRepository.findByStatusOrderByHackathonIdDesc("COMPLETED");
        model.addAttribute("completedHackathons", completed);
        return "results/CompletedHackathons";
    }

    @GetMapping("/results/scoreboard")
    public String scoreboard(@RequestParam Integer hackathonId, HttpSession session, Model model) {
        if (SessionUserUtil.getCurrentUser(session) == null) {
            return AppConstants.REDIRECT_LOGIN;
        }

        HackathonEntity h = hackathonRepository.findById(hackathonId).orElse(null);
        if (h == null) {
            model.addAttribute("msg", "Hackathon not found");
            model.addAttribute("msgType", "error");
            return "results/Scoreboard";
        }

        // ensure hackathon is completed (or allow organizers/admins/judges/organizer owner to view regardless)
        boolean isCompleted = "COMPLETED".equalsIgnoreCase(h.getStatus()) || HackathonStatusUtil.isExpired(h, null);

        // role-based access: allow admin and organizer and judges to view even if not completed
        var currentUser = SessionUserUtil.getCurrentUser(session);
        String role = SessionUserUtil.getNormalizedRole(currentUser);
        boolean allowedWhenNotCompleted = "ADMIN".equals(role) || "ORGANIZER".equals(role) || "JUDGE".equals(role);

        if (!isCompleted && !allowedWhenNotCompleted) {
            model.addAttribute("msg", "Results are not available until the hackathon is completed.");
            model.addAttribute("msgType", "error");
            return "results/Scoreboard";
        }

        model.addAttribute("hackathon", h);
        List<ScoreboardEntry> entries = scoreboardService.getScoreboardForHackathon(hackathonId);
        model.addAttribute("scoreboard", entries);
        model.addAttribute("isCompleted", isCompleted);

        return "results/Scoreboard";
    }
}

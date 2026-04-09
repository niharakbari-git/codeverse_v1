package com.grownited.controller;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.grownited.common.AppConstants;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.UserRepository;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {

	@Autowired
	HackathonRepository hackathonRepository;

	@Autowired
	UserRepository userRepository;

	@Autowired
	HackathonApplicationRepository hackathonApplicationRepository;

	@GetMapping(value = { "admin-dashboard", "/" })
	public String adminDashboard(Model model) {

	 

			long totalHackathon = hackathonRepository.count();
			long totalUpcoming = hackathonRepository.countByStatus("UPCOMING");
			long totalCompleted = hackathonRepository.countByStatus("COMPLETED");
			long totalParticipant = userRepository.countByRole("PARTICIPANT");

			model.addAttribute("totalHackathon", totalHackathon);
			model.addAttribute("totalUpcoming", totalUpcoming);
			model.addAttribute("totalCompleted", totalCompleted);
			model.addAttribute("totalParticipant", totalParticipant);

			return "AdminDashboard";
	 
	}

	@GetMapping("organizer-dashboard")
	public String organizerDashboard(Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		List<HackathonEntity> myHackathons = hackathonRepository.findByUserId(currentUser.getUserId());
		long totalHackathon = myHackathons.size();
		long totalUpcoming = myHackathons.stream().filter(h -> "UPCOMING".equalsIgnoreCase(h.getStatus())).count();
		long totalCompleted = myHackathons.stream().filter(h -> "COMPLETED".equalsIgnoreCase(h.getStatus())).count();

		Set<Integer> uniqueParticipants = new HashSet<>();
		for (HackathonEntity hackathon : myHackathons) {
			List<HackathonApplicationEntity> apps = hackathonApplicationRepository.findByHackathonId(hackathon.getHackathonId());
			for (HackathonApplicationEntity app : apps) {
				if (app.getParticipantUserId() != null) {
					uniqueParticipants.add(app.getParticipantUserId());
				}
			}
		}

		model.addAttribute("totalHackathon", totalHackathon);
		model.addAttribute("totalUpcoming", totalUpcoming);
		model.addAttribute("totalCompleted", totalCompleted);
		model.addAttribute("totalParticipant", uniqueParticipants.size());

		return "AdminDashboard";
	}

}

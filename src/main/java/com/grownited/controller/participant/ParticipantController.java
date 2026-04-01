package com.grownited.controller.participant;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;

import java.util.Optional;

import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.UserDetailRepository;

import jakarta.servlet.http.HttpSession;



@Controller
public class ParticipantController {

	@Autowired
	HackathonRepository hackathonRepository; 

	@Autowired
	HackathonApplicationRepository hackathonApplicationRepository;

	@Autowired
	UserDetailRepository userDetailRepository;
	
	@GetMapping("/participant/participant-dashboard")
	public String participantDashboard(Model model) {
		model.addAttribute("totalHackathons", hackathonRepository.count());
		model.addAttribute("liveHackathons", hackathonRepository.countByStatus("ONGOING"));
		model.addAttribute("freeHackathons", hackathonRepository.countByPayment("FREE"));
		model.addAttribute("paidHackathons", hackathonRepository.countByPayment("PAID"));
		return "participant/ParticipantDashboard";
	}
	
	@GetMapping("participant/home")
	public String home( Model model) {
		model.addAttribute("hackathons",hackathonRepository.findAll()); 
		return   "participant/Home";
	}

	@GetMapping("/participant/profile")
	public String profile(HttpSession session, Model model) {
		UserEntity currentUser = (UserEntity) session.getAttribute("user");
		if (currentUser == null) {
			return "redirect:/login";
		}

		Optional<UserDetailEntity> opUserDetail = userDetailRepository.findByUserId(currentUser.getUserId());
		model.addAttribute("profileUser", currentUser);
		model.addAttribute("profileUserDetail", opUserDetail.orElse(null));
		return "participant/Profile";
	}

	@GetMapping("/participant/hackathon/{hackathonId}")
	public String viewHackathonDetails(@PathVariable Integer hackathonId, Model model, HttpSession session) {
		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/participant/home";
		}

		UserEntity currentUser = (UserEntity) session.getAttribute("user");
		boolean hasApplied = false;
		if (currentUser != null) {
			hasApplied = hackathonApplicationRepository.existsByHackathonIdAndParticipantUserId(hackathonId,
					currentUser.getUserId());
		}

		model.addAttribute("hackathon", opHackathon.get());
		model.addAttribute("hasApplied", hasApplied);
		return "participant/HackathonDetails";
	}
	
	
}

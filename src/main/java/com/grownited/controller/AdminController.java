package com.grownited.controller;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.common.AppConstants;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.OrganizerOnboardingRequestEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.UserRepository;
import com.grownited.service.OrganizerOnboardingService;
import com.grownited.util.HackathonStatusUtil;
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

	@Autowired
	OrganizerOnboardingService organizerOnboardingService;

	@GetMapping("admin-dashboard")
	public String adminDashboard(@RequestParam(required = false, defaultValue = "ALL") String status, Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		if (!AppConstants.ROLE_ADMIN.equalsIgnoreCase(SessionUserUtil.getNormalizedRole(currentUser))) {
			return resolveHomeRedirect(currentUser);
		}

		List<HackathonEntity> hackathons = hackathonRepository.findAllByOrderByHackathonIdDesc();
		decorateStatuses(hackathons);
		String normalizedStatus = normalizeStatus(status);
		long totalHackathon = hackathons.size();
		long totalUpcoming = countByStatus(hackathons, "UPCOMING");
		long totalOngoing = countByStatus(hackathons, "ONGOING");
		long totalCompleted = countByStatus(hackathons, "COMPLETED");
		long totalParticipant = userRepository.countByRole("PARTICIPANT");
		List<HackathonEntity> dashboardHackathons = filterByStatus(hackathons, normalizedStatus);

		model.addAttribute("totalHackathon", totalHackathon);
		model.addAttribute("totalUpcoming", totalUpcoming);
		model.addAttribute("totalOngoing", totalOngoing);
		model.addAttribute("totalCompleted", totalCompleted);
		model.addAttribute("totalParticipant", totalParticipant);
		model.addAttribute("selectedStatus", normalizedStatus);
		model.addAttribute("dashboardHackathons", dashboardHackathons);
		model.addAttribute("allDashboardHackathons", hackathons);
		model.addAttribute("dashboardHackathonCount", dashboardHackathons.size());

		return "AdminDashboard";
	}

	@GetMapping("/")
	public String homeRedirect(HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		return resolveHomeRedirect(currentUser);
	}

	@GetMapping("organizer-dashboard")
	public String organizerDashboard(@RequestParam(required = false, defaultValue = "ALL") String status, Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		List<HackathonEntity> myHackathons = hackathonRepository.findByUserIdOrderByHackathonIdDesc(currentUser.getUserId());
		decorateStatuses(myHackathons);
		String normalizedStatus = normalizeStatus(status);
		long totalHackathon = myHackathons.size();
		long totalUpcoming = countByStatus(myHackathons, "UPCOMING");
		long totalOngoing = countByStatus(myHackathons, "ONGOING");
		long totalCompleted = countByStatus(myHackathons, "COMPLETED");
		List<HackathonEntity> dashboardHackathons = filterByStatus(myHackathons, normalizedStatus);

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
		model.addAttribute("totalOngoing", totalOngoing);
		model.addAttribute("totalCompleted", totalCompleted);
		model.addAttribute("totalParticipant", uniqueParticipants.size());
		model.addAttribute("selectedStatus", normalizedStatus);
		model.addAttribute("dashboardHackathons", dashboardHackathons);
		model.addAttribute("allDashboardHackathons", myHackathons);
		model.addAttribute("dashboardHackathonCount", dashboardHackathons.size());

		return "AdminDashboard";
	}

	private void decorateStatuses(List<HackathonEntity> hackathons) {
		LocalDate today = LocalDate.now();
		for (HackathonEntity hackathon : hackathons) {
			hackathon.setDisplayStatus(HackathonStatusUtil.resolveStatus(hackathon, today));
		}
	}

	private long countByStatus(List<HackathonEntity> hackathons, String status) {
		return hackathons.stream().filter(h -> status.equalsIgnoreCase(h.getDisplayStatus())).count();
	}

	private String normalizeStatus(String status) {
		if (status == null || status.isBlank()) {
			return "ALL";
		}
		String normalized = status.trim().toUpperCase();
		if ("UPCOMING".equals(normalized) || "ONGOING".equals(normalized) || "COMPLETED".equals(normalized)) {
			return normalized;
		}
		return "ALL";
	}

	private List<HackathonEntity> filterByStatus(List<HackathonEntity> hackathons, String status) {
		if ("ALL".equals(status)) {
			return hackathons;
		}
		return hackathons.stream().filter(h -> status.equalsIgnoreCase(h.getDisplayStatus())).toList();
	}

	private String resolveHomeRedirect(UserEntity currentUser) {
		String role = SessionUserUtil.getNormalizedRole(currentUser);
		if (AppConstants.ROLE_ADMIN.equals(role)) {
			return "redirect:/admin-dashboard";
		}
		if (AppConstants.ROLE_ORGANIZER.equals(role)) {
			return "redirect:/organizer-dashboard";
		}
		if (AppConstants.ROLE_JUDGE.equals(role)) {
			return "redirect:/judge-dashboard";
		}
		return AppConstants.REDIRECT_PARTICIPANT_HOME;
	}

	@GetMapping("admin/organizer-requests")
	public String organizerRequests(@RequestParam(required = false, defaultValue = "ALL") String status, Model model) {
		List<OrganizerOnboardingRequestEntity> requests = organizerOnboardingService.listRequests(status);
		model.addAttribute("requests", requests);
		model.addAttribute("selectedStatus", status == null ? "ALL" : status.trim().toUpperCase());
		model.addAttribute("pendingCount", organizerOnboardingService.countByStatus(OrganizerOnboardingService.STATUS_PENDING));
		model.addAttribute("approvedCount", organizerOnboardingService.countByStatus(OrganizerOnboardingService.STATUS_APPROVED));
		model.addAttribute("rejectedCount", organizerOnboardingService.countByStatus(OrganizerOnboardingService.STATUS_REJECTED));
		return "AdminOrganizerRequests";
	}

	@PostMapping("admin/organizer-requests/approve")
	public String approveOrganizerRequest(Integer requestId, String reviewNotes, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		OrganizerOnboardingService.ActionResult result = organizerOnboardingService.approveRequest(requestId,
				currentUser.getUserId(), reviewNotes);
		String type = result.isSuccessful() ? "success" : "error";
		return "redirect:/admin/organizer-requests?msg=" + result.getMessage().replace(" ", "+") + "&type=" + type;
	}

	@PostMapping("admin/organizer-requests/reject")
	public String rejectOrganizerRequest(Integer requestId, String reviewNotes, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		OrganizerOnboardingService.ActionResult result = organizerOnboardingService.rejectRequest(requestId,
				currentUser.getUserId(), reviewNotes);
		String type = result.isSuccessful() ? "success" : "error";
		return "redirect:/admin/organizer-requests?msg=" + result.getMessage().replace(" ", "+") + "&type=" + type;
	}

}

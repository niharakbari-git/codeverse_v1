package com.grownited.controller.participant;

import java.time.LocalDate;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.grownited.common.AppConstants;
import com.grownited.dto.ParticipantApplicationView;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.service.AuthService;
import com.grownited.service.ParticipantTeamService;
import com.grownited.util.HackathonStatusUtil;
import com.grownited.util.SessionUserUtil;

import java.util.Optional;

import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;

import jakarta.servlet.http.HttpSession;



@Controller
public class ParticipantController {

	@Autowired
	HackathonRepository hackathonRepository; 

	@Autowired
	HackathonApplicationRepository hackathonApplicationRepository;

	@Autowired
	UserDetailRepository userDetailRepository;

	@Autowired
	AuthService authService;

	@Autowired
	ParticipantTeamService participantTeamService;

	@Autowired
	UserRepository userRepository;
	
	@GetMapping("/participant/participant-dashboard")
	public String participantDashboard(Model model, HttpSession session) {
		List<HackathonEntity> visibleHackathons = getVisibleHackathons();
		model.addAttribute("totalHackathons", visibleHackathons.size());
		model.addAttribute("liveHackathons", countLiveHackathons(visibleHackathons));
		model.addAttribute("upcomingHackathons", countUpcomingHackathons(visibleHackathons));
		model.addAttribute("freeHackathons", countPaymentHackathons(visibleHackathons, "FREE"));
		model.addAttribute("paidHackathons", countPaymentHackathons(visibleHackathons, "PAID"));
		model.addAttribute("selectedView", "ALL");
		
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser != null) {
			List<ParticipantApplicationView> myApps = participantTeamService.getMyApplications(currentUser.getUserId());
			Map<String, Long> stats = calculateApplicationStats(myApps);
			model.addAttribute("applicationStats", stats);
		} else {
			model.addAttribute("applicationStats", new HashMap<>());
		}
		
		return "participant/ParticipantDashboard";
	}
	
	@GetMapping({"/participant/home", "participant/home", "/participant/home/"})
	public String home(@org.springframework.web.bind.annotation.RequestParam(required = false, defaultValue = "all") String view,
			Model model) {
		List<HackathonEntity> visibleHackathons = getVisibleHackathons();
		List<HackathonEntity> filteredHackathons = filterHackathonsByView(visibleHackathons, view);
		model.addAttribute("hackathons", filteredHackathons);
		model.addAttribute("totalHackathons", visibleHackathons.size());
		model.addAttribute("liveHackathons", countLiveHackathons(visibleHackathons));
		model.addAttribute("upcomingHackathons", countUpcomingHackathons(visibleHackathons));
		model.addAttribute("freeHackathons", countPaymentHackathons(visibleHackathons, "FREE"));
		model.addAttribute("paidHackathons", countPaymentHackathons(visibleHackathons, "PAID"));
		model.addAttribute("selectedView", normalizeView(view));
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

	@PostMapping("/participant/profile/change-pfp")
	public String changeProfilePicture(MultipartFile profilePic, HttpSession session) {
		UserEntity currentUser = (UserEntity) session.getAttribute(AppConstants.SESSION_USER);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		AuthService.ProfilePictureUpdateResult result = authService.updateProfilePicture(currentUser.getUserId(), profilePic);
		if (result.isSuccessful()) {
			session.setAttribute(AppConstants.SESSION_USER, result.getUpdatedUser());
			return "redirect:/participant/profile?msg=Profile+picture+updated+successfully&type=success";
		}
		return "redirect:/participant/profile?msg=" + result.getMessage().replace(" ", "+") + "&type=error";
	}

	@PostMapping("/participant/profile/remove-pfp")
	public String removeProfilePicture(HttpSession session) {
		UserEntity currentUser = (UserEntity) session.getAttribute(AppConstants.SESSION_USER);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		AuthService.ProfilePictureUpdateResult result = authService.removeProfilePicture(currentUser.getUserId());
		if (result.isSuccessful()) {
			session.setAttribute(AppConstants.SESSION_USER, result.getUpdatedUser());
			return "redirect:/participant/profile?msg=Profile+picture+removed+successfully&type=success";
		}
		return "redirect:/participant/profile?msg=" + result.getMessage().replace(" ", "+") + "&type=error";
	}

	@PostMapping("/participant/profile/change-password")
	public String changePassword(String currentPassword, String newPassword, String confirmPassword, HttpSession session) {
		UserEntity currentUser = (UserEntity) session.getAttribute(AppConstants.SESSION_USER);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		String error = authService.changePassword(currentUser.getUserId(), currentPassword, newPassword, confirmPassword);
		if (error == null) {
			return "redirect:/participant/profile?msg=Password+changed+successfully&type=success";
		}
		return "redirect:/participant/profile?msg=" + error.replace(" ", "+") + "&type=error";
	}

	@PostMapping("/participant/profile/update-details")
	public String updateProfileDetails(String firstName, String lastName, String email, String gender, String birthYear,
			String contactNum, String qualification, String city, String state, String country,
			String linkedinUrl, HttpSession session) {
		UserEntity currentUser = (UserEntity) session.getAttribute(AppConstants.SESSION_USER);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		String normalizedEmail = trimToNull(email);
		if (normalizedEmail == null) {
			return "redirect:/participant/profile?msg=Email+is+required&type=error";
		}

		Optional<UserEntity> existingUser = userRepository.findByEmail(normalizedEmail);
		if (existingUser.isPresent() && !existingUser.get().getUserId().equals(currentUser.getUserId())) {
			return "redirect:/participant/profile?msg=Email+already+exists.+Use+another+email&type=error";
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
		return "redirect:/participant/profile?msg=Profile+updated+successfully&type=success";
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

		HackathonEntity hackathon = opHackathon.get();
		hackathon.setDisplayStatus(HackathonStatusUtil.resolveStatus(hackathon, LocalDate.now()));
		model.addAttribute("hackathon", hackathon);
		model.addAttribute("hasApplied", hasApplied);
		boolean isExpired = HackathonStatusUtil.isExpired(hackathon, LocalDate.now());
		model.addAttribute("isExpired", isExpired);
		return "participant/HackathonDetails";
	}

	private List<HackathonEntity> getVisibleHackathons() {
		LocalDate today = LocalDate.now();
		List<HackathonEntity> hackathons = hackathonRepository.findAllByOrderByHackathonIdDesc();
		for (HackathonEntity hackathon : hackathons) {
			hackathon.setDisplayStatus(HackathonStatusUtil.resolveStatus(hackathon, today));
		}
		return hackathons.stream().filter(h -> !HackathonStatusUtil.isExpired(h, today)).toList();
	}

	private List<HackathonEntity> filterHackathonsByView(List<HackathonEntity> hackathons, String view) {
		String normalizedView = normalizeView(view);
		if ("LIVE".equals(normalizedView)) {
			return hackathons.stream().filter(h -> HackathonStatusUtil.isLive(h, LocalDate.now())).toList();
		}
		if ("UPCOMING".equals(normalizedView)) {
			return hackathons.stream().filter(h -> HackathonStatusUtil.isUpcoming(h, LocalDate.now())).toList();
		}
		if ("FREE".equals(normalizedView)) {
			return hackathons.stream().filter(h -> "FREE".equalsIgnoreCase(h.getPayment())).toList();
		}
		if ("PAID".equals(normalizedView)) {
			return hackathons.stream().filter(h -> "PAID".equalsIgnoreCase(h.getPayment())).toList();
		}
		return hackathons;
	}

	private String normalizeView(String view) {
		if (view == null || view.isBlank()) {
			return "ALL";
		}
		String normalized = view.trim().toUpperCase();
		if ("SOON".equals(normalized)) {
			return "UPCOMING";
		}
		return normalized;
	}

	private long countLiveHackathons(List<HackathonEntity> hackathons) {
		return hackathons.stream().filter(h -> HackathonStatusUtil.isLive(h, LocalDate.now())).count();
	}

	private long countUpcomingHackathons(List<HackathonEntity> hackathons) {
		return hackathons.stream().filter(h -> HackathonStatusUtil.isUpcoming(h, LocalDate.now())).count();
	}

	private long countPaymentHackathons(List<HackathonEntity> hackathons, String payment) {
		return hackathons.stream().filter(h -> payment.equalsIgnoreCase(h.getPayment())).count();
	}

	private Map<String, Long> calculateApplicationStats(List<ParticipantApplicationView> applications) {
		Map<String, Long> stats = new HashMap<>();
		stats.put("applied", applications.stream().filter(a -> "APPLIED".equals(a.getApplication().getStatus())).count());
		stats.put("approved", applications.stream().filter(a -> "APPROVED".equals(a.getApplication().getStatus())).count());
		stats.put("submitted", applications.stream().filter(a -> "SUBMITTED".equals(a.getApplication().getStatus())).count());
		stats.put("scored", applications.stream().filter(a -> "SCORED".equals(a.getApplication().getStatus())).count());
		return stats;
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
	
	
}

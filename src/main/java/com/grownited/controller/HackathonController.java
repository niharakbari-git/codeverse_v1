package com.grownited.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.common.AppConstants;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.UserDetailRepository;
import com.grownited.service.HackathonValidationService;
import com.grownited.util.HackathonStatusUtil;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;


@Controller
public class HackathonController {

	@Autowired
	HackathonRepository hackathonRepository;

	@Autowired
	UserDetailRepository userDetailRepository;

	@Autowired
	HackathonValidationService hackathonValidationService;

	@Autowired
	com.grownited.service.OrganizerOnboardingService organizerOnboardingService;
	
	@GetMapping("newHackathon")
	public String newHackathon(Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}
		if (AppConstants.ROLE_ORGANIZER.equalsIgnoreCase(currentUser.getRole())
				&& !organizerOnboardingService.isApprovedOrganizer(currentUser.getUserId())) {
			return "redirect:/organizer-dashboard?msg=Your+organizer+account+is+not+approved+yet.+Please+wait+for+admin+approval.&type=error";
		}
		model.addAttribute("hackathon", new HackathonEntity());
		return "NewHackathon";
	}
	
	@PostMapping("saveHackathon")
	public String saveHackathon(HackathonEntity hackathonEntity,HttpSession session) {
		UserEntity currentLogInUser = SessionUserUtil.getCurrentUser(session);
		if (currentLogInUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}
		if (AppConstants.ROLE_ORGANIZER.equalsIgnoreCase(currentLogInUser.getRole())
				&& !organizerOnboardingService.isApprovedOrganizer(currentLogInUser.getUserId())) {
			return "redirect:/organizer-dashboard?msg=Your+organizer+account+is+not+approved+yet.+Please+wait+for+admin+approval.&type=error";
		}

		if (!isValidHackathonInput(hackathonEntity)) {
			return "redirect:/newHackathon?msg=Please+check+hackathon+details&type=error";
		}

		normalizeHackathonFields(hackathonEntity);
		if (hackathonEntity.getGracePeriodHours() == null || hackathonEntity.getGracePeriodHours() < 0) {
			hackathonEntity.setGracePeriodHours(0);
		}
		normalizeEntryFeeAmount(hackathonEntity);

		if (hackathonEntity.getHackathonId() != null) {
			Optional<HackathonEntity> existingHackathon = hackathonRepository.findById(hackathonEntity.getHackathonId());
			if (existingHackathon.isPresent()) {
				if (!canManageHackathon(currentLogInUser, existingHackathon.get())) {
					return "redirect:/listHackathon?msg=You+can+edit+only+your+hackathons&type=error";
				}
				hackathonEntity.setUserId(existingHackathon.get().getUserId());
				hackathonEntity.setUserTypeId(existingHackathon.get().getUserTypeId());
			} else {
				return "redirect:/listHackathon?msg=Hackathon+not+found&type=error";
			}
		}

		if (hackathonEntity.getUserId() == null) {
			hackathonEntity.setUserId(currentLogInUser.getUserId());
		}

		if (hackathonEntity.getUserTypeId() == null) {
			hackathonEntity.setUserTypeId(userDetailRepository.findByUserId(currentLogInUser.getUserId())
					.map(detail -> detail.getUserTypeId())
					.orElse(null));
		}

		try {
			hackathonRepository.save(hackathonEntity);
		} catch (DataIntegrityViolationException ex) {
			return "redirect:/newHackathon?msg=Unable+to+save+hackathon.+Please+check+all+required+fields&type=error";
		}
		return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
	}

	@GetMapping("listHackathon")
	public String listHackathon(@org.springframework.web.bind.annotation.RequestParam(required = false) String status,
			@org.springframework.web.bind.annotation.RequestParam(required = false) String payment, Model model,
			HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		List<HackathonEntity> allHackathons;
		if (AppConstants.ROLE_ORGANIZER.equalsIgnoreCase(currentUser.getRole())) {
			allHackathons = hackathonRepository.findByUserIdOrderByHackathonIdDesc(currentUser.getUserId());
		} else {
			allHackathons =  hackathonRepository.findAllByOrderByHackathonIdDesc();
		}

		decorateStatuses(allHackathons);
		String normalizedStatus = normalizeFilter(status);
		String normalizedPayment = normalizeFilter(payment);
		List<HackathonEntity> filteredHackathons = allHackathons.stream()
				.filter(h -> matchesStatusFilter(h, normalizedStatus))
				.filter(h -> matchesPaymentFilter(h, normalizedPayment))
				.toList();

		long totalCount = allHackathons.size();
		long upcomingCount = countByStatus(allHackathons, "UPCOMING");
		long ongoingCount = countByStatus(allHackathons, "ONGOING");
		long completedCount = countByStatus(allHackathons, "COMPLETED");

		model.addAttribute("hackathons", filteredHackathons);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("upcomingCount", upcomingCount);
		model.addAttribute("ongoingCount", ongoingCount);
		model.addAttribute("completedCount", completedCount);
		model.addAttribute("selectedStatus", normalizedStatus == null ? "ALL" : normalizedStatus);
		model.addAttribute("selectedPayment", normalizedPayment == null ? "ALL" : normalizedPayment);
		return "ListHackathon";
	}
	
	@GetMapping("deleteHackathon")
	public String deleteHackathon(Integer hackathonId, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		if (hackathonId == null) {
			return "redirect:/listHackathon";
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/listHackathon?msg=Hackathon+not+found&type=error";
		}

		if (!canManageHackathon(currentUser, opHackathon.get())) {
			return "redirect:/listHackathon?msg=You+can+delete+only+your+hackathons&type=error";
		}

		hackathonRepository.deleteById(hackathonId);
		
		return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
	}

	@GetMapping("editHackathon")
	public String editHackathon(@RequestParam Integer hackathonId, Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/listHackathon";
		}
		if (!canManageHackathon(currentUser, opHackathon.get())) {
			return "redirect:/listHackathon?msg=You+can+edit+only+your+hackathons&type=error";
		}

		model.addAttribute("hackathon", opHackathon.get());
		return "NewHackathon";
	}

	@GetMapping("viewHackathon")
	public String viewHackathon(@RequestParam Integer hackathonId, Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/listHackathon";
		}
		if (!canManageHackathon(currentUser, opHackathon.get())) {
			return "redirect:/listHackathon?msg=You+can+view+only+your+hackathons&type=error";
		}

		model.addAttribute("hackathon", opHackathon.get());
		return "ViewHackathon";
	}

	private boolean canManageHackathon(UserEntity currentUser, HackathonEntity hackathon) {
		if (currentUser == null || hackathon == null) {
			return false;
		}
		if (AppConstants.ROLE_ADMIN.equalsIgnoreCase(currentUser.getRole())) {
			return true;
		}
		return hackathon.getUserId() != null && hackathon.getUserId().equals(currentUser.getUserId());
	}

	private void normalizeHackathonFields(HackathonEntity hackathonEntity) {
		hackathonEntity.setStatus(normalizeValue(hackathonEntity.getStatus()));
		hackathonEntity.setEventType(normalizeValue(hackathonEntity.getEventType()));
		hackathonEntity.setPayment(normalizeValue(hackathonEntity.getPayment()));
		normalizeEntryFeeAmount(hackathonEntity);
		hackathonEntity.setProblemTitle(trimValue(hackathonEntity.getProblemTitle()));
		hackathonEntity.setProblemStatement(trimValue(hackathonEntity.getProblemStatement()));
		hackathonEntity.setProblemConstraints(trimValue(hackathonEntity.getProblemConstraints()));
		hackathonEntity.setProblemDeliverables(trimValue(hackathonEntity.getProblemDeliverables()));
		hackathonEntity.setEvaluationCriteria(trimValue(hackathonEntity.getEvaluationCriteria()));
		hackathonEntity.setSubmissionChecklist(trimValue(hackathonEntity.getSubmissionChecklist()));

		if ("ONLINE".equals(hackathonEntity.getEventType())) {
			hackathonEntity.setLocation("Online");
		} else if (hackathonEntity.getLocation() != null) {
			hackathonEntity.setLocation(hackathonEntity.getLocation().trim());
		}
	}

	private String normalizeValue(String value) {
		return value == null ? null : value.trim().toUpperCase();
	}

	private String trimValue(String value) {
		return value == null ? null : value.trim();
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

	private String normalizeFilter(String value) {
		if (value == null || value.isBlank() || "ALL".equalsIgnoreCase(value)) {
			return null;
		}
		String normalized = value.trim().toUpperCase();
		if ("LIVE".equals(normalized)) {
			return "ONGOING";
		}
		return normalized;
	}

	private boolean matchesStatusFilter(HackathonEntity hackathon, String status) {
		if (status == null) {
			return true;
		}
		return status.equalsIgnoreCase(hackathon.getDisplayStatus());
	}

	private boolean matchesPaymentFilter(HackathonEntity hackathon, String payment) {
		if (payment == null) {
			return true;
		}
		return payment.equalsIgnoreCase(trimValue(hackathon.getPayment()));
	}

	private boolean isValidHackathonInput(HackathonEntity hackathonEntity) {
		if (hackathonEntity == null) {
			return false;
		}
		if (hackathonEntity.getTitle() == null || hackathonEntity.getTitle().isBlank()) {
			return false;
		}
		if (hackathonEntity.getDescription() == null || hackathonEntity.getDescription().isBlank()) {
			return false;
		}
		if (hackathonEntity.getMinTeamSize() == null || hackathonEntity.getMaxTeamSize() == null
				|| hackathonEntity.getMinTeamSize() <= 0 || hackathonEntity.getMaxTeamSize() <= 0
				|| hackathonEntity.getMinTeamSize() > hackathonEntity.getMaxTeamSize()) {
			return false;
		}
		if (hackathonEntity.getRegistrationStartDate() == null || hackathonEntity.getRegistrationEndDate() == null
				|| hackathonEntity.getRegistrationStartDate().isAfter(hackathonEntity.getRegistrationEndDate())) {
			return false;
		}
		if (hackathonEntity.getEventStartDate() != null && hackathonEntity.getEventEndDate() != null
				&& hackathonEntity.getEventStartDate().isAfter(hackathonEntity.getEventEndDate())) {
			return false;
		}
		if (hackathonEntity.getSubmissionDeadline() != null
				&& hackathonEntity.getSubmissionDeadline().isBefore(hackathonEntity.getRegistrationEndDate())) {
			return false;
		}

		String eventType = normalizeValue(hackathonEntity.getEventType());
		if (eventType == null || (!"ONLINE".equals(eventType) && !"OFFLINE".equals(eventType) && !"HYBRID".equals(eventType))) {
			return false;
		}

		if (!"ONLINE".equals(eventType)
				&& (hackathonEntity.getLocation() == null || hackathonEntity.getLocation().isBlank())) {
			return false;
		}

		String payment = normalizeValue(hackathonEntity.getPayment());
		if ("PAID".equals(payment) && (hackathonEntity.getEntryFeeAmount() == null || hackathonEntity.getEntryFeeAmount() <= 0)) {
			return false;
		}

		if (hackathonEntity.getProblemTitle() == null || hackathonEntity.getProblemTitle().isBlank()
				|| hackathonEntity.getProblemStatement() == null || hackathonEntity.getProblemStatement().isBlank()
				|| hackathonEntity.getProblemDeliverables() == null || hackathonEntity.getProblemDeliverables().isBlank()) {
			return false;
		}

		return hackathonValidationService.isValid(hackathonEntity);
	}

	private void normalizeEntryFeeAmount(HackathonEntity hackathonEntity) {
		if (hackathonEntity == null) {
			return;
		}
		String payment = normalizeValue(hackathonEntity.getPayment());
		if ("FREE".equals(payment)) {
			hackathonEntity.setEntryFeeAmount(0);
			return;
		}
		if (hackathonEntity.getEntryFeeAmount() == null || hackathonEntity.getEntryFeeAmount() <= 0) {
			hackathonEntity.setEntryFeeAmount((int) Math.round(AppConstants.HACKATHON_ENTRY_FEE_AMOUNT));
		}
	}
	
	

}

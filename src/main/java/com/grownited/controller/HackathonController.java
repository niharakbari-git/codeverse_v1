package com.grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.common.AppConstants;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonRepository;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;


@Controller
public class HackathonController {

	@Autowired
	HackathonRepository hackathonRepository;
	
	@GetMapping("newHackathon")
	public String newHackathon(Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
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

		if (!isValidHackathonInput(hackathonEntity)) {
			return "redirect:/newHackathon?msg=Please+check+hackathon+details&type=error";
		}

		normalizeHackathonFields(hackathonEntity);

		if (hackathonEntity.getHackathonId() != null) {
			Optional<HackathonEntity> existingHackathon = hackathonRepository.findById(hackathonEntity.getHackathonId());
			if (existingHackathon.isPresent()) {
				if (!canManageHackathon(currentLogInUser, existingHackathon.get())) {
					return "redirect:/listHackathon?msg=You+can+edit+only+your+hackathons&type=error";
				}
				hackathonEntity.setUserId(existingHackathon.get().getUserId());
			} else {
				return "redirect:/listHackathon?msg=Hackathon+not+found&type=error";
			}
		}

		if (hackathonEntity.getUserId() == null) {
			hackathonEntity.setUserId(currentLogInUser.getUserId());
		}

		hackathonEntity.setUserTypeId(null);

		hackathonRepository.save(hackathonEntity);
		return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
	}

	@GetMapping("listHackathon")
	public String listHackathon(Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		List<HackathonEntity> allHackthon;
		if (AppConstants.ROLE_ORGANIZER.equalsIgnoreCase(currentUser.getRole())) {
			allHackthon = hackathonRepository.findByUserId(currentUser.getUserId());
		} else {
			allHackthon =  hackathonRepository.findAll();
		}
		model.addAttribute("allHackthon",allHackthon);
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

		if ("ONLINE".equals(hackathonEntity.getEventType())) {
			hackathonEntity.setLocation("Online");
		} else if (hackathonEntity.getLocation() != null) {
			hackathonEntity.setLocation(hackathonEntity.getLocation().trim());
		}
	}

	private String normalizeValue(String value) {
		return value == null ? null : value.trim().toUpperCase();
	}

	private boolean isValidHackathonInput(HackathonEntity hackathonEntity) {
		if (hackathonEntity == null) {
			return false;
		}
		if (hackathonEntity.getTitle() == null || hackathonEntity.getTitle().isBlank()) {
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

		String eventType = normalizeValue(hackathonEntity.getEventType());
		if (eventType == null || (!"ONLINE".equals(eventType) && !"OFFLINE".equals(eventType) && !"HYBRID".equals(eventType))) {
			return false;
		}

		if (!"ONLINE".equals(eventType)
				&& (hackathonEntity.getLocation() == null || hackathonEntity.getLocation().isBlank())) {
			return false;
		}

		return true;
	}
	
	

}

package com.grownited.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.grownited.common.AppConstants;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.OrganizerOnboardingRequestEntity;
import com.grownited.entity.TeamEntity;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.JudgeAssignmentRepository;
import com.grownited.repository.JudgeScoreRepository;
import com.grownited.repository.NotificationLogRepository;
import com.grownited.repository.OrganizerOnboardingRequestRepository;
import com.grownited.repository.PaymentTransactionRepository;
import com.grownited.repository.SubmissionVersionRepository;
import com.grownited.repository.TeamMemberRepository;
import com.grownited.repository.TeamRepository;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;
import com.grownited.repository.UserTypeRepository;

@Controller
public class UserController {

	@Autowired
	UserRepository userRepository;

	@Autowired
	UserDetailRepository userDetailRepository;

	@Autowired
	UserTypeRepository userTypeRepository;

	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	HackathonRepository hackathonRepository;

	@Autowired
	HackathonApplicationRepository hackathonApplicationRepository;

	@Autowired
	TeamRepository teamRepository;

	@Autowired
	TeamMemberRepository teamMemberRepository;

	@Autowired
	JudgeAssignmentRepository judgeAssignmentRepository;

	@Autowired
	JudgeScoreRepository judgeScoreRepository;

	@Autowired
	NotificationLogRepository notificationLogRepository;

	@Autowired
	PaymentTransactionRepository paymentTransactionRepository;

	@Autowired
	SubmissionVersionRepository submissionVersionRepository;

	@Autowired
	OrganizerOnboardingRequestRepository organizerOnboardingRequestRepository;

	@GetMapping({"listUser", "/listUser"})
	public String listUser(@org.springframework.web.bind.annotation.RequestParam(required = false) String role,
			Model model) {

		String normalizedRole = normalizeRoleFilter(role);
		List<UserEntity> allUser = normalizedRole == null ? userRepository.findAllByOrderByUserIdDesc()
				: userRepository.findByRoleOrderByUserIdDesc(normalizedRole);
		model.addAttribute("users", allUser);
		model.addAttribute("userList", allUser);
		model.addAttribute("selectedRole", normalizedRole == null ? "ALL" : normalizedRole);
		model.addAttribute("totalUserCount", userRepository.count());
		model.addAttribute("adminCount", userRepository.countByRole(AppConstants.ROLE_ADMIN));
		model.addAttribute("organizerCount", userRepository.countByRole(AppConstants.ROLE_ORGANIZER));
		model.addAttribute("judgeCount", userRepository.countByRole(AppConstants.ROLE_JUDGE));
		model.addAttribute("participantCount", userRepository.countByRole(AppConstants.ROLE_PARTICIPANT));
		return "ListUser";
	}

	@GetMapping({"admin/user-list", "/admin/user-list"})
	public String adminUserList(@org.springframework.web.bind.annotation.RequestParam(required = false) String role,
			Model model) {
		return listUser(role, model);
	}

	@GetMapping("admin/user/new")
	public String newUser(Model model) {
		model.addAttribute("user", new UserEntity());
		model.addAttribute("userDetail", new UserDetailEntity());
		return "AdminNewUser";
	}

	@PostMapping("admin/user/save")
	public String saveUser(UserEntity userEntity, UserDetailEntity userDetailEntity) {
		if (userEntity.getEmail() == null || userEntity.getEmail().isBlank()) {
			return "redirect:/admin/user/new?msg=Email+is+required&type=error";
		}

		String normalizedEmail = userEntity.getEmail().trim();
		if (userRepository.findByEmail(normalizedEmail).isPresent()) {
			return "redirect:/admin/user/new?msg=Email+already+exists&type=error";
		}

		if (userEntity.getPassword() == null || userEntity.getPassword().isBlank()) {
			return "redirect:/admin/user/new?msg=Password+is+required&type=error";
		}

		String normalizedRole = normalizeAllowedRole(userEntity.getRole(), AppConstants.ROLE_PARTICIPANT);
		if (!AppConstants.isAllowedRole(normalizedRole)) {
			return "redirect:/admin/user/new?msg=Invalid+role+selected&type=error";
		}

		userEntity.setEmail(normalizedEmail);
		userEntity.setRole(normalizedRole);
		userEntity.setCreatedAt(LocalDate.now());
		userEntity.setActive(userEntity.getActive() != null ? userEntity.getActive() : true);
		userEntity.setPassword(passwordEncoder.encode(userEntity.getPassword()));
		userRepository.save(userEntity);

		UserDetailEntity detail = new UserDetailEntity();
		detail.setUserId(userEntity.getUserId());
		detail.setQualification(userDetailEntity.getQualification());
		detail.setCity(userDetailEntity.getCity());
		detail.setState(userDetailEntity.getState());
		detail.setCountry(userDetailEntity.getCountry());
		detail.setLinkedinUrl(userDetailEntity.getLinkedinUrl());

		if (AppConstants.ROLE_PARTICIPANT.equals(normalizedRole)) {
			Optional<Integer> participantTypeId = userTypeRepository.findByUserTypeIgnoreCase(AppConstants.ROLE_PARTICIPANT)
					.map(ut -> ut.getUserTypeId());
			detail.setUserTypeId(participantTypeId.orElse(null));
		} else {
			detail.setUserTypeId(null);
		}

		userDetailRepository.save(detail);
		return "redirect:/listUser?msg=User+created+successfully&type=success";
	}

	@GetMapping({"viewUser", "/viewUser", "admin/viewUser", "/admin/viewUser"})
	public String viewUser(Integer userId, Model model) {
		// read userId
		// select * from users where userId = rock?
		Optional<UserEntity> opUser = userRepository.findById(userId);// Optional
		Optional<UserDetailEntity> opUserDetail = userDetailRepository.findByUserId(userId);
		if (opUser.isEmpty()) {
			// error set
			// list redirect
			return "redirect:/listUser";
		} else {

			UserEntity userEntity = opUser.get();
			UserDetailEntity userDetailEntity = opUserDetail.orElseGet(UserDetailEntity::new);
			if (userDetailEntity.getUserId() == null) {
				userDetailEntity.setUserId(userEntity.getUserId());
			}

			model.addAttribute("user", userEntity);
			model.addAttribute("userDetail", userDetailEntity);
			return "ViewUser";
		}

	}

	@GetMapping({"editUser", "/editUser", "admin/editUser", "/admin/editUser"})
	public String editUser(Integer userId, Model model) {
		Optional<UserEntity> opUser = userRepository.findById(userId);
		if (opUser.isEmpty()) {
			return "redirect:/listUser";
		}

		UserEntity userEntity = opUser.get();
		UserDetailEntity userDetailEntity = userDetailRepository.findByUserId(userId).orElseGet(UserDetailEntity::new);
		if (userDetailEntity.getUserId() == null) {
			userDetailEntity.setUserId(userEntity.getUserId());
		}

		model.addAttribute("user", userEntity);
		model.addAttribute("userDetail", userDetailEntity);
		return "EditUser";
	}

	@PostMapping("updateUser")
	public String updateUser(UserEntity userEntity, UserDetailEntity userDetailEntity) {
		Optional<UserEntity> existingUserOp = userRepository.findById(userEntity.getUserId());
		if (existingUserOp.isEmpty()) {
			return "redirect:/listUser";
		}

		UserEntity existingUser = existingUserOp.get();
		String normalizedRole = normalizeAllowedRole(userEntity.getRole(), existingUser.getRole());
		existingUser.setFirstName(userEntity.getFirstName());
		existingUser.setLastName(userEntity.getLastName());
		existingUser.setEmail(userEntity.getEmail());
		existingUser.setRole(normalizedRole);
		existingUser.setGender(userEntity.getGender());
		existingUser.setBirthYear(userEntity.getBirthYear());
		existingUser.setContactNum(userEntity.getContactNum());
		existingUser.setActive(userEntity.getActive() != null ? userEntity.getActive() : existingUser.getActive());

		userRepository.save(existingUser);

		UserDetailEntity userDetail = userDetailRepository.findByUserId(existingUser.getUserId())
				.orElseGet(UserDetailEntity::new);
		userDetail.setUserId(existingUser.getUserId());
		userDetail.setQualification(userDetailEntity.getQualification());
		userDetail.setCity(userDetailEntity.getCity());
		userDetail.setState(userDetailEntity.getState());
		userDetail.setCountry(userDetailEntity.getCountry());
		userDetail.setLinkedinUrl(userDetailEntity.getLinkedinUrl());
		if (!AppConstants.ROLE_PARTICIPANT.equals(normalizedRole)) {
			userDetail.setUserTypeId(null);
		}

		userDetailRepository.save(userDetail);
		return "redirect:/listUser";
	}

	private String normalizeAllowedRole(String incomingRole, String fallbackRole) {
		if (incomingRole == null) {
			return fallbackRole;
		}

		String role = incomingRole.trim().toUpperCase();
		if (AppConstants.ROLE_ADMIN.equals(role)
				|| AppConstants.ROLE_PARTICIPANT.equals(role)
				|| AppConstants.ROLE_ORGANIZER.equals(role)
				|| AppConstants.ROLE_JUDGE.equals(role)) {
			return role;
		}

		return fallbackRole;
	}

	private String normalizeRoleFilter(String role) {
		if (role == null || role.isBlank() || "ALL".equalsIgnoreCase(role)) {
			return null;
		}

		String normalized = role.trim().toUpperCase();
		if (AppConstants.ROLE_ADMIN.equals(normalized)
				|| AppConstants.ROLE_PARTICIPANT.equals(normalized)
				|| AppConstants.ROLE_ORGANIZER.equals(normalized)
				|| AppConstants.ROLE_JUDGE.equals(normalized)) {
			return normalized;
		}
		return null;
	}

	@GetMapping({"deleteUser", "/deleteUser", "admin/deleteUser", "/admin/deleteUser"})
	@Transactional
	public String deleteUser(Integer userId, RedirectAttributes redirectAttributes) {
		if (userId == null) {
			return "redirect:/listUser";
		}

		Optional<UserEntity> existingUser = userRepository.findById(userId);
		if (existingUser.isEmpty()) {
			redirectAttributes.addAttribute("msg", "User not found.");
			redirectAttributes.addAttribute("type", "error");
			return "redirect:/listUser";
		}

		UserEntity user = existingUser.get();
		try {
			removeUserDependencies(user);
			userRepository.deleteById(userId);
			redirectAttributes.addAttribute("msg", "User deleted permanently.");
			redirectAttributes.addAttribute("type", "success");
		} catch (Exception ex) {
			redirectAttributes.addAttribute("msg", "Unable to delete user completely. " + ex.getMessage());
			redirectAttributes.addAttribute("type", "error");
		}
		return "redirect:/listUser";
	}

	private void removeUserDependencies(UserEntity user) {
		Integer userId = user.getUserId();

		notificationLogRepository.deleteByUserId(userId);
		teamMemberRepository.deleteByUserId(userId);

		deleteApplications(hackathonApplicationRepository.findByParticipantUserId(userId));

		for (TeamEntity team : teamRepository.findByLeaderUserId(userId)) {
			deleteTeamWithApplications(team.getTeamId());
		}

		for (HackathonEntity hackathon : hackathonRepository.findByUserId(userId)) {
			deleteHackathonWithDependencies(hackathon.getHackathonId());
		}

		judgeScoreRepository.deleteByJudgeUserId(userId);
		judgeAssignmentRepository.deleteByJudgeUserId(userId);

		organizerOnboardingRequestRepository.findByApprovedUserId(userId)
				.ifPresent(organizerOnboardingRequestRepository::delete);

		if (user.getEmail() != null && !user.getEmail().isBlank()) {
			organizerOnboardingRequestRepository.findByEmailIgnoreCase(user.getEmail())
					.ifPresent(organizerOnboardingRequestRepository::delete);
		}

		List<OrganizerOnboardingRequestEntity> reviewedByUser = organizerOnboardingRequestRepository
				.findByReviewedByUserId(userId);
		for (OrganizerOnboardingRequestEntity request : reviewedByUser) {
			request.setReviewedByUserId(null);
		}
		if (!reviewedByUser.isEmpty()) {
			organizerOnboardingRequestRepository.saveAll(reviewedByUser);
		}

		userDetailRepository.deleteByUserId(userId);
	}

	private void deleteHackathonWithDependencies(Integer hackathonId) {
		judgeAssignmentRepository.deleteByHackathonId(hackathonId);

		deleteApplications(hackathonApplicationRepository.findByHackathonId(hackathonId));

		for (TeamEntity team : teamRepository.findByHackathonId(hackathonId)) {
			deleteTeamWithApplications(team.getTeamId());
		}

		hackathonRepository.deleteById(hackathonId);
	}

	private void deleteTeamWithApplications(Integer teamId) {
		deleteApplications(hackathonApplicationRepository.findByTeamId(teamId));
		teamMemberRepository.deleteByTeamId(teamId);
		teamRepository.deleteById(teamId);
	}

	private void deleteApplications(List<HackathonApplicationEntity> applications) {
		for (HackathonApplicationEntity application : applications) {
			Integer applicationId = application.getApplicationId();
			submissionVersionRepository.deleteByApplicationId(applicationId);
			paymentTransactionRepository.deleteByApplicationId(applicationId);
			judgeScoreRepository.deleteByApplicationId(applicationId);
			hackathonApplicationRepository.deleteById(applicationId);
		}
	}

}

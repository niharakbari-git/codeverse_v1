package com.grownited.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.grownited.common.AppConstants;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
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

	@GetMapping("listUser")
	public String listUser(Model model) {

		List<UserEntity> allUser = userRepository.findAll();
		model.addAttribute("userList", allUser);
		return "ListUser";
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

	@GetMapping("viewUser")
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

	@GetMapping("editUser")
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

	@GetMapping("deleteUser")
	public String deleteUser(Integer userId) {
		if (userId == null) {
			return "redirect:/listUser";
		}

		userDetailRepository.deleteByUserId(userId);
		userRepository.deleteById(userId);
		return "redirect:/listUser";
	}

}

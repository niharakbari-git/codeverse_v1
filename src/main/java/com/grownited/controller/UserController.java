package com.grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.UserTypeEntity;
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

	@GetMapping("listUser")
	public String listUser(Model model) {

		List<UserEntity> allUser = userRepository.findAll();
		model.addAttribute("userList", allUser);
		return "ListUser";
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

		List<UserTypeEntity> allUserType = userTypeRepository.findAll();

		model.addAttribute("user", userEntity);
		model.addAttribute("userDetail", userDetailEntity);
		model.addAttribute("allUserType", allUserType);
		return "EditUser";
	}

	@PostMapping("updateUser")
	public String updateUser(UserEntity userEntity, UserDetailEntity userDetailEntity) {
		Optional<UserEntity> existingUserOp = userRepository.findById(userEntity.getUserId());
		if (existingUserOp.isEmpty()) {
			return "redirect:/listUser";
		}

		UserEntity existingUser = existingUserOp.get();
		existingUser.setFirstName(userEntity.getFirstName());
		existingUser.setLastName(userEntity.getLastName());
		existingUser.setEmail(userEntity.getEmail());
		existingUser.setRole(userEntity.getRole());
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
		userDetail.setUserTypeId(userDetailEntity.getUserTypeId());

		userDetailRepository.save(userDetail);
		return "redirect:/listUser";
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

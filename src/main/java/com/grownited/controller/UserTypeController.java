package com.grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.grownited.common.AppConstants;
import com.grownited.entity.UserTypeEntity;
import com.grownited.repository.UserTypeRepository;

//Logic			DB			?			? 
//Controller , Repository , Service , Component 
@Controller 
public class UserTypeController {

	//Singleton design pattern 
	@Autowired
	UserTypeRepository userTypeRepository;
	
	@GetMapping("newUserType")
	public String newUserType() {
		return "NewUserType";
	}
	
	@PostMapping("saveUserType")
	public String saveUserType(UserTypeEntity userTypeEntity) {
		String normalizedRole = AppConstants.normalizeRole(userTypeEntity.getUserType());
		if (!AppConstants.isAllowedRole(normalizedRole)) {
			return "redirect:/newUserType?error=Only+ADMIN%2C+ORGANIZER%2C+JUDGE+or+PARTICIPANT+is+allowed";
		}

		boolean alreadyExists = userTypeRepository.findAll().stream()
				.anyMatch(existing -> normalizedRole.equalsIgnoreCase(existing.getUserType()));
		if (!alreadyExists) {
			userTypeEntity.setUserType(normalizedRole);
			userTypeRepository.save(userTypeEntity);
		}

		return "redirect:/admin-dashboard";
	}
}

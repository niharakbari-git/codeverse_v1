package com.grownited.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

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
		userTypeRepository.save(userTypeEntity);
		return "redirect:/admin-dashboard";
	}
}

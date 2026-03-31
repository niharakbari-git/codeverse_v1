package com.grownited.controller;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.HackathonEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.UserTypeEntity;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.UserTypeRepository;

import jakarta.servlet.http.HttpSession;


@Controller
public class HackathonController {

	@Autowired
	HackathonRepository hackathonRepository;
	
	@Autowired
	UserTypeRepository userTypeRepository; 
	
	@GetMapping("newHackathon")
	public String newHackathon(Model model) {
		List<UserTypeEntity> allUserType =  userTypeRepository.findAll(); 
		model.addAttribute("allUserType",allUserType);
		model.addAttribute("hackathon", new HackathonEntity());
		return "NewHackathon";
	}
	
	@PostMapping("saveHackathon")
	public String saveHackathon(HackathonEntity hackathonEntity,HttpSession session) {
		if (hackathonEntity.getHackathonId() != null) {
			Optional<HackathonEntity> existingHackathon = hackathonRepository.findById(hackathonEntity.getHackathonId());
			if (existingHackathon.isPresent()) {
				hackathonEntity.setUserId(existingHackathon.get().getUserId());
			}
		}

		if (hackathonEntity.getUserId() == null) {
			UserEntity currentLogInUser = (UserEntity) session.getAttribute("user");
			if (currentLogInUser != null) {
				hackathonEntity.setUserId(currentLogInUser.getUserId());
			}
		}

		hackathonRepository.save(hackathonEntity);
		return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
	}

	@GetMapping("listHackathon")
	public String listHackathon(Model model) {
		List<HackathonEntity> allHackthon =  hackathonRepository.findAll(); 
		model.addAttribute("allHackthon",allHackthon);
		return "ListHackathon";
	}
	
	@GetMapping("deleteHackathon")
	public String deleteHackathon(Integer hackathonId) {
		hackathonRepository.deleteById(hackathonId);
		
		return "redirect:/listHackathon";//do not open jsp , open another url -> listHackathon
	}

	@GetMapping("editHackathon")
	public String editHackathon(@RequestParam Integer hackathonId, Model model) {
		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/listHackathon";
		}

		List<UserTypeEntity> allUserType = userTypeRepository.findAll();
		model.addAttribute("allUserType", allUserType);
		model.addAttribute("hackathon", opHackathon.get());
		return "NewHackathon";
	}

	@GetMapping("viewHackathon")
	public String viewHackathon(@RequestParam Integer hackathonId, Model model) {
		Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
		if (opHackathon.isEmpty()) {
			return "redirect:/listHackathon";
		}

		model.addAttribute("hackathon", opHackathon.get());
		return "ViewHackathon";
	}
	
	

}

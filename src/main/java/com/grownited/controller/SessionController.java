package com.grownited.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.UserTypeEntity;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;
import com.grownited.repository.UserTypeRepository;
import com.grownited.service.MailerService;

import jakarta.servlet.http.HttpSession;

@Controller
public class SessionController {

	@Autowired
	UserRepository userRepository;

	@Autowired
	UserTypeRepository userTypeRepository;

	@Autowired
	UserDetailRepository userDetailRepository;

	@Autowired
	MailerService mailerService;

	@Autowired
	PasswordEncoder passwordEncoder;

	@Autowired
	Cloudinary cloudinary;

	@GetMapping("/signup")
	public String openSignupPage(Model model) {

		List<UserTypeEntity> allUserType = getAllUserTypesWithDefault();
		// userType -> send Signup->
		model.addAttribute("allUserType", allUserType);
		return "Signup"; // jsp name
	}

	@GetMapping("/login")
	public String openLoginPage() {
		return "Login";
	}

	@PostMapping("/authenticate")
	public String authenticate(String email, String password, Model model, HttpSession session) {
		Optional<UserEntity> op = userRepository.findByEmail(email);

		if (op.isPresent()) {
			UserEntity dbUser = op.get();

			if (passwordEncoder.matches(password, dbUser.getPassword())) {
				session.setAttribute("user", dbUser);
//			if (dbUser.getPassword().equals(password)) {
				if (dbUser.getRole().equals("ADMIN")) {
					return "redirect:/admin-dashboard";// url '
				} else if (dbUser.getRole().equals("ORGANIZER")) {
					return "redirect:/organizer-dashboard";
				} else if (dbUser.getRole().equals("PARTICIPANT")) {
					return "redirect:/participant/home";// url '
				} else if (dbUser.getRole().equals("JUDGE")) {
					return "redirect:/judge-dashboard";
				}
			}
		}

		model.addAttribute("error", "Invalid Credentials");
		return "Login";
	}

	@GetMapping("/forgetpassword")
	public String openForgetPassword() {
		return "ForgetPassword";
	}

	@PostMapping("/sendResetLink")
	public String sendResetLink(String email, Model model) {
		Optional<UserEntity> opUser = userRepository.findByEmail(email);
		if (opUser.isEmpty()) {
			model.addAttribute("error", "No user found with this email.");
			return "ForgetPassword";
		}

		model.addAttribute("success", "Reset link request received. Please contact admin to reset your password.");
		return "ForgetPassword";
	}

	@PostMapping("/register")
	public String register(UserEntity userEntity, UserDetailEntity userDetailEntity, MultipartFile profilePic, Model model) {

		if (userDetailEntity.getUserTypeId() == null || userDetailEntity.getUserTypeId() <= 0) {
			model.addAttribute("error", "Please select a valid user type.");
			model.addAttribute("allUserType", getAllUserTypesWithDefault());
			return "Signup";
		}

		if (userRepository.findByEmail(userEntity.getEmail()).isPresent()) {
			model.addAttribute("error", "This email is already registered.");
			model.addAttribute("allUserType", getAllUserTypesWithDefault());
			return "Signup";
		}

		System.out.println(userEntity.getFirstName());
		System.out.println(userEntity.getLastName());
		System.out.println("Processor => " + Runtime.getRuntime().availableProcessors());
		System.out.println(userDetailEntity.getCountry());
		System.out.println(userDetailEntity.getState());

		userEntity.setRole("PARTICIPANT");
		userEntity.setActive(true);
		userEntity.setCreatedAt(LocalDate.now());

		// encode password
		String encodedPassword = passwordEncoder.encode(userEntity.getPassword());
		System.out.println(encodedPassword);
		userEntity.setPassword(encodedPassword);

		// file uploading
		if (profilePic != null && !profilePic.isEmpty()) {
			System.out.println(profilePic.getOriginalFilename());

			try {
				@SuppressWarnings("unchecked")
				Map<String, Object> map = (Map<String, Object>) cloudinary.uploader().upload(profilePic.getBytes(), null);
				String profilePicURL = map.get("secure_url").toString();
				System.out.println(profilePicURL);
				userEntity.setProfilePicURL(profilePicURL);

			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		// users insert -> UserRepository
		// new -> X
		userRepository.save(userEntity); // users insert -> userId
		userDetailEntity.setUserId(userEntity.getUserId());
		userDetailRepository.save(userDetailEntity);//

		// welcome mail send
		// mailerService.sendWelcomeMail(userEntity);
		return "Login";
	}

	private List<UserTypeEntity> getAllUserTypesWithDefault() {
		List<UserTypeEntity> allUserType = userTypeRepository.findAll();
		if (allUserType.isEmpty()) {
			UserTypeEntity defaultType = new UserTypeEntity();
			defaultType.setUserType("PARTICIPANT");
			userTypeRepository.save(defaultType);
			allUserType = userTypeRepository.findAll();
		}
		return allUserType;
	}

	@GetMapping("logout")
	public String logout(HttpSession session) {
		session.invalidate();
		return "Login";
	}

}

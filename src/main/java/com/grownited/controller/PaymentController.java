package com.grownited.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;


@Controller
public class PaymentController {

	//input 
	@GetMapping("/charge")
	public String charge(String status, String message, Model model) {
		model.addAttribute("status", status);
		model.addAttribute("message", message);
		return "ChargeCreditCard";
	}
	
	
	@PostMapping("charge")
	public String chargeCreditCard(Double amount, String cardNumber) {
		
		if (amount == null || amount <= 0) {
			return "redirect:/charge?status=error&message=Invalid+amount";
		}

		if (cardNumber == null || cardNumber.length() < 12) {
			return "redirect:/charge?status=error&message=Invalid+card+number";
		}

		//logic -> payment gateway 
		return "redirect:/charge?status=success&message=Payment+request+accepted";
	}
	
	
	
	
	
}

package com.grownited.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.grownited.common.AppConstants;
import com.grownited.entity.PaymentTransactionEntity;
import com.grownited.entity.UserEntity;
import com.grownited.service.PaymentTransactionService;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpSession;


@Controller
public class PaymentController {

	@Autowired
	PaymentTransactionService paymentTransactionService;

	//input 
	@GetMapping("/charge")
	public String charge(String status, String message, Model model, HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		String cancelPath = AppConstants.PARTICIPANT_HOME_PATH;
		if (currentUser != null) {
			String role = SessionUserUtil.getNormalizedRole(currentUser);
			if (AppConstants.ROLE_ADMIN.equals(role)) {
				cancelPath = "/admin-dashboard";
			} else if (AppConstants.ROLE_ORGANIZER.equals(role)) {
				cancelPath = "/organizer-dashboard";
			} else if (AppConstants.ROLE_JUDGE.equals(role)) {
				cancelPath = "/judge-dashboard";
			} else {
				cancelPath = "/participant/participant-dashboard";
			}
		}

		model.addAttribute("status", status);
		model.addAttribute("message", message);
		model.addAttribute("cancelPath", cancelPath);
		model.addAttribute("amount", AppConstants.HACKATHON_ENTRY_FEE_AMOUNT);
		model.addAttribute("fixedFeeLabel", "Application fee: Rs. " + (int) AppConstants.HACKATHON_ENTRY_FEE_AMOUNT + " per team application");
		return "ChargeCreditCard";
	}
	
	
	@PostMapping("charge")
		public String chargeCreditCard(Double amount, String cardNumber, String idempotencyKey) {
			amount = AppConstants.HACKATHON_ENTRY_FEE_AMOUNT;

		if (cardNumber == null || cardNumber.length() < 12) {
			return "redirect:/charge?status=error&message=Invalid+card+number";
		}

		PaymentTransactionEntity transaction = paymentTransactionService.startTransaction(null, amount,
				idempotencyKey == null || idempotencyKey.isBlank() ? UUID.randomUUID().toString() : idempotencyKey);
		paymentTransactionService.markSuccess(transaction, "SIMULATED-GATEWAY", "Payment request accepted");
		return "redirect:/charge?status=success&message=Payment+request+accepted";
	}
	
	
	
	
	
}

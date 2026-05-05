package com.grownited.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.common.AppConstants;
import com.grownited.dto.RazorpayCheckoutView;
import com.grownited.entity.PaymentTransactionEntity;
import com.grownited.entity.UserEntity;
import com.grownited.service.PaymentTransactionService;
import com.grownited.service.RazorpayPaymentService;
import com.grownited.util.SessionUserUtil;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;


@Controller
public class PaymentController {

	@Autowired
	PaymentTransactionService paymentTransactionService;

	@Autowired
	RazorpayPaymentService razorpayPaymentService;

	@Value("${app.base-url:http://localhost:9797}")
	private String appBaseUrl;

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
		model.addAttribute("fixedFeeLabel", "Hackathon registration fee: Rs. " + (int) AppConstants.HACKATHON_ENTRY_FEE_AMOUNT + " per team application");
		model.addAttribute("paymentGuide", "Open My Applications, then click Pay with UPI / Cards next to the application you want to pay for.");
		return "ChargeCreditCard";
	}

	@PostMapping("/participant/payment/initiate")
	public String initiatePayment(@RequestParam Integer applicationId, HttpSession session, Model model,
			HttpServletRequest request) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		try {
			RazorpayCheckoutView checkout = razorpayPaymentService.initiateCheckout(applicationId, currentUser);
			checkout.setVerifyUrl(request.getContextPath() + "/participant/payment/verify");
			checkout.setWebhookUrl(appBaseUrl + "/payments/razorpay/webhook");
			checkout.setCancelUrl(request.getContextPath() + "/participant/my-applications");
			model.addAttribute("checkout", checkout);
			return "RazorpayCheckout";
		} catch (IllegalArgumentException ex) {
			return "redirect:/participant/my-applications?msg=" + ex.getMessage().replace(" ", "+") + "&type=error";
		}
	}

	@PostMapping("/participant/payment/verify")
	public String verifyPayment(@RequestParam("razorpay_order_id") String razorpayOrderId,
			@RequestParam("razorpay_payment_id") String razorpayPaymentId,
			@RequestParam("razorpay_signature") String razorpaySignature,
			HttpSession session) {
		UserEntity currentUser = SessionUserUtil.getCurrentUser(session);
		if (currentUser == null) {
			return AppConstants.REDIRECT_LOGIN;
		}

		try {
			razorpayPaymentService.verifyCheckoutPayment(razorpayOrderId, razorpayPaymentId, razorpaySignature);
			return "redirect:/participant/my-applications?msg=Payment+verified+successfully&type=success";
		} catch (IllegalArgumentException ex) {
			return "redirect:/participant/my-applications?msg=" + ex.getMessage().replace(" ", "+") + "&type=error";
		}
	}

	@PostMapping("/payments/razorpay/webhook")
	public ResponseEntity<String> razorpayWebhook(@RequestBody String rawBody,
			@RequestHeader(value = "X-Razorpay-Signature", required = false) String signature) {
		try {
			razorpayPaymentService.processWebhook(rawBody, signature);
			return ResponseEntity.ok("ok");
		} catch (IllegalArgumentException ex) {
			return ResponseEntity.badRequest().body(ex.getMessage());
		}
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

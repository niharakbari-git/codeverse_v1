package com.grownited.service;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Objects;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import com.grownited.entity.UserEntity;

import jakarta.mail.internet.MimeMessage;

@Service
public class MailerService {

	private static final Logger logger = LoggerFactory.getLogger(MailerService.class);

	@Autowired
	JavaMailSender javaMailSender;

	@Autowired
	private ResourceLoader resourceLoader;

	@Value("${app.base-url:http://localhost:9797}")
	private String baseUrl;

	@Value("${spring.mail.username:}")
	private String fromAddress;

	@Value("${spring.application.name:CodeVerse}")
	private String applicationName;

	@Value("${app.reset-password-link-valid-minutes:30}")
	private int resetLinkValidMinutes;

	public String buildResetPasswordUrl(String email, String token) {
		return normalizedBaseUrl() + "/resetpassword?email=" + URLEncoder.encode(email, StandardCharsets.UTF_8)
				+ "&token=" + URLEncoder.encode(token, StandardCharsets.UTF_8);
	}

	public boolean sendWelcomeMail(UserEntity user) {
		return sendMail(user.getEmail(), "CodeVerse - Welcome aboard !!! ", buildWelcomeBody(user));
	}

	public boolean sendPasswordResetMail(UserEntity user, String resetUrl) {
		String body = buildResetBody(user, resetUrl);
		return sendMail(user.getEmail(), applicationName + " - Reset your password", body);
	}

	private String buildWelcomeBody(UserEntity user) {
		try {
			Resource resource = resourceLoader.getResource("classpath:templates/WelcomeMailTemplate.html");
			String html = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
			return html.replace("${name}", safeValue(user.getFirstName()))
					.replace("${email}", safeValue(user.getEmail()))
					.replace("${loginUrl}", loginUrl())
					.replace("${companyName}", "CodeVerse")
					.replace("${year}", String.valueOf(LocalDate.now().getYear()));
		} catch (IOException e) {
			logger.error("Failed to read welcome mail template for {}", user.getEmail(), e);
			return buildFallbackWelcomeBody(user);
		}
	}

	private String buildResetBody(UserEntity user, String resetUrl) {
		try {
			String html = loadTemplate("templates/ResetPasswordMailTemplate.html");
			return html.replace("${name}", safeValue(user.getFirstName()))
					.replace("${email}", safeValue(user.getEmail()))
					.replace("${resetUrl}", safeValue(resetUrl))
					.replace("${validMinutes}", String.valueOf(resetLinkValidMinutes))
					.replace("${companyName}", applicationName)
					.replace("${year}", String.valueOf(LocalDate.now().getYear()));
		} catch (IOException e) {
			logger.error("Failed to read reset password mail template for {}", user.getEmail(), e);
			return buildFallbackResetBody(user, resetUrl);
		}
	}

	private String buildFallbackWelcomeBody(UserEntity user) {
		String safeName = safeValue(user.getFirstName());
		String safeEmail = safeValue(user.getEmail());
		return "<html><body><h1>Welcome " + safeName + "</h1><p>Your account (" + safeEmail
				+ ") has been created.</p><p><a href=\"" + loginUrl() + "\">Login to CodeVerse</a></p></body></html>";
	}

	private String buildFallbackResetBody(UserEntity user, String resetUrl) {
		String safeName = safeValue(user.getFirstName());
		String safeEmail = safeValue(user.getEmail());
		return "<html><body><h1>Password reset request</h1>"
				+ "<p>Hello " + safeName + ",</p>"
				+ "<p>We received a password reset request for " + safeEmail + ".</p>"
				+ "<p>This link is valid for " + resetLinkValidMinutes + " minutes:</p>"
				+ "<p><a href=\"" + resetUrl + "\">" + resetUrl + "</a></p>"
				+ "<p>If you did not request this, you can safely ignore this email.</p>"
				+ "<p>Thanks,<br/>" + applicationName + " Team</p></body></html>";
	}

	private String loadTemplate(String templatePath) throws IOException {
		Resource resource = resourceLoader.getResource("classpath:" + templatePath);
		return new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
	}

	private String normalizedBaseUrl() {
		return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
	}

	private String loginUrl() {
		return normalizedBaseUrl() + "/login";
	}

	private boolean sendMail(String to, String subject, String body) {
		try {
			MimeMessage message = javaMailSender.createMimeMessage();
			MimeMessageHelper helper = new MimeMessageHelper(message, true, StandardCharsets.UTF_8.name());
			helper.setTo(to);
			if (!fromAddress.isBlank()) {
				helper.setFrom(fromAddress.trim(), applicationName + " Team");
			}
			helper.setSubject(subject);
			helper.setText(body, true);
			javaMailSender.send(message);
			return true;
		} catch (Exception e) {
			logger.error("Failed to send mail to {}", to, e);
			return false;
		}
	}

	private String safeValue(String value) {
		return Objects.toString(value, "");
	}

}

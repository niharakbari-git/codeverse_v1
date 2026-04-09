package com;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import com.cloudinary.Cloudinary;

@SpringBootApplication
public class CodeVerseApplication {

	public static void main(String[] args) {
		SpringApplication.run(CodeVerseApplication.class, args);
	}

	@Bean
	PasswordEncoder getPasswordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	Cloudinary getCloudinary(
		@Value("${cloudinary.cloud_name}") String cloudName,
		@Value("${cloudinary.api_key}") String apiKey,
		@Value("${cloudinary.api_secret}") String apiSecret) {
		Map<String, String> config = new HashMap<>();
		config.put("cloud_name", sanitizeCloudinaryValue(cloudName));
		config.put("api_key", sanitizeCloudinaryValue(apiKey));
		config.put("api_secret", sanitizeCloudinaryValue(apiSecret));
		return new Cloudinary(config);
	}

	private String sanitizeCloudinaryValue(String value) {
		if (value == null) {
			return "";
		}
		return value.trim().replace("\"", "").replace("'", "");
	}

}

package com.grownited.service;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Locale;
import java.util.Optional;
import java.util.concurrent.ThreadLocalRandom;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.grownited.common.AppConstants;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.HackathonJoinVerificationEntity;
import com.grownited.repository.HackathonJoinVerificationRepository;
import com.grownited.repository.HackathonRepository;

@Service
public class HackathonAccessVerificationService {

    private static final int OTP_VALID_MINUTES = 10;

    @Autowired
    private HackathonRepository hackathonRepository;

    @Autowired
    private HackathonJoinVerificationRepository verificationRepository;

    @Autowired
    private MailerService mailerService;

    public OperationResult requestJoinOtp(Integer userId, Integer hackathonId, String verificationEmail, String inviteCode) {
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return OperationResult.error("Hackathon+not+found");
        }

        HackathonEntity hackathon = opHackathon.get();
        if (!isCampusOnly(hackathon)) {
            return OperationResult.error("Campus+verification+is+not+required+for+this+hackathon");
        }

        String normalizedEmail = normalizeEmail(verificationEmail);
        if (normalizedEmail == null) {
            return OperationResult.error("Please+enter+a+valid+email");
        }

        String normalizedInviteCode = normalizeInviteCode(inviteCode);
        if (normalizedInviteCode == null || !matchesInviteCode(normalizedInviteCode, hackathon.getInvitationCode())) {
            return OperationResult.error("Invitation+code+is+invalid");
        }

        if (!isAllowedDomain(normalizedEmail, hackathon.getAllowedEmailDomains())) {
            return OperationResult.error("Email+domain+is+not+allowed+for+this+hackathon");
        }

        String otp = String.format("%06d", ThreadLocalRandom.current().nextInt(0, 1_000_000));
        LocalDateTime expiresAt = LocalDateTime.now().plusMinutes(OTP_VALID_MINUTES);

        HackathonJoinVerificationEntity verification = verificationRepository
                .findByHackathonIdAndUserIdAndVerificationEmail(hackathonId, userId, normalizedEmail)
                .orElseGet(HackathonJoinVerificationEntity::new);

        verification.setHackathonId(hackathonId);
        verification.setUserId(userId);
        verification.setVerificationEmail(normalizedEmail);
        verification.setInviteCode(normalizedInviteCode);
        verification.setOtp(otp);
        verification.setOtpExpiresAt(expiresAt);
        verification.setVerified(false);
        verification.setVerifiedAt(null);
        verificationRepository.save(verification);

        boolean sent = mailerService.sendHackathonJoinOtpMail(normalizedEmail, hackathon.getTitle(), otp, OTP_VALID_MINUTES);
        if (!sent) {
            return OperationResult.error("Unable+to+send+OTP+mail+right+now");
        }

        return OperationResult.success("OTP+sent+to+your+email");
    }

    public OperationResult verifyJoinOtp(Integer userId, Integer hackathonId, String verificationEmail, String inviteCode,
            String otp) {
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return OperationResult.error("Hackathon+not+found");
        }

        HackathonEntity hackathon = opHackathon.get();
        if (!isCampusOnly(hackathon)) {
            return OperationResult.success("Verification+not+required+for+this+hackathon");
        }

        String normalizedEmail = normalizeEmail(verificationEmail);
        String normalizedInviteCode = normalizeInviteCode(inviteCode);
        String normalizedOtp = otp == null ? null : otp.trim();

        if (normalizedEmail == null || normalizedInviteCode == null || normalizedOtp == null || normalizedOtp.isBlank()) {
            return OperationResult.error("Email,+invite+code,+and+OTP+are+required");
        }

        Optional<HackathonJoinVerificationEntity> opVerification = verificationRepository
                .findByHackathonIdAndUserIdAndVerificationEmail(hackathonId, userId, normalizedEmail);
        if (opVerification.isEmpty()) {
            return OperationResult.error("Request+OTP+first");
        }

        HackathonJoinVerificationEntity verification = opVerification.get();
        if (!matchesInviteCode(normalizedInviteCode, hackathon.getInvitationCode())) {
            return OperationResult.error("Invitation+code+is+invalid");
        }

        if (!isAllowedDomain(normalizedEmail, hackathon.getAllowedEmailDomains())) {
            return OperationResult.error("Email+domain+is+not+allowed+for+this+hackathon");
        }

        if (verification.getOtp() == null || !verification.getOtp().equals(normalizedOtp)) {
            return OperationResult.error("OTP+is+invalid");
        }

        if (verification.getOtpExpiresAt() == null || LocalDateTime.now().isAfter(verification.getOtpExpiresAt())) {
            return OperationResult.error("OTP+expired.+Please+request+a+new+OTP");
        }

        verification.setVerified(true);
        verification.setVerifiedAt(LocalDateTime.now());
        verification.setOtp(null);
        verification.setOtpExpiresAt(null);
        verificationRepository.save(verification);
        return OperationResult.success("Email+verified+for+this+hackathon");
    }

    public boolean hasVerifiedAccess(Integer userId, Integer hackathonId) {
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return false;
        }

        HackathonEntity hackathon = opHackathon.get();
        if (!isCampusOnly(hackathon)) {
            return true;
        }

        return verificationRepository.existsByHackathonIdAndUserIdAndVerifiedTrue(hackathonId, userId);
    }

    private boolean isCampusOnly(HackathonEntity hackathon) {
        return hackathon != null
                && AppConstants.HACKATHON_SCOPE_CAMPUS_ONLY.equalsIgnoreCase(safeTrim(hackathon.getParticipationScope()));
    }

    private String normalizeEmail(String email) {
        if (email == null) {
            return null;
        }
        String normalized = email.trim().toLowerCase(Locale.ROOT);
        return normalized.isBlank() || !normalized.contains("@") ? null : normalized;
    }

    private String normalizeInviteCode(String inviteCode) {
        if (inviteCode == null) {
            return null;
        }
        String normalized = inviteCode.trim().toUpperCase(Locale.ROOT);
        return normalized.isBlank() ? null : normalized;
    }

    private boolean matchesInviteCode(String inputCode, String configuredCode) {
        String configured = normalizeInviteCode(configuredCode);
        return configured != null && configured.equalsIgnoreCase(inputCode);
    }

    private boolean isAllowedDomain(String email, String allowedDomainsRaw) {
        if (email == null || allowedDomainsRaw == null || allowedDomainsRaw.isBlank()) {
            return false;
        }
        int atIndex = email.lastIndexOf('@');
        if (atIndex <= 0 || atIndex >= email.length() - 1) {
            return false;
        }
        String domain = email.substring(atIndex + 1).toLowerCase(Locale.ROOT);

        return Arrays.stream(allowedDomainsRaw.split("[,;\\n]"))
                .map(this::safeTrim)
                .filter(value -> !value.isBlank())
                .map(value -> value.toLowerCase(Locale.ROOT))
                .anyMatch(allowed -> allowed.equals(domain));
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    public static class OperationResult {
        private final boolean success;
        private final String message;

        private OperationResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public static OperationResult success(String message) {
            return new OperationResult(true, message);
        }

        public static OperationResult error(String message) {
            return new OperationResult(false, message);
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }
    }
}

package com.grownited.service;

import java.time.LocalDate;
import java.util.UUID;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.grownited.common.AppConstants;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.UserTypeEntity;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;
import com.grownited.repository.UserTypeRepository;

@Service
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserTypeRepository userTypeRepository;

    @Autowired
    private UserDetailRepository userDetailRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private Cloudinary cloudinary;

    @Autowired
    private MailerService mailerService;

    private static final List<String> SYSTEM_USER_TYPES_ORDER = List.of(
            AppConstants.ROLE_PARTICIPANT,
            AppConstants.ROLE_JUDGE,
            AppConstants.ROLE_ORGANIZER,
            AppConstants.ROLE_ADMIN);

    private static final List<String> SELF_REGISTRATION_ALLOWED_USER_TYPES = List.of(
            AppConstants.ROLE_PARTICIPANT);

    public AuthResult authenticate(String email, String password) {
        Optional<UserEntity> op = userRepository.findByEmail(email);
        if (op.isEmpty()) {
            return AuthResult.failure("Invalid Credentials");
        }

        UserEntity user = op.get();
        if (!passwordEncoder.matches(password, user.getPassword())) {
            return AuthResult.failure("Invalid Credentials");
        }

        return AuthResult.success(user, resolveRoleRedirect(user.getRole()));
    }

    public String requestPasswordReset(String email) {
        String normalizedEmail = email == null ? "" : email.trim();
        Optional<UserEntity> opUser = userRepository.findByEmail(normalizedEmail);
        if (opUser.isEmpty()) {
            return "No user found with this email.";
        }

        UserEntity user = opUser.get();
        String resetToken = UUID.randomUUID().toString().replace("-", "");
        user.setOtp(resetToken);
        userRepository.save(user);

        String resetUrl = mailerService.buildResetPasswordUrl(normalizedEmail, resetToken);
        if (!mailerService.sendPasswordResetMail(user, resetUrl)) {
            user.setOtp(null);
            userRepository.save(user);
            return "Unable to send reset email right now. Please try again later.";
        }
        return null;
    }

    public String resetPassword(String email, String token, String newPassword, String confirmPassword) {
        String normalizedEmail = email == null ? "" : email.trim();
        String normalizedToken = token == null ? "" : token.trim();

        if (normalizedEmail.isBlank() || normalizedToken.isBlank()) {
            return "Reset link is invalid.";
        }

        if (newPassword == null || newPassword.isBlank()) {
            return "Password cannot be empty.";
        }

        if (!newPassword.equals(confirmPassword)) {
            return "Passwords do not match.";
        }

        Optional<UserEntity> opUser = userRepository.findByEmail(normalizedEmail);
        if (opUser.isEmpty()) {
            return "No user found with this email.";
        }

        UserEntity user = opUser.get();
        if (user.getOtp() == null || !user.getOtp().equals(normalizedToken)) {
            return "Reset link is invalid or has expired.";
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        user.setOtp(null);
        userRepository.save(user);
        return null;
    }

    public RegistrationResult registerParticipant(UserEntity userEntity, UserDetailEntity userDetailEntity, MultipartFile profilePic) {
        boolean profileUploadFailed = false;

        Optional<UserTypeEntity> participantTypeOp = userTypeRepository
                .findByUserTypeIgnoreCase(AppConstants.ROLE_PARTICIPANT);
        if (participantTypeOp.isEmpty()) {
            return RegistrationResult.failure("Participant user type is not configured. Please contact admin.");
        }

        if (userRepository.findByEmail(userEntity.getEmail()).isPresent()) {
            return RegistrationResult.failure("This email is already registered.");
        }

        userEntity.setRole(AppConstants.ROLE_PARTICIPANT);
        userEntity.setActive(true);
        userEntity.setCreatedAt(LocalDate.now());
        userEntity.setPassword(passwordEncoder.encode(userEntity.getPassword()));

        if (profilePic != null && !profilePic.isEmpty()) {
            try {
                @SuppressWarnings("unchecked")
                Map<String, Object> map = (Map<String, Object>) cloudinary.uploader().upload(profilePic.getBytes(), null);
                Object secureUrl = map.get("secure_url");
                if (secureUrl != null) {
                    userEntity.setProfilePicURL(secureUrl.toString());
                } else {
                    logger.warn("Cloudinary response missing secure_url for email {}", userEntity.getEmail());
                    profileUploadFailed = true;
                    userEntity.setProfilePicURL(null);
                }
            } catch (Exception e) {
                logger.error("Profile image upload failed for email {}", userEntity.getEmail(), e);
                // Keep signup successful even if third-party image upload is temporarily unavailable.
                profileUploadFailed = true;
                userEntity.setProfilePicURL(null);
            }
        }

        userRepository.save(userEntity);
        userDetailEntity.setUserId(userEntity.getUserId());
        userDetailEntity.setUserTypeId(participantTypeOp.get().getUserTypeId());
        userDetailRepository.save(userDetailEntity);
        mailerService.sendWelcomeMail(userEntity);
        logger.info("New participant registered with email {}", userEntity.getEmail());

        if (profileUploadFailed) {
            return RegistrationResult.success("User registered successfully, but profile picture upload failed. Check Cloudinary API secret and try again from Profile page.");
        }
        return RegistrationResult.success("User registered successfully. Please login.");
    }

    public ProfilePictureUpdateResult updateProfilePicture(Integer userId, MultipartFile profilePic) {
        if (userId == null) {
            return ProfilePictureUpdateResult.failure("User session is invalid. Please login again.");
        }

        if (profilePic == null || profilePic.isEmpty()) {
            return ProfilePictureUpdateResult.failure("Please select a profile picture to upload.");
        }

        String contentType = profilePic.getContentType();
        if (contentType == null || !contentType.toLowerCase().startsWith("image/")) {
            return ProfilePictureUpdateResult.failure("Only image files are allowed for profile picture.");
        }

        Optional<UserEntity> opUser = userRepository.findById(userId);
        if (opUser.isEmpty()) {
            return ProfilePictureUpdateResult.failure("User not found. Please login again.");
        }

        try {
            @SuppressWarnings("unchecked")
            Map<String, Object> map = (Map<String, Object>) cloudinary.uploader().upload(profilePic.getBytes(), null);
            Object secureUrl = map.get("secure_url");
            if (secureUrl == null) {
                logger.warn("Cloudinary response missing secure_url for userId {}", userId);
                return ProfilePictureUpdateResult.failure("Upload failed. Please try again.");
            }

            UserEntity user = opUser.get();
            user.setProfilePicURL(secureUrl.toString());
            userRepository.save(user);
            return ProfilePictureUpdateResult.success(user, "Profile picture updated successfully.");
        } catch (Exception e) {
            logger.error("Profile image update failed for userId {}", userId, e);
            return ProfilePictureUpdateResult.failure(resolveCloudinaryUploadErrorMessage(e));
        }
    }

    private String resolveCloudinaryUploadErrorMessage(Exception e) {
        String message = flattenExceptionMessage(e).toLowerCase();
        if (message.contains("401") || message.contains("invalid signature") || message.contains("unauthorized")
                || message.contains("api secret") || message.contains("api key")) {
            return "Cloudinary auth failed (401). Fix cloud_name/api_key/api_secret in application-local.properties and restart app.";
        }
        return "Cloudinary upload failed. Verify cloud_name/api_key/api_secret in application-local.properties and restart app.";
    }

    private String flattenExceptionMessage(Throwable throwable) {
        StringBuilder sb = new StringBuilder();
        Throwable current = throwable;
        while (current != null) {
            if (current.getMessage() != null) {
                sb.append(' ').append(current.getMessage());
            }
            current = current.getCause();
        }
        return sb.toString();
    }

    public List<UserTypeEntity> getAllUserTypesWithDefault() {
        ensureAllowedUserTypes();

        List<UserTypeEntity> allUserType = userTypeRepository.findAll();

        List<UserTypeEntity> allowedUserTypes = new ArrayList<>();
        for (String allowedType : SELF_REGISTRATION_ALLOWED_USER_TYPES) {
            for (UserTypeEntity userTypeEntity : allUserType) {
                if (allowedType.equalsIgnoreCase(userTypeEntity.getUserType())) {
                    allowedUserTypes.add(userTypeEntity);
                    break;
                }
            }
        }

        return allowedUserTypes;
    }

    private void ensureAllowedUserTypes() {
        List<UserTypeEntity> allUserType = userTypeRepository.findAll();

        for (String allowedType : SYSTEM_USER_TYPES_ORDER) {
            boolean exists = allUserType.stream().anyMatch(ut -> allowedType.equalsIgnoreCase(ut.getUserType()));
            if (!exists) {
                UserTypeEntity userTypeEntity = new UserTypeEntity();
                userTypeEntity.setUserType(allowedType);
                userTypeRepository.save(userTypeEntity);
            }
        }
    }

    private String resolveRoleRedirect(String role) {
        if (AppConstants.ROLE_ADMIN.equals(role)) {
            return "redirect:/admin-dashboard";
        }
        if (AppConstants.ROLE_ORGANIZER.equals(role)) {
            return "redirect:/organizer-dashboard";
        }
        if (AppConstants.ROLE_PARTICIPANT.equals(role)) {
            return AppConstants.REDIRECT_PARTICIPANT_HOME;
        }
        if (AppConstants.ROLE_JUDGE.equals(role)) {
            return "redirect:/judge-dashboard";
        }
        return AppConstants.REDIRECT_LOGIN;
    }

    public static class AuthResult {
        private final boolean authenticated;
        private final String errorMessage;
        private final UserEntity user;
        private final String redirectPath;

        private AuthResult(boolean authenticated, String errorMessage, UserEntity user, String redirectPath) {
            this.authenticated = authenticated;
            this.errorMessage = errorMessage;
            this.user = user;
            this.redirectPath = redirectPath;
        }

        public static AuthResult success(UserEntity user, String redirectPath) {
            return new AuthResult(true, null, user, redirectPath);
        }

        public static AuthResult failure(String errorMessage) {
            return new AuthResult(false, errorMessage, null, null);
        }

        public boolean isAuthenticated() {
            return authenticated;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public UserEntity getUser() {
            return user;
        }

        public String getRedirectPath() {
            return redirectPath;
        }
    }

    public static class RegistrationResult {
        private final boolean successful;
        private final String errorMessage;
        private final String successMessage;

        private RegistrationResult(boolean successful, String errorMessage, String successMessage) {
            this.successful = successful;
            this.errorMessage = errorMessage;
            this.successMessage = successMessage;
        }

        public static RegistrationResult success(String successMessage) {
            return new RegistrationResult(true, null, successMessage);
        }

        public static RegistrationResult failure(String errorMessage) {
            return new RegistrationResult(false, errorMessage, null);
        }

        public boolean isSuccessful() {
            return successful;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public String getSuccessMessage() {
            return successMessage;
        }
    }

    public static class ProfilePictureUpdateResult {
        private final boolean successful;
        private final String message;
        private final UserEntity updatedUser;

        private ProfilePictureUpdateResult(boolean successful, String message, UserEntity updatedUser) {
            this.successful = successful;
            this.message = message;
            this.updatedUser = updatedUser;
        }

        public static ProfilePictureUpdateResult success(UserEntity updatedUser, String message) {
            return new ProfilePictureUpdateResult(true, message, updatedUser);
        }

        public static ProfilePictureUpdateResult failure(String message) {
            return new ProfilePictureUpdateResult(false, message, null);
        }

        public boolean isSuccessful() {
            return successful;
        }

        public String getMessage() {
            return message;
        }

        public UserEntity getUpdatedUser() {
            return updatedUser;
        }
    }
}

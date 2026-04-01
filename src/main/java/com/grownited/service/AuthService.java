package com.grownited.service;

import java.io.IOException;
import java.time.LocalDate;
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
        Optional<UserEntity> opUser = userRepository.findByEmail(email);
        return opUser.isEmpty() ? "No user found with this email." : null;
    }

    public RegistrationResult registerParticipant(UserEntity userEntity, UserDetailEntity userDetailEntity, MultipartFile profilePic) {
        if (userDetailEntity.getUserTypeId() == null || userDetailEntity.getUserTypeId() <= 0) {
            return RegistrationResult.failure("Please select a valid user type.");
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
                String profilePicURL = map.get("secure_url").toString();
                userEntity.setProfilePicURL(profilePicURL);
            } catch (IOException e) {
                logger.error("Profile image upload failed for email {}", userEntity.getEmail(), e);
                return RegistrationResult.failure("Unable to upload profile image right now.");
            }
        }

        userRepository.save(userEntity);
        userDetailEntity.setUserId(userEntity.getUserId());
        userDetailRepository.save(userDetailEntity);
        logger.info("New participant registered with email {}", userEntity.getEmail());

        return RegistrationResult.success();
    }

    public List<UserTypeEntity> getAllUserTypesWithDefault() {
        List<UserTypeEntity> allUserType = userTypeRepository.findAll();
        if (allUserType.isEmpty()) {
            UserTypeEntity defaultType = new UserTypeEntity();
            defaultType.setUserType(AppConstants.ROLE_PARTICIPANT);
            userTypeRepository.save(defaultType);
            allUserType = userTypeRepository.findAll();
        }
        return allUserType;
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

        private RegistrationResult(boolean successful, String errorMessage) {
            this.successful = successful;
            this.errorMessage = errorMessage;
        }

        public static RegistrationResult success() {
            return new RegistrationResult(true, null);
        }

        public static RegistrationResult failure(String errorMessage) {
            return new RegistrationResult(false, errorMessage);
        }

        public boolean isSuccessful() {
            return successful;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }
}

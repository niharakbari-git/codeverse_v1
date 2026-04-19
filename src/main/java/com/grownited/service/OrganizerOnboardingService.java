package com.grownited.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.grownited.common.AppConstants;
import com.grownited.entity.OrganizerOnboardingRequestEntity;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.OrganizerOnboardingRequestRepository;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;
import com.grownited.service.MailerService;

@Service
public class OrganizerOnboardingService {

    private static final Logger logger = LoggerFactory.getLogger(OrganizerOnboardingService.class);

    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_APPROVED = "APPROVED";
    public static final String STATUS_REJECTED = "REJECTED";

    @Autowired
    private OrganizerOnboardingRequestRepository organizerOnboardingRequestRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserDetailRepository userDetailRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private MailerService mailerService;

    public SubmissionResult submitRequest(OrganizerOnboardingRequestEntity request, String rawPassword) {
        if (request == null) {
            return SubmissionResult.failure("Invalid request payload.");
        }

        String email = normalize(request.getEmail());
        String firstName = normalize(request.getFirstName());
        String organizationName = normalize(request.getOrganizationName());
        String websiteUrl = normalize(request.getWebsiteUrl());

        if (email == null || firstName == null || organizationName == null || websiteUrl == null) {
            return SubmissionResult.failure("First name, organization, email, and website URL are required.");
        }
        if (rawPassword == null || rawPassword.isBlank() || rawPassword.length() < 6) {
            return SubmissionResult.failure("Password must be at least 6 characters.");
        }

        if (userRepository.findByEmail(email).isPresent()) {
            return SubmissionResult.failure("Email is already registered. Please login or use a different email.");
        }

        Optional<OrganizerOnboardingRequestEntity> existingRequest = organizerOnboardingRequestRepository
                .findByEmailIgnoreCase(email);
        if (existingRequest.isPresent() && STATUS_PENDING.equalsIgnoreCase(existingRequest.get().getStatus())) {
            return SubmissionResult.failure("A pending organizer request already exists for this email.");
        }

        request.setEmail(email);
        request.setFirstName(firstName);
        request.setLastName(normalize(request.getLastName()));
        request.setOrganizationName(organizationName);
        request.setContactNum(normalize(request.getContactNum()));
        request.setCity(normalize(request.getCity()));
        request.setState(normalize(request.getState()));
        request.setCountry(normalize(request.getCountry()) == null ? "India" : normalize(request.getCountry()));
        request.setLinkedinUrl(normalize(request.getLinkedinUrl()));
        request.setWebsiteUrl(websiteUrl);
        request.setEventExperience(normalize(request.getEventExperience()));
        request.setPasswordHash(passwordEncoder.encode(rawPassword));
        request.setStatus(STATUS_PENDING);
        request.setReviewNotes(null);
        request.setCreatedAt(LocalDate.now());
        request.setReviewedAt(null);
        request.setReviewedByUserId(null);
        request.setApprovedUserId(null);

        organizerOnboardingRequestRepository.save(request);

        boolean mailSent = mailerService.sendOrganizerRequestReceivedMail(email, firstName, organizationName);
        String message = mailSent
            ? "Organizer onboarding request submitted. A confirmation email has been sent. You will be notified by email after admin review."
            : "Organizer onboarding request submitted. You will be notified by email after admin review.";
        return SubmissionResult.success(message);
    }

    public List<OrganizerOnboardingRequestEntity> listRequests(String status) {
        String normalizedStatus = normalizeStatusFilter(status);
        if (normalizedStatus == null) {
            return organizerOnboardingRequestRepository.findAllByOrderByOrganizerOnboardingRequestIdDesc();
        }
        return organizerOnboardingRequestRepository.findByStatusOrderByOrganizerOnboardingRequestIdDesc(normalizedStatus);
    }

    public boolean isApprovedOrganizer(Integer userId) {
        if (userId == null) {
            return false;
        }
        
        // For backwards compatibility: Allow legacy organizers to create hackathons
        UserEntity user = userRepository.findById(userId).orElse(null);
        if (user != null && "ORGANIZER".equalsIgnoreCase(user.getRole())) {
            // Check if there is an onboarding request linked to this user
            boolean hasRequest = organizerOnboardingRequestRepository.findByApprovedUserId(userId).isPresent();
            if (!hasRequest) {
                // If there's no request but they have the ORGANIZER role, they are a legacy organizer
                return true;
            }
        }

        return organizerOnboardingRequestRepository.findByApprovedUserId(userId)
                .filter(request -> STATUS_APPROVED.equalsIgnoreCase(request.getStatus()))
                .isPresent();
    }

    public ActionResult approveRequest(Integer requestId, Integer reviewerUserId, String reviewNotes) {
        if (requestId == null || reviewerUserId == null) {
            return ActionResult.failure("Invalid approval request.");
        }

        Optional<OrganizerOnboardingRequestEntity> opRequest = organizerOnboardingRequestRepository.findById(requestId);
        if (opRequest.isEmpty()) {
            return ActionResult.failure("Organizer request not found.");
        }

        OrganizerOnboardingRequestEntity request = opRequest.get();
        if (!STATUS_PENDING.equalsIgnoreCase(request.getStatus())) {
            return ActionResult.failure("Only pending requests can be approved.");
        }

        if (userRepository.findByEmail(request.getEmail()).isPresent()) {
            request.setStatus(STATUS_REJECTED);
            request.setReviewNotes("Email already exists in users. Manual merge required.");
            request.setReviewedAt(LocalDate.now());
            request.setReviewedByUserId(reviewerUserId);
            organizerOnboardingRequestRepository.save(request);
            return ActionResult.failure("Email already exists in users. Request marked as rejected.");
        }

        UserEntity user = new UserEntity();
        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setEmail(request.getEmail());
        user.setPassword(request.getPasswordHash());
        user.setRole(AppConstants.ROLE_ORGANIZER);
        user.setContactNum(request.getContactNum());
        user.setActive(true);
        user.setCreatedAt(LocalDate.now());
        userRepository.save(user);

        UserDetailEntity detail = new UserDetailEntity();
        detail.setUserId(user.getUserId());
        detail.setQualification(request.getOrganizationName());
        detail.setCity(request.getCity());
        detail.setState(request.getState());
        detail.setCountry(request.getCountry());
        detail.setLinkedinUrl(request.getLinkedinUrl());
        detail.setUserTypeId(null);
        userDetailRepository.save(detail);

        request.setStatus(STATUS_APPROVED);
        request.setReviewNotes(normalize(reviewNotes));
        request.setReviewedAt(LocalDate.now());
        request.setReviewedByUserId(reviewerUserId);
        request.setApprovedUserId(user.getUserId());
        organizerOnboardingRequestRepository.save(request);

        boolean approvalMailSent = mailerService.sendOrganizerRequestApprovedMail(request.getEmail(), request.getFirstName(), request.getOrganizationName());
        if (!approvalMailSent) {
            logger.warn("Organizer approval email failed for requestId={} email={}", requestId, request.getEmail());
        }

        String successMessage = approvalMailSent
                ? "Organizer request approved and account created. Approval email sent to the organizer."
                : "Organizer request approved and account created, but approval email could not be sent.";
        return ActionResult.success(successMessage);
    }

    public ActionResult rejectRequest(Integer requestId, Integer reviewerUserId, String reviewNotes) {
        if (requestId == null || reviewerUserId == null) {
            return ActionResult.failure("Invalid rejection request.");
        }

        Optional<OrganizerOnboardingRequestEntity> opRequest = organizerOnboardingRequestRepository.findById(requestId);
        if (opRequest.isEmpty()) {
            return ActionResult.failure("Organizer request not found.");
        }

        OrganizerOnboardingRequestEntity request = opRequest.get();
        if (!STATUS_PENDING.equalsIgnoreCase(request.getStatus())) {
            return ActionResult.failure("Only pending requests can be rejected.");
        }

        request.setStatus(STATUS_REJECTED);
        request.setReviewNotes(normalize(reviewNotes));
        request.setReviewedAt(LocalDate.now());
        request.setReviewedByUserId(reviewerUserId);
        organizerOnboardingRequestRepository.save(request);

        return ActionResult.success("Organizer request rejected.");
    }

    public long countByStatus(String status) {
        return organizerOnboardingRequestRepository.countByStatus(status);
    }

    private String normalizeStatusFilter(String status) {
        String normalized = normalize(status);
        if (normalized == null || "ALL".equalsIgnoreCase(normalized)) {
            return null;
        }
        if (STATUS_PENDING.equals(normalized) || STATUS_APPROVED.equals(normalized) || STATUS_REJECTED.equals(normalized)) {
            return normalized;
        }
        return null;
    }

    private String normalize(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    public static class SubmissionResult {
        private final boolean successful;
        private final String message;

        private SubmissionResult(boolean successful, String message) {
            this.successful = successful;
            this.message = message;
        }

        public static SubmissionResult success(String message) {
            return new SubmissionResult(true, message);
        }

        public static SubmissionResult failure(String message) {
            return new SubmissionResult(false, message);
        }

        public boolean isSuccessful() {
            return successful;
        }

        public String getMessage() {
            return message;
        }
    }

    public static class ActionResult {
        private final boolean successful;
        private final String message;

        private ActionResult(boolean successful, String message) {
            this.successful = successful;
            this.message = message;
        }

        public static ActionResult success(String message) {
            return new ActionResult(true, message);
        }

        public static ActionResult failure(String message) {
            return new ActionResult(false, message);
        }

        public boolean isSuccessful() {
            return successful;
        }

        public String getMessage() {
            return message;
        }
    }
}

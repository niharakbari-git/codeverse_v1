package com.grownited.config;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.grownited.common.AppConstants;
import com.grownited.entity.CategoryEntity;
import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.JudgeAssignmentEntity;
import com.grownited.entity.JudgeScoreEntity;
import com.grownited.entity.PaymentTransactionEntity;
import com.grownited.entity.SubmissionVersionEntity;
import com.grownited.entity.TeamEntity;
import com.grownited.entity.TeamMemberEntity;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.UserTypeEntity;
import com.grownited.repository.AuditLogRepository;
import com.grownited.repository.CategoryRepository;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.JudgeAssignmentRepository;
import com.grownited.repository.JudgeScoreRepository;
import com.grownited.repository.NotificationLogRepository;
import com.grownited.repository.OrganizerOnboardingRequestRepository;
import com.grownited.repository.PaymentTransactionRepository;
import com.grownited.repository.SubmissionVersionRepository;
import com.grownited.repository.TeamMemberRepository;
import com.grownited.repository.TeamRepository;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;
import com.grownited.repository.UserTypeRepository;

@Component
@ConditionalOnProperty(name = "app.seed-demo-data", havingValue = "true")
public class DemoDataSeeder implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DemoDataSeeder.class);

    private static final String DEFAULT_PASSWORD = "00000000";
    private static final String DEFAULT_PFP = "/assets/images/faces/dummy.jpg";
    private static final String[] PARTICIPANT_NAMES = { "Aarav", "Ira", "Rohan", "Siya", "Kabir" };
    private static final String[] ORGANIZER_NAMES = { "Om", "Meera", "Karan", "Diya", "Ritvik" };
    private static final String[] JUDGE_NAMES = { "Vivek", "Riya", "Ishita", "Manav", "Neel" };

    private final UserRepository userRepository;
    private final UserDetailRepository userDetailRepository;
    private final UserTypeRepository userTypeRepository;
    private final HackathonRepository hackathonRepository;
    private final JudgeAssignmentRepository judgeAssignmentRepository;
    private final TeamRepository teamRepository;
    private final TeamMemberRepository teamMemberRepository;
    private final HackathonApplicationRepository hackathonApplicationRepository;
    private final JudgeScoreRepository judgeScoreRepository;
    private final PaymentTransactionRepository paymentTransactionRepository;
    private final SubmissionVersionRepository submissionVersionRepository;
    private final NotificationLogRepository notificationLogRepository;
    private final AuditLogRepository auditLogRepository;
    private final OrganizerOnboardingRequestRepository organizerOnboardingRequestRepository;
    private final CategoryRepository categoryRepository;
    private final PasswordEncoder passwordEncoder;

    public DemoDataSeeder(
            UserRepository userRepository,
            UserDetailRepository userDetailRepository,
            UserTypeRepository userTypeRepository,
            HackathonRepository hackathonRepository,
            JudgeAssignmentRepository judgeAssignmentRepository,
            TeamRepository teamRepository,
            TeamMemberRepository teamMemberRepository,
            HackathonApplicationRepository hackathonApplicationRepository,
            JudgeScoreRepository judgeScoreRepository,
            PaymentTransactionRepository paymentTransactionRepository,
            SubmissionVersionRepository submissionVersionRepository,
            NotificationLogRepository notificationLogRepository,
            AuditLogRepository auditLogRepository,
            OrganizerOnboardingRequestRepository organizerOnboardingRequestRepository,
            CategoryRepository categoryRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.userDetailRepository = userDetailRepository;
        this.userTypeRepository = userTypeRepository;
        this.hackathonRepository = hackathonRepository;
        this.judgeAssignmentRepository = judgeAssignmentRepository;
        this.teamRepository = teamRepository;
        this.teamMemberRepository = teamMemberRepository;
        this.hackathonApplicationRepository = hackathonApplicationRepository;
        this.judgeScoreRepository = judgeScoreRepository;
        this.paymentTransactionRepository = paymentTransactionRepository;
        this.submissionVersionRepository = submissionVersionRepository;
        this.notificationLogRepository = notificationLogRepository;
        this.auditLogRepository = auditLogRepository;
        this.organizerOnboardingRequestRepository = organizerOnboardingRequestRepository;
        this.categoryRepository = categoryRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(String... args) {
        logger.info("[SEED] Fresh demo seeding started...");

        clearExistingData();
        Map<String, Integer> userTypeIds = ensureUserTypes();
        if (userTypeIds.isEmpty()) {
            logger.warn("[SEED] User types missing; seeding aborted.");
            return;
        }

        seedCategories();

        UserEntity admin = createUser("Admin", "CodeVerse", "admin1@gmail.com", AppConstants.ROLE_ADMIN, 1001, userTypeIds.get(AppConstants.ROLE_ADMIN));
        List<UserEntity> organizers = createRoleUsers(AppConstants.ROLE_ORGANIZER, "org", ORGANIZER_NAMES, 2000, userTypeIds.get(AppConstants.ROLE_ORGANIZER));
        List<UserEntity> participants = createRoleUsers(AppConstants.ROLE_PARTICIPANT, "part", PARTICIPANT_NAMES, 3000, userTypeIds.get(AppConstants.ROLE_PARTICIPANT));
        List<UserEntity> judges = createRoleUsers(AppConstants.ROLE_JUDGE, "judge", JUDGE_NAMES, 4000, userTypeIds.get(AppConstants.ROLE_JUDGE));

        List<HackathonEntity> hackathons = seedHackathons(organizers, userTypeIds.get(AppConstants.ROLE_PARTICIPANT));
        seedJudgeAssignments(hackathons, organizers, judges);
        List<HackathonApplicationEntity> applications = seedTeamsAndApplications(hackathons, participants);
        seedSubmissionVersions(applications);
        seedPayments(applications, hackathons);
        seedScores(applications, hackathons, judges);

        logger.info("[SEED] Fresh demo seeding finished.");
        logger.info("[SEED] Login password for all seeded users: {}", DEFAULT_PASSWORD);
        logger.info("[SEED] Seeded users: admin={}, organizers={}, participants={}, judges={}",
                admin.getEmail(), organizers.size(), participants.size(), judges.size());
        logger.info("[SEED] Totals -> users={}, hackathons={}, teams={}, applications={}, judgeAssignments={}, scores={}",
            userRepository.count(),
            hackathonRepository.count(),
            teamRepository.count(),
            hackathonApplicationRepository.count(),
            judgeAssignmentRepository.count(),
            judgeScoreRepository.count());
    }

    private void clearExistingData() {
        submissionVersionRepository.deleteAllInBatch();
        judgeScoreRepository.deleteAllInBatch();
        paymentTransactionRepository.deleteAllInBatch();
        hackathonApplicationRepository.deleteAllInBatch();
        teamMemberRepository.deleteAllInBatch();
        teamRepository.deleteAllInBatch();
        judgeAssignmentRepository.deleteAllInBatch();
        notificationLogRepository.deleteAllInBatch();
        auditLogRepository.deleteAllInBatch();
        organizerOnboardingRequestRepository.deleteAllInBatch();
        hackathonRepository.deleteAllInBatch();
        categoryRepository.deleteAllInBatch();
        userDetailRepository.deleteAllInBatch();
        userRepository.deleteAllInBatch();
        logger.info("[SEED] Existing mutable data cleared.");
    }

    private Map<String, Integer> ensureUserTypes() {
        List<String> defaults = List.of(
            AppConstants.ROLE_PARTICIPANT,
            AppConstants.ROLE_JUDGE,
            AppConstants.ROLE_ORGANIZER,
            AppConstants.ROLE_ADMIN);

        Map<String, Integer> byRole = new HashMap<>();

        for (String typeName : defaults) {
            UserTypeEntity type = userTypeRepository.findByUserTypeIgnoreCase(typeName).orElseGet(() -> {
                UserTypeEntity created = new UserTypeEntity();
                created.setUserType(typeName);
                return userTypeRepository.save(created);
            });
            byRole.put(typeName, type.getUserTypeId());
        }
        return byRole;
    }

    private void seedCategories() {
        List<String> categories = List.of("AI/ML", "Web Development", "Cybersecurity", "Cloud & DevOps", "Mobile Apps");
        for (String categoryName : categories) {
            CategoryEntity category = new CategoryEntity();
            category.setCategoryName(categoryName);
            category.setActive(true);
            categoryRepository.save(category);
        }
    }

    private List<UserEntity> createRoleUsers(String role, String emailPrefix, String[] firstNames, int phoneBase,
            Integer userTypeId) {
        List<UserEntity> users = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            int serial = i + 1;
            String email = emailPrefix + serial + "@gmail.com";
            UserEntity user = createUser(firstNames[i], role.substring(0, 1) + role.substring(1).toLowerCase(), email, role,
                    phoneBase + serial, userTypeId);
            users.add(user);
        }
        return users;
    }

    private UserEntity createUser(String firstName, String lastName, String email, String role, int phoneSuffix,
            Integer userTypeId) {
        UserEntity user = new UserEntity();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(DEFAULT_PASSWORD));
        user.setRole(role);
        user.setGender("OTHER");
        user.setBirthYear(1998);
        user.setContactNum("90000" + String.format("%05d", phoneSuffix));
        user.setProfilePicURL(DEFAULT_PFP);
        user.setActive(true);
        user.setCreatedAt(LocalDate.now());
        user = userRepository.save(user);

        UserDetailEntity detail = new UserDetailEntity();
        detail.setUserId(user.getUserId());
        detail.setUserTypeId(userTypeId);
        detail.setQualification("B.Tech");
        detail.setCity("Ahmedabad");
        detail.setState("Gujarat");
        detail.setCountry("India");
        detail.setLinkedinUrl("https://www.linkedin.com/in/" + email.split("@")[0]);
        userDetailRepository.save(detail);

        return user;
    }

    private List<HackathonEntity> seedHackathons(List<UserEntity> organizers, Integer participantTypeId) {
        List<HackathonEntity> hackathons = new ArrayList<>();
        hackathons.add(createHackathon("[DEMO] Vision AI Sprint", organizers.get(0).getUserId(), participantTypeId,
            "UPCOMING", "ONLINE", "FREE", 0, 1, 4, "Ahmedabad", 0, 12, 14, 16, 17));
        hackathons.add(createHackathon("[DEMO] Cloud Cost Optimizer", organizers.get(1).getUserId(), participantTypeId,
            "UPCOMING", "HYBRID", "PAID", 199, 2, 5, "Bengaluru", -1, 10, 13, 15, 15));
        hackathons.add(createHackathon("[DEMO] Secure Stack Challenge", organizers.get(2).getUserId(), participantTypeId,
            "ONGOING", "OFFLINE", "PAID", 199, 2, 4, "Pune", -8, -1, 0, 2, 3));
        hackathons.add(createHackathon("[DEMO] Product UX Jam", organizers.get(3).getUserId(), participantTypeId,
            "COMPLETED", "ONLINE", "FREE", 0, 1, 3, "Mumbai", -25, -18, -16, -10, -9));
        hackathons.add(createHackathon("[DEMO] API Performance Cup", organizers.get(4).getUserId(), participantTypeId,
            "UPCOMING", "HYBRID", "FREE", 0, 1, 5, "Hyderabad", 1, 20, 22, 24, 25));
        hackathons.add(createHackathon("[DEMO] GreenTech Buildathon", organizers.get(0).getUserId(), participantTypeId,
            "UPCOMING", "OFFLINE", "PAID", 199, 2, 6, "Delhi", 2, 18, 20, 23, 23));
        return hackathons;
    }

    private HackathonEntity createHackathon(String title, Integer organizerUserId, Integer userTypeId, String status,
            String eventType, String payment, int entryFeeAmount, int minTeam, int maxTeam, String location, int regStartOffset,
            int regEndOffset, int eventStartOffset, int eventEndOffset, int submissionOffset) {
        LocalDate today = LocalDate.now();
        HackathonEntity hackathon = new HackathonEntity();
        hackathon.setTitle(title);
        hackathon.setDescription("Scenario-ready demo event for showcasing organizer, participant, and judge workflows.");
        hackathon.setStatus(status);
        hackathon.setEventType(eventType);
        hackathon.setPayment(payment);
        hackathon.setEntryFeeAmount(entryFeeAmount);
        hackathon.setMinTeamSize(minTeam);
        hackathon.setMaxTeamSize(maxTeam);
        hackathon.setLocation(location);
        hackathon.setProblemTitle("Build a working solution and ship a clean submission");
        hackathon.setProblemStatement("Create a practical product that solves a real-world workflow problem.");
        hackathon.setProblemConstraints("Use open-source stack, submit demo link, repo links, and brief report.");
        hackathon.setProblemDeliverables("Presentation, running demo, source code, and architecture notes.");
        hackathon.setEvaluationCriteria("Idea, design, implementation quality, and communication.");
        hackathon.setSubmissionChecklist("Demo URL, frontend repo, backend repo, and summary document.");
        hackathon.setUserTypeId(userTypeId);
        hackathon.setRegistrationStartDate(today.plusDays(regStartOffset));
        hackathon.setRegistrationEndDate(today.plusDays(regEndOffset));
        hackathon.setEventStartDate(today.plusDays(eventStartOffset));
        hackathon.setEventEndDate(today.plusDays(eventEndOffset));
        hackathon.setSubmissionDeadline(today.plusDays(submissionOffset));
        hackathon.setGracePeriodHours(24);
        hackathon.setUserId(organizerUserId);
        return hackathonRepository.save(hackathon);
    }

    private void seedJudgeAssignments(List<HackathonEntity> hackathons, List<UserEntity> organizers, List<UserEntity> judges) {
        for (int i = 0; i < hackathons.size(); i++) {
            HackathonEntity hackathon = hackathons.get(i);
            UserEntity primaryJudge = judges.get(i % judges.size());
            UserEntity secondaryJudge = judges.get((i + 1) % judges.size());
            Integer assignedBy = organizers.get(i % organizers.size()).getUserId();

            createJudgeAssignment(hackathon.getHackathonId(), primaryJudge.getUserId(), assignedBy, LocalDate.now().minusDays(3));
            if (!primaryJudge.getUserId().equals(secondaryJudge.getUserId())) {
                createJudgeAssignment(hackathon.getHackathonId(), secondaryJudge.getUserId(), assignedBy, LocalDate.now().minusDays(2));
            }
        }
    }

    private List<HackathonApplicationEntity> seedTeamsAndApplications(List<HackathonEntity> hackathons, List<UserEntity> participants) {
        List<HackathonApplicationEntity> applications = new ArrayList<>();

        TeamEntity team1 = createTeam(hackathons.get(0), participants.get(0), "Vision Sparks", participants.get(1));
        TeamEntity team2 = createTeam(hackathons.get(1), participants.get(1), "Cloud Riders", participants.get(2));
        TeamEntity team3 = createTeam(hackathons.get(1), participants.get(2), "Latency Hunters", participants.get(3));
        TeamEntity team4 = createTeam(hackathons.get(2), participants.get(3), "Firewall Ninjas", participants.get(4));
        TeamEntity team5 = createTeam(hackathons.get(3), participants.get(4), "UX Orbit", participants.get(0));

        applications.add(createApplication(hackathons.get(0), team1, participants.get(0), "APPLIED", "PENDING", 0));
        applications.add(createApplication(hackathons.get(1), team2, participants.get(1), "SHORTLISTED", "PAID", -1));
        applications.add(createApplication(hackathons.get(1), team3, participants.get(2), "REJECTED", "FAILED", -2));
        applications.add(createApplication(hackathons.get(2), team4, participants.get(3), "FINALIST", "PAID", -3));
        applications.add(createApplication(hackathons.get(3), team5, participants.get(4), "WINNER", "PENDING", -12));

        return applications;
    }

    private TeamEntity createTeam(HackathonEntity hackathon, UserEntity leader, String teamName, UserEntity... extraMembers) {
        TeamEntity team = new TeamEntity();
        team.setHackathonId(hackathon.getHackathonId());
        team.setTeamName(teamName);
        team.setLeaderUserId(leader.getUserId());
        team.setCreatedAt(LocalDate.now().minusDays(4));
        team = teamRepository.save(team);

        Integer teamId = team.getTeamId();
        createTeamMember(teamId, leader.getUserId());
        Arrays.stream(extraMembers).forEach(member -> createTeamMember(teamId, member.getUserId()));
        return team;
    }

    private void createTeamMember(Integer teamId, Integer userId) {
        TeamMemberEntity member = new TeamMemberEntity();
        member.setTeamId(teamId);
        member.setUserId(userId);
        teamMemberRepository.save(member);
    }

    private HackathonApplicationEntity createApplication(HackathonEntity hackathon, TeamEntity team, UserEntity participant,
            String status, String paymentStatus, int appliedDaysOffset) {
        HackathonApplicationEntity application = new HackathonApplicationEntity();
        application.setHackathonId(hackathon.getHackathonId());
        application.setTeamId(team.getTeamId());
        application.setParticipantUserId(participant.getUserId());
        application.setStatus(status);
        application.setPaymentStatus(paymentStatus);
        application.setAppliedAt(LocalDate.now().plusDays(appliedDaysOffset));

        if (!"APPLIED".equals(status)) {
            String handle = participant.getEmail().split("@")[0];
            application.setSubmissionUrl("https://demo.example.com/" + handle + "/" + applicationSafeSlug(hackathon.getTitle()));
            application.setSubmissionDescription("Demo submission showcasing working features for jury evaluation.");
            application.setFrontendGithubLink("https://github.com/codeverse-demo/" + handle + "-frontend");
            application.setBackendGithubLink("https://github.com/codeverse-demo/" + handle + "-backend");
            application.setSubmissionAttachmentUrl("https://files.example.com/" + handle + "/submission.pdf");
            application.setSubmissionAttachmentName(handle + "-submission.pdf");
        }

        return hackathonApplicationRepository.save(application);
    }

    private void seedSubmissionVersions(List<HackathonApplicationEntity> applications) {
        for (HackathonApplicationEntity application : applications) {
            if ("APPLIED".equals(application.getStatus()) || "REJECTED".equals(application.getStatus())) {
                continue;
            }

            SubmissionVersionEntity version = new SubmissionVersionEntity();
            version.setApplicationId(application.getApplicationId());
            version.setVersionNumber(1);
            version.setSubmissionUrl(application.getSubmissionUrl());
            version.setSubmissionDescription(application.getSubmissionDescription());
            version.setFrontendGithubLink(application.getFrontendGithubLink());
            version.setBackendGithubLink(application.getBackendGithubLink());
            version.setSubmissionAttachmentUrl(application.getSubmissionAttachmentUrl());
            version.setSubmissionAttachmentName(application.getSubmissionAttachmentName());
            version.setSubmittedAt(LocalDateTime.now().minusDays(2));
            version.setLocked("WINNER".equals(application.getStatus()) || "FINALIST".equals(application.getStatus()));
            submissionVersionRepository.save(version);
        }
    }

    private void seedPayments(List<HackathonApplicationEntity> applications, List<HackathonEntity> hackathons) {
        Map<Integer, HackathonEntity> hackathonById = new HashMap<>();
        for (HackathonEntity hackathon : hackathons) {
            hackathonById.put(hackathon.getHackathonId(), hackathon);
        }

        for (HackathonApplicationEntity application : applications) {
            HackathonEntity hackathon = hackathonById.get(application.getHackathonId());
            if (hackathon == null || "FREE".equalsIgnoreCase(hackathon.getPayment())) {
                continue;
            }

            PaymentTransactionEntity payment = new PaymentTransactionEntity();
            payment.setApplicationId(application.getApplicationId());
            payment.setAmount(199.00);
            payment.setStatus(application.getPaymentStatus());
            payment.setIdempotencyKey("seed-app-" + application.getApplicationId());
            payment.setGatewayTransactionId("TXN-SEED-" + application.getApplicationId());
            payment.setResponseMessage("PAID".equals(application.getPaymentStatus())
                    ? "Payment captured successfully"
                    : "Payment failed for demo scenario");
            payment.setWebhookVerified("PAID".equals(application.getPaymentStatus()));
            payment.setCreatedAt(LocalDateTime.now().minusDays(1));
            payment.setUpdatedAt(LocalDateTime.now().minusHours(4));
            paymentTransactionRepository.save(payment);
        }
    }

    private void seedScores(List<HackathonApplicationEntity> applications, List<HackathonEntity> hackathons,
            List<UserEntity> judges) {
        Map<Integer, HackathonEntity> hackathonById = new HashMap<>();
        for (HackathonEntity hackathon : hackathons) {
            hackathonById.put(hackathon.getHackathonId(), hackathon);
        }

        for (HackathonApplicationEntity application : applications) {
            if (!"FINALIST".equals(application.getStatus()) && !"WINNER".equals(application.getStatus())) {
                continue;
            }

            HackathonEntity hackathon = hackathonById.get(application.getHackathonId());
            if (hackathon == null) {
                continue;
            }

            UserEntity judgeA = judges.get(application.getApplicationId() % judges.size());
            UserEntity judgeB = judges.get((application.getApplicationId() + 1) % judges.size());

            createScore(hackathon.getHackathonId(), application.getApplicationId(), judgeA.getUserId(), 8, 8, 9, 8,
                    "Strong execution and clear storytelling.");
            createScore(hackathon.getHackathonId(), application.getApplicationId(), judgeB.getUserId(), 9, 8, 8, 9,
                    "Balanced solution with practical impact.");
        }
    }

    private void createScore(Integer hackathonId, Integer applicationId, Integer judgeUserId, int idea, int design,
            int execution, int pitch, String remarks) {
        JudgeScoreEntity score = new JudgeScoreEntity();
        score.setHackathonId(hackathonId);
        score.setApplicationId(applicationId);
        score.setJudgeUserId(judgeUserId);
        score.setIdeaScore(idea);
        score.setDesignScore(design);
        score.setExecutionScore(execution);
        score.setPitchScore(pitch);
        score.setScore(idea + design + execution + pitch);
        score.setRemarks(remarks);
        score.setScoredAt(LocalDate.now().minusDays(1));
        judgeScoreRepository.save(score);
    }

    private void createJudgeAssignment(Integer hackathonId, Integer judgeUserId, Integer assignedByUserId, LocalDate assignedAt) {
        JudgeAssignmentEntity assignment = new JudgeAssignmentEntity();
        assignment.setHackathonId(hackathonId);
        assignment.setJudgeUserId(judgeUserId);
        assignment.setAssignedByUserId(assignedByUserId);
        assignment.setAssignedAt(assignedAt);
        judgeAssignmentRepository.save(assignment);
    }

    private String applicationSafeSlug(String title) {
        return title.toLowerCase().replace("[demo]", "").trim().replaceAll("[^a-z0-9]+", "-");
    }
}

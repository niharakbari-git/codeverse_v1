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
import com.grownited.entity.NotificationLogEntity;
import com.grownited.entity.OrganizerOnboardingRequestEntity;
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

    private static final String DEFAULT_PASSWORD = "0000";
    private static final String DEFAULT_PFP = "/assets/images/faces/dummy.jpg";

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

        UserEntity admin = createUser("Arjun", "Sharma", "admin@gmail.com", AppConstants.ROLE_ADMIN,
                "9000012345", 1990, "MALE", DEFAULT_PFP, true, userTypeIds.get(AppConstants.ROLE_ADMIN),
                "MBA (Operations)", "New Delhi", "Delhi", "India",
                "https://www.linkedin.com/in/arjun-sharma-admin");

        List<UserEntity> organizers = createOrganizers(userTypeIds.get(AppConstants.ROLE_ORGANIZER));
        List<UserEntity> participants = createParticipants(userTypeIds.get(AppConstants.ROLE_PARTICIPANT));
        List<UserEntity> judges = createJudges(userTypeIds.get(AppConstants.ROLE_JUDGE));

        seedOrganizerRequests(admin);
        List<HackathonEntity> hackathons = seedHackathons(organizers, userTypeIds.get(AppConstants.ROLE_PARTICIPANT));
        seedJudgeAssignments(hackathons, organizers, judges, admin);

        List<TeamEntity> allTeams = seedTeams(hackathons, participants);
        List<HackathonApplicationEntity> applications = seedApplications(hackathons, allTeams, participants);

        seedSubmissionVersions(applications);
        seedPayments(applications, hackathons);
        seedScores(applications, hackathons, judges);
        seedNotificationLogs(admin, organizers, participants, judges, hackathons, applications);

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
        List<String> categories = List.of(
                "AI/ML",
                "Web Development",
                "Cybersecurity",
                "Cloud & DevOps",
                "Mobile Apps",
                "Blockchain",
                "UI/UX",
                "Data Science",
                "Sustainability",
                "FinTech");
        for (String categoryName : categories) {
            CategoryEntity category = new CategoryEntity();
            category.setCategoryName(categoryName);
            category.setActive(true);
            categoryRepository.save(category);
        }
    }

    private List<UserEntity> createParticipants(Integer userTypeId) {
        List<DemoUserSeed> seeds = List.of(
            new DemoUserSeed("Meera", "Rathi", "part1@gmail.com", "B.Tech Computer Science", "Mumbai", "Maharashtra", "India",
                    "https://www.linkedin.com/in/meera-rathi", "FEMALE", 2001, "9000111101", true),
            new DemoUserSeed("Aarav", "Patel", "part2@gmail.com", "B.Tech Artificial Intelligence", "Ahmedabad", "Gujarat", "India",
                    "https://www.linkedin.com/in/aarav-patel-ai", "MALE", 2000, "9000111102", true),
            new DemoUserSeed("Sanya", "Iyer", "part3@gmail.com", "B.Sc Data Science", "Bengaluru", "Karnataka", "India",
                    "https://www.linkedin.com/in/sanya-iyer", "FEMALE", 2002, "9000111103", true),
            new DemoUserSeed("Arjun", "Singh", "part4@gmail.com", "B.Tech Cybersecurity", "New Delhi", "Delhi", "India",
                    "https://www.linkedin.com/in/arjun-singh-cyber", "MALE", 1999, "9000111104", true),
            new DemoUserSeed("Riya", "Nair", "part5@gmail.com", "B.Des UI/UX", "Kochi", "Kerala", "India",
                    "https://www.linkedin.com/in/riya-nair-design", "FEMALE", 2001, "9000111105", true),
            new DemoUserSeed("Nikhil", "Verma", "part6@gmail.com", "B.Tech Cloud Computing", "Pune", "Maharashtra", "India",
                    "https://www.linkedin.com/in/nikhil-verma-cloud", "MALE", 2000, "9000111106", true),
            new DemoUserSeed("Sneha", "Gupta", "part7@gmail.com", "BCA Mobile Development", "Jaipur", "Rajasthan", "India",
                    "https://www.linkedin.com/in/sneha-gupta-mobile", "FEMALE", 2002, "9000111107", true),
            new DemoUserSeed("Zara", "Khan", "part8@gmail.com", "B.Tech Blockchain", "Hyderabad", "Telangana", "India",
                    "https://www.linkedin.com/in/zara-khan-blockchain", "FEMALE", 2000, "9000111108", true),
            new DemoUserSeed("Kunal", "Malhotra", "part9@gmail.com", "B.Tech FinTech", "Chennai", "Tamil Nadu", "India",
                    "https://www.linkedin.com/in/kunal-malhotra-fintech", "MALE", 2001, "9000111109", true),
            new DemoUserSeed("Priya", "Das", "part10@gmail.com", "B.Tech HealthTech", "Kolkata", "West Bengal", "India",
                    "https://www.linkedin.com/in/priya-das-healthtech", "FEMALE", 2001, "9000111110", true),
            new DemoUserSeed("Maya", "Sharma", "part11@gmail.com", "B.Tech Artificial Intelligence", "Lucknow", "Uttar Pradesh", "India",
                    null, "FEMALE", 2001, "9000111111", true),
            new DemoUserSeed("Devansh", "Mehta", "part12@gmail.com", "B.Tech Full Stack", "New Delhi", "Delhi", "India",
                    "https://www.linkedin.com/in/devansh-mehta", "MALE", 2000, "9000111112", false),
            new DemoUserSeed("Aditi", "Joshi", "part13@gmail.com", "B.Sc Data Science", "Noida", "Uttar Pradesh", "India",
                    "https://www.linkedin.com/in/aditi-joshi", "FEMALE", 1999, "9000111113", true),
            new DemoUserSeed("Harish", "Rao", "part14@gmail.com", "B.Tech Mobile Apps", "Visakhapatnam", "Andhra Pradesh", "India",
                    "https://www.linkedin.com/in/harish-rao-mobile", "MALE", 1999, "9000111114", true),
            new DemoUserSeed("Anika", "Roy", "part15@gmail.com", "B.Tech Sustainability", "Bengaluru", "Karnataka", "India",
                    "https://www.linkedin.com/in/anika-roy-sustainability", "FEMALE", 2000, "9000111115", true)
        );
        return createRoleUsers(seeds, AppConstants.ROLE_PARTICIPANT, userTypeId);
    }

    private List<UserEntity> createOrganizers(Integer userTypeId) {
        List<DemoUserSeed> seeds = List.of(
            new DemoUserSeed("Anant", "Mehta", "org1@gmail.com", "M.Tech Product Management", "Mumbai", "Maharashtra", "India",
                    "https://www.linkedin.com/in/anant-mehta", "MALE", 1990, "9000211101", true),
            new DemoUserSeed("Lila", "Shah", "org2@gmail.com", "MBA Event Management", "Ahmedabad", "Gujarat", "India",
                    "https://www.linkedin.com/in/lila-shah", "FEMALE", 1991, "9000211102", true),
            new DemoUserSeed("Rohan", "Desai", "org3@gmail.com", "B.Tech Innovation and Entrepreneurship", "Bengaluru", "Karnataka", "India",
                    "https://www.linkedin.com/in/rohan-desai", "MALE", 1992, "9000211103", true),
            new DemoUserSeed("Priyanka", "Kapoor", "org4@gmail.com", "B.Des Experience Design", "Delhi", "Delhi", "India",
                    "https://www.linkedin.com/in/priyanka-kapoor", "FEMALE", 1990, "9000211104", true),
            new DemoUserSeed("Vikram", "Nair", "org5@gmail.com", "MBA Sustainability", "Chennai", "Tamil Nadu", "India",
                    "https://www.linkedin.com/in/vikram-nair", "MALE", 1989, "9000211105", true),
            new DemoUserSeed("Neha", "Sethi", "org6@gmail.com", "B.Tech Biomedical", "Hyderabad", "Telangana", "India",
                    "https://www.linkedin.com/in/neha-sethi", "FEMALE", 1991, "9000211106", true),
            new DemoUserSeed("Tarun", "Bose", "org7@gmail.com", "B.Tech Finance", "Pune", "Maharashtra", "India",
                    "https://www.linkedin.com/in/tarun-bose", "MALE", 1988, "9000211107", true)
        );
        return createRoleUsers(seeds, AppConstants.ROLE_ORGANIZER, userTypeId);
    }

    private List<UserEntity> createJudges(Integer userTypeId) {
        List<DemoUserSeed> seeds = List.of(
            new DemoUserSeed("Dr. Kavita", "Rao", "judge1@gmail.com", "Ph.D Data Science", "Bengaluru", "Karnataka", "India",
                    "https://www.linkedin.com/in/kavita-rao", "FEMALE", 1984, "9000311101", true),
            new DemoUserSeed("Sanjay", "Kulkarni", "judge2@gmail.com", "M.Tech Cybersecurity", "Pune", "Maharashtra", "India",
                    "https://www.linkedin.com/in/sanjay-kulkarni", "MALE", 1985, "9000311102", true),
            new DemoUserSeed("Elena", "Cruz", "judge3@gmail.com", "M.Des Product Design", "Singapore", "Singapore", "Singapore",
                    "https://www.linkedin.com/in/elena-cruz", "FEMALE", 1986, "9000311103", true),
            new DemoUserSeed("Arun", "Mishra", "judge4@gmail.com", "Cloud Architect", "Bengaluru", "Karnataka", "India",
                    "https://www.linkedin.com/in/arun-mishra-cloud", "MALE", 1983, "9000311104", true),
            new DemoUserSeed("Priya", "Menon", "judge5@gmail.com", "Blockchain Strategist", "Hyderabad", "Telangana", "India",
                    "https://www.linkedin.com/in/priya-menon-blockchain", "FEMALE", 1987, "9000311105", true),
            new DemoUserSeed("Michael", "Chen", "judge6@gmail.com", "AI Research Lead", "Bangalore", "Karnataka", "India",
                    "https://www.linkedin.com/in/michael-chen-ai", "MALE", 1985, "9000311106", true)
        );
        return createRoleUsers(seeds, AppConstants.ROLE_JUDGE, userTypeId);
    }

    private List<UserEntity> createRoleUsers(List<DemoUserSeed> seeds, String role, Integer userTypeId) {
        List<UserEntity> users = new ArrayList<>();
        for (DemoUserSeed seed : seeds) {
            UserEntity user = createUser(seed.firstName, seed.lastName, seed.email, role,
                    seed.contactNum, seed.birthYear, seed.gender, seed.profilePicURL, seed.active,
                    userTypeId, seed.qualification, seed.city, seed.state, seed.country, seed.linkedinUrl);
            users.add(user);
        }
        return users;
    }

    private UserEntity createUser(String firstName, String lastName, String email, String role,
            String contactNum, int birthYear, String gender, String profilePicURL, boolean active,
            Integer userTypeId, String qualification, String city, String state, String country, String linkedinUrl) {
        UserEntity user = new UserEntity();
        user.setFirstName(firstName);
        user.setLastName(lastName);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(DEFAULT_PASSWORD));
        user.setRole(role);
        user.setGender(gender);
        user.setBirthYear(birthYear);
        user.setContactNum(contactNum);
        user.setProfilePicURL(profilePicURL);
        user.setActive(active);
        user.setCreatedAt(LocalDate.now().minusDays((int) (Math.random() * 45)));
        user = userRepository.save(user);

        UserDetailEntity detail = new UserDetailEntity();
        detail.setUserId(user.getUserId());
        detail.setUserTypeId(userTypeId);
        detail.setQualification(qualification);
        detail.setCity(city);
        detail.setState(state);
        detail.setCountry(country);
        detail.setLinkedinUrl(linkedinUrl);
        userDetailRepository.save(detail);

        return user;
    }

    private void seedOrganizerRequests(UserEntity admin) {
        OrganizerOnboardingRequestEntity pending = new OrganizerOnboardingRequestEntity();
        pending.setFirstName("Shreya");
        pending.setLastName("Mishra");
        pending.setEmail("futureorg1@gmail.com");
        pending.setPasswordHash(passwordEncoder.encode(DEFAULT_PASSWORD));
        pending.setContactNum("9000411101");
        pending.setOrganizationName("Campus Innovators Hub");
        pending.setCity("Nagpur");
        pending.setState("Maharashtra");
        pending.setCountry("India");
        pending.setLinkedinUrl("https://www.linkedin.com/in/shreya-mishra");
        pending.setWebsiteUrl("https://campusinnovators.in");
        pending.setEventExperience("Organized university hackathons and tech bootcamps for 400+ students.");
        pending.setStatus("PENDING");
        pending.setCreatedAt(LocalDate.now().minusDays(2));
        organizerOnboardingRequestRepository.save(pending);

        OrganizerOnboardingRequestEntity rejected = new OrganizerOnboardingRequestEntity();
        rejected.setFirstName("Rajat");
        rejected.setLastName("Joshi");
        rejected.setEmail("futureorg2@gmail.com");
        rejected.setPasswordHash(passwordEncoder.encode(DEFAULT_PASSWORD));
        rejected.setContactNum("9000411102");
        rejected.setOrganizationName("Local Startup Network");
        rejected.setCity("Bhopal");
        rejected.setState("Madhya Pradesh");
        rejected.setCountry("India");
        rejected.setLinkedinUrl("https://www.linkedin.com/in/rajat-joshi");
        rejected.setWebsiteUrl("https://localstartupnetwork.org");
        rejected.setEventExperience("Worked with local founders on product sprints and demo days.");
        rejected.setStatus("REJECTED");
        rejected.setReviewNotes("Please share more details about your event team and sponsorship commitments.");
        rejected.setCreatedAt(LocalDate.now().minusDays(10));
        rejected.setReviewedAt(LocalDate.now().minusDays(1));
        rejected.setReviewedByUserId(admin.getUserId());
        rejected.setApprovedUserId(admin.getUserId());
        organizerOnboardingRequestRepository.save(rejected);
    }

    private List<HackathonEntity> seedHackathons(List<UserEntity> organizers, Integer participantTypeId) {
        List<HackathonEntity> hackathons = new ArrayList<>();
        hackathons.add(createHackathon("Connected Campus: AI Sprint", organizers.get(0).getUserId(), participantTypeId,
                "UPCOMING", "ONLINE", "OPEN", "FREE", 0, 1, 4, "Ahmedabad", -2, 12, 18, 20, 19,
                "gmail.com", "CAMPUSAI2026", "AI on campus, smart learning and student-friendly product ideas.",
                "Build a polished AI-powered campus assistant for mentoring, schedules, and tutoring."));
        hackathons.add(createHackathon("FinEdge Innovation Challenge", organizers.get(6).getUserId(), participantTypeId,
                "ONGOING", "HYBRID", "OPEN", "PAID", 299, 2, 5, "Pune", -20, 2, -1, 3, 2,
                "gmail.com,hotmail.com", "FINEDGE2026", "FinTech product ideas with real customer workflows.",
                "Design a minimum viable financial product that improves payment journeys or budgeting."));
        hackathons.add(createHackathon("SecureChain Web3 Challenge", organizers.get(2).getUserId(), participantTypeId,
                "ONGOING", "OFFLINE", "INVITE ONLY", "PAID", 399, 2, 5, "Bengaluru", -10, -1, -3, 1, 1,
                "gmail.com", "SECURECHAIN2026", "Create a secure Web3 utility for governance, identity, or DeFi.",
                "Build a blockchain-native solution with wallet integrations and strong security controls."));
        hackathons.add(createHackathon("HealthyPulse Hack", organizers.get(5).getUserId(), participantTypeId,
                "COMPLETED", "ONLINE", "OPEN", "FREE", 0, 1, 3, "Remote", -40, -35, -30, -26, -27,
                "gmail.com", "HEALTHPULSE2026", "HealthTech platforms that make care personal, accessible and efficient.",
                "Create a patient-centric tool, telehealth workflow or preventive health analytics dashboard."));
        hackathons.add(createHackathon("GreenGrid Sustainability Sprint", organizers.get(4).getUserId(), participantTypeId,
                "UPCOMING", "OFFLINE", "OPEN", "PAID", 249, 2, 6, "Chennai", 3, 18, 23, 25, 24,
                "gmail.com", "GREENGRID2026", "Sustainable solutions that reduce carbon, waste or resource use.",
                "Build a working prototype for waste tracking, energy efficiency or urban sustainability."));
        hackathons.add(createHackathon("Startup Product Jam", organizers.get(3).getUserId(), participantTypeId,
                "UPCOMING", "HYBRID", "OPEN", "FREE", 0, 1, 4, "Delhi", 5, 28, 33, 35, 34,
                "gmail.com", "STARTUPJAM2026", "Startup-focused product and Go-to-market hackathon.",
                "Build an MVP, user validation flow and investor-ready pitch deck."));
        hackathons.add(createHackathon("MobileSprint 2026", organizers.get(1).getUserId(), participantTypeId,
                "CANCELLED", "ONLINE", "OPEN", "FREE", 0, 1, 4, "Remote", -28, -24, -22, -20, -21,
                "gmail.com", "MOBILESPRINT2026", "Mobile-first product ideas for consumers and communities.",
                "Create a mobile prototype with polished flows and onboarding UX."));
        hackathons.add(createHackathon("CloudLaunch Developer Cup", organizers.get(0).getUserId(), participantTypeId,
                "DRAFT", "ONLINE", "OPEN", "FREE", 0, 1, 5, "Remote", 30, 40, 45, 47, 46,
                "gmail.com", "CLOUDLAUNCH2026", "Cloud and DevOps tooling for deployment, automation and monitoring.",
                "Create a platform or dashboard that simplifies cloud workflow, costs, or observability."));
        hackathons.add(createHackathon("DataDriven Smart City Challenge", organizers.get(1).getUserId(), participantTypeId,
                "UPCOMING", "HYBRID", "OPEN", "PAID", 299, 2, 5, "Hyderabad", 1, 14, 18, 20, 19,
                "gmail.com", "SMARTCITY2026", "Urban innovation with data, mobility, safety and citizen services.",
                "Build a data-driven solution for public services, transport, or urban sustainability."));
        return hackathons;
    }

    private HackathonEntity createHackathon(String title, Integer organizerUserId, Integer userTypeId,
            String status, String eventType, String participationScope, String payment, int entryFeeAmount,
            int minTeam, int maxTeam, String location, int regStartOffset, int regEndOffset,
            int eventStartOffset, int eventEndOffset, int submissionOffset,
            String allowedEmailDomains, String invitationCode, String shortDescription, String problemStatement) {
        LocalDate today = LocalDate.now();
        HackathonEntity hackathon = new HackathonEntity();
        hackathon.setTitle(title);
        hackathon.setDescription(shortDescription + "\n\n" + problemStatement);
        hackathon.setStatus(status);
        hackathon.setEventType(eventType);
        hackathon.setParticipationScope(participationScope);
        hackathon.setAllowedEmailDomains(allowedEmailDomains);
        hackathon.setInvitationCode(invitationCode);
        hackathon.setPayment(payment);
        hackathon.setEntryFeeAmount(entryFeeAmount);
        hackathon.setMinTeamSize(minTeam);
        hackathon.setMaxTeamSize(maxTeam);
        hackathon.setLocation(location);
        hackathon.setProblemTitle(problemStatement);
        hackathon.setProblemStatement(problemStatement + "\nEnsure the final submission includes user flows, architecture diagrams and a demo link.");
        hackathon.setProblemConstraints("Use open-source stacks. Prefer mobile, web or cloud integrations.");
        hackathon.setProblemDeliverables("Submit source code, deployment instructions, demo video link and a short technical summary.");
        hackathon.setEvaluationCriteria("Innovation, relevance, technical quality, demo clarity and design.");
        hackathon.setSubmissionChecklist("Working prototype, repository links, presentation deck and summary document.");
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

    private List<TeamEntity> seedTeams(List<HackathonEntity> hackathons, List<UserEntity> participants) {
        List<TeamEntity> teams = new ArrayList<>();
        teams.add(createTeam(hackathons.get(0), participants.get(0), "AlphaMesh", participants.get(2), participants.get(3)));
        teams.add(createTeam(hackathons.get(0), participants.get(4), "SoloSpark"));
        teams.add(createTeam(hackathons.get(0), participants.get(5), "Campus Connect", participants.get(1), participants.get(10), participants.get(11), participants.get(12)));
        teams.add(createTeam(hackathons.get(1), participants.get(6), "FinCrafters", participants.get(7), participants.get(8)));
        teams.add(createTeam(hackathons.get(1), participants.get(9), "LedgerLoop"));
        teams.add(createTeam(hackathons.get(1), participants.get(13), "BlockBridge", participants.get(14)));
        teams.add(createTeam(hackathons.get(2), participants.get(3), "CipherGuard", participants.get(1)));
        teams.add(createTeam(hackathons.get(2), participants.get(7), "NinjaProxy", participants.get(5)));
        teams.add(createTeam(hackathons.get(3), participants.get(9), "MediMesh", participants.get(2)));
        teams.add(createTeam(hackathons.get(3), participants.get(10), "HealthHues", participants.get(0)));
        teams.add(createTeam(hackathons.get(5), participants.get(12), "PixelPulse"));
        teams.add(createTeam(hackathons.get(5), participants.get(13), "SprintFlow", participants.get(14)));
        return teams;
    }

    private TeamEntity createTeam(HackathonEntity hackathon, UserEntity leader, String teamName, UserEntity... extraMembers) {
        TeamEntity team = new TeamEntity();
        team.setHackathonId(hackathon.getHackathonId());
        team.setTeamName(teamName);
        team.setLeaderUserId(leader.getUserId());
        team.setCreatedAt(LocalDate.now().minusDays(10));
        TeamEntity savedTeam = teamRepository.save(team);

        createTeamMember(savedTeam.getTeamId(), leader.getUserId());
        Arrays.stream(extraMembers).forEach(member -> createTeamMember(savedTeam.getTeamId(), member.getUserId()));
        return savedTeam;
    }

    private void createTeamMember(Integer teamId, Integer userId) {
        TeamMemberEntity member = new TeamMemberEntity();
        member.setTeamId(teamId);
        member.setUserId(userId);
        teamMemberRepository.save(member);
    }

    private List<HackathonApplicationEntity> seedApplications(List<HackathonEntity> hackathons, List<TeamEntity> teams,
            List<UserEntity> participants) {
        List<HackathonApplicationEntity> applications = new ArrayList<>();

        applications.add(createApplication(hackathons.get(0), teams.get(0), participants.get(0), "APPLIED", "PENDING", 0,
                null, null, null, null, null));
        applications.add(createApplication(hackathons.get(0), teams.get(1), participants.get(4), "APPLIED", "PENDING", 1,
                null, null, null, null, null));
        applications.add(createApplication(hackathons.get(0), teams.get(2), participants.get(5), "SHORTLISTED", "PAID", -3,
                "https://demo.campusconnect.ai", "Campus assistant for mentoring and schedule planning.",
                "https://github.com/part6/campus-connect-frontend", "https://github.com/part6/campus-connect-backend",
                "CampusConnect-submission.pdf"));

        applications.add(createApplication(hackathons.get(1), teams.get(3), participants.get(6), "FINALIST", "PAID", -6,
                "https://finedge.app", "A cross-border payment dashboard for small businesses.",
                "https://github.com/part6/finedge-frontend", "https://github.com/part6/finedge-backend",
                "FinCrafters-submission.pdf"));
        applications.add(createApplication(hackathons.get(1), teams.get(4), participants.get(9), "SHORTLISTED", "PAID", -5,
                "https://ledgerloop.app", "A smart billing assistant for gig workers.",
                "https://github.com/part10/ledgerloop-frontend", null,
                "LedgerLoop-submission.pdf"));
        applications.add(createApplication(hackathons.get(1), teams.get(5), participants.get(13), "REJECTED", "FAILED", -8,
                null, null, null, null, null));

        applications.add(createApplication(hackathons.get(2), teams.get(6), participants.get(3), "FINALIST", "PAID", -9,
                "https://cipherguard.io", "Endpoint threat detection for API-first applications.",
                "https://github.com/part4/cipherguard-frontend", "https://github.com/part4/cipherguard-backend",
                "CipherGuard-submission.pdf"));
        applications.add(createApplication(hackathons.get(2), teams.get(7), participants.get(7), "WINNER", "PAID", -7,
                "https://ninjaproxy.network", "Adaptive firewall and zero trust policy manager.",
                "https://github.com/part8/ninjaproxy-frontend", "https://github.com/part8/ninjaproxy-backend",
                "NinjaProxy-submission.pdf"));

        applications.add(createApplication(hackathons.get(3), teams.get(8), participants.get(9), "WINNER", "PAID", -20,
                "https://medimesh.health", "Patient intake and remote care coordination platform.",
                "https://github.com/part10/medimesh-frontend", "https://github.com/part10/medimesh-backend",
                "MediMesh-submission.pdf"));
        applications.add(createApplication(hackathons.get(3), teams.get(9), participants.get(10), "REJECTED", "PAID", -22,
                "https://healthhues.app", "Incomplete care companion experience for senior patients.",
                "https://github.com/part11/healthhues-frontend", "https://github.com/part11/healthhues-backend",
                "HealthHues-submission.pdf"));

        applications.add(createApplication(hackathons.get(5), teams.get(10), participants.get(12), "APPLIED", "FAILED", -2,
                "https://pixelpulse.app", null,
                "https://github.com/part13/pixelpulse-frontend", null,
                null));
        applications.add(createApplication(hackathons.get(5), teams.get(11), participants.get(13), "SHORTLISTED", "PENDING", -3,
                null, "Early submission in progress with incomplete documentation.",
                null, null, null));

        TeamEntity soloFuture = createTeam(hackathons.get(4), participants.get(14), "EcoPulse Solo");
        applications.add(createApplication(hackathons.get(4), soloFuture, participants.get(14), "APPLIED", "PENDING", -1,
                null, null, null, null, null));

        return applications;
    }

    private HackathonApplicationEntity createApplication(HackathonEntity hackathon, TeamEntity team, UserEntity participant,
            String status, String paymentStatus, int appliedDaysOffset, String submissionUrl,
            String submissionDescription, String frontendGithubLink, String backendGithubLink,
            String submissionAttachmentName) {
        HackathonApplicationEntity application = new HackathonApplicationEntity();
        application.setHackathonId(hackathon.getHackathonId());
        application.setTeamId(team.getTeamId());
        application.setParticipantUserId(participant.getUserId());
        application.setStatus(status);
        application.setPaymentStatus(paymentStatus);
        application.setAppliedAt(LocalDate.now().plusDays(appliedDaysOffset));
        application.setSubmissionUrl(submissionUrl);
        application.setSubmissionDescription(submissionDescription);
        application.setFrontendGithubLink(frontendGithubLink);
        application.setBackendGithubLink(backendGithubLink);
        if (submissionAttachmentName != null) {
            application.setSubmissionAttachmentName(submissionAttachmentName);
            application.setSubmissionAttachmentUrl("https://files.codeverse.com/" + participant.getEmail().split("@")[0] + "/" + submissionAttachmentName);
        }
        return hackathonApplicationRepository.save(application);
    }

    private void seedSubmissionVersions(List<HackathonApplicationEntity> applications) {
        for (HackathonApplicationEntity application : applications) {
            if (application.getSubmissionUrl() == null && application.getSubmissionAttachmentUrl() == null) {
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

            if ("WINNER".equals(application.getStatus())) {
                SubmissionVersionEntity secondVersion = new SubmissionVersionEntity();
                secondVersion.setApplicationId(application.getApplicationId());
                secondVersion.setVersionNumber(2);
                secondVersion.setSubmissionUrl(application.getSubmissionUrl());
                secondVersion.setSubmissionDescription(application.getSubmissionDescription() + " Updated with final demo notes and product video.");
                secondVersion.setFrontendGithubLink(application.getFrontendGithubLink());
                secondVersion.setBackendGithubLink(application.getBackendGithubLink());
                secondVersion.setSubmissionAttachmentUrl(application.getSubmissionAttachmentUrl());
                secondVersion.setSubmissionAttachmentName(application.getSubmissionAttachmentName());
                secondVersion.setSubmittedAt(LocalDateTime.now().minusDays(1));
                secondVersion.setLocked(true);
                submissionVersionRepository.save(secondVersion);
            }
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
            payment.setAmount(hackathon.getEntryFeeAmount() * 1.0);
            payment.setStatus(application.getPaymentStatus());
            payment.setIdempotencyKey("seed-app-" + application.getApplicationId());
            payment.setGatewayOrderId("ORD-SEED-" + application.getApplicationId());
            payment.setGatewayTransactionId("TXN-SEED-" + application.getApplicationId());
            payment.setCurrency("INR");
            payment.setResponseMessage("PAID".equals(application.getPaymentStatus())
                    ? "Payment captured successfully"
                    : "Payment failed or is pending for demo verification.");
            payment.setWebhookVerified("PAID".equals(application.getPaymentStatus()));
            payment.setCreatedAt(LocalDateTime.now().minusDays(1));
            payment.setUpdatedAt(LocalDateTime.now().minusHours(4));
            paymentTransactionRepository.save(payment);
        }
    }

    private void seedScores(List<HackathonApplicationEntity> applications, List<HackathonEntity> hackathons,
            List<UserEntity> judges) {
        for (HackathonApplicationEntity application : applications) {
            if (!"FINALIST".equals(application.getStatus()) && !"WINNER".equals(application.getStatus())
                    && !"SHORTLISTED".equals(application.getStatus())) {
                continue;
            }

            UserEntity judgeA = judges.get(application.getApplicationId() % judges.size());
            UserEntity judgeB = judges.get((application.getApplicationId() + 1) % judges.size());

            if ("WINNER".equals(application.getStatus())) {
                createScore(application.getHackathonId(), application.getApplicationId(), judgeA.getUserId(), 9, 9, 9, 9,
                        "Outstanding delivery, strong demonstration, and clear product vision.");
                createScore(application.getHackathonId(), application.getApplicationId(), judgeB.getUserId(), 9, 8, 9, 9,
                        "High-potential solution with scalable architecture.");
            } else if ("FINALIST".equals(application.getStatus())) {
                createScore(application.getHackathonId(), application.getApplicationId(), judgeA.getUserId(), 8, 8, 8, 8,
                        "Well-structured project with good presentation.");
                createScore(application.getHackathonId(), application.getApplicationId(), judgeB.getUserId(), 8, 7, 8, 8,
                        "Clear concept and solid progress. Needs more polish.");
            } else if ("SHORTLISTED".equals(application.getStatus())) {
                createScore(application.getHackathonId(), application.getApplicationId(), judgeA.getUserId(), 7, 7, 7, 8,
                        "Strong UX and concept, execution is progressing well.");
                if (application.getApplicationId() % 2 == 0) {
                    createScore(application.getHackathonId(), application.getApplicationId(), judgeB.getUserId(), 6, 7, 7, 6,
                            "Good direction, but submission needs more depth.");
                }
            }
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

    private void seedJudgeAssignments(List<HackathonEntity> hackathons, List<UserEntity> organizers,
            List<UserEntity> judges, UserEntity admin) {
        for (int i = 0; i < hackathons.size(); i++) {
            HackathonEntity hackathon = hackathons.get(i);
            UserEntity judgeA = judges.get(i % judges.size());
            UserEntity judgeB = judges.get((i + 2) % judges.size());
            Integer assignedBy = (i % 2 == 0) ? admin.getUserId() : organizers.get(i % organizers.size()).getUserId();
            createJudgeAssignment(hackathon.getHackathonId(), judgeA.getUserId(), assignedBy, LocalDate.now().minusDays(3));
            if (!judgeA.getUserId().equals(judgeB.getUserId())) {
                createJudgeAssignment(hackathon.getHackathonId(), judgeB.getUserId(), assignedBy, LocalDate.now().minusDays(2));
            }
        }
    }

    private void seedNotificationLogs(UserEntity admin, List<UserEntity> organizers, List<UserEntity> participants,
            List<UserEntity> judges, List<HackathonEntity> hackathons, List<HackathonApplicationEntity> applications) {
        createNotification(admin.getUserId(), "ADMIN_ALERT", "EMAIL",
                "Two new organizer onboarding requests are awaiting your review.", null,
                LocalDateTime.now().minusHours(5), true);
        createNotification(organizers.get(0).getUserId(), "EVENT_PUBLISHED", "IN_APP",
                "Your hackathon 'Connected Campus: AI Sprint' is now visible to participants.", hackathons.get(0).getHackathonId(),
                LocalDateTime.now().minusDays(1), true);
        createNotification(organizers.get(2).getUserId(), "JUDGE_ASSIGNED", "EMAIL",
                "Judge Dr. Kavita Rao has been assigned to SecureChain Web3 Challenge.", hackathons.get(2).getHackathonId(),
                LocalDateTime.now().minusDays(2), true);
        createNotification(participants.get(0).getUserId(), "APPLICATION_RECEIVED", "IN_APP",
                "Your application for Connected Campus: AI Sprint has been received.", applications.get(0).getApplicationId(),
                LocalDateTime.now().minusDays(1), true);
        createNotification(participants.get(9).getUserId(), "PAYMENT_FAILED", "EMAIL",
                "Your payment for FinEdge Innovation Challenge could not be completed.", applications.get(4).getApplicationId(),
                LocalDateTime.now().minusHours(20), false);
        createNotification(judges.get(4).getUserId(), "REVIEW_REMINDER", "IN_APP",
                "You have pending evaluations for SecureChain Web3 Challenge.", hackathons.get(2).getHackathonId(),
                LocalDateTime.now().minusHours(3), true);
    }

    private void createNotification(Integer userId, String type, String channel, String message,
            Integer relatedEntityId, LocalDateTime sentAt, boolean delivered) {
        NotificationLogEntity notification = new NotificationLogEntity();
        notification.setUserId(userId);
        notification.setType(type);
        notification.setChannel(channel);
        notification.setMessage(message);
        notification.setRelatedEntityId(relatedEntityId);
        notification.setSentAt(sentAt);
        notification.setDelivered(delivered);
        notificationLogRepository.save(notification);
    }

    private void createJudgeAssignment(Integer hackathonId, Integer judgeUserId, Integer assignedByUserId, LocalDate assignedAt) {
        JudgeAssignmentEntity assignment = new JudgeAssignmentEntity();
        assignment.setHackathonId(hackathonId);
        assignment.setJudgeUserId(judgeUserId);
        assignment.setAssignedByUserId(assignedByUserId);
        assignment.setAssignedAt(assignedAt);
        judgeAssignmentRepository.save(assignment);
    }

    private static class DemoUserSeed {
        private final String firstName;
        private final String lastName;
        private final String email;
        private final String qualification;
        private final String city;
        private final String state;
        private final String country;
        private final String linkedinUrl;
        private final String gender;
        private final int birthYear;
        private final String contactNum;
        private final boolean active;
        private final String profilePicURL;

        DemoUserSeed(String firstName, String lastName, String email, String qualification,
                String city, String state, String country, String linkedinUrl,
                String gender, int birthYear, String contactNum, boolean active) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.email = email;
            this.qualification = qualification;
            this.city = city;
            this.state = state;
            this.country = country;
            this.linkedinUrl = linkedinUrl;
            this.gender = gender;
            this.birthYear = birthYear;
            this.contactNum = contactNum;
            this.active = active;
            this.profilePicURL = DEFAULT_PFP;
        }
    }

    private String applicationSafeSlug(String title) {
        return title.toLowerCase().replace("[demo]", "").trim().replaceAll("[^a-z0-9]+", "-");
    }
}

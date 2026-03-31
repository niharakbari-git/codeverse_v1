package com.grownited.config;

import java.time.LocalDate;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.grownited.entity.HackathonEntity;
import com.grownited.entity.JudgeAssignmentEntity;
import com.grownited.entity.UserDetailEntity;
import com.grownited.entity.UserEntity;
import com.grownited.entity.UserTypeEntity;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.JudgeAssignmentRepository;
import com.grownited.repository.UserDetailRepository;
import com.grownited.repository.UserRepository;
import com.grownited.repository.UserTypeRepository;

@Component
@ConditionalOnProperty(name = "app.seed-demo-data", havingValue = "true")
public class DemoDataSeeder implements CommandLineRunner {

    private static final String DEFAULT_PASSWORD = "00000000";
    private static final String DEMO_PREFIX = "[DEMO]";

    private final UserRepository userRepository;
    private final UserDetailRepository userDetailRepository;
    private final UserTypeRepository userTypeRepository;
    private final HackathonRepository hackathonRepository;
    private final JudgeAssignmentRepository judgeAssignmentRepository;
    private final PasswordEncoder passwordEncoder;

    public DemoDataSeeder(
            UserRepository userRepository,
            UserDetailRepository userDetailRepository,
            UserTypeRepository userTypeRepository,
            HackathonRepository hackathonRepository,
            JudgeAssignmentRepository judgeAssignmentRepository,
            PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.userDetailRepository = userDetailRepository;
        this.userTypeRepository = userTypeRepository;
        this.hackathonRepository = hackathonRepository;
        this.judgeAssignmentRepository = judgeAssignmentRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public void run(String... args) {
        System.out.println("[SEED] Demo data seeding started...");

        List<UserTypeEntity> userTypes = ensureUserTypes();
        if (userTypes.isEmpty()) {
            System.out.println("[SEED] No user types available. Seeding aborted.");
            return;
        }

        UserEntity admin = upsertUser("Admin", "CodeVerse", "admin@codeverse.dev", "ADMIN", "9876500001");
        UserEntity organizer = upsertUser("Om", "Organizer", "organizer1@codeverse.dev", "ORGANIZER", "9876500005");
        UserEntity participant1 = upsertUser("Nihar", "Participant", "participant1@codeverse.dev", "PARTICIPANT", "9876500002");
        UserEntity participant2 = upsertUser("Aarav", "Participant", "participant2@codeverse.dev", "PARTICIPANT", "9876500003");
        UserEntity judge = upsertUser("Riya", "Judge", "judge1@codeverse.dev", "JUDGE", "9876500004");

        Integer defaultUserTypeId = userTypes.get(0).getUserTypeId();
        upsertUserDetail(organizer.getUserId(), defaultUserTypeId, "B.Tech", "Ahmedabad", "Gujarat", "India");
        upsertUserDetail(participant1.getUserId(), defaultUserTypeId, "B.Tech", "Ahmedabad", "Gujarat", "India");
        upsertUserDetail(participant2.getUserId(), defaultUserTypeId, "MCA", "Surat", "Gujarat", "India");
        upsertUserDetail(judge.getUserId(), defaultUserTypeId, "M.Tech", "Vadodara", "Gujarat", "India");

        List<Integer> creatorUserIds = List.of(admin.getUserId(), organizer.getUserId(), participant1.getUserId(), judge.getUserId());
        seedHackathons(userTypes, creatorUserIds);
        seedJudgeAssignments(organizer.getUserId(), judge.getUserId());

        System.out.println("[SEED] Demo data seeding finished.");
        System.out.println("[SEED] Test password for all seeded users: " + DEFAULT_PASSWORD);
    }

    private List<UserTypeEntity> ensureUserTypes() {
        List<String> defaults = List.of("Working Professional", "Fresher", "College Student", "School Student");
        List<UserTypeEntity> allTypes = userTypeRepository.findAll();

        for (String typeName : defaults) {
            boolean exists = allTypes.stream().anyMatch(t -> typeName.equalsIgnoreCase(t.getUserType()));
            if (!exists) {
                UserTypeEntity type = new UserTypeEntity();
                type.setUserType(typeName);
                userTypeRepository.save(type);
            }
        }

        return userTypeRepository.findAll();
    }

    private UserEntity upsertUser(String firstName, String lastName, String email, String role, String contact) {
        return userRepository.findByEmail(email).map(existing -> {
            existing.setFirstName(firstName);
            existing.setLastName(lastName);
            existing.setRole(role);
            existing.setContactNum(contact);
            existing.setGender(existing.getGender() == null ? "OTHER" : existing.getGender());
            existing.setBirthYear(existing.getBirthYear() == null ? 1995 : existing.getBirthYear());
            existing.setActive(true);
            if (existing.getCreatedAt() == null) {
                existing.setCreatedAt(LocalDate.now());
            }
            existing.setPassword(passwordEncoder.encode(DEFAULT_PASSWORD));
            return userRepository.save(existing);
        }).orElseGet(() -> {
            UserEntity user = new UserEntity();
            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setEmail(email);
            user.setPassword(passwordEncoder.encode(DEFAULT_PASSWORD));
            user.setRole(role);
            user.setGender("OTHER");
            user.setBirthYear(1995);
            user.setContactNum(contact);
            user.setActive(true);
            user.setCreatedAt(LocalDate.now());
            return userRepository.save(user);
        });
    }

    private void upsertUserDetail(Integer userId, Integer userTypeId, String qualification, String city, String state, String country) {
        UserDetailEntity userDetail = userDetailRepository.findByUserId(userId).orElseGet(UserDetailEntity::new);
        userDetail.setUserId(userId);
        userDetail.setUserTypeId(userTypeId);
        userDetail.setQualification(qualification);
        userDetail.setCity(city);
        userDetail.setState(state);
        userDetail.setCountry(country);
        userDetailRepository.save(userDetail);
    }

    private void seedHackathons(List<UserTypeEntity> userTypes, List<Integer> creatorUserIds) {
        List<HackathonEntity> existing = hackathonRepository.findAll();
        long existingDemoCount = existing.stream()
                .filter(h -> h.getTitle() != null && h.getTitle().startsWith(DEMO_PREFIX))
                .count();

        int targetCount = 10;
        int toCreate = targetCount - (int) existingDemoCount;
        if (toCreate <= 0) {
            System.out.println("[SEED] Demo hackathons already present: " + existingDemoCount);
            return;
        }

        Random random = new Random();
        List<String> domains = List.of("AI/ML", "Web3", "Cloud", "Cybersecurity", "Mobile", "DevOps");
        List<String> formats = List.of("ONLINE", "OFFLINE", "HYBRID");
        List<String> payments = List.of("FREE", "PAID");
        List<String> statuses = List.of("UPCOMING", "ONGOING", "COMPLETED");
        List<String> cities = List.of("Ahmedabad", "Bengaluru", "Mumbai", "Pune", "Hyderabad", "Delhi");

        List<String> usedTitles = existing.stream()
                .map(HackathonEntity::getTitle)
                .filter(t -> t != null)
                .collect(Collectors.toSet())
                .stream().toList();

        int nextIndex = (int) existingDemoCount + 1;
        int created = 0;
        while (created < toCreate) {
            String domain = domains.get(random.nextInt(domains.size()));
            String title = DEMO_PREFIX + " " + domain + " Challenge " + nextIndex;
            nextIndex++;

            if (usedTitles.contains(title)) {
                continue;
            }

            int minTeam = 1 + random.nextInt(3);
            int maxTeam = minTeam + 1 + random.nextInt(3);
            LocalDate startDate = LocalDate.now().plusDays(random.nextInt(20) + 1);
            LocalDate endDate = startDate.plusDays(random.nextInt(15) + 3);

            UserTypeEntity anyType = userTypes.get(random.nextInt(userTypes.size()));
            Integer creatorId = creatorUserIds.get(random.nextInt(creatorUserIds.size()));

            HackathonEntity hackathon = new HackathonEntity();
            hackathon.setTitle(title);
            hackathon.setDescription("Demo listing for " + domain + " enthusiasts. Build, collaborate, and showcase your prototype.");
            hackathon.setStatus(statuses.get(random.nextInt(statuses.size())));
            hackathon.setEventType(formats.get(random.nextInt(formats.size())));
            hackathon.setPayment(payments.get(random.nextInt(payments.size())));
            hackathon.setMinTeamSize(minTeam);
            hackathon.setMaxTeamSize(maxTeam);
            hackathon.setLocation(cities.get(random.nextInt(cities.size())));
            hackathon.setUserTypeId(anyType.getUserTypeId());
            hackathon.setRegistrationStartDate(startDate);
            hackathon.setRegistrationEndDate(endDate);
            hackathon.setUserId(creatorId);

            hackathonRepository.save(hackathon);
            created++;
        }

        System.out.println("[SEED] Created demo hackathons: " + created);
    }

    private void seedJudgeAssignments(Integer organizerUserId, Integer judgeUserId) {
        List<HackathonEntity> organizerHackathons = hackathonRepository.findByUserId(organizerUserId);
        if (organizerHackathons.isEmpty()) {
                HackathonEntity organizerHackathon = new HackathonEntity();
                organizerHackathon.setTitle(DEMO_PREFIX + " Organizer Evaluation Event");
                organizerHackathon.setDescription("Organizer-owned demo hackathon for judge assignment flow.");
                organizerHackathon.setStatus("UPCOMING");
                organizerHackathon.setEventType("ONLINE");
                organizerHackathon.setPayment("FREE");
                organizerHackathon.setMinTeamSize(1);
                organizerHackathon.setMaxTeamSize(4);
                organizerHackathon.setLocation("Ahmedabad");
                organizerHackathon.setUserTypeId(userTypeRepository.findAll().get(0).getUserTypeId());
                organizerHackathon.setRegistrationStartDate(LocalDate.now().plusDays(1));
                organizerHackathon.setRegistrationEndDate(LocalDate.now().plusDays(15));
                organizerHackathon.setUserId(organizerUserId);
                hackathonRepository.save(organizerHackathon);
                organizerHackathons = List.of(organizerHackathon);
        }

        HackathonEntity firstHackathon = organizerHackathons.get(0);
        boolean exists = judgeAssignmentRepository.existsByHackathonIdAndJudgeUserId(firstHackathon.getHackathonId(),
                judgeUserId);
        if (exists) {
            return;
        }

        JudgeAssignmentEntity assignment = new JudgeAssignmentEntity();
        assignment.setHackathonId(firstHackathon.getHackathonId());
        assignment.setJudgeUserId(judgeUserId);
        assignment.setAssignedByUserId(organizerUserId);
        assignment.setAssignedAt(LocalDate.now());
        judgeAssignmentRepository.save(assignment);
    }
}

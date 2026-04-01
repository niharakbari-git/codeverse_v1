package com.grownited.controller.participant;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.HackathonEntity;
import com.grownited.entity.TeamEntity;
import com.grownited.entity.TeamMemberEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.TeamMemberRepository;
import com.grownited.repository.TeamRepository;
import com.grownited.repository.UserRepository;

import jakarta.servlet.http.HttpSession;

@Controller
public class ParticipantWorkflowController {

    @Autowired
    TeamRepository teamRepository;

    @Autowired
    TeamMemberRepository teamMemberRepository;

    @Autowired
    HackathonRepository hackathonRepository;

    @Autowired
    HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    UserRepository userRepository;

    @GetMapping("/participant/team/new")
    public String newTeam(@RequestParam Integer hackathonId, Model model) {
        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return "redirect:/participant/home";
        }

        model.addAttribute("hackathon", opHackathon.get());
        return "participant/NewTeam";
    }

    @PostMapping("/participant/team/create")
    public String createTeamAndApply(@RequestParam Integer hackathonId, @RequestParam String teamName, HttpSession session,
            Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (hackathonApplicationRepository.existsByHackathonIdAndParticipantUserId(hackathonId, currentUser.getUserId())) {
            return "redirect:/participant/my-applications";
        }

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(hackathonId);
        if (opHackathon.isEmpty()) {
            return "redirect:/participant/home";
        }

        TeamEntity team = new TeamEntity();
        team.setTeamName(teamName == null || teamName.isBlank() ? "Team " + currentUser.getFirstName() : teamName.trim());
        team.setHackathonId(hackathonId);
        team.setLeaderUserId(currentUser.getUserId());
        team.setCreatedAt(LocalDate.now());
        teamRepository.save(team);

        TeamMemberEntity leaderMember = new TeamMemberEntity();
        leaderMember.setTeamId(team.getTeamId());
        leaderMember.setUserId(currentUser.getUserId());
        teamMemberRepository.save(leaderMember);

        HackathonApplicationEntity app = new HackathonApplicationEntity();
        app.setHackathonId(hackathonId);
        app.setTeamId(team.getTeamId());
        app.setParticipantUserId(currentUser.getUserId());
        app.setStatus("APPLIED");
        app.setPaymentStatus("PENDING");
        app.setAppliedAt(LocalDate.now());
        hackathonApplicationRepository.save(app);

        return "redirect:/participant/my-applications";
    }

    @GetMapping("/participant/my-teams")
    public String myTeams(HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Map<Integer, TeamEntity> visibleTeamsById = new LinkedHashMap<>();
        List<TeamEntity> leaderTeams = teamRepository.findByLeaderUserId(currentUser.getUserId());
        for (TeamEntity team : leaderTeams) {
            visibleTeamsById.put(team.getTeamId(), team);
        }

        List<TeamMemberEntity> memberships = teamMemberRepository.findByUserId(currentUser.getUserId());
        for (TeamMemberEntity membership : memberships) {
            Optional<TeamEntity> opTeam = teamRepository.findById(membership.getTeamId());
            opTeam.ifPresent(team -> visibleTeamsById.putIfAbsent(team.getTeamId(), team));
        }

        List<TeamView> teamViews = new ArrayList<>();
        for (TeamEntity team : visibleTeamsById.values()) {
            TeamView view = new TeamView();
            view.setTeam(team);
            boolean isLeader = team.getLeaderUserId() != null && team.getLeaderUserId().equals(currentUser.getUserId());
            view.setCanManageMembers(isLeader);
            view.setRoleInTeam(isLeader ? "Leader" : "Member");

            Optional<HackathonEntity> opHackathon = hackathonRepository.findById(team.getHackathonId());
            view.setHackathonTitle(opHackathon.map(HackathonEntity::getTitle).orElse("Unknown Hackathon"));
            List<TeamMemberEntity> members = teamMemberRepository.findByTeamId(team.getTeamId());
            view.setMemberCount(members.size());

            List<String> memberNames = new ArrayList<>();
            for (TeamMemberEntity m : members) {
                Optional<UserEntity> opMember = userRepository.findById(m.getUserId());
                memberNames.add(opMember.map(u -> u.getFirstName() + " " + u.getLastName()).orElse("Unknown Member"));
            }
            view.setMemberNames(memberNames);
            teamViews.add(view);
        }

        model.addAttribute("teamViews", teamViews);
        return "participant/MyTeams";
    }

    @PostMapping("/participant/team/add-member")
    public String addTeamMember(@RequestParam Integer teamId, @RequestParam String memberEmail, HttpSession session) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        Optional<TeamEntity> opTeam = teamRepository.findById(teamId);
        if (opTeam.isEmpty()) {
            return "redirect:/participant/my-teams?msg=Team+not+found&type=error";
        }

        TeamEntity team = opTeam.get();
        if (!team.getLeaderUserId().equals(currentUser.getUserId())) {
            return "redirect:/participant/my-teams?msg=Only+team+leader+can+add+members&type=error";
        }

        Optional<UserEntity> opMember = userRepository.findByEmail(memberEmail == null ? "" : memberEmail.trim());
        if (opMember.isEmpty()) {
            return "redirect:/participant/my-teams?msg=User+not+found+for+email&type=error";
        }

        UserEntity member = opMember.get();
        if (teamMemberRepository.existsByTeamIdAndUserId(teamId, member.getUserId())) {
            return "redirect:/participant/my-teams?msg=User+already+in+team&type=error";
        }

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(team.getHackathonId());
        if (opHackathon.isEmpty()) {
            return "redirect:/participant/my-teams?msg=Hackathon+not+found&type=error";
        }

        int currentSize = teamMemberRepository.findByTeamId(teamId).size();
        int maxTeamSize = opHackathon.get().getMaxTeamSize() == null ? Integer.MAX_VALUE : opHackathon.get().getMaxTeamSize();
        if (currentSize >= maxTeamSize) {
            return "redirect:/participant/my-teams?msg=Team+is+already+at+maximum+size&type=error";
        }

        TeamMemberEntity newMember = new TeamMemberEntity();
        newMember.setTeamId(teamId);
        newMember.setUserId(member.getUserId());
        teamMemberRepository.save(newMember);

        return "redirect:/participant/my-teams?msg=Member+added+successfully&type=success";
    }

    @GetMapping("/participant/my-applications")
    public String myApplications(HttpSession session, Model model) {
        UserEntity currentUser = (UserEntity) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/login";
        }

        List<HackathonApplicationEntity> myApps = hackathonApplicationRepository.findByParticipantUserId(currentUser.getUserId());
        List<ApplicationView> appViews = new ArrayList<>();
        for (HackathonApplicationEntity app : myApps) {
            ApplicationView view = new ApplicationView();
            view.setApplication(app);

            Optional<HackathonEntity> opHackathon = hackathonRepository.findById(app.getHackathonId());
            view.setHackathonTitle(opHackathon.map(HackathonEntity::getTitle).orElse("Unknown Hackathon"));

            Optional<TeamEntity> opTeam = teamRepository.findById(app.getTeamId());
            view.setTeamName(opTeam.map(TeamEntity::getTeamName).orElse("N/A"));
            appViews.add(view);
        }

        model.addAttribute("appViews", appViews);
        return "participant/MyApplications";
    }

    public static class TeamView {
        private TeamEntity team;
        private String hackathonTitle;
        private Integer memberCount;
        private List<String> memberNames;
        private Boolean canManageMembers;
        private String roleInTeam;

        public TeamEntity getTeam() {
            return team;
        }

        public void setTeam(TeamEntity team) {
            this.team = team;
        }

        public String getHackathonTitle() {
            return hackathonTitle;
        }

        public void setHackathonTitle(String hackathonTitle) {
            this.hackathonTitle = hackathonTitle;
        }

        public Integer getMemberCount() {
            return memberCount;
        }

        public void setMemberCount(Integer memberCount) {
            this.memberCount = memberCount;
        }

        public List<String> getMemberNames() {
            return memberNames;
        }

        public void setMemberNames(List<String> memberNames) {
            this.memberNames = memberNames;
        }

        public Boolean getCanManageMembers() {
            return canManageMembers;
        }

        public void setCanManageMembers(Boolean canManageMembers) {
            this.canManageMembers = canManageMembers;
        }

        public String getRoleInTeam() {
            return roleInTeam;
        }

        public void setRoleInTeam(String roleInTeam) {
            this.roleInTeam = roleInTeam;
        }
    }

    public static class ApplicationView {
        private HackathonApplicationEntity application;
        private String hackathonTitle;
        private String teamName;

        public HackathonApplicationEntity getApplication() {
            return application;
        }

        public void setApplication(HackathonApplicationEntity application) {
            this.application = application;
        }

        public String getHackathonTitle() {
            return hackathonTitle;
        }

        public void setHackathonTitle(String hackathonTitle) {
            this.hackathonTitle = hackathonTitle;
        }

        public String getTeamName() {
            return teamName;
        }

        public void setTeamName(String teamName) {
            this.teamName = teamName;
        }
    }
}

package com.grownited.service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.grownited.dto.ParticipantApplicationView;
import com.grownited.dto.ParticipantTeamView;
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

@Service
public class ParticipantTeamService {

    @Autowired
    private TeamRepository teamRepository;

    @Autowired
    private TeamMemberRepository teamMemberRepository;

    @Autowired
    private HackathonRepository hackathonRepository;

    @Autowired
    private HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    private UserRepository userRepository;

    public String createTeamAndApply(Integer hackathonId, String teamName, UserEntity currentUser) {
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

    public List<ParticipantTeamView> getMyTeams(Integer currentUserId) {
        Map<Integer, TeamEntity> visibleTeamsById = new LinkedHashMap<>();
        List<TeamEntity> leaderTeams = teamRepository.findByLeaderUserId(currentUserId);
        for (TeamEntity team : leaderTeams) {
            visibleTeamsById.put(team.getTeamId(), team);
        }

        List<TeamMemberEntity> memberships = teamMemberRepository.findByUserId(currentUserId);
        for (TeamMemberEntity membership : memberships) {
            Optional<TeamEntity> opTeam = teamRepository.findById(membership.getTeamId());
            opTeam.ifPresent(team -> visibleTeamsById.putIfAbsent(team.getTeamId(), team));
        }

        List<ParticipantTeamView> teamViews = new ArrayList<>();
        for (TeamEntity team : visibleTeamsById.values()) {
            ParticipantTeamView view = new ParticipantTeamView();
            view.setTeam(team);
            boolean isLeader = team.getLeaderUserId() != null && team.getLeaderUserId().equals(currentUserId);
            view.setCanManageMembers(isLeader);
            view.setRoleInTeam(isLeader ? "Leader" : "Member");

            Optional<HackathonEntity> opHackathon = hackathonRepository.findById(team.getHackathonId());
            view.setHackathonTitle(opHackathon.map(HackathonEntity::getTitle).orElse("Unknown Hackathon"));
            List<TeamMemberEntity> members = teamMemberRepository.findByTeamId(team.getTeamId());
            view.setMemberCount(members.size());

            List<String> memberNames = new ArrayList<>();
            for (TeamMemberEntity member : members) {
                Optional<UserEntity> opMember = userRepository.findById(member.getUserId());
                memberNames.add(opMember.map(u -> u.getFirstName() + " " + u.getLastName()).orElse("Unknown Member"));
            }
            view.setMemberNames(memberNames);
            teamViews.add(view);
        }
        return teamViews;
    }

    public AddMemberResult addTeamMember(Integer teamId, String memberEmail, Integer currentUserId) {
        Optional<TeamEntity> opTeam = teamRepository.findById(teamId);
        if (opTeam.isEmpty()) {
            return AddMemberResult.error("Team+not+found");
        }

        TeamEntity team = opTeam.get();
        if (!team.getLeaderUserId().equals(currentUserId)) {
            return AddMemberResult.error("Only+team+leader+can+add+members");
        }

        Optional<UserEntity> opMember = userRepository.findByEmail(memberEmail == null ? "" : memberEmail.trim());
        if (opMember.isEmpty()) {
            return AddMemberResult.error("User+not+found+for+email");
        }

        UserEntity member = opMember.get();
        if (teamMemberRepository.existsByTeamIdAndUserId(teamId, member.getUserId())) {
            return AddMemberResult.error("User+already+in+team");
        }

        Optional<HackathonEntity> opHackathon = hackathonRepository.findById(team.getHackathonId());
        if (opHackathon.isEmpty()) {
            return AddMemberResult.error("Hackathon+not+found");
        }

        int currentSize = teamMemberRepository.findByTeamId(teamId).size();
        int maxTeamSize = opHackathon.get().getMaxTeamSize() == null ? Integer.MAX_VALUE : opHackathon.get().getMaxTeamSize();
        if (currentSize >= maxTeamSize) {
            return AddMemberResult.error("Team+is+already+at+maximum+size");
        }

        TeamMemberEntity newMember = new TeamMemberEntity();
        newMember.setTeamId(teamId);
        newMember.setUserId(member.getUserId());
        teamMemberRepository.save(newMember);

        return AddMemberResult.success("Team+member+added");
    }

    public List<ParticipantApplicationView> getMyApplications(Integer currentUserId) {
        List<HackathonApplicationEntity> myApps = hackathonApplicationRepository.findByParticipantUserId(currentUserId);
        List<ParticipantApplicationView> appViews = new ArrayList<>();
        for (HackathonApplicationEntity app : myApps) {
            ParticipantApplicationView view = new ParticipantApplicationView();
            view.setApplication(app);

            Optional<HackathonEntity> opHackathon = hackathonRepository.findById(app.getHackathonId());
            view.setHackathonTitle(opHackathon.map(HackathonEntity::getTitle).orElse("Unknown Hackathon"));

            Optional<TeamEntity> opTeam = teamRepository.findById(app.getTeamId());
            view.setTeamName(opTeam.map(TeamEntity::getTeamName).orElse("N/A"));
            appViews.add(view);
        }
        return appViews;
    }

    public static class AddMemberResult {
        private final boolean success;
        private final String message;

        private AddMemberResult(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public static AddMemberResult success(String message) {
            return new AddMemberResult(true, message);
        }

        public static AddMemberResult error(String message) {
            return new AddMemberResult(false, message);
        }

        public boolean isSuccess() {
            return success;
        }

        public String getMessage() {
            return message;
        }
    }
}

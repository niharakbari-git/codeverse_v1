package com.grownited.dto;

import java.util.List;

import com.grownited.entity.TeamEntity;

public class ParticipantTeamView {

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

package com.grownited.dto;

import com.grownited.entity.HackathonApplicationEntity;

public class ParticipantApplicationView {

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

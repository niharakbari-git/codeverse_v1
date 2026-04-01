package com.grownited.dto;

import com.grownited.entity.HackathonApplicationEntity;

public class OrganizerApplicationManageView {

    private HackathonApplicationEntity application;
    private String participantName;

    public HackathonApplicationEntity getApplication() {
        return application;
    }

    public void setApplication(HackathonApplicationEntity application) {
        this.application = application;
    }

    public String getParticipantName() {
        return participantName;
    }

    public void setParticipantName(String participantName) {
        this.participantName = participantName;
    }
}

package com.grownited.dto;

import java.time.LocalDate;

import com.grownited.entity.HackathonApplicationEntity;

public class ParticipantApplicationView {

    private HackathonApplicationEntity application;
    private String hackathonTitle;
    private String teamName;
    private Integer entryFeeAmount;
    private long submissionVersionCount;
    private LocalDate submissionDeadline;

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

    public Integer getEntryFeeAmount() {
        return entryFeeAmount;
    }

    public void setEntryFeeAmount(Integer entryFeeAmount) {
        this.entryFeeAmount = entryFeeAmount;
    }

    public long getSubmissionVersionCount() {
        return submissionVersionCount;
    }

    public void setSubmissionVersionCount(long submissionVersionCount) {
        this.submissionVersionCount = submissionVersionCount;
    }

    public LocalDate getSubmissionDeadline() {
        return submissionDeadline;
    }

    public void setSubmissionDeadline(LocalDate submissionDeadline) {
        this.submissionDeadline = submissionDeadline;
    }
}

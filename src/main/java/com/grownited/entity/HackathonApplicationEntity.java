package com.grownited.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "hackathon_applications")
public class HackathonApplicationEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer applicationId;

    private Integer hackathonId;
    private Integer teamId;
    private Integer participantUserId;
    private String status;
    private String paymentStatus;
    private LocalDate appliedAt;

    // Added fields for project submission
    private String submissionUrl;
    private String submissionDescription;
    private String frontendGithubLink;
    private String backendGithubLink;

    public Integer getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Integer applicationId) {
        this.applicationId = applicationId;
    }

    public Integer getHackathonId() {
        return hackathonId;
    }

    public void setHackathonId(Integer hackathonId) {
        this.hackathonId = hackathonId;
    }

    public Integer getTeamId() {
        return teamId;
    }

    public void setTeamId(Integer teamId) {
        this.teamId = teamId;
    }

    public Integer getParticipantUserId() {
        return participantUserId;
    }

    public void setParticipantUserId(Integer participantUserId) {
        this.participantUserId = participantUserId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public LocalDate getAppliedAt() {
        return appliedAt;
    }

    public void setAppliedAt(LocalDate appliedAt) {
        this.appliedAt = appliedAt;
    }

    public String getSubmissionUrl() {
        return submissionUrl;
    }

    public void setSubmissionUrl(String submissionUrl) {
        this.submissionUrl = submissionUrl;
    }

    public String getSubmissionDescription() {
        return submissionDescription;
    }

    public void setSubmissionDescription(String submissionDescription) {
        this.submissionDescription = submissionDescription;
    }

    public String getFrontendGithubLink() {
        return frontendGithubLink;
    }

    public void setFrontendGithubLink(String frontendGithubLink) {
        this.frontendGithubLink = frontendGithubLink;
    }

    public String getBackendGithubLink() {
        return backendGithubLink;
    }

    public void setBackendGithubLink(String backendGithubLink) {
        this.backendGithubLink = backendGithubLink;
    }
}

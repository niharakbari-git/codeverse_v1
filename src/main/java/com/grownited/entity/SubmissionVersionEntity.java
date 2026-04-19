package com.grownited.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "submission_versions")
public class SubmissionVersionEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer submissionVersionId;

    private Integer applicationId;
    private Integer versionNumber;
    private String submissionUrl;
    private String submissionDescription;
    private String frontendGithubLink;
    private String backendGithubLink;
    private String submissionAttachmentUrl;
    private String submissionAttachmentName;
    private LocalDateTime submittedAt;
    private boolean locked;

    public Integer getSubmissionVersionId() {
        return submissionVersionId;
    }

    public void setSubmissionVersionId(Integer submissionVersionId) {
        this.submissionVersionId = submissionVersionId;
    }

    public Integer getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Integer applicationId) {
        this.applicationId = applicationId;
    }

    public Integer getVersionNumber() {
        return versionNumber;
    }

    public void setVersionNumber(Integer versionNumber) {
        this.versionNumber = versionNumber;
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

    public String getSubmissionAttachmentUrl() {
        return submissionAttachmentUrl;
    }

    public void setSubmissionAttachmentUrl(String submissionAttachmentUrl) {
        this.submissionAttachmentUrl = submissionAttachmentUrl;
    }

    public String getSubmissionAttachmentName() {
        return submissionAttachmentName;
    }

    public void setSubmissionAttachmentName(String submissionAttachmentName) {
        this.submissionAttachmentName = submissionAttachmentName;
    }

    public LocalDateTime getSubmittedAt() {
        return submittedAt;
    }

    public void setSubmittedAt(LocalDateTime submittedAt) {
        this.submittedAt = submittedAt;
    }

    public boolean isLocked() {
        return locked;
    }

    public void setLocked(boolean locked) {
        this.locked = locked;
    }
}
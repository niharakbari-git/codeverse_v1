package com.grownited.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Transient;
import jakarta.persistence.Table;

@Entity
@Table(name = "hackathon")
public class HackathonEntity {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Integer hackathonId;
	String title;
	String description; 
	
	String status;

	String eventType;
	String participationScope;
	String allowedEmailDomains;
	String invitationCode;
	String payment;
	Integer entryFeeAmount;
	Integer minTeamSize;
	Integer maxTeamSize;
	String location;
	String problemTitle;
	String problemStatement;
	String problemConstraints;
	String problemDeliverables;
	String evaluationCriteria;
	String submissionChecklist;
	Integer userTypeId;// fk
	LocalDate registrationStartDate;
	LocalDate registrationEndDate;
	LocalDate eventStartDate;
	LocalDate eventEndDate;
	LocalDate submissionDeadline;
	Integer gracePeriodHours;
	
	Integer userId; //fk 

	@Transient
	String displayStatus;
	
	
	public Integer getHackathonId() {
		return hackathonId;
	}
	public void setHackathonId(Integer hackathonId) {
		this.hackathonId = hackathonId;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getEventType() {
		return eventType;
	}
	public void setEventType(String eventType) {
		this.eventType = eventType;
	}
	public String getParticipationScope() {
		return participationScope;
	}
	public void setParticipationScope(String participationScope) {
		this.participationScope = participationScope;
	}
	public String getAllowedEmailDomains() {
		return allowedEmailDomains;
	}
	public void setAllowedEmailDomains(String allowedEmailDomains) {
		this.allowedEmailDomains = allowedEmailDomains;
	}
	public String getInvitationCode() {
		return invitationCode;
	}
	public void setInvitationCode(String invitationCode) {
		this.invitationCode = invitationCode;
	}
	public String getPayment() {
		return payment;
	}
	public void setPayment(String payment) {
		this.payment = payment;
	}
	public Integer getEntryFeeAmount() {
		return entryFeeAmount;
	}
	public void setEntryFeeAmount(Integer entryFeeAmount) {
		this.entryFeeAmount = entryFeeAmount;
	}
	public Integer getMinTeamSize() {
		return minTeamSize;
	}
	public void setMinTeamSize(Integer minTeamSize) {
		this.minTeamSize = minTeamSize;
	}
	public Integer getMaxTeamSize() {
		return maxTeamSize;
	}
	public void setMaxTeamSize(Integer maxTeamSize) {
		this.maxTeamSize = maxTeamSize;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getProblemTitle() {
		return problemTitle;
	}
	public void setProblemTitle(String problemTitle) {
		this.problemTitle = problemTitle;
	}
	public String getProblemStatement() {
		return problemStatement;
	}
	public void setProblemStatement(String problemStatement) {
		this.problemStatement = problemStatement;
	}
	public String getProblemConstraints() {
		return problemConstraints;
	}
	public void setProblemConstraints(String problemConstraints) {
		this.problemConstraints = problemConstraints;
	}
	public String getProblemDeliverables() {
		return problemDeliverables;
	}
	public void setProblemDeliverables(String problemDeliverables) {
		this.problemDeliverables = problemDeliverables;
	}
	public String getEvaluationCriteria() {
		return evaluationCriteria;
	}
	public void setEvaluationCriteria(String evaluationCriteria) {
		this.evaluationCriteria = evaluationCriteria;
	}
	public String getSubmissionChecklist() {
		return submissionChecklist;
	}
	public void setSubmissionChecklist(String submissionChecklist) {
		this.submissionChecklist = submissionChecklist;
	}
	public Integer getUserTypeId() {
		return userTypeId;
	}
	public void setUserTypeId(Integer userTypeId) {
		this.userTypeId = userTypeId;
	}
	public LocalDate getRegistrationStartDate() {
		return registrationStartDate;
	}
	public void setRegistrationStartDate(LocalDate registrationStartDate) {
		this.registrationStartDate = registrationStartDate;
	}
	public LocalDate getRegistrationEndDate() {
		return registrationEndDate;
	}
	public void setRegistrationEndDate(LocalDate registrationEndDate) {
		this.registrationEndDate = registrationEndDate;
	}
	public LocalDate getEventStartDate() {
		return eventStartDate;
	}
	public void setEventStartDate(LocalDate eventStartDate) {
		this.eventStartDate = eventStartDate;
	}
	public LocalDate getEventEndDate() {
		return eventEndDate;
	}
	public void setEventEndDate(LocalDate eventEndDate) {
		this.eventEndDate = eventEndDate;
	}
	public LocalDate getSubmissionDeadline() {
		return submissionDeadline;
	}
	public void setSubmissionDeadline(LocalDate submissionDeadline) {
		this.submissionDeadline = submissionDeadline;
	}
	public Integer getGracePeriodHours() {
		return gracePeriodHours;
	}
	public void setGracePeriodHours(Integer gracePeriodHours) {
		this.gracePeriodHours = gracePeriodHours;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public String getDisplayStatus() {
		return displayStatus;
	}
	public void setDisplayStatus(String displayStatus) {
		this.displayStatus = displayStatus;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}

	
}

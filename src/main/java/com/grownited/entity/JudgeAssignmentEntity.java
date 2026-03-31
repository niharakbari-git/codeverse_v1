package com.grownited.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "judge_assignments")
public class JudgeAssignmentEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer judgeAssignmentId;

    private Integer hackathonId;
    private Integer judgeUserId;
    private Integer assignedByUserId;
    private LocalDate assignedAt;

    public Integer getJudgeAssignmentId() {
        return judgeAssignmentId;
    }

    public void setJudgeAssignmentId(Integer judgeAssignmentId) {
        this.judgeAssignmentId = judgeAssignmentId;
    }

    public Integer getHackathonId() {
        return hackathonId;
    }

    public void setHackathonId(Integer hackathonId) {
        this.hackathonId = hackathonId;
    }

    public Integer getJudgeUserId() {
        return judgeUserId;
    }

    public void setJudgeUserId(Integer judgeUserId) {
        this.judgeUserId = judgeUserId;
    }

    public Integer getAssignedByUserId() {
        return assignedByUserId;
    }

    public void setAssignedByUserId(Integer assignedByUserId) {
        this.assignedByUserId = assignedByUserId;
    }

    public LocalDate getAssignedAt() {
        return assignedAt;
    }

    public void setAssignedAt(LocalDate assignedAt) {
        this.assignedAt = assignedAt;
    }
}

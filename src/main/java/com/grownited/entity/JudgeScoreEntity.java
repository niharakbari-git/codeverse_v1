package com.grownited.entity;

import java.time.LocalDate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "judge_scores")
public class JudgeScoreEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer judgeScoreId;

    private Integer hackathonId;
    private Integer applicationId;
    private Integer judgeUserId;
    private Integer score;
    private String remarks;
    private LocalDate scoredAt;

    public Integer getJudgeScoreId() {
        return judgeScoreId;
    }

    public void setJudgeScoreId(Integer judgeScoreId) {
        this.judgeScoreId = judgeScoreId;
    }

    public Integer getHackathonId() {
        return hackathonId;
    }

    public void setHackathonId(Integer hackathonId) {
        this.hackathonId = hackathonId;
    }

    public Integer getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(Integer applicationId) {
        this.applicationId = applicationId;
    }

    public Integer getJudgeUserId() {
        return judgeUserId;
    }

    public void setJudgeUserId(Integer judgeUserId) {
        this.judgeUserId = judgeUserId;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public LocalDate getScoredAt() {
        return scoredAt;
    }

    public void setScoredAt(LocalDate scoredAt) {
        this.scoredAt = scoredAt;
    }
}

package com.grownited.service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.grownited.entity.HackathonApplicationEntity;
import com.grownited.entity.JudgeScoreEntity;
import com.grownited.entity.TeamEntity;
import com.grownited.entity.UserEntity;
import com.grownited.repository.HackathonApplicationRepository;
import com.grownited.repository.HackathonRepository;
import com.grownited.repository.JudgeScoreRepository;
import com.grownited.repository.TeamRepository;
import com.grownited.repository.UserRepository;

@Service
public class ScoreboardService {

    @Autowired
    HackathonRepository hackathonRepository;

    @Autowired
    HackathonApplicationRepository hackathonApplicationRepository;

    @Autowired
    JudgeScoreRepository judgeScoreRepository;

    @Autowired
    UserRepository userRepository;

    @Autowired
    TeamRepository teamRepository;

    public static class ScoreboardEntry {
        private Integer applicationId;
        private Integer teamId;
        private String name; // participant or team name
        private double averageScore;
        private int scoreCount;
        private int rank;
        private double totalScore;
        private boolean winner;

        public Integer getApplicationId() { return applicationId; }
        public void setApplicationId(Integer applicationId) { this.applicationId = applicationId; }
        public Integer getTeamId() { return teamId; }
        public void setTeamId(Integer teamId) { this.teamId = teamId; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public double getAverageScore() { return averageScore; }
        public void setAverageScore(double averageScore) { this.averageScore = averageScore; }
        public int getScoreCount() { return scoreCount; }
        public void setScoreCount(int scoreCount) { this.scoreCount = scoreCount; }
        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
        public double getTotalScore() { return totalScore; }
        public void setTotalScore(double totalScore) { this.totalScore = totalScore; }
        public boolean isWinner() { return winner; }
        public void setWinner(boolean winner) { this.winner = winner; }
    }

    public List<ScoreboardEntry> getScoreboardForHackathon(Integer hackathonId) {
        List<HackathonApplicationEntity> apps = hackathonApplicationRepository.findByHackathonId(hackathonId);
        List<ScoreboardEntry> entries = new ArrayList<>();

        for (HackathonApplicationEntity app : apps) {
            List<JudgeScoreEntity> scores = judgeScoreRepository.findByApplicationId(app.getApplicationId());
            int total = scores.stream().mapToInt(s -> s.getScore() == null ? 0 : s.getScore()).sum();
            double avg = scores.isEmpty() ? 0.0 : ((double) total) / scores.size();
            ScoreboardEntry e = new ScoreboardEntry();
            e.setApplicationId(app.getApplicationId());
            e.setTeamId(app.getTeamId());
            e.setAverageScore(avg);
            e.setScoreCount(scores.size());
            e.setTotalScore(total);

            if (app.getTeamId() != null) {
                Optional<TeamEntity> t = teamRepository.findById(app.getTeamId());
                e.setName(t.map(TeamEntity::getTeamName).orElse("Team #" + app.getTeamId()));
            } else {
                Optional<UserEntity> p = userRepository.findById(app.getParticipantUserId());
                e.setName(p.map(u -> u.getFirstName() + " " + u.getLastName()).orElse("Participant #" + app.getParticipantUserId()));
            }

            entries.add(e);
        }

        // sort by average desc
        entries = entries.stream().sorted(Comparator.comparingDouble(ScoreboardEntry::getAverageScore).reversed()
                .thenComparing(ScoreboardEntry::getScoreCount, Comparator.reverseOrder()))
                .collect(Collectors.toList());

        // assign ranks (dense ranking) with tie-break by scoreCount already applied in sort
        AtomicInteger rankCounter = new AtomicInteger(0);
        double prevScore = Double.NaN;
        int currentRank = 0;
        for (int i = 0; i < entries.size(); i++) {
            ScoreboardEntry e = entries.get(i);
            if (Double.isNaN(prevScore) || Double.compare(e.getAverageScore(), prevScore) != 0) {
                currentRank = rankCounter.incrementAndGet();
                prevScore = e.getAverageScore();
            }
            e.setRank(currentRank);
            e.setWinner(currentRank == 1);
        }

        return entries;
    }
}

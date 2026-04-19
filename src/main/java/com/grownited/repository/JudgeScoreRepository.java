package com.grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.JudgeScoreEntity;

@Repository
public interface JudgeScoreRepository extends JpaRepository<JudgeScoreEntity, Integer> {

    List<JudgeScoreEntity> findByHackathonId(Integer hackathonId);

    List<JudgeScoreEntity> findByJudgeUserId(Integer judgeUserId);

    List<JudgeScoreEntity> findByApplicationId(Integer applicationId);

    void deleteByJudgeUserId(Integer judgeUserId);

    void deleteByApplicationId(Integer applicationId);

    Optional<JudgeScoreEntity> findByApplicationIdAndJudgeUserId(Integer applicationId, Integer judgeUserId);
}

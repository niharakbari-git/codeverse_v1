package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.JudgeAssignmentEntity;

@Repository
public interface JudgeAssignmentRepository extends JpaRepository<JudgeAssignmentEntity, Integer> {

    List<JudgeAssignmentEntity> findByJudgeUserId(Integer judgeUserId);

    List<JudgeAssignmentEntity> findByHackathonId(Integer hackathonId);

    boolean existsByHackathonIdAndJudgeUserId(Integer hackathonId, Integer judgeUserId);
}

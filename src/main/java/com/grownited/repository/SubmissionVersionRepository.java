package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.SubmissionVersionEntity;

@Repository
public interface SubmissionVersionRepository extends JpaRepository<SubmissionVersionEntity, Integer> {

    List<SubmissionVersionEntity> findByApplicationIdOrderByVersionNumberDesc(Integer applicationId);

    long countByApplicationId(Integer applicationId);

    void deleteByApplicationId(Integer applicationId);
}
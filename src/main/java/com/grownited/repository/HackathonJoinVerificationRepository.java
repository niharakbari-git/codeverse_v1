package com.grownited.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.HackathonJoinVerificationEntity;

@Repository
public interface HackathonJoinVerificationRepository extends JpaRepository<HackathonJoinVerificationEntity, Integer> {

    Optional<HackathonJoinVerificationEntity> findByHackathonIdAndUserIdAndVerificationEmail(Integer hackathonId,
            Integer userId, String verificationEmail);

    boolean existsByHackathonIdAndUserIdAndVerifiedTrue(Integer hackathonId, Integer userId);
}

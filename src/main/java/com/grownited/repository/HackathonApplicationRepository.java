package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.HackathonApplicationEntity;

@Repository
public interface HackathonApplicationRepository extends JpaRepository<HackathonApplicationEntity, Integer> {

    List<HackathonApplicationEntity> findByParticipantUserId(Integer participantUserId);

    List<HackathonApplicationEntity> findByHackathonId(Integer hackathonId);

    boolean existsByHackathonIdAndParticipantUserId(Integer hackathonId, Integer participantUserId);
}

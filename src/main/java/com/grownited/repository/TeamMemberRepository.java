package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.TeamMemberEntity;

@Repository
public interface TeamMemberRepository extends JpaRepository<TeamMemberEntity, Integer> {

    List<TeamMemberEntity> findByTeamId(Integer teamId);

    List<TeamMemberEntity> findByUserId(Integer userId);

    boolean existsByTeamIdAndUserId(Integer teamId, Integer userId);
}

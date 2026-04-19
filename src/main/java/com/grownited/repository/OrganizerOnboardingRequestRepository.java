package com.grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.OrganizerOnboardingRequestEntity;

@Repository
public interface OrganizerOnboardingRequestRepository extends JpaRepository<OrganizerOnboardingRequestEntity, Integer> {

    Optional<OrganizerOnboardingRequestEntity> findByEmailIgnoreCase(String email);

    Optional<OrganizerOnboardingRequestEntity> findByApprovedUserId(Integer approvedUserId);

    List<OrganizerOnboardingRequestEntity> findByReviewedByUserId(Integer reviewedByUserId);

    List<OrganizerOnboardingRequestEntity> findByStatusOrderByOrganizerOnboardingRequestIdDesc(String status);

    List<OrganizerOnboardingRequestEntity> findAllByOrderByOrganizerOnboardingRequestIdDesc();

    long countByStatus(String status);
}

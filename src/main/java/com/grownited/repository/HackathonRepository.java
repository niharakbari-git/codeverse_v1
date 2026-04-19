package com.grownited.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.HackathonEntity;

@Repository
public interface HackathonRepository extends JpaRepository<HackathonEntity, Integer>{
			
		long countByStatus(String status);
		long countByPayment(String payment);
		List<HackathonEntity> findByUserId(Integer userId);
		List<HackathonEntity> findByUserIdOrderByHackathonIdDesc(Integer userId);
		List<HackathonEntity> findAllByOrderByHackathonIdDesc();
		List<HackathonEntity> findByStatusOrderByHackathonIdDesc(String status);
		List<HackathonEntity> findByPaymentOrderByHackathonIdDesc(String payment);
		List<HackathonEntity> findByStatusNotOrderByRegistrationEndDateAsc(String status);
		List<HackathonEntity> findByStatusNotAndRegistrationEndDateGreaterThanEqualOrderByRegistrationEndDateAsc(String status,
				LocalDate registrationEndDate);
}

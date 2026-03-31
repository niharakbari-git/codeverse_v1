package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.HackathonEntity;

@Repository
public interface HackathonRepository extends JpaRepository<HackathonEntity, Integer>{
			
		long countByStatus(String status);
		long countByPayment(String payment);
		List<HackathonEntity> findByUserId(Integer userId);
}

package com.grownited.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.UserDetailEntity;

@Repository
public interface UserDetailRepository extends JpaRepository<UserDetailEntity, Integer> {

	// select * from userDetails where countr , city , useri
	// findByXXXX();
	// findByCountry(String country)
	// findByCity(String city)

	Optional<UserDetailEntity> findByUserId(Integer userId);

	void deleteByUserId(Integer userId);
}

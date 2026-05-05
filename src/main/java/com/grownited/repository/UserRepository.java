package com.grownited.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.UserEntity;

@Repository
public interface UserRepository extends JpaRepository<UserEntity, Integer>{

	Optional<UserEntity>  findByEmail(String email);
	Optional<UserEntity> findByEmailIgnoreCase(String email);
	
	List<UserEntity> findByRole(String role);
	List<UserEntity> findByRoleOrderByUserIdDesc(String role);
	List<UserEntity> findAllByOrderByUserIdDesc();

	long countByRole(String role);
	
}

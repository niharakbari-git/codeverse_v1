package com.grownited.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

import com.grownited.entity.UserTypeEntity;

@Repository
public interface UserTypeRepository extends JpaRepository<UserTypeEntity, Integer>{

	Optional<UserTypeEntity> findByUserTypeIgnoreCase(String userType);

}

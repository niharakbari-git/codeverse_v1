package com.grownited.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.UserTypeEntity;

@Repository//stereotype annotation 
public interface UserTypeRepository extends JpaRepository<UserTypeEntity, Integer>{

}

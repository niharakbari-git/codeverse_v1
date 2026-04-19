package com.grownited.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.grownited.entity.NotificationLogEntity;

@Repository
public interface NotificationLogRepository extends JpaRepository<NotificationLogEntity, Integer> {

    List<NotificationLogEntity> findByUserIdOrderBySentAtDesc(Integer userId);

    List<NotificationLogEntity> findTop10ByUserIdOrderBySentAtDesc(Integer userId);

    void deleteByUserId(Integer userId);
}
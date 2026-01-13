package com.cafe.erp.notification;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;


@Mapper
public interface NotificationDAO {
	
	// 목록 조회 페이징
    List<NotificationDTO> selectNotificationPage(
            int memberId,
            int size,
            int offset
    );
	
    // 알림 저장
    int insertNotification(NotificationDTO notification);

    // 회원 알림 목록 조회
    List<NotificationDTO> selectNotificationList(int memberId);

    // 알림 읽음 처리
    int updateReadYn(long notificationId);

    // 안 읽은 알림 개수
    int selectUnreadCount(int memberId);
    
}

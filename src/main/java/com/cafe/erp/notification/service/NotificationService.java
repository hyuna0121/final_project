package com.cafe.erp.notification.service;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.cafe.erp.notification.NotificationDAO;
import com.cafe.erp.notification.NotificationDTO;
import com.cafe.erp.store.voc.VocDTO;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class NotificationService {

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @Autowired
    private NotificationDAO notificationDAO;

    public void sendVocNotification(VocDTO vocDTO) {

        // 수신자 (점주)
        int receiverId = vocDTO.getOwnerId().intValue();
        
        
        //DB 저장
        NotificationDTO notification = new NotificationDTO();
        notification.setNotificationType("VOC");
        notification.setNotificationTitle(vocDTO.getVocTitle());
        notification.setNotificationContent(
            vocDTO.getMemName() + "님의 VOC가 등록되었습니다."
        );
       
        notification.setNotificationLink( "/store/voc/detail?vocId=" + vocDTO.getVocId());
        notification.setSenderMemberId(vocDTO.getMemberId().intValue());
        notification.setReceiverMemberId(receiverId);
        notificationDAO.insertNotification(notification);
        
        log.info("🔥 WS send start receiverId={}, dest={}", receiverId, "/sub/notification");
        //실시간 알림
        messagingTemplate.convertAndSendToUser(
            String.valueOf(receiverId),
            "/sub/notification",
            notification
        );
        log.info("🔥 WS send end receiverId={}", receiverId);
    }
}
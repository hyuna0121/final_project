package com.cafe.erp.notification.socket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

@Component
public class NotificationSocketSender {
	
	@Autowired
	private SimpMessagingTemplate messagingTemplate;
	

    public void send(Long memberId, Object message) {
        messagingTemplate.convertAndSend(
            "/sub/notifications/" + memberId,
            message
        );
    }
}

package com.cafe.erp.notification.service;



import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.List;

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
    
    // voc 알람 메서드
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
        notification.setNotificationCreatedAt(
        		LocalDateTime.now(ZoneId.of("Asia/Seoul"))
        		);
        notificationDAO.insertNotification(notification);
        notification.setNotificationReadYn("N");
        //실시간 알림
        messagingTemplate.convertAndSendToUser(
            String.valueOf(receiverId),
            "/sub/notification",
            notification
        );
    }
    // 알람 페이징 처리
    public List<NotificationDTO> selectNotificationPage(
            int memberId, int page, int size, String filter) {

        int offset = page * size;
        return notificationDAO.selectNotificationPage(
            memberId, size, offset, filter
        );
    }
    
    // 안읽음 알림 갯수
    public int selectUnreadCount(int memberId) {
        return notificationDAO.selectUnreadCount(memberId);
    }
    // 알람 읽음 처리 로직
    public void updateReadYn(long notificationId) {
        notificationDAO.updateReadYn(notificationId);
    }
    
    // 발주 시 재무팀 전원 알림 발송
    public void sendOrderNotificationToFinanceTeam(
    		String orderId,
    		int senderMemberId
    		) {
    	// 재무팀 전체 조회
    	List<Integer> financeMembers = notificationDAO.selectFinanceTeamMemberIds();
    	
    	// 재무팀 전체에게 알람
    	
    	for (Integer financeMember : financeMembers) {
			
    		NotificationDTO dto = new NotificationDTO();
    		dto.setNotificationType("ORDER");
    		dto.setNotificationTitle("가맹점 발주 요청");
    		dto.setNotificationContent(
    			"가맹점 발주가 접수되었습니다. (발주번호: " + orderId + ")"
    		);
    		dto.setNotificationLink(
    				"/order/approval"
    		);
    		dto.setReceiverMemberId(financeMember);
    		dto.setSenderMemberId(senderMemberId);
            dto.setNotificationCreatedAt(
                    LocalDateTime.now(ZoneId.of("Asia/Seoul"))
                );
            dto.setNotificationReadYn("N");
    		
    		notificationDAO.insertNotification(dto);
            messagingTemplate.convertAndSendToUser(
                    String.valueOf(financeMember),
                    "/sub/notification",
                    dto
                );
		}
    }
    // 반려 시 가맹점주 알림 발송
    public void sendOrderRejectNotification(
    		int senderMemberId,
    		int receiverMemberId,
    		String orderId
    	) {
    		NotificationDTO dto = new NotificationDTO();
    		dto.setNotificationType("Reject");
    		dto.setNotificationTitle("발주 반려 안내");
    		dto.setNotificationContent(
    		  "요청하신 발주가 반려되었습니다. (발주번호: " + orderId + ")"
    		);
    		dto.setNotificationLink("/order/approval");
    		dto.setSenderMemberId(senderMemberId);
    		dto.setReceiverMemberId(receiverMemberId);
            dto.setNotificationCreatedAt(
                    LocalDateTime.now(ZoneId.of("Asia/Seoul"))
                );
    		dto.setNotificationReadYn("N");
    		
    		notificationDAO.insertNotification(dto);
            messagingTemplate.convertAndSendToUser(
                    String.valueOf(receiverMemberId),
                    "/sub/notification",
                    dto
                );
    		
    }
    
}
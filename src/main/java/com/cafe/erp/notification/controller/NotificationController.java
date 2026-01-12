package com.cafe.erp.notification.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cafe.erp.notification.NotificationDAO;
import com.cafe.erp.notification.NotificationDTO;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationDAO notificationDAO;

    /**
     *  내 알림 목록 조회
     */
    @GetMapping
    public List<NotificationDTO> getMyNotifications(
            @AuthenticationPrincipal UserDetails user) {

        int memberId = Integer.parseInt(user.getUsername());
        return notificationDAO.selectNotificationList(memberId);
    }

    /**
     *  알림 읽음 처리
     */
    @PatchMapping("/{notificationId}/read")
    public void readNotification(
            @PathVariable long notificationId) {

        notificationDAO.updateReadYn(notificationId);
    }

    /**
     *  안 읽은 알림 개수 (헤더용)
     */
    @GetMapping("/unread-count")
    public int getUnreadCount(
            @AuthenticationPrincipal UserDetails user) {

        int memberId = Integer.parseInt(user.getUsername());
        return notificationDAO.selectUnreadCount(memberId);
    }
}

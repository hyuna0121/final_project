package com.cafe.erp.notification.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.cafe.erp.notification.NotificationDAO;
import com.cafe.erp.notification.NotificationDTO;
import com.cafe.erp.notification.service.NotificationService;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    @Autowired
    private NotificationService service;

    @GetMapping
    public List<NotificationDTO> selectNotificationPage(
            @AuthenticationPrincipal UserDetails user,
            @RequestParam int page,
            @RequestParam int size) {

        int memberId = Integer.parseInt(user.getUsername());
        return service.selectNotificationPage(memberId, page, size);
    }

    @PatchMapping("/{notificationId}/read")
    public void updateReadYn(
            @PathVariable long notificationId) {

    	service.updateReadYn(notificationId);
    }

    @GetMapping("/unread-count")
    public int selectUnreadCount(
            @AuthenticationPrincipal UserDetails user) {

        int memberId = Integer.parseInt(user.getUsername());
        return service.selectUnreadCount(memberId);
    }
}

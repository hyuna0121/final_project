package com.cafe.erp.security.websocket;

import org.springframework.messaging.*;
import org.springframework.messaging.simp.stomp.*;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.cafe.erp.member.MemberDTO;

@Component
public class StompAuthChannelInterceptor implements ChannelInterceptor {

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {

        StompHeaderAccessor accessor =
                MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);

        if (accessor == null) {
            return message;
        }

        // 🔥 STOMP CONNECT 시점에만 처리
        if (StompCommand.CONNECT.equals(accessor.getCommand())) {

            // 1️⃣ HTTP 로그인 정보 가져오기
            Authentication authentication =
                    SecurityContextHolder.getContext().getAuthentication();

            if (authentication == null || !authentication.isAuthenticated()) {
                throw new IllegalStateException("인증되지 않은 WebSocket 접근");
            }

            // 2️⃣ Principal → memberId로 세팅 (🔥 핵심)
            Object principal = authentication.getPrincipal();

            if (principal instanceof UserDTO user) {

                String memberId = String.valueOf(
                        user.getMember().getMemberId()
                );

                accessor.setUser(() -> memberId);

            } else {
                throw new IllegalStateException("알 수 없는 사용자 타입: " + principal);
            }
        }

        return message;
    }
}

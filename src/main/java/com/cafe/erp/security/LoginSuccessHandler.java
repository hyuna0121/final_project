package com.cafe.erp.security;

import com.cafe.erp.member.MemberService;
import com.cafe.erp.member.history.MemberHistoryService;
import com.cafe.erp.member.history.MemberLoginHistoryDTO;
import com.cafe.erp.store.StoreDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {
	
	@Autowired
	private MemberHistoryService memberHistoryService;
	
	@Autowired
	private MemberService memberService;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        UserDTO user = (UserDTO) authentication.getPrincipal();
        
        try {
            MemberLoginHistoryDTO history = new MemberLoginHistoryDTO();
            history.setMemLogHisClientIp(getClientIp(request)); 
            history.setMemLogHisRequestUrl(request.getRequestURI());
            history.setMemLogHisActionType("LOGIN");
            history.setMemLogHisIsSuccess(true);
            history.setMemLogHisLoginId(user.getUsername()); 
            history.setMemberId(user.getMember().getMemberId()); 
            
            memberHistoryService.insertLoginHistory(history);
            
        } catch (Exception e) {
            System.out.println("로그인 이력 저장 실패: " + e.getMessage());
            e.printStackTrace(); 
        }
        
        // 비밀번호(1234)인지 체크용 + 로그인 진행
        boolean pwPass = false;
        try {
        	pwPass = memberService.pwPass(user.getMember().getMemberId());
		} catch (Exception e) {
			e.printStackTrace();
		}
        
        
        boolean isStoreOwner = user.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

        
        // 본사직원 + 가맹점이 생성되지 않음 가맹점주 => 상세페이지 X : ? 추가 (첫번째 파라미터: ?)
        // 가맹점주: 본인의 상세페이지 => & 추가(두번째 파라미터 부터 &)
        if (isStoreOwner) {
            StoreDTO store = user.getStore();
            if (store != null) response.sendRedirect("/store/detail?storeId=" + store.getStoreId() + (pwPass ? "&forcePw=1" : "")); // 가맹점주
            else response.sendRedirect("/error/noStoreInfo"); // 가맹점이 아직 생성되지 않은 가맹점주
        } else { // 본사 직원
            response.sendRedirect("/member/AM_group_chart" + (pwPass ? "?forcePw=1" : ""));
        }
    }
    
    
    // ip 가져오는 매서드 (AWS 등 배포시 ip동일, 구분용)
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }

}

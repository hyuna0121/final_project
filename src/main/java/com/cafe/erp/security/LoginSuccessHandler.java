package com.cafe.erp.security;

import com.cafe.erp.store.StoreDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class LoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        UserDTO user = (UserDTO) authentication.getPrincipal();
        boolean isStoreOwner = user.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

        if (isStoreOwner) {
            StoreDTO store = user.getStore();
            if (store != null) response.sendRedirect("/store/detail?storeId=" + store.getStoreId()); // 가맹점주
            else response.sendRedirect("/error/noStoreInfo"); // 가맹점이 아직 생성되지 않은 가맹점주
        } else { // 본사 직원
            response.sendRedirect("/member/AM_group_chart");
        }
    }

}

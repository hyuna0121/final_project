package com.cafe.erp.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.boot.autoconfigure.security.servlet.PathRequest;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.http.HttpSession;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired 
    private UserDetailsService userDetailsService;

    @Autowired
    private MemberDetailsServiceImpl impl;


    @Bean
    public DaoAuthenticationProvider authenticationProvider(PasswordEncoder passwordEncoder) {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();
        authProvider.setUserDetailsService(userDetailsService); 
        authProvider.setPasswordEncoder(passwordEncoder);   
        return authProvider;
    }

	@Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
                .requestMatchers(PathRequest.toStaticResources().atCommonLocations())
                .requestMatchers("/assets/**", "/img/**", "/css/**", "/js/**");
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        
        http
            .csrf(csrf -> csrf.disable())
            .authenticationProvider(authenticationProvider(null))
            .authorizeHttpRequests(auth -> auth
            		.dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                    .requestMatchers("/member/login", "login", "/error", "/member/sessionCheck").permitAll()                    
                    .anyRequest().authenticated() // 로그인 안 된 사용자 막기
            )
            .formLogin(login -> login
                    .loginPage("/member/login")
                    .loginProcessingUrl("/login")
                    .usernameParameter("memberId")
                    
                    .passwordParameter("memPassword")
                    .defaultSuccessUrl("/member/AM_group_chat", true)
                    .permitAll()
            )
            
            .logout(logout -> logout
                    .logoutUrl("/member/logout")
                    .logoutSuccessUrl("/member/login")
                    	.addLogoutHandler((request, response, authentication) -> {
                    		HttpSession session = request.getSession(false);
                    		if(session != null) {
                    			session.invalidate();
                    		}
                    	})
                    	.logoutSuccessHandler((request, response, authentication) ->{
                    		Cookie sessCookie = new Cookie("JSESSIONID", null);
                    		sessCookie.setMaxAge(0);
                    		sessCookie.setPath("/");
                    		response.addCookie(sessCookie);
                    		
                    		response.sendRedirect("/member/login");
                    	})
            )
            
            .sessionManagement(session -> session
            		.invalidSessionUrl("/member/login")
                    .maximumSessions(1)
                    .maxSessionsPreventsLogin(false)
                    .expiredUrl("/member/login")
            );

        return http.build();
    }
    
    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
    	return new HttpSessionEventPublisher();
    }

}
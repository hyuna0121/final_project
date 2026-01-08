package com.cafe.erp.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.cafe.erp.member.MemberDAO;
import com.cafe.erp.member.MemberDTO;

@Service
public class UserService implements UserDetailsService{
	
	@Autowired
	private MemberDAO memberDAO;

	@Autowired
    private PasswordEncoder passwordEncoder;
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		MemberDTO dto = null;
		try {
			int memberId = Integer.parseInt(username);
			
			dto = memberDAO.login(memberId);
		}catch (NumberFormatException e) {
			throw new UsernameNotFoundException(username + "은(는) 형식이 올바르지 않습니다.");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		if(dto == null) {
			throw new UsernameNotFoundException(username + "은(는) 없는 사원입니다.");
		}
		System.out.println("========================================");
        System.out.println("1. 사용자가 입력한 ID: " + username);
        System.out.println("2. DB에서 가져온 암호: [" + dto.getMemPassword() + "]"); 
        // ↑↑ 대괄호 [] 안에 값이 꽉 차있어야 함. 비어있으면 MyBatis 문제!
        
        boolean isMatch = passwordEncoder.matches("1234", dto.getMemPassword());
        System.out.println("3. 1234랑 매칭 결과: " + isMatch);
        System.out.println("========================================");
        // ==========================================================
		return new UserDTO(dto);
		
	} 

	
	
}

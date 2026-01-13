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
        
		return new UserDTO(dto);
		
	} 

	
	
}

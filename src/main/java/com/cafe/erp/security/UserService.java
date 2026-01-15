package com.cafe.erp.security;

import com.cafe.erp.member.MemberDTO;
import com.cafe.erp.store.StoreDAO;
import com.cafe.erp.store.StoreDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.cafe.erp.member.MemberDAO;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService implements UserDetailsService {
	
	@Autowired
	private MemberDAO memberDAO;
	@Autowired
	private StoreDAO storeDAO;

	@Override
	public UserDetails loadUserByUsername(String username) {
		if (username == null || !username.matches("^[0-9]*$")) throw new UsernameNotFoundException("아이디는 숫자만 입력 가능합니다. : " + username);

		MemberDTO member = null;
        try {
			int memberId = Integer.parseInt(username);
            member = memberDAO.login(memberId);
        } catch (Exception e) {
            throw new RuntimeException("DB 조회 중 오류가 발생했습니다.");
        }
		if (member == null) throw new UsernameNotFoundException(username + "은(는) 없는 사원입니다.");

		List<GrantedAuthority> authorities = new ArrayList<>();

		StoreDTO store = null;
		if (member.getDeptCode() == 17) {
			authorities.add(new SimpleGrantedAuthority("ROLE_STORE")); // 가맹점 권한
			store = storeDAO.findByMemberId(member.getMemberId()); // store 정보 추가
		} else {
			authorities.add(new SimpleGrantedAuthority("ROLE_HQ")); // 본사 권한

			switch (member.getDeptCode()) {
				case 10: authorities.add(new SimpleGrantedAuthority("ROLE_DEPT_HR")); break; // 인사
				case 11: authorities.add(new SimpleGrantedAuthority("ROLE_DEPT_ACCOUNTING")); break; // 회계
				case 12: authorities.add(new SimpleGrantedAuthority("ROLE_DEPT_FINANCE")); break; // 재무
				case 13: authorities.add(new SimpleGrantedAuthority("ROLE_DEPT_SALES")); break; // 영업
				case 14: authorities.add(new SimpleGrantedAuthority("ROLE_DEPT_CS")); break; // CS
				case 15: authorities.add(new SimpleGrantedAuthority("ROLE_DEPT_MARKETING")); break; // 마케팅
				case 16: authorities.add(new SimpleGrantedAuthority("ROLE_DEPT_RND")); break; // 식품개발
				case 20: authorities.add(new SimpleGrantedAuthority("ROLE_EXEC")); break; // 임원
				case 99: authorities.add(new SimpleGrantedAuthority("ROLE_MASTER")); break; // ADMIN
				default: break;
			}
		}

		return new UserDTO(member, store, authorities);
    }

}

package com.cafe.erp.security;

import com.cafe.erp.store.StoreDAO;
import com.cafe.erp.store.StoreDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.cafe.erp.member.MemberDAO;
import com.cafe.erp.member.MemberDTO;
@Service
@Primary
public class MemberDetailsServiceImpl implements UserDetailsService {
    
    @Autowired
    private MemberDAO memberDAO;
    @Autowired
    private StoreDAO storeDAO;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    
    
    

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        int memberId;
        try {
            memberId = Integer.parseInt(username);
        } catch (NumberFormatException e) {
            throw new UsernameNotFoundException("아이디 숫자 아님");
        }
        
        MemberDTO memberDTO = null;
        try {
            memberDTO = memberDAO.login(memberId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        if (memberDTO == null) {
            throw new UsernameNotFoundException("회원 없음");
        }

        if (username.startsWith("2")) {
            StoreDTO storeDTO = storeDAO.findByMemberId(memberId);
            return new UserDTO(memberDTO, storeDTO);
        }

        return new UserDTO(memberDTO);
    }
    
    
}
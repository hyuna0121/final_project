package com.cafe.erp.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberService {

	@Autowired
	private MemberDAO memberDAO;
	
	public List<MemberDTO> list(MemberDTO memberDTO) throws Exception {
		return memberDAO.list(memberDTO);
	}
	
	public int add(MemberDTO memberDTO) throws Exception{
		int result = memberDAO.add(memberDTO);
		return result;
	}

}

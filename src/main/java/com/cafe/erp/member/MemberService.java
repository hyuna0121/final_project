package com.cafe.erp.member;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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
		String year = LocalDate.now().format(DateTimeFormatter.ofPattern("yy"));
		String id = memberDTO.getIdPrefix() + year;
		
		String prefixId = memberDAO.getMemberId(id);
		
		int num = 1;
		
		if(prefixId != null) {
			num = Integer.parseInt(prefixId.substring(3)) + 1;
		}
		
		String finalId = id + String.format("%03d", num);

		memberDTO.setMemberId(Integer.parseInt(finalId));
		
		int result = memberDAO.add(memberDTO);
		return result;
	}

	public List<MemberDTO> searchOwner(String keyword) {
		return memberDAO.searchOwner(keyword);
	}





	public MemberDTO detail(MemberDTO memberDTO) throws Exception{
		return memberDAO.detail(memberDTO);
	}





	public int update(MemberDTO memberDTO) throws Exception {
		return memberDAO.update(memberDTO);
	}
	
	
	
	
	
	
	
	

}

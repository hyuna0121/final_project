package com.cafe.erp.member;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberDAO {
	
	public List<MemberDTO> list(MemberDTO memberDTO) throws Exception;
	public int add(MemberDTO memberDTO) throws Exception;
	public List<MemberDTO> searchOwner(String keyword);
	public MemberDTO detail(MemberDTO memberDTO) throws Exception;
	public int update(MemberDTO memberDTO) throws Exception;
	
	
	
	
	
	
	
	
	
	
	
	public String getMemberId(String id);
}

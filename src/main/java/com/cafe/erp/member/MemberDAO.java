package com.cafe.erp.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberDAO {
	
	public MemberDTO login(int memberId)throws Exception;
	
	public List<MemberDTO> list(MemberDTO memberDTO) throws Exception;
	
	public int add(MemberDTO memberDTO) throws Exception;
	
	public List<MemberDTO> searchOwner(String keyword);
	
	public MemberDTO detail(MemberDTO memberDTO) throws Exception;
	
	public int update(MemberDTO memberDTO) throws Exception;
	
	public int resetPw(MemberDTO memberDTO) throws Exception;
	
	public int InActive(MemberDTO memberDTO) throws Exception;
	

	public List<MemberDTO> chatList(Map<String, Object> val);
	
	public List<Map<String, Object>> deptMemberCount();
	
	public int totalMemberCount();

	public String getMemberId(String id);
	public MemberDTO getMemberId(MemberDTO memberDTO);
	

	String findProfileSavedName(int memberId);
	int checkProfileExist(int memberId);
	int updateProfile(@Param("originalName") String originalName, @Param("savedName") String savedName, @Param("memberId") int memberId);
	int insertProfile(@Param("originalName") String originalName, @Param("savedName") String savedName, @Param("memberId") int memberId);

	public int countAllMember(MemberDTO memberDTO) throws Exception;

	public int countActiveMember(MemberDTO memberDTO) throws Exception;

	
	public int changePassword(MemberChangePasswordDTO changePasswordDTO) throws Exception;
	public String getMemberPassword(int memberId) throws Exception;
	
	public List<MemberDTO> searchManager(String keyword) throws Exception;
	}






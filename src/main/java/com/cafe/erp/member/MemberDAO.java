package com.cafe.erp.member;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface MemberDAO {
	
	// 로그인
	public MemberDTO login(int memberId)throws Exception;
	
	// 관리자 전체 사원 리스트
	public List<MemberDTO> list(MemberDTO memberDTO) throws Exception;
	
	public Long memberCount(MemberSearchDTO searchDTO) throws Exception;
	
    public List<MemberDTO> memberList(MemberSearchDTO searchDTO) throws Exception;
	
	// 사원 추가
	public int add(MemberDTO memberDTO) throws Exception;
	
	public List<MemberDTO> searchOwner(String keyword);
	
	// 사원 상세정보
	public MemberDTO detail(MemberDTO memberDTO) throws Exception;
	
	// 사원 업데이트
	public int update(MemberDTO memberDTO) throws Exception;
	
	// 비밀번호 초기화
	public int resetPw(MemberDTO memberDTO) throws Exception;
	
	// 사원 재직 여부
	public int InActive(MemberDTO memberDTO) throws Exception;
	
	// 조직도 리스트
	public List<MemberDTO> chatList(Map<String, Object> val);
	
	// 부서별 인원 수
	public List<Map<String, Object>> deptMemberCount(Map<String, Object> checkMem);
	
	// DB에 있는 전체 사원 수
	public int countAllMember(MemberSearchDTO memberSearchDTO) throws Exception;
	
	// 전체 활성 사원 수
	public int countActiveMember(MemberSearchDTO memberSearchDTO) throws Exception;
	

	public String getMemberId(String id);
	public MemberDTO getMemberId(MemberDTO memberDTO);
	

	String findProfileSavedName(int memberId);
	int checkProfileExist(int memberId);
	int updateProfile(@Param("originalName") String originalName, @Param("savedName") String savedName, @Param("memberId") int memberId);
	int insertProfile(@Param("originalName") String originalName, @Param("savedName") String savedName, @Param("memberId") int memberId);


	
	public int changePassword(MemberChangePasswordDTO changePasswordDTO) throws Exception;
	public String getMemberPassword(int memberId) throws Exception;
	
	public List<MemberDTO> searchManager(String keyword) throws Exception;

	// 계정 잠금
	public void lockAccount(int memberId) throws Exception;

	// 사원 추가시 기본 연차 지급
	public void addFirstLeave(MemberDTO memberDTO)throws Exception;

	// 매해 한 번 전 사원 연차 지급
	public void yearLeave() throws Exception;

	// 상세페이지 부서 리스트 가져오기
	public List<MemberDTO> deptList();

	// 상세페이지 직급 리스트 가져오기
	public List<MemberDTO> positionList();

	
	}






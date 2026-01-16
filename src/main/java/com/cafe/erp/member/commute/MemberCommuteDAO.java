package com.cafe.erp.member.commute;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberCommuteDAO {

	public Long countCommuteList(MemberCommuteSearchDTO searchDTO) throws Exception;
	public List<MemberCommuteDTO> attendanceList(MemberCommuteSearchDTO searchDTO) throws Exception;

	public int checkIn(MemberCommuteDTO commuteDTO) throws Exception;

	public int checkOut(MemberCommuteDTO commuteDTO) throws Exception;
	public int updateCommute(MemberCommuteDTO commuteDTO) throws Exception;


	
}

package com.cafe.erp.member.commute;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberCommuteDAO {

	public List<MemberCommuteDTO> attendanceList(MemberCommuteDTO commuteDTO)throws Exception;

	public int checkIn(MemberCommuteDTO commuteDTO) throws Exception;

	public int checkOut(MemberCommuteDTO commuteDTO) throws Exception;


	
}

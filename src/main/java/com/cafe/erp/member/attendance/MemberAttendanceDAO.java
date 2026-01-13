package com.cafe.erp.member.attendance;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberAttendanceDAO {
	List<MemberAttendanceDTO> attendanceList(int memberId);
	
	MemberLeaveStatsDTO selectLeaveStats(int memberId);
}

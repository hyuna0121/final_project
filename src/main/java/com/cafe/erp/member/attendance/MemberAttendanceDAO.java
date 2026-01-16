package com.cafe.erp.member.attendance;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberAttendanceDAO {
    
    Long countAttendanceList(MemberAttendanceSearchDTO searchDTO) throws Exception;

    List<MemberAttendanceDTO> attendanceList(MemberAttendanceSearchDTO searchDTO) throws Exception;
    
    MemberLeaveStatsDTO selectLeaveStats(int memberId) throws Exception;

    List<MemberAttendanceDTO> selectApprovedAttendance(int memberId) throws Exception;
}
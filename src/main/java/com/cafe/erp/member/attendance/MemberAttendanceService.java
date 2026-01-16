package com.cafe.erp.member.attendance;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberAttendanceService {

    @Autowired
    private MemberAttendanceDAO memberAttendanceDAO;
    
    public Long countAttendanceList(MemberAttendanceSearchDTO searchDTO) throws Exception {
        return memberAttendanceDAO.countAttendanceList(searchDTO);
    }
    
    public List<MemberAttendanceDTO> attendanceList(MemberAttendanceSearchDTO searchDTO) throws Exception{
        return memberAttendanceDAO.attendanceList(searchDTO);
    }
    
    public MemberLeaveStatsDTO selectLeaveStats(int memberId) throws Exception{
        return memberAttendanceDAO.selectLeaveStats(memberId);
    }
}
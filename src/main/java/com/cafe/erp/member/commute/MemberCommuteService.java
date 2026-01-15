package com.cafe.erp.member.commute;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafe.erp.member.attendance.MemberAttendanceDAO;
import com.cafe.erp.member.attendance.MemberAttendanceDTO;

@Service
public class MemberCommuteService {

	@Autowired
	private MemberCommuteDAO commuteDAO;
	
	@Autowired
	private MemberAttendanceDAO memberAttendanceDAO;
	
	public Long countCommuteList(MemberCommuteSearchDTO memberCommuteSearchDTO) throws Exception{
		return commuteDAO.countCommuteList(memberCommuteSearchDTO);
		
	}
	public List<MemberCommuteDTO> attendanceList(MemberCommuteSearchDTO memberCommuteSearchDTO) throws Exception{
		Long totalCount = commuteDAO.countCommuteList(memberCommuteSearchDTO);
		memberCommuteSearchDTO.pageing(totalCount);
		return commuteDAO.attendanceList(memberCommuteSearchDTO);
		
	}

	public int checkOut(MemberCommuteDTO commuteDTO) throws Exception{
		return commuteDAO.checkOut(commuteDTO);
	}

	public int checkIn(MemberCommuteDTO commuteDTO) throws Exception {
		return commuteDAO.checkIn(commuteDTO);
	}
	
	public List<MemberAttendanceDTO> getApprovedAttendance(int memberId) throws Exception {
	    return memberAttendanceDAO.selectApprovedAttendance(memberId);
	}
}

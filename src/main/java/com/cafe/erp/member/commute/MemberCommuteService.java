package com.cafe.erp.member.commute;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberCommuteService {

	@Autowired
	private MemberCommuteDAO commuteDAO;
	
	public List<MemberCommuteDTO> attendanceList(MemberCommuteDTO commuteDTO)throws Exception{
		return commuteDAO.attendanceList(commuteDTO);
	}


	public int checkOut(MemberCommuteDTO commuteDTO) throws Exception{
		return commuteDAO.checkOut(commuteDTO);
	}

	public int checkIn(MemberCommuteDTO commuteDTO) throws Exception {
		return commuteDAO.checkIn(commuteDTO);
	}
}

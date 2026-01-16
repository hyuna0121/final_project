package com.cafe.erp.member.history;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MemberHistoryService {

	@Autowired
	private MemberHistoryDAO memberHistoryDAO;

	public void insertLoginHistory(MemberLoginHistoryDTO historyDTO) throws Exception {
		memberHistoryDAO.insertLoginHistory(historyDTO);
    }
	
	public List<MemberLoginHistoryDTO> selectLoginHistoryList(MemberHistorySearchDTO memberHistorySearchDTO)throws Exception{
		
		Long totalCount = memberHistoryDAO.totalCount(memberHistorySearchDTO);
		
		memberHistorySearchDTO.setTotalCount(totalCount);
		
		memberHistorySearchDTO.pageing(totalCount);
		
		return memberHistoryDAO.selectLoginHistoryList(memberHistorySearchDTO);
		
	}
}

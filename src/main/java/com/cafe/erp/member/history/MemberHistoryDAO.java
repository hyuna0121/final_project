package com.cafe.erp.member.history;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MemberHistoryDAO {

	int insertLoginHistory(MemberLoginHistoryDTO historyDTO) throws Exception;
	List<MemberLoginHistoryDTO> selectLoginHistoryList(MemberHistorySearchDTO memberHistorySearchDTO)throws Exception;
	Long totalCount(MemberHistorySearchDTO memberHistorySearchDTO)throws Exception;
}

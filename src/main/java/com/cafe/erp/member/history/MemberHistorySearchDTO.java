package com.cafe.erp.member.history;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberHistorySearchDTO extends Pager{

	
	private String startDate;
	private String endDate;
	private Boolean isSuccess;
	private String searchKeyword;
	
	private Long totalCount;
}

package com.cafe.erp.member.attendance;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberAttendanceSearchDTO extends Pager{

	private Integer memberId;
    
    private String dateType;     
    private String yearDate;     
    private String statusFilter;
	
    private String startDate;  
    private String endDate;
    
}

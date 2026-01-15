package com.cafe.erp.member.commute;

import java.awt.print.Paper;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberCommuteSearchDTO extends Pager{
	
	private Integer memberId;
    
    private String dateType;     
    private String startDate;    
    private String endDate;       
    private String statusFilter;
    
    private String monthDate;     
    private String yearDate;

}

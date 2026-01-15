package com.cafe.erp.member;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberSearchDTO extends Pager{
	
	private String memName;      
	private Integer deptCode;
    private Boolean memIsActive;
    private String searchKeyword;
    
    
    
    }

package com.cafe.erp.member;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class DeptCountDTO {

	private int deptCode;
	private String memDeptName;
	private int count;
	
	private String memDeptGroupName;
}


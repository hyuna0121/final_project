package com.cafe.erp.member;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberDTO {


	private int memberId;
	private String memPassword;
	private String memName;
	private String memZipCode;
	private String memAddress;
	private String memAddressDetail;
	private String memEmail;
	private String memPhone;
	private Date memHireDate;
	private Date memLeftDate;
	private Boolean memIsActive;
	private int deptCode;
    private int positionCode;
    
    
    private int idPrefix;
    
}

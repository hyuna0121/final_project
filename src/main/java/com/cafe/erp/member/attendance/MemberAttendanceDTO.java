package com.cafe.erp.member.attendance;

import java.math.BigDecimal;
import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberAttendanceDTO {

	private int memberCommuteId;
	private String memberAttendanceId;     
	private String memAttendanceType;     
    private Date memAttendanceStartDate;  
    private Date memAttendanceEndDate;    
    private BigDecimal memAttendanceUsedDays; 
    private String memAttendanceReason;   
    private int memberId;            
    private String approvalId;            
    

    private String appStatus;
}

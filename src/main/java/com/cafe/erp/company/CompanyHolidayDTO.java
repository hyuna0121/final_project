package com.cafe.erp.company;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CompanyHolidayDTO {
	
	private int companyHolidayId;
	private Date comHolidayDate;
	private String comHolidayName;
	private String comHolidayType;
	private int memberId;
}

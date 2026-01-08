package com.cafe.erp.store;

import java.time.LocalDate;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class StoreManageDTO {
	
	private Integer manageId;
	private Integer storeId;
	private Integer memberId;
	private LocalDate manageStartDate;
	private LocalDate manageEndDate;
	
	// member table column
	private String memName;

}

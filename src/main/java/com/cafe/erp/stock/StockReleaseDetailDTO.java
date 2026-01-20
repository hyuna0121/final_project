package com.cafe.erp.stock;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class StockReleaseDetailDTO {
	private Integer releaseId;
	private String releaseType;
	private String releaseReason;
	private Date releaseCreatedAt;
	private Date releaseApprovaledAt;
	private Integer inputId;
	
}

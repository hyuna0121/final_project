package com.cafe.erp.receivable.detail;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReceivableRoyaltyDTO {

	private String receivableId;
	private Date contractDate;
	private Integer supplyAmount;
	private Integer taxAmount;
	private Integer totalAmount;
	private String status;	
}
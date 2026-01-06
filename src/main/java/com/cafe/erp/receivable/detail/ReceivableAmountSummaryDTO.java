package com.cafe.erp.receivable.detail;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReceivableAmountSummaryDTO {
	
	//db에서 가져옴
	private Integer royaltyTotal;
	private Integer productTotal;
	//지급금액
	private Integer paidAmount;
	
	
	//service에서 값 계산
	private Integer totalAmount;
	private Integer unpaidAmount;
	
	
	
}

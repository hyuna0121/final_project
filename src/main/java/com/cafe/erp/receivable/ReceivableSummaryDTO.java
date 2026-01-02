package com.cafe.erp.receivable;

import lombok.Getter;

import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReceivableSummaryDTO {
	
	
	private Long storeId;
    private String storeName;
    private String baseMonth;   
    private Long totalAmount;
	
}

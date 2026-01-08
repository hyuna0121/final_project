package com.cafe.erp.receivable.detail;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReceivableTransactionDTO {
	
	private Date transactionDate;
	private Integer transactionAmount;
	private String transactionMemo;
	private String sourceType;
	private String memberName;
	
	
	
	
}

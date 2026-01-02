package com.cafe.erp.receivable.detail;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReceivableItemDTO {
	
	private String receivableId;
	private Date orderDate;
	private String itemName;
	private Integer quantity;
	private Integer unitPrice;
	private Integer supplyAmount;
	private Integer taxAmount;
	private Integer totalAmount;
	
	
	
	
}

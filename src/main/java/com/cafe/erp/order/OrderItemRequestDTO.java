package com.cafe.erp.order;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderItemRequestDTO {
	private Integer itemId;
	private String itemCode;
	private String itemName;
	private Integer itemQuantity;
	private Integer itemSupplyPrice;
	private Boolean itemAutoOrder;
	private Integer vendorCode;
}

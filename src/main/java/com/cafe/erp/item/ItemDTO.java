package com.cafe.erp.item;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ItemDTO {
	
	private int itemId;
	private String itemCode;
	private String itemName;
	private String itemCategory;
	private boolean itemEnable;
	private boolean itemAutoOrder;
	private int itemSupplyPrice;
	private int vendorId;
	
}

package com.cafe.erp.item;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ItemDTO {
	
	private Integer itemId;
	private String itemCode;
	private String itemName;
	private String itemCategory;
	private Boolean itemEnable;
	private Boolean itemAutoOrder;
	private Integer itemSupplyPrice;
	private Integer vendorId;
	private Integer vendorCode;
	private String vendorName;
	private Boolean itemPriceEnable;
	
}

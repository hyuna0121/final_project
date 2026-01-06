package com.cafe.erp.item;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ItemPriceDetailDTO {
	
	// 보여주는 view 전용 DTO
	
	// 단가
	private int itemPriceId;
	private int itemSupplyPrice;
	private boolean itemPriceEnable;
	
	// 품목
	private int itemId;
	private String itemCode;
	private String itemName;
	private String itemCategory;
	
	// 거래처
	private int vendorId;
	private int vendorCode;
	private String vendorName;
}

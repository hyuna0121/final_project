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
	private Integer itemPriceId;
	private Integer itemSupplyPrice;
	private Boolean itemPriceEnable;
	
	// 품목
	private Integer itemId;
	private String itemCode;
	private String itemName;
	private String itemCategory;
	
	// 거래처
	private Integer vendorId;
	private Integer vendorCode;
	private String vendorName;
}

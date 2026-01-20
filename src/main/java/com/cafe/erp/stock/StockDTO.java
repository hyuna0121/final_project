package com.cafe.erp.stock;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class StockDTO {
	private Integer stockHistoryId;
	private Integer warehouseId;
	private Integer itemId;
	private String itemName;
	private String stockInoutType;
	private Integer stockQuantity;
	private Integer inputId;
	private Date createdAt;
}

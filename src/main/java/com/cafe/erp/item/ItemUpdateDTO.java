package com.cafe.erp.item;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ItemUpdateDTO {
	private int itemId;
    private String itemName;
    private boolean itemEnable;
    private boolean itemAutoOrder;
    private int itemPriceId;
    private boolean itemPriceEnable;
}

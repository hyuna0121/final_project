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
    private int itemEnable;
    private int itemAutoOrder;
}

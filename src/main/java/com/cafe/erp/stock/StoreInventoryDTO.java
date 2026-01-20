package com.cafe.erp.stock;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class StoreInventoryDTO {

    private Integer itemId;      // item_id
    private String itemName;  // item_name
    private Integer stockQuantity;    // 보유 수량
    private Integer quantity; // 사용 수량
    private Integer warehouseId;
}

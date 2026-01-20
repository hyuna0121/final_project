package com.cafe.erp.stock;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class StoreStockUseRequest {
    private List<StoreInventoryDTO> items;
}
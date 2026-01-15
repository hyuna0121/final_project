package com.cafe.erp.order;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class OrderRequestDTO {
	private String orderNo;
    private String orderType; // HQ / STORE
}

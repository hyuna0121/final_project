package com.cafe.erp.stock;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class StockController {
	
	@Autowired
	private StockService stockService;
	
	// 입고처리
	public void inStock() {
		stockService.inStock();
	}
}

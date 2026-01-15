package com.cafe.erp.stock;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StockService {
	
	@Autowired
	private StockDAO stockDAO;

	public void inStock() {
		stockDAO.inStock();
	}
}

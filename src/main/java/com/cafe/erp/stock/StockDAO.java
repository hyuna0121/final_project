package com.cafe.erp.stock;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StockDAO {
	
	public void inStock();

}

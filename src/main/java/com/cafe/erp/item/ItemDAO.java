package com.cafe.erp.item;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ItemDAO {

	public void add(ItemDTO itemDTO);
	
	public void priceAdd(ItemDTO itemDTO);
	
	public List<ItemDTO> list();

	public List<ItemDTO> search(String itemName, String category, String vendorCode);
	
	public String max(String itemCode);
	
	public List<ItemPriceDetailDTO> priceList();
	
	public void updateItem(ItemDTO itemDTO);
	
}

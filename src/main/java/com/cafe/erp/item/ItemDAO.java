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
	
	public void updateItem(ItemUpdateDTO itemDTO);
	public void updateItemPrice(ItemUpdateDTO itemDTO);
	
	public void priceCheck(ItemUpdateDTO itemDTO);
	
	public void insertPrice(ItemPriceDetailDTO itemPriceDetailDTO);
	
	public List<ItemPriceDetailDTO> searchPrice(String itemName, String category, Boolean itemPriceEnable, String vendorCode);

	public List<ItemDTO> searchForOrder(Long vendorCode, String keyword);
}

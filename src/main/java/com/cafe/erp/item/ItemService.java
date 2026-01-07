package com.cafe.erp.item;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ItemService {
	
	@Autowired
	private ItemDAO itemDAO;

	public void add(ItemDTO itemDTO) {
		
		String category = itemDTO.getItemCategory(); 
		String itemCode ="";
		if (category.equals("원두") ||
			category.equals("유제품") ||
			category.equals("시럽/파우더") ||
			category.equals("음료원료") ||
			category.equals("베이커리") 
			) {
			itemCode = "FD";
		} else {
			itemCode = "NF";
		};
		
		String max = itemDAO.max(itemCode);
		String number = max.substring(2, 6);
		int result = Integer.parseInt(number);
		result ++;
		String format = String.format("%04d",result);
		
		itemDTO.setItemCode(itemCode+format);
		itemDAO.add(itemDTO);
	}
	
	public void priceAdd(ItemDTO itemDTO) {
		itemDAO.priceAdd(itemDTO);
	}
	
	public List<ItemDTO> list(){
		return itemDAO.list();
	}
	
	public List<ItemDTO> search(String itemName, String category, String vendorCode){
		return itemDAO.search(itemName,category,vendorCode);
	}
	
	public List<ItemPriceDetailDTO> priceList() {
		return itemDAO.priceList();
	}
	
	// 아이템 사용정보 수정
	public void updateItem(ItemUpdateDTO itemDTO) {
		itemDAO.updateItem(itemDTO);
	}
	public void updateItemPrice(ItemUpdateDTO itemDTO) {
		itemDAO.updateItemPrice(itemDTO);
	}
	
	// 단가 사용여부 수정
	public void priceCheck(ItemUpdateDTO itemDTO) {
		itemDAO.priceCheck(itemDTO);
	}
	
	public void insertPrice(ItemPriceDetailDTO itemPriceDetailDTO) {
		itemDAO.insertPrice(itemPriceDetailDTO);
	}
	
	public List<ItemPriceDetailDTO> searchPrice(String itemName, String category, Boolean itemPriceEnable, String vendorCode) {
		return itemDAO.searchPrice(itemName,category,itemPriceEnable,vendorCode);
	}
	
//	
	public List<ItemDTO> searchForOrder(Long vendorCode, String keyword) {
		return itemDAO.searchForOrder(vendorCode, keyword);
	}
}

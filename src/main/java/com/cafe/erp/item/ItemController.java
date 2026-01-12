package com.cafe.erp.item;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cafe.erp.vendor.VendorDTO;
import com.cafe.erp.vendor.VendorService;

@Controller
@RequestMapping("/item/*")
public class ItemController {
	
	@Autowired
	private ItemService itemService;
	
	@Autowired
	private VendorService vendorService;

	@GetMapping("add")
	public void add(Model model) {
		List<VendorDTO> vendorList = vendorService.findAll();
		model.addAttribute("vendorList", vendorList);
	}
	
	@PostMapping("add")
	@Transactional
	public String add(ItemDTO itemDTO) {
		// itemId null -> add() 실행되면서 itemId 삽입
		itemService.add(itemDTO);
		
		// 생성된 itemId를 다시 itemDTO에 삽입
		int itemId = itemDTO.getItemId();
		itemDTO.setItemId(itemId);
		
		itemService.priceAdd(itemDTO);
		
		return "redirect:./list";
	}
	
	@GetMapping("list")
	public String itemList(Model model) {
	    model.addAttribute("ItemList", itemService.list());
	    List<VendorDTO> vendorList = vendorService.findAll();
		model.addAttribute("vendorList", vendorList);
	  //System.out.println(itemService.list().iterator().next().toString());
	    return "item/list";
	}
	
	@GetMapping("search")
	@ResponseBody
	public List<ItemDTO> searchItems(@RequestParam(required = false) String itemName,
		    		@RequestParam(required = false) String category,
		    		@RequestParam(required = false) String vendorCode) {
		return itemService.search(itemName, category, vendorCode);
	}
	
	@GetMapping("priceDetail")
	public void priceDetail(Model model) {
		List<ItemPriceDetailDTO> priceList = itemService.priceList();
		
		//System.out.println(priceList.iterator().next().toString());
		model.addAttribute("priceList", priceList);
	}
	
	@PostMapping("updateItem")
	@Transactional
	public String updateItem(ItemUpdateDTO itemDTO) {
		System.out.println(itemDTO.getItemId());
		itemService.updateItem(itemDTO);
		itemService.updateItemPrice(itemDTO);
		System.out.println(itemDTO.toString());
		return "redirect:./list";
	}
	@PostMapping("priceCheck")
	public String priceCheck(ItemUpdateDTO itemDTO) {
		if(itemDTO.isItemPriceEnable() == true) {
			itemDTO.setItemPriceEnable(false);
		} else {
			itemDTO.setItemPriceEnable(true);			
		}
		itemService.priceCheck(itemDTO);
		return "redirect:./priceDetail";
	}
	
	@PostMapping("insertPrice")
	public String insertPrice(ItemPriceDetailDTO itemPriceDetailDTO) {
		itemService.insertPrice(itemPriceDetailDTO);
		System.out.println(itemPriceDetailDTO.toString());
		return "redirect:./list";
	}
	
	@GetMapping("searchPrice")
	@ResponseBody
	public List<ItemPriceDetailDTO> searchPrice(@RequestParam(required = false) String itemName,
    		@RequestParam(required = false) String category,
    		@RequestParam(required = false) Boolean itemPriceEnable,
    		@RequestParam(required = false) String vendorCode) {
		return itemService.searchPrice(itemName, category, itemPriceEnable, vendorCode);
	}
}
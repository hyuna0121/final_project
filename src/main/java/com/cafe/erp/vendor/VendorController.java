package com.cafe.erp.vendor;

import java.util.List;

import com.cafe.erp.item.ItemService;

import jakarta.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/vendor/*")
public class VendorController {

	@Autowired
	private VendorService vendorService;
	
	private final ItemService itemService;

    VendorController(ItemService itemService) {
        this.itemService = itemService;
    }
	
	@GetMapping("add")
	public void add() {
		
	}
	
	@PostMapping("add")
	public String add(@Valid VendorDTO vendorDTO, 
			@RequestParam String vendorBusinessNumber1,
	        @RequestParam String vendorBusinessNumber2,
	        @RequestParam String vendorBusinessNumber3,
	        @RequestParam String vendorAddress,
	        @RequestParam(required = false) String vendorAddressDetail) {
		
		String businessNumber =
		        vendorBusinessNumber1 + "-" +
		        vendorBusinessNumber2 + "-" +
		        vendorBusinessNumber3;
		
		// 주소 + 상세주소 합치기
	    if (vendorAddressDetail != null && !vendorAddressDetail.isBlank()) {
	        vendorDTO.setVendorAddress(
	            vendorAddress + " " + vendorAddressDetail
	        );
	    } else {
	        vendorDTO.setVendorAddress(vendorAddress);
	    }

	    // 2. DTO에 세팅
	    vendorDTO.setVendorBusinessNumber(businessNumber);
		vendorService.add(vendorDTO);
		
		return "redirect:./list";
	}
	
	@PostMapping("update")
	public String update(@Valid VendorDTO vendorDTO) {
		vendorService.update(vendorDTO);
		return "redirect:./list";
	}
	
	@GetMapping("list")
	public String list(VendorDTO vendorDTO, Model model) {
	    model.addAttribute("vendorList", vendorService.search(vendorDTO));
	    model.addAttribute("vendorDTO", vendorDTO);
	    return "vendor/list";
	}
	
}

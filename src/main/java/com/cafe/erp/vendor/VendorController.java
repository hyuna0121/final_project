package com.cafe.erp.vendor;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/vendor/*")
public class VendorController {

	@Autowired
	private VendorService vendorService;
	
	@GetMapping("add")
	public void add() {
		
	}
	
	@PostMapping("add")
	public void add(VendorDTO vendorDTO) {
		vendorService.add(vendorDTO);
	}
	
	
}

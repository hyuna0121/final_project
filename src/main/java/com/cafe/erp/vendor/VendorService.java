package com.cafe.erp.vendor;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VendorService {

	@Autowired
	private VendorDAO vendorDAO;
	
	public void add(VendorDTO vendorDTO) {
		vendorDTO.setMemberId(119001);
		vendorDTO.setVendorCode(150003);
		vendorDAO.add(vendorDTO);
	}
	
	public List<VendorDTO> findAll() {
		List<VendorDTO> list = vendorDAO.findAll();
		return list;
	}
	
}

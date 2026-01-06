package com.cafe.erp.vendor;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VendorDAO {

	public void add(VendorDTO vendorDTO);
	
	public List<VendorDTO> findAll();
}

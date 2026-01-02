package com.cafe.erp.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cafe.erp.util.Pager;

@Mapper
public interface StoreDAO { 
	
	public List<StoreDTO> list(StoreSearchDTO searchDTO) throws Exception;

	public int add(StoreDTO storeDTO) throws Exception;
	
	public Integer maxStoreId(String id) throws Exception;

	public List<StoreDTO> searchStore(String keyword) throws Exception;

	public Long count(StoreSearchDTO searchDTO) throws Exception;

	public List<StoreDTO> excelList(StoreSearchDTO searchDTO) throws Exception;
	
}

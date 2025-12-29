package com.cafe.erp.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface StoreDAO { 
	
	public List<StoreDTO> list() throws Exception;

	public int add(StoreDTO storeDTO) throws Exception;
	
	public int countStoreId(String id) throws Exception;
	
}

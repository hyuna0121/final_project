package com.cafe.erp.store.voc;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VocDAO {
	
	public List<VocDTO> list() throws Exception;

	public int add(VocDTO vocDTO) throws Exception;

	public VocDTO detail(Integer vocId) throws Exception;

}

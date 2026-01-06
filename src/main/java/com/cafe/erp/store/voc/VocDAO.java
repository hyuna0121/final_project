package com.cafe.erp.store.voc;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface VocDAO {
	
	public List<VocDTO> list(VocSearchDTO searchDTO) throws Exception;

	public int add(VocDTO vocDTO) throws Exception;

	public VocDTO detail(Integer vocId) throws Exception;

	public List<VocProcessDTO> processList(Integer vocId) throws Exception;

	public int addProcess(VocProcessDTO processDTO) throws Exception;

	public Long count(VocSearchDTO searchDTO) throws Exception;

	public List<VocDTO> excelList(VocSearchDTO searchDTO) throws Exception;

	public int addFile(VocProcessFileDTO processFileDTO) throws Exception;

}
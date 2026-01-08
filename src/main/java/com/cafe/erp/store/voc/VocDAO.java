package com.cafe.erp.store.voc;

import java.util.List;
import java.util.Map;

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

	public List<VocStatDTO> trend(String year, String month) throws Exception;
	
	public List<VocStatDTO> countByType(String year, String month) throws Exception;
	
	public List<VocStatDTO> topComplaintStores(String year, String month) throws Exception;
	
	public Map<String, Object> summary(String year, String month) throws Exception;

	public int updateToActive(Integer vocId) throws Exception;
	
	public List<VocStatDTO> managerPerformance(String year, String month) throws Exception;

}
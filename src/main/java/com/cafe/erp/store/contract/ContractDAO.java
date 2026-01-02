package com.cafe.erp.store.contract;

import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ContractDAO {
	
	public List<ContractDTO> list() throws Exception;

	public String maxContractId(String id);

	public int add(ContractDTO contractDTO);

	public int fileAdd(ContractFileDTO contractFileDTO);

	public ContractDTO getDetail(String contractId);

	public int updateStatusToActive(LocalDate today);

	public int updateStatusToExpired(LocalDate yesterday);

}

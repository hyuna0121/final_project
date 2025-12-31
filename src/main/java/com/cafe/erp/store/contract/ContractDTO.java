package com.cafe.erp.store.contract;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ContractDTO {

	private String contractId;
	private Integer storeId;
	private Integer contractRoyalti;
	private Integer contractDeposit;
	private LocalDate contractStartDate;
	private LocalDate contractEndDate;
	private Integer contractStatus;
	private LocalDateTime contractCreatedAt;
	private LocalDateTime contractUpdatedAt;
	
	// store table column
	private String storeName;
	private String storeAddress;
	
	// member table column
	private String memName;
	
	// store_contract_file table
	private List<ContractFileDTO> fileDTOs;
}

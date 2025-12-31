package com.cafe.erp.store.contract;

import com.cafe.erp.files.FileDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ContractFileDTO extends FileDTO {

	private String contractId;
	
}

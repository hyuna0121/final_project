package com.cafe.erp.store.voc;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VocProcessDTO {
	
	private Integer processId;
	private Integer vocId;
	private Integer memberId;
	private String processContents;
	private LocalDateTime processCreatedAt;
	private Integer processIsDeleted;
	
	// member table column
	private String memName;
	
	// store_contract_file table
	private List<VocProcessFileDTO> fileDTOs;
	
	public String getProcessCreatedAtStr() {
        if (this.processCreatedAt == null) return "";
        
        return this.processCreatedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }

}

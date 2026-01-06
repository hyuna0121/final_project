package com.cafe.erp.store.voc;

import com.cafe.erp.files.FileDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VocProcessFileDTO extends FileDTO {

	private Integer processId;
	
}

package com.cafe.erp.files;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class FileDTO {
	
	private Integer fileId;
	private String fileOriginalName;
	private String fileSavedName;

}

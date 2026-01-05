package com.cafe.erp.store.voc;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VocDTO {
	
	private Integer vocId;
	private Integer memberId;
	private Integer storeId;
	private String vocTitle;
	private String vocType;
	private String vocContact;
	private String vocContents;
	private Integer vocStatus;
	private LocalDateTime vocCreatedAt;
	private LocalDateTime vocUpdatedAt;
	
	// member table column
	private String memName; // 작성자 이름
	
	// store table column 
	private String storeName;
	private String ownerName;
	private String storeAddress;
	
	public String getVocCreatedAtStr() {
        if (this.vocCreatedAt == null) {
            return "";
        }
        
        return this.vocCreatedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }

}

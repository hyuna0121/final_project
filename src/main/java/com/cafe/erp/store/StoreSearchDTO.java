package com.cafe.erp.store;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class StoreSearchDTO extends Pager {
	
	private String storeStatus;
	private String storeStartTime;
	private String storeCloseTime;
	private String storeAddress;
	private String storeName;

}

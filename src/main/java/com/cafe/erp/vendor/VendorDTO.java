package com.cafe.erp.vendor;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VendorDTO {

	private int vendorId;
	private int vendorCode;
	private String vendorBusinessNumber;
	private String vendorName;
	private boolean vendorEnable;
	private Date vendorCreatedAt;
	private int memberId;
	
}

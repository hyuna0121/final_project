package com.cafe.erp.store;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class StoreDTO {
	
	private Integer storeId;
	private String storeName;
	private Integer memberId;
	private String storeAddress;
	private Integer storeZonecode;
	private Double storeLatitude;
	private Double storeLongitude;
	private String storeStatus;
	private LocalTime storeStartTime;
	private LocalTime storeCloseTime;
	private LocalDateTime storeCreatedAt;
	private LocalDateTime storeUpdatedAt;
	
	// member table column
	private String memName;
	private String memEmail;
	private String memPhone;

	private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("a hh:mm", Locale.KOREAN);
	
	public String getStoreZonecodeStr() { return String.format("%05d", storeZonecode); }
	public String getFormattedStartTime() {
		if (this.storeStartTime == null) return "";
		return storeStartTime.format(TIME_FORMATTER);
	}
	public String getFormattedCloseTime() {
		if (this.storeCloseTime == null) return "";
		return storeCloseTime.format(TIME_FORMATTER);
	}
	
}

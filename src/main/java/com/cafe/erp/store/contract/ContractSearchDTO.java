package com.cafe.erp.store.contract;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ContractSearchDTO extends Pager {

	private Integer searchContractStatus;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate searchStartDate;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate searchEndDate;
	private String searchStoreName;
	private Integer searchRoyaltyMin;
	private Integer searchRoyaltyMax;
	private Integer searchDepositMin;
	private Integer searchDepositMax;

	// 분기용
	private Integer searchStoreId;

	public String getsearchRoyaltyMinFormatted() {
		if (this.searchRoyaltyMin == null) return "";
		return String.format("%,d", this.searchRoyaltyMin);
	}
	public String getsearchRoyaltyMaxFormatted() {
		if (this.searchRoyaltyMax == null) return "";
		return String.format("%,d", this.searchRoyaltyMax);
	}
	public String getsearchDepositMinFormatted() {
		if (this.searchDepositMin == null) return "";
		return String.format("%,d", this.searchDepositMin);
	}
	public String getsearchDepositMaxFormatted() {
		if (this.searchDepositMax == null) return "";
		return String.format("%,d", this.searchDepositMax);
	}
	
}

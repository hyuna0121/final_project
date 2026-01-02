package com.cafe.erp.receivable;

import com.cafe.erp.util.Pager;

import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ReceivableSearchDTO {
	
	private String sourceType;
	private String baseMonth;
	@Size(max=50, message = "지점명은 최대 50자까지 가능합니다.")
	private String storeName;
	
	private Pager pager = new Pager();
	
	
}

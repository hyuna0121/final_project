package com.cafe.erp.receivable.hq;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HqPayableSearchDTO {
	
	
	
    private String baseMonth;

    private String vendorName;

    private String payStatus;

    private Pager pager;
	
}

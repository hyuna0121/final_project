package com.cafe.erp.receivable.hq;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class HqPayablePaymentDTO {
	private Integer memberId;
    private Integer vendorCode;   // 거래처
    private String baseMonth;     // 기준월 (yyyy-MM)

    private Integer payAmount;       // 이번 지급 금액
    private String memo;          // 비고
    
    private boolean fullPay;
}

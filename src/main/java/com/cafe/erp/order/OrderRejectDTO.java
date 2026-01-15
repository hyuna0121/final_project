package com.cafe.erp.order;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class OrderRejectDTO {

    private String rejectId; // 발주번호
    private String rejectReason; // 발주 사유
    private Integer storeMemberId; // 가맹점주 아이디
}
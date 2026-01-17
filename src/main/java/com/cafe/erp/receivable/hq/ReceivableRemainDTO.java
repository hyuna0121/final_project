package com.cafe.erp.receivable.hq;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReceivableRemainDTO {
    private String receivableId;
    private Integer remainAmount;
}

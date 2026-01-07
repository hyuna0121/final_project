package com.cafe.erp.store.voc;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VocStatDTO {

    private String category; // 날짜, 유형이름, 가맹점명
    private Integer count;
    private String description; // 주소
}

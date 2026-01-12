package com.cafe.erp.store.qsc.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class QscDetailDTO {

    private Integer detailId;
    private Integer qscId;
    private Integer listId;
    private Integer detailScore;
    private QscQuestionDTO questionDTO;

}

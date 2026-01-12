package com.cafe.erp.store.qsc.dto;

import com.cafe.erp.util.Pager;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@ToString
public class QscSearchDTO extends Pager {

    private Integer searchStoreId;
    private String searchStoreName;
    private String searchMemname;
    private String searchQscTitle;
    private LocalDate searchStartDate;
    private LocalDate searchEndDate;
    private String searchQscGrade;

}

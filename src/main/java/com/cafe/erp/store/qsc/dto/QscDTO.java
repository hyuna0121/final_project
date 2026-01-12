package com.cafe.erp.store.qsc.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Getter
@Setter
@ToString
public class QscDTO {

    private Integer qscId;
    private Integer storeId;
    private Integer memberId;
    private String qscTitle;
    private LocalDateTime qscDate;
    private Integer qscQuestionTotalScore;
    private Integer qscTotalScore;
    private String qscGrade;
    private String qscOpinion;
    private List<QscDetailDTO> qscDetailDTOS;

    // store table column
    private String storeName;
    private String storeAddress;

    // member table column
    private String memName;
    private String ownerName;

    public String getQscDateStr() {
        if (this.qscDate == null) return "";

        return this.qscDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }

    public Double getQscScore() {
        double rate = (double) this.qscTotalScore / this.qscQuestionTotalScore * 100;
        return Math.round(rate * 10.0) / 10.0;
    }

}

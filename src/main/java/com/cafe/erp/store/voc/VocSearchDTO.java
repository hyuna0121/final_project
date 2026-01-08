package com.cafe.erp.store.voc;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;

import com.cafe.erp.util.Pager;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class VocSearchDTO extends Pager {
	
	private String searchVocType;
	private Integer searchVocStatus;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate searchStartDate;
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private LocalDate searchEndDate;
	private String searchStoreName;
	private String searchVocTitle;

}

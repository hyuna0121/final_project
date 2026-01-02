package com.cafe.erp.receivable;

import java.util.List;


import org.apache.ibatis.annotations.Mapper;

import com.cafe.erp.receivable.detail.ReceivableItemDTO;

@Mapper
public interface ReceivableDAO {

	// 조회된 리스트
	public List<ReceivableSummaryDTO> receivableSearchList(
			ReceivableSearchDTO receivableSearchDTO
			);
	// 페이지 네이션 총 페이지 수
	public Long receivableSearchCount(
			ReceivableSearchDTO receivableSearchDTO
			);
	// 디테일 페이지 물품 대금 품목 리스트
	public List<ReceivableItemDTO> receivableItem(ReceivableSummaryDTO receivableSummaryDTO);
	
}

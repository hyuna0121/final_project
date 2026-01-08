package com.cafe.erp.receivable;

import java.util.List;


import org.apache.ibatis.annotations.Mapper;

import com.cafe.erp.receivable.detail.ReceivableAmountSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableAvailableDTO;
import com.cafe.erp.receivable.detail.ReceivableCollectionRequestDTO;
import com.cafe.erp.receivable.detail.ReceivableItemDTO;
import com.cafe.erp.receivable.detail.ReceivableOrderSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableRoyaltyDTO;
import com.cafe.erp.receivable.detail.ReceivableTransactionDTO;

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
	
	// detail page 물품 대금 요약
	public List<ReceivableOrderSummaryDTO> orderSummary(ReceivableSummaryDTO receivableSummaryDTO);
	
	// detail page 물품 대금 품목 상세 리스트
	public List<ReceivableItemDTO> receivableItemList(String receivableId);
	
	// detail page 가맹비 미수 내역
	public ReceivableRoyaltyDTO receivableRoyalty(ReceivableSummaryDTO receivableSummaryDTO);
	
	// detail page 금액 요약
	public ReceivableAmountSummaryDTO selectAmountSummary(ReceivableSummaryDTO receivableSummaryDTO);
	// detail page 지급 내역
	public List<ReceivableTransactionDTO> paidAmount(ReceivableSummaryDTO receivableSummaryDTO);
	
	//detail page 지급 버튼 클릭 시 채권 목록
	public List<ReceivableAvailableDTO> getAvailableReceivables(ReceivableSummaryDTO receivableSummaryDTO);
	
	// 지급 이력 DB에 삽입
	public void insertCollection(ReceivableCollectionRequestDTO receivableCollectionRequestDTO);
	// 지급 후 채권의 남은 금액
    public Integer selectRemainAmount(String receivableId);
    // 채권의 총 금액
    public Integer selectTotalAmount(String receivableId);
    // 채권의 status 업데이트
    public void updateReceivableStatus(ReceivableCollectionRequestDTO receivableCollectionRequestDTO);
    
    
    // 채권 매월 1일에 자동 생성
    public int insertMonthlyRoyaltyReceivable();
}

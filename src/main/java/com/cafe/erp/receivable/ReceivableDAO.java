package com.cafe.erp.receivable;

import java.util.List;


import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.cafe.erp.receivable.detail.ReceivableAmountSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableAvailableDTO;
import com.cafe.erp.receivable.detail.ReceivableCollectionRequestDTO;
import com.cafe.erp.receivable.detail.ReceivableItemDTO;
import com.cafe.erp.receivable.detail.ReceivableOrderSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableRoyaltyDTO;
import com.cafe.erp.receivable.detail.ReceivableTransactionDTO;
import com.cafe.erp.receivable.hq.HqPayablePaymentDTO;
import com.cafe.erp.receivable.hq.HqPayableReceivableDTO;
import com.cafe.erp.receivable.hq.HqPayableSearchDTO;
import com.cafe.erp.receivable.hq.HqPayableSummaryDTO;
import com.cafe.erp.receivable.hq.HqPayableTotalSummaryDTO;
import com.cafe.erp.receivable.hq.ReceivableRemainDTO;
import com.cafe.erp.vendor.VendorDTO;

@Mapper
public interface ReceivableDAO {

	// 조회된 리스트
	public List<ReceivableSummaryDTO> receivableSearchList(
			ReceivableSearchDTO receivableSearchDTO
			);
	// 조회된 리스트 금액 요약
	public ReceivableSummaryDTO getSummary(ReceivableSearchDTO receivableSearchDTO);
	
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
    
    // 생성된 채권인지 확인 (본사 - 거래처)
    public boolean existsByHqOrderId(String hqOrderId);
    // 발주 공급가액 조회 (본사 - 거래처)
    public Integer selectHqOrderSupplyAmount(String hqOrderId);
    // 발주테이블 상태값이 400이면 채권생성 
    public void insertReceivableForHqOrder(String hqOrderId);
    
    // 생성된 채권인지 확인 (본사 - 가맹점)
    public boolean existsByStoreOrderId(String storeOrderId);
    // 발주 공급가액 조회 (본사 - 가맹점)
    public Integer selectStoreOrderSupplyAmount(String storeOrderId);
    // 발주테이블 상태값이 400이면 채권생성
    public void insertReceivableForStoreOrder(String storeOrderId, Integer supplyAmount);

    
    // 거래처 코드
    public List<HqPayableSummaryDTO> selectHqPayableList(HqPayableSearchDTO dto);

	public Long selectHqPayableCountByMonth(HqPayableSearchDTO dto);

	public HqPayableTotalSummaryDTO selectHqPayableTotalSummaryByMonth(HqPayableSearchDTO dto);
	// 지급 처리 폼 거래처 채권 목록 조회
	public List<HqPayableReceivableDTO> selectVendorReceivableList(
	        @Param("vendorId") Integer vendorId,
	        @Param("baseMonth") String baseMonth
	);
	
	// 4) 지급 insert
	void insertHqPayment(ReceivableCollectionRequestDTO dto);
	
	public void payHqReceivable(HqPayablePaymentDTO dto);

    // 단일 채권 남은 금액 조회
    Integer selectReceivableRemainAmount(
            @Param("receivableId") String receivableId
    );

    
    
    
    
    
    
    
    
}

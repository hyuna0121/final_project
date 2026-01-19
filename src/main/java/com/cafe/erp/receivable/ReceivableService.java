package com.cafe.erp.receivable;

import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
import com.cafe.erp.security.UserDTO;
import com.cafe.erp.util.Pager;
import com.cafe.erp.vendor.VendorDTO;

@Service
public class ReceivableService {
	
	@Autowired
	private ReceivableDAO dao;
	
	
	@Transactional
	public void collectReceivable(ReceivableCollectionRequestDTO receivableCollectionRequestDTO , Integer memberId) {
		
		receivableCollectionRequestDTO.setMemberId(memberId);
		
		// 지급 내역 DB반영
		dao.insertCollection(receivableCollectionRequestDTO);
		// 채권 남은 금액
		Integer remainAmount = dao.selectRemainAmount(receivableCollectionRequestDTO.getReceivableId());
		// 채권 총 금액
		Integer totalAmount = dao.selectTotalAmount(receivableCollectionRequestDTO.getReceivableId());
		
		String status;
		
		if (remainAmount.equals(totalAmount)) {
			// 남은 금액이랑 총 금액이랑 같으면 상태 미지급
			status = "O";
		} else if (remainAmount == 0) {
			// 남은 금액이 0원이면 상태 완납 P
			status = "C";
		} else {
			// 나머지 상태 부분지급
			status = "P";
		}
		receivableCollectionRequestDTO.setStatus(status);
		dao.updateReceivableStatus(receivableCollectionRequestDTO);
		
	}
	
	// 가맹비 채권 자동 생성
	@Transactional
	public void createMonlyRoyaltyReceivable() {
		
		int insertCount = dao.insertMonthlyRoyaltyReceivable();

	    if (insertCount == 0) {
	        System.out.println("[ReceivableService] 생성된 채권 없음 (이미 생성됨)");
	    } else {
	        System.out.println("[ReceivableService] 월초 가맹비 채권 생성 완료: " + insertCount + "건");
	    }
		
	}
	
	
	public List<ReceivableSummaryDTO> receivableSearchList(
			ReceivableSearchDTO receivableSearchDTO
			){
		Long totalCount = dao.receivableSearchCount(receivableSearchDTO);
		try {
			Pager pager = receivableSearchDTO.getPager();
			pager.pageing(totalCount);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dao.receivableSearchList(receivableSearchDTO);
	}
	
	public List<ReceivableOrderSummaryDTO> orderSummary(ReceivableSummaryDTO receivableSummaryDTO) {
		
		List<ReceivableOrderSummaryDTO> list = dao.orderSummary(receivableSummaryDTO);
		
		Iterator<ReceivableOrderSummaryDTO> iterator = list.iterator();
		
		while (iterator.hasNext()) {
			ReceivableOrderSummaryDTO dto = iterator.next();
			String receivableId = dto.getReceivableId();
			Integer remainAmount = dao.selectRemainAmount(receivableId);
			dto.setRemainAmount(remainAmount);
		}
		
		return list;
	}
	
	// 채권 리스트 페이지 조회 시 금액 요약
	public ReceivableSummaryDTO getSummary(ReceivableSearchDTO receivableSearchDTO) {
		return dao.getSummary(receivableSearchDTO);
	}
	
	
	// detail page 물품대금 미수 내역 리스트
	public List<ReceivableItemDTO > receivableItem(String receivableId) {
		return dao.receivableItemList(receivableId);
	}
	
	// detail page 가맹비 미수 내역
	public ReceivableRoyaltyDTO receivableRoyalty(ReceivableSummaryDTO receivableSummaryDTO) {
		return dao.receivableRoyalty(receivableSummaryDTO);
	}
	
	// detail page 금액 요약
	public ReceivableAmountSummaryDTO selectAmountSummary(ReceivableSummaryDTO receivableSummaryDTO) {
	    ReceivableAmountSummaryDTO dto = dao.selectAmountSummary(receivableSummaryDTO);

	    int royaltyTotal = dto.getRoyaltyTotal();
	    int productTotal = dto.getProductTotal();

	    int amountTotal = royaltyTotal + productTotal;
	    dto.setTotalAmount(amountTotal);

	    List<ReceivableTransactionDTO> list = dao.paidAmount(receivableSummaryDTO);

	    int paidAmount = 0;

	    // 수금 내역이 있으면 합산
	    if (list != null && !list.isEmpty()) {
	        for (ReceivableTransactionDTO t : list) {
	            paidAmount += t.getTransactionAmount();
	        }
	    }

	    dto.setPaidAmount(paidAmount);

	    // ⭐ 핵심: 미수금은 "총액 - 수금액"
	    int unpaidAmount = amountTotal - paidAmount;

	    // 방어코드: 혹시 paidAmount가 더 큰 비정상 케이스면 0으로
	    if (unpaidAmount < 0) unpaidAmount = 0;

	    dto.setUnpaidAmount(unpaidAmount);

	    return dto;
	}
	
	// detail page 지급 내역
	public List<ReceivableTransactionDTO> paidAmount(ReceivableSummaryDTO receivableSummaryDTO) {
		return dao.paidAmount(receivableSummaryDTO);
	}
	
	// detail page 지급 버튼 클릭 시 채권목록
	public List<ReceivableAvailableDTO> getAvailableReceivables(ReceivableSummaryDTO receivableSummaryDTO) {
		return dao.getAvailableReceivables(receivableSummaryDTO);
	}
	
	// 본사 채권 생성
    @Transactional
    public void createReceivableForHqOrder(String hqOrderId) {

        // 중복 생성 방지
        if (dao.existsByHqOrderId(hqOrderId)) {
            return;
        }

        Integer supplyAmount =
        		dao.selectHqOrderSupplyAmount(hqOrderId);

        dao.insertReceivableForHqOrder(
                hqOrderId
        );
    }
    
    // 가맹점 채권 생성
    public void createReceivableForStoreOrder(String storeOrderId) {

        if (dao.existsByStoreOrderId(storeOrderId)) {
            return;
        }

        Integer supplyAmount =
        		dao.selectStoreOrderSupplyAmount(storeOrderId);

        dao.insertReceivableForStoreOrder(
            storeOrderId,
            supplyAmount
        );
    }
    
    
    
    // 거래처 코드
    public List<HqPayableSummaryDTO> hqPayableSearchList(HqPayableSearchDTO dto) {

        long totalCount = dao.selectHqPayableCountByMonth(dto);

        try {
        	Pager pager = dto.getPager();
			pager.pageing(totalCount);
		} catch (Exception e) {
			e.printStackTrace();
		}

        return dao.selectHqPayableList(dto);
    }


    public HqPayableTotalSummaryDTO getHqPayableSummary(HqPayableSearchDTO dto) {

        return dao.selectHqPayableTotalSummaryByMonth(dto);
    }
    
    public List<HqPayableReceivableDTO> getVendorReceivableList(
            Integer vendorId,
            String baseMonth
    ) {
        return dao.selectVendorReceivableList(vendorId, baseMonth);
    }
    
    
    
    @Transactional
    public void payHqReceivable(
            HqPayablePaymentDTO paymentDTO,
            UserDTO userDTO
    ) {
        // 로그인 사용자
        Integer memberId = userDTO.getMember().getMemberId();

        // 파라미터 검증
        if (paymentDTO.getReceivableId() == null || paymentDTO.getReceivableId().isBlank()) {
            throw new IllegalArgumentException("채권 정보가 없습니다.");
        }

        Integer payAmount = paymentDTO.getPayAmount();
        if (payAmount == null || payAmount <= 0) {
            throw new IllegalArgumentException("지급 금액이 올바르지 않습니다.");
        }

        //  해당 채권의 남은 금액 조회
        Integer remainAmount =
                dao.selectReceivableRemainAmount(paymentDTO.getReceivableId());

        if (remainAmount == null || remainAmount <= 0) {
            throw new IllegalStateException("이미 지급 완료된 채권입니다.");
        }

        if (payAmount > remainAmount) {
            throw new IllegalArgumentException("지급 금액이 남은 미지급 금액을 초과했습니다.");
        }

        //  지급 트랜잭션 insert
        ReceivableCollectionRequestDTO insertDTO =
                new ReceivableCollectionRequestDTO();

        insertDTO.setReceivableId(paymentDTO.getReceivableId());
        insertDTO.setAmount(payAmount);
        insertDTO.setMemo(paymentDTO.getMemo());
        insertDTO.setMemberId(memberId);

        dao.insertHqPayment(insertDTO);
    }

}

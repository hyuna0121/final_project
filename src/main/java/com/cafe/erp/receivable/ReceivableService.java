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
import com.cafe.erp.util.Pager;

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
		
		List<ReceivableTransactionDTO> list  = dao.paidAmount(receivableSummaryDTO);
		
		int paidAmount = 0;
		int UnpaidAmount = 0;
		
		if (list.isEmpty()) {
			dto.setPaidAmount(paidAmount);
			dto.setUnpaidAmount(UnpaidAmount);
		} else {
			
			Iterator<ReceivableTransactionDTO> item = list.iterator();
			
			while (item.hasNext()) {
				ReceivableTransactionDTO receivableTransactionDTO = item.next();
				 paidAmount += receivableTransactionDTO.getTransactionAmount();
			}
			
			dto.setPaidAmount(paidAmount);
			
			UnpaidAmount = amountTotal - paidAmount;
			
			dto.setUnpaidAmount(UnpaidAmount);
		}
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
	
	
	
	
	
}

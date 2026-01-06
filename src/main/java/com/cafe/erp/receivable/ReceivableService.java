package com.cafe.erp.receivable;

import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cafe.erp.receivable.detail.ReceivableAmountSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableItemDTO;
import com.cafe.erp.receivable.detail.ReceivableOrderSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableRoyaltyDTO;
import com.cafe.erp.receivable.detail.ReceivableTransactionDTO;
import com.cafe.erp.util.Pager;

@Service
public class ReceivableService {
	
	@Autowired
	private ReceivableDAO dao;
	
	
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
		return dao.orderSummary(receivableSummaryDTO);
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
	
	
	
}

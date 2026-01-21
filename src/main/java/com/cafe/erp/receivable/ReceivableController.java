package com.cafe.erp.receivable;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cafe.erp.receivable.detail.ReceivableAmountSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableOrderSummaryDTO;
import com.cafe.erp.receivable.detail.ReceivableRoyaltyDTO;
import com.cafe.erp.receivable.detail.ReceivableTransactionDTO;
import com.cafe.erp.receivable.hq.HqPayablePaymentDTO;
import com.cafe.erp.receivable.hq.HqPayableReceivableDTO;
import com.cafe.erp.receivable.hq.HqPayableSearchDTO;
import com.cafe.erp.receivable.hq.HqPayableSummaryDTO;
import com.cafe.erp.receivable.hq.HqPayableTotalSummaryDTO;
import com.cafe.erp.security.UserDTO;
import com.cafe.erp.util.Pager;
import com.cafe.erp.vendor.VendorDTO;

import jakarta.validation.Valid;

@Controller
@RequestMapping("/receivable/*")
public class ReceivableController {
	
	@Autowired
	private ReceivableService service;
	
	
	@GetMapping("receivable")
	public void receivableList() throws Exception {
		
	}
	
	@PostMapping("search")
	public String searchReceivable(
			@Valid ReceivableSearchDTO receivableSearchDTO,
			BindingResult bindingResult,
			Model model
			){
		
		if (bindingResult.hasErrors()) {
			model.addAttribute("errorMessage", bindingResult.getFieldError().getDefaultMessage());
			return "receivable/receivable-table";
		}
		List<ReceivableSummaryDTO> list = service.receivableSearchList(receivableSearchDTO);
		model.addAttribute("receivables", list);
		Pager pager  = receivableSearchDTO.getPager();
		
		model.addAttribute("pager", receivableSearchDTO.getPager());
		
		return "receivable/receivable-table";
	}
	
	@GetMapping("receivableDetail")
	public void detail(ReceivableSummaryDTO receivableSummaryDTO, Model model) {
		// 디테일 페이지 물품 대금 리스트
		List<ReceivableOrderSummaryDTO> receivableOrderSummaryDTO = service.orderSummary(receivableSummaryDTO);
		ReceivableRoyaltyDTO receivableRoyaltyDTO = service.receivableRoyalty(receivableSummaryDTO);
		ReceivableAmountSummaryDTO receivableAmountSummaryDTO = service.selectAmountSummary(receivableSummaryDTO);
		List<ReceivableTransactionDTO> receivableTransactionDTO = service.paidAmount(receivableSummaryDTO);
		
		
		model.addAttribute("receivableSummaryDTO", receivableSummaryDTO);
		model.addAttribute("receivableOrderSummaryDTO", receivableOrderSummaryDTO);
		model.addAttribute("receivableRoyaltyDTO", receivableRoyaltyDTO);
		model.addAttribute("receivableAmountSummaryDTO", receivableAmountSummaryDTO);
		model.addAttribute("receivableTransactionDTO", receivableTransactionDTO);
	}
	
	
	
	@GetMapping("vendor")
	public String receivableVendor() {
		return "receivable/receivable-vendor";
	}

	@PostMapping("vendor/search")
	public String hqPayableSearch(HqPayableSearchDTO dto, Model model) {
		
		List<HqPayableSummaryDTO> list = service.hqPayableSearchList(dto);

		model.addAttribute("list", list);
		model.addAttribute("pager", dto.getPager());
		return "receivable/hq-payable-table";
	}

	@PostMapping("vendor/summary")
	@ResponseBody
	public HqPayableTotalSummaryDTO hqPayableSummary(HqPayableSearchDTO dto) {
		return service.getHqPayableSummary(dto);
	}
	
	// 지급 폼 채권 목록 조회
	@GetMapping("vendor/receivables")
	@ResponseBody
	public List<HqPayableReceivableDTO> getVendorReceivables(
	        @RequestParam Integer vendorId,
	        @RequestParam String baseMonth
	) {
	    return service.getVendorReceivableList(vendorId, baseMonth);
	}
	
	
	
	@PostMapping("/hq/pay")
	@ResponseBody	
	public void payHqReceivable(
			HqPayablePaymentDTO dto,
			@AuthenticationPrincipal UserDTO userDTO
			) {
		service.payHqReceivable(dto,userDTO);
	}

	
	
}

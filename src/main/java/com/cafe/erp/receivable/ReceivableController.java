package com.cafe.erp.receivable;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cafe.erp.receivable.detail.ReceivableItemDTO;
import com.cafe.erp.util.Pager;

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
		List<ReceivableItemDTO> itemList = service.receivableItem(receivableSummaryDTO);
	    model.addAttribute("receivableSummaryDTO", receivableSummaryDTO);
	    model.addAttribute("receivableItemList", itemList);
	    
	}
	
	
}

package com.cafe.erp.receivable;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.cafe.erp.receivable.detail.ReceivableAvailableDTO;
import com.cafe.erp.receivable.detail.ReceivableCollectionRequestDTO;
import com.cafe.erp.receivable.detail.ReceivableItemDTO;

@RestController
@RequestMapping("/receivable/*")
public class ReceivableApiController {
	
	@Autowired
	private ReceivableService service;

	
	@GetMapping("items")
	public List<ReceivableItemDTO> receivableItemList(
			@RequestParam("receivableId")String receivableId
			) {
		return service.receivableItem(receivableId);
	}
	
	@GetMapping("avilable")
	public List<ReceivableAvailableDTO> getAvailableReceivables(
			ReceivableSummaryDTO receivableSummaryDTO
			) {
		return service.getAvailableReceivables(receivableSummaryDTO);
	}
	
	@PostMapping("collection")
	public void collectReceivable(
			@RequestBody ReceivableCollectionRequestDTO dto
			) {
		service.collectReceivable(dto);
	}
	
	
}

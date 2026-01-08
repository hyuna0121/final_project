package com.cafe.erp.receivable;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
import com.cafe.erp.security.UserDTO;

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
	
	// 지급 내역 Insert
	@PostMapping("collection")
	public void collectReceivable(
			@RequestBody ReceivableCollectionRequestDTO dto,
			@AuthenticationPrincipal UserDTO userDTO
			) {
		service.collectReceivable(dto,userDTO.getMember().getMemberId());
	}
	
	
}

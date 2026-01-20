package com.cafe.erp.stock;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.cafe.erp.item.ItemService;
import com.cafe.erp.member.MemberDTO;
import com.cafe.erp.order.OrderDetailDTO;
import com.cafe.erp.stock.StoreInventoryDTO;
import com.cafe.erp.security.UserDTO;

@Controller
@RequestMapping("/stock/*")
public class StockController {

    private final ItemService itemService;
	
	@Autowired
	private StockService stockService;

    StockController(ItemService itemService) {
        this.itemService = itemService;
    }
	
	@GetMapping("stock")
	public String stock(@AuthenticationPrincipal UserDTO userDTO, Model model){
		MemberDTO member = userDTO.getMember();
		List<StockDTO> stockList = stockService.getStockByMember(member.getMemberId());
		model.addAttribute("stockList", stockList);
		return "stock/stock";
	}
	
	// 재고 기록 삽입
	public void insertStockHistory(StockDTO stockDTO, OrderDetailDTO orderDetailDTO) {
		stockService.insertStockHistory(stockDTO, orderDetailDTO);
	}
	// 재고 여부
	public int existsStock(StockDTO stockDTO){
	 	return stockService.existsStock(stockDTO);
	}
	// 재고 수량 변경
	public void updateStockQuantity(StockDTO stockDTO) {
		stockService.updateStockQuantity(stockDTO);
	}
	// 입출고 기록
	public void insertStock(StockDTO stockDTO) {
		stockService.insertStock(stockDTO);
	}
	
	@GetMapping("storeInventory")
	@ResponseBody
	public List<StoreInventoryDTO> getStoreInventory(
	        @AuthenticationPrincipal UserDTO userDTO
	) {
	    MemberDTO member = userDTO.getMember();

	    // 가맹점만 허용
	    if (String.valueOf(member.getMemberId()).charAt(0) != '2') {
	        throw new IllegalStateException("가맹점만 접근 가능");
	    }

	    // 가맹 재고 목록 조회
	    return stockService.getStoreInventory(member.getMemberId());
	}
	
	@PostMapping("storeStockUse")
	public String storeStockUse(
	    StoreStockUseRequest request,
	    @RequestParam String releaseType,
	    @RequestParam(required = false) String releaseReason,
	    @AuthenticationPrincipal UserDTO userDTO
	) {
		
	    int memberId = userDTO.getMember().getMemberId();

	    stockService.storeStockUse(
	        request.getItems(),
	        memberId,
	        releaseType,
	        releaseReason
	    );

	    return "redirect:/order/release";
	}
	
	@GetMapping("/stock/release")
	@ResponseBody
	public List<StockReleaseItemDTO> releaseDetail(
	        @RequestParam Integer inputId
	) {
	    return stockService.getStoreReleaseDetail(inputId);
	}
	
}

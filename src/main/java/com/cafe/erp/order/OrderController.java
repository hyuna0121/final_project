package com.cafe.erp.order;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cafe.erp.item.ItemDTO;
import com.cafe.erp.item.ItemService;
import com.cafe.erp.member.MemberDTO;
import com.cafe.erp.security.UserDTO;
import com.cafe.erp.store.StoreService;
import com.cafe.erp.vendor.VendorService;

@Controller
@RequestMapping("/order/*")
public class OrderController {

    private final StoreService storeService;
	
	private final ItemService itemService;
	private final VendorService vendorService;
	
	@Autowired
	private OrderService orderService;
	
	@Autowired
    public OrderController(ItemService itemService, VendorService vendorService, StoreService storeService) {
        this.itemService = itemService;
        this.vendorService = vendorService;
        this.storeService = storeService;
    }
	
	// 본사 발주 등록 페이지 요청
	@GetMapping("request")
	public String request(Model model, @AuthenticationPrincipal UserDTO userDTO ) {
		model.addAttribute("showVendorSelect", true);
		model.addAttribute("vendorList", vendorService.findAll());
		MemberDTO member = userDTO.getMember();
		model.addAttribute("member", member);
		System.out.println(userDTO.getMember().getMemberId());
		return "order/hqOrder";
	}
	
	// 발주 등록 상품 검색 목록 요청
	@GetMapping("/order/itemSearch")
	@ResponseBody
	public List<ItemDTO> searchForOrder(
	        @RequestParam(required = false) Long vendorCode,
	        @RequestParam(required = false) String keyword) {
		
	    return itemService.searchForOrder(vendorCode, keyword);
	}
	
	// 발주 등록
	@PostMapping("request")
	@Transactional
	public String request(OrderDTO orderDTO, @AuthenticationPrincipal UserDTO userDTO) {
		orderService.requestOrder(orderDTO, userDTO);
		return "redirect:./approval";
	}
	
	// 발주 목록 요청
	@GetMapping("approval")
	@Transactional
	public void approval(Model model) {
		List<OrderDTO> orderHqList = orderService.listHq();
		model.addAttribute("orderHqList", orderHqList);
		List<OrderDTO> orderStoreList = orderService.listStore();
		model.addAttribute("orderStoreList", orderStoreList);
	}
	//발주 상세 목록 요청
	@GetMapping("detail")
	@Transactional
	public String orderDetail(@RequestParam String orderNo, @RequestParam String orderType, Model model) {
	    List<OrderDetailDTO> items = null;
	    if ("HQ".equals(orderType)) {
	    	items = orderService.getHqOrderDetail(orderNo);
	    } else {
	    	items = orderService.getStoreOrderDetail(orderNo);
	    }
	    model.addAttribute("items", items);

	  return "order/orderDetailFragment"; // tbody용 fragment
	}
	
	// 승인 요청
	@PostMapping("approve")
	@ResponseBody
	public String approveOrder(@RequestBody List<OrderApproveRequestDTO> orderNos) {
		orderService.approveOrder(orderNos);
		return "order/approval";
	}
	
	// 입고 목록 요청
	@GetMapping("receive")
	public void receive() {
		
	}
	
	//출고 목록 요청
	@GetMapping("release")
	public void release() {
		
	}

}
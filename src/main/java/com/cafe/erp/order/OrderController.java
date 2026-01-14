package com.cafe.erp.order;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	public String request(OrderDTO orderDTO, 
			@AuthenticationPrincipal UserDTO userDTO,
			RedirectAttributes redirectAttributes) {
		try {
			orderService.requestOrder(orderDTO, userDTO);
			redirectAttributes.addFlashAttribute("msg", "발주 요청이 완료되었습니다.");
			return "redirect:/order/approval";

		} catch (IllegalArgumentException e) {
			redirectAttributes.addFlashAttribute("errorMsg", e.getMessage());
			return "redirect:/order/request";

		}
	}
	
	// 목록 요청 
	@GetMapping("list")
	@Transactional
	public String orderList(
			@RequestParam List<Integer> statuses,
			Model model, MemberDTO member) {
		
		List<OrderDTO> orderHqList = orderService.listHq(statuses, member);
	    List<OrderDTO> orderStoreList = orderService.listStore(statuses, member);

	    model.addAttribute("orderHqList", orderHqList);
	    model.addAttribute("orderStoreList", orderStoreList);
	    model.addAttribute("member", member);
	    boolean hasRequest = statuses.contains(100);
	    boolean hasApproved = statuses.contains(200);

	    model.addAttribute("hasRequest", hasRequest);
	    model.addAttribute("hasApproved", hasApproved);

	    return "order/approval"; // JSP 하나만 사용
	}
	// 발주 목록 요청
	@GetMapping("approval")
	public String approval(Model model, @AuthenticationPrincipal UserDTO userDTO) {
		MemberDTO member = userDTO.getMember();
		List<Integer> statuses = List.of(100, 150, 300); // 요청 + 반려
	    return orderList(statuses, model, member);
	}
	// 입고 목록 요청
	@GetMapping("receive")
	public String receive(Model model, @AuthenticationPrincipal UserDTO userDTO) {
		MemberDTO member = userDTO.getMember();
		List<Integer> statuses = List.of(200); // 승인
		return orderList(statuses, model, member);
	}
	
	//출고 목록 요청
	@GetMapping("release")
	public void release() {
		
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
	public String approveOrder(@RequestBody List<OrderRequestDTO> orderNos, @AuthenticationPrincipal UserDTO userDTO) {
		MemberDTO member = userDTO.getMember();
		orderService.approveOrder(orderNos, member);
		return "order/approval";
	}
	
	// 반려 요청
	@PostMapping("reject")
	@ResponseBody
	public String rejectOrder(
			@RequestBody OrderRejectDTO orderRejectDTO,
			@AuthenticationPrincipal UserDTO userDTO
			) {
		orderService.rejectOrder(orderRejectDTO,userDTO);
		return "order/approval";
	}
	
	// 입고 요청
	@PostMapping("receive")
	@ResponseBody
	public String receive(@RequestBody List<OrderRequestDTO> orderNos) {
		orderService.receiveOrder(orderNos);
		return "redirect:/order/receive";
	}
	
	// 승인 취소 요청
	@PostMapping("cancelApprove")
	public String cancelApprove(@RequestBody List<OrderRequestDTO> orderNos) {
		orderService.cancelApprove(orderNos);
		return "redirect:/order/receive";
	}

}
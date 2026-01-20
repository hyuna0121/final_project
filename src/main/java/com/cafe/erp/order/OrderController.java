package com.cafe.erp.order;

import java.util.List;

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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.cafe.erp.item.ItemDTO;
import com.cafe.erp.item.ItemService;
import com.cafe.erp.member.MemberDTO;
import com.cafe.erp.security.UserDTO;
import com.cafe.erp.stock.StockDAO;
import com.cafe.erp.stock.StockReleaseDTO;
import com.cafe.erp.stock.StockService;
import com.cafe.erp.store.StoreService;
import com.cafe.erp.vendor.VendorService;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/order/*")
@Slf4j
public class OrderController {

    private final StoreService storeService;
	private final ItemService itemService;
	private final VendorService vendorService;
	private final StockService stockService;
	
	@Autowired
	private OrderService orderService;
	
    public OrderController(ItemService itemService, VendorService vendorService, StoreService storeService,StockService stockService) {
        this.itemService = itemService;
        this.vendorService = vendorService;
        this.storeService = storeService;
        this.stockService = stockService;
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
	
	// 목록 요청 
	@GetMapping("list")
	@Transactional
	public String orderList(
			@RequestParam List<Integer> statuses,
			@RequestParam(required = false) String viewType,
			Model model, MemberDTO member) {
		
		// viewType에 따라 필요한 목록만 조회
	    List<OrderDTO> orderHqList = List.of();
	    List<OrderDTO> orderStoreList = List.of();
	    
	    if ("HQ_APPROVAL".equals(viewType) || "HQ_RECEIVE".equals(viewType)) {
	        orderHqList = orderService.listHq(statuses, member);
	    }

	    if ("HQ_APPROVAL".equals(viewType) || "STORE_RECEIVE".equals(viewType)) {
	        orderStoreList = orderService.listStore(statuses, member);
	    }
	    model.addAttribute("orderHqList", orderHqList);
	    model.addAttribute("orderStoreList", orderStoreList);
	    model.addAttribute("member", member);
	    
	    // 버튼 제어
	    boolean hasRequest = statuses.contains(100);
	    boolean hasApproved = statuses.contains(200);
	    model.addAttribute("hasRequest", hasRequest);
	    model.addAttribute("hasApproved", hasApproved);  
	    model.addAttribute("viewType", viewType); // JSP에서 탭/버튼 제어에도 사용 가능

	    return "order/approval"; // JSP 하나만 사용
	}
	// 승인 목록 요청
	@GetMapping("approval")
	public String approval(Model model, @AuthenticationPrincipal UserDTO userDTO) {
		MemberDTO member = userDTO.getMember();
		List<Integer> statuses = List.of(100, 150, 300); // 요청 + 반려
		String viewType = "HQ_APPROVAL";
	    return orderList(statuses, viewType, model, member);
	}
	//입고 목록 요청
	@GetMapping("receive")
	@Transactional
	public String receiveList(Model model, @AuthenticationPrincipal UserDTO userDTO) {

	    MemberDTO member = userDTO.getMember();

	    // 본사 유저
	    if (String.valueOf(member.getMemberId()).charAt(0) == '1' ) {
	        // 가맹 발주 중 출고 대상
	        List<OrderDTO> storeReleaseList =
	            orderService.listHq(List.of(200, 400), member);
	        model.addAttribute("orderStoreList", storeReleaseList);
	    }

	    // 가맹 유저
	    if (String.valueOf(member.getMemberId()).charAt(0) == '2') {
	        List<OrderDTO> storeReleaseReqList =
	            orderService.getStoreReleaseRequests(List.of(330, 350), member);
	        model.addAttribute("orderStoreList", storeReleaseReqList);
	    }
	    model.addAttribute("member", member);

	    return "order/receive";
	}
	
	
	//출고 목록 요청
	@GetMapping("release")
	public String releaseEntry(@AuthenticationPrincipal UserDTO userDTO) {

	    MemberDTO member = userDTO.getMember();

	    // 본사
	    if (String.valueOf(member.getMemberId()).charAt(0) == '1') {
	        return "redirect:/order/releaseHq";
	    }

	    // 가맹
	    if (String.valueOf(member.getMemberId()).charAt(0) == '2') {
	        return "redirect:/order/releaseStore";
	    }

	    throw new IllegalStateException("잘못된 사용자 접근");
	}
	
	@GetMapping("releaseHq")
	public String releaseHq(Model model, @AuthenticationPrincipal UserDTO userDTO) {

	    MemberDTO member = userDTO.getMember();
	    List<OrderDTO> storeReleaseList =
	        orderService.getStoreReleaseTarget(List.of(330, 350), member);
	    model.addAttribute("orderStoreList", storeReleaseList);
	    model.addAttribute("member", member);

	    return "order/release"; // 📌 JSP
	}
	
	//==============================
	@GetMapping("releaseStore")
	public String releaseStore(Model model, @AuthenticationPrincipal UserDTO userDTO) {

	    MemberDTO member = userDTO.getMember();
	    List<StockReleaseDTO> releaseList = stockService.getStoreReleaseList(member.getMemberId());
	    
	    model.addAttribute("releaseList", releaseList);
	    model.addAttribute("member", member);

	    return "order/releaseStore"; // 📌 JSP
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
	// 발주 요청
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
	// 승인 요청
	@PostMapping("approve")
	@ResponseBody
	public String approveOrder(@RequestBody List<OrderRequestDTO> orderNos, @AuthenticationPrincipal UserDTO userDTO) {
		MemberDTO member = userDTO.getMember();
		orderService.approveOrder(orderNos, member);
		return "order/approval";
	}
	// 승인 취소 요청
	@PostMapping("cancelApprove")
	public String cancelApprove(@RequestBody List<OrderRequestDTO> orderNos) {
		orderService.cancelApprove(orderNos);
		return "redirect:/order/receive";
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
		System.out.println("입고 메서드 실행");
		orderService.inoutOrder(orderNos, "IN");
		return "redirect:/order/receive";
	}
	// 입고 취소 요청
	@PostMapping("cancelReceive")
	@ResponseBody
	public String cancelReceive(@RequestBody List<OrderRequestDTO> orderNos) {
		orderService.cancelReceive(orderNos);
		return "redirect:/order/receive";
	}
	// 본사출고완료
	@PostMapping("updateReceiveStatusByStoreOrder")
	@ResponseBody
	@Transactional
	public String updateReceiveStatusByStoreOrder(@RequestBody List<OrderRequestDTO> orderNos) {
		for (OrderRequestDTO orderNo : orderNos) {
			orderService.shipStoreOrder(orderNo.getOrderNo());	
		}
		orderService.updateReceiveStatusByStoreOrder(orderNos);
		return "redirect:/order/receive";
	}
	// 본사출고취소
	@PostMapping("updateCancelReceiveStatusByStoreOrder")
	@ResponseBody
	public String updateCancelReceiveStatusByStoreOrder(@RequestBody List<OrderRequestDTO> orderNos) {
		orderService.updateCancelReceiveStatusByStoreOrder(orderNos);
		return "redirect:/order/receive";
	}
	
	@PostMapping("releaseByHq")
	@ResponseBody
	@Transactional
	public String releaseByHq(@RequestBody List<OrderRequestDTO> orderNos) {
		orderService.releaseByHq(orderNos);
		orderService.inoutOrder(orderNos, "IN");
		return "redirect:/order/receive";
	}
	// 가맹 재고사용 요청
	@PostMapping("release")
	@ResponseBody
	public String release(@RequestBody List<OrderRequestDTO> orderNos) {
		orderService.inoutOrder(orderNos, "OUT");
		return "redirect:/order/release";
	}
	
}
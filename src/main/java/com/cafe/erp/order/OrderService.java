package com.cafe.erp.order;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.cafe.erp.item.ItemDTO;
import com.cafe.erp.security.UserDTO;

@Service
public class OrderService {
	
	@Autowired
	private OrderDAO orderDAO;
	
	public void requestOrder(OrderDTO orderDTO, UserDTO userDTO) { 
		
		// 본사/가맹 어느쪽인지
		int orderType = userDTO.getMember().getMemberId();
		// 기본(memberId가 1로 시작): 본사(false)
		boolean isHqOrder = false;
		// 그외(memberId가 2로 시작): 가맹(ture)
		if(String.valueOf(orderType).charAt(0) == '2') {
			isHqOrder = true;
			// 스토어 정보 가져오기
			int storeId = orderDAO.selectStoreId(orderType);
			orderDTO.setStoreId(storeId);
		}
		// orderId 기입
		String orderId = generateOrderId(isHqOrder);
				
		// 발주번호 기입
		orderDTO.setHqOrderId(orderId);
		
		// 요청자 기입
		orderDTO.setMemberId(orderType);
		
		// 발주 insert
		insertOrder(orderDTO, isHqOrder);
		// 발주 상세 insert
		insertOrderItemDetail(orderDTO, isHqOrder);
	}
	
	// orderId 생성
	public String generateOrderId(boolean isHqOrder) {

	    // R / P 구분
	    String prefix = isHqOrder ? "R" : "P";

	    // 오늘 날짜 yyyyMMdd
	    String orderDate = LocalDate.now()
	        .format(DateTimeFormatter.BASIC_ISO_DATE);
	    
	    String maxOrderId = "";
	    if (prefix.equals("P")) {
	    	// 오늘 + 타입 기준 최대값 조회
	    	maxOrderId = orderDAO.selectMaxOrderHqId(prefix, orderDate);
	    } else {
	    	maxOrderId = orderDAO.selectMaxOrderStoreId(prefix, orderDate);
	    }

	    // 일련번호 계산
	    int nextSeq = 1;
	    if (maxOrderId != null) {
	      // 뒤 4자리 추출
	      String seqStr = maxOrderId.substring(maxOrderId.length() - 4);
	      nextSeq = Integer.parseInt(seqStr) + 1;
	    }

	    // 4자리 zero padding
	    String seq = String.format("%04d", nextSeq);

	    // 최종 발주번호
	    return prefix + orderDate + seq;
	  }
	
	public void insertOrder(OrderDTO orderDTO, Boolean isHqOrder) {
		if (!isHqOrder) {
			orderDAO.insertHqOrder(orderDTO);
		} else {
			orderDAO.insertStoreOrder(orderDTO);			
		}
	}
	public void insertOrderItemDetail(OrderDTO orderDTO, Boolean isHqOrder) {
		if (!isHqOrder) {
			for (OrderItemRequestDTO req : orderDTO.getItems()) {
				
				OrderDetailDTO detail = new OrderDetailDTO();
				detail.setHqOrderId(orderDTO.getHqOrderId()); // ⭐ FK 세팅
				detail.setHqOrderItemCode(req.getItemCode());
				detail.setHqOrderQty(req.getItemQuantity());
				detail.setHqOrderPrice(req.getItemSupplyPrice());
				detail.setHqOrderAmount(
						req.getItemQuantity() * req.getItemSupplyPrice()
						);
				detail.setItemId(req.getItemId());
				detail.setVendorCode(req.getVendorCode());
				detail.setHqOrderItemName(req.getItemName());
				
				orderDAO.insertHqOrderItemDetail(detail);
			}
		} else {
			for (OrderItemRequestDTO req : orderDTO.getItems()) {
				
				OrderDetailDTO detail = new OrderDetailDTO();
				detail.setHqOrderId(orderDTO.getHqOrderId()); // ⭐ FK 세팅
				detail.setHqOrderItemCode(req.getItemCode());
				detail.setHqOrderQty(req.getItemQuantity());
				detail.setHqOrderPrice(req.getItemSupplyPrice());
				detail.setHqOrderAmount(
						req.getItemQuantity() * req.getItemSupplyPrice()
						);
				detail.setItemId(req.getItemId());
				detail.setVendorCode(req.getVendorCode());
				detail.setHqOrderItemName(req.getItemName());
				
				// 발주 상세 insert
				orderDAO.insertStoreOrderItemDetail(detail);
			}
		}
	}

	
	// 발주 목록 
	public List<OrderDTO> listHq() {
		return orderDAO.listHq();
	}
	public List<OrderDTO> listStore() {
		return orderDAO.listStore();
	}
	
	public List<OrderDetailDTO> getHqOrderDetail(String orderNo) {
		return orderDAO.getHqOrderDetail(orderNo);
	}
	public List<OrderDetailDTO> getStoreOrderDetail(String orderNo) {
		return orderDAO.getStoreOrderDetail(orderNo);
	}
	
	public void approveOrder(List<OrderApproveRequestDTO> orderNos) {
		
		for (OrderApproveRequestDTO orderNo : orderNos) {
			if ("HQ".equals(orderNo.getOrderType())) {
				orderDAO.approveHqOrder(orderNo.getOrderNo());							
			} else if("STORE".equals(orderNo.getOrderType())){
				orderDAO.approveStoreOrder(orderNo.getOrderNo());							
			}
		}
	}
	

}

package com.cafe.erp.order;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

@Service
public class OrderService {
	
	@Autowired
	private OrderDAO orderDAO;
	
	public void requestOrder(OrderDTO orderDTO) { 
		
		// 본사/가맹 어느쪽 발주 인지 본사인경우 false
		String orderId = generateOrderId(false);
		
		// 발주번호 생성
		orderDTO.setHqOrderId(orderId);
		
		// 발주 insert
		orderDAO.insertOrder(orderDTO);
		
		// 발주 상세 insert
		for (OrderItemRequestDTO req : orderDTO.getItems()) {

		      OrderDetailDTO detail = new OrderDetailDTO();
		      detail.setHqOrderId(orderId); // ⭐ FK 세팅
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
		      orderDAO.insertOrderDetail(detail);
		}
	}
	// orderId 생성
	public String generateOrderId(boolean isHqOrder) {

	    // R / P 구분
	    String prefix = isHqOrder ? "R" : "P";

	    // 오늘 날짜 yyyyMMdd
	    String orderDate = LocalDate.now()
	        .format(DateTimeFormatter.BASIC_ISO_DATE);

	    // 오늘 + 타입 기준 최대값 조회
	    String maxOrderId = orderDAO.selectMaxOrderId(prefix, orderDate);

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
	
	// 발주 목록 
	public List<OrderDTO> listRequest() {
		return orderDAO.listRequest();
	}

}

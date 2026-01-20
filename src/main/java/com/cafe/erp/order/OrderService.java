package com.cafe.erp.order;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafe.erp.member.MemberDTO;
import com.cafe.erp.notification.service.NotificationService;
import com.cafe.erp.order.event.OrderReceivedEvent;
import com.cafe.erp.receivable.ReceivableDAO;
import com.cafe.erp.security.UserDTO;
import com.cafe.erp.stock.StockDAO;
import com.cafe.erp.stock.StockDTO;
import com.cafe.erp.stock.StockInoutDTO;
import com.cafe.erp.stock.StockService;

@Service
public class OrderService {
	
	@Autowired
	private OrderDAO orderDAO;
	
	@Autowired
	private StockDAO stockDAO;
	
	@Autowired
	private ApplicationEventPublisher eventPublisher;
	
	@Autowired
	private NotificationService notificationService;
	
	@Autowired
	private ReceivableDAO receivableDAO;
	
	@Autowired
	private StockService stockService;
	
	public void requestOrder(OrderDTO orderDTO, UserDTO userDTO) { 
		
		if (orderDTO.getHqOrderTotalAmount() == null) {
	        throw new IllegalArgumentException("발주 금액이 없습니다.");
	    }
		
		// 본사/가맹 어느쪽인지
		int orderType = userDTO.getMember().getMemberId();
		// 기본(memberId가 1로 시작): 본사(false)
		boolean isHqOrder = false;
		// 그외(memberId가 2로 시작): 가맹(ture)
		if(String.valueOf(orderType).charAt(0) == '2') {
			isHqOrder = true;
			// 스토어 정보 가져오기
			OrderDTO dto = orderDAO.selectStoreId(orderType);
			
			orderDTO.setStoreId(dto.getStoreId());
			orderDTO.setStoreName(dto.getStoreName());
		}
		// 발주번호(orderId) 생성
		String orderId = generateOrderId(isHqOrder);
				
		// 발주번호 기입
		orderDTO.setHqOrderId(orderId);
		
		// 요청자 기입
		orderDTO.setMemberId(orderType);
		
		// 상태값 기입(요청/자동승인)
		orderDTO.setHqOrderStatus(100);	// 기본: 요청	
		if (isHqOrder) {
			List<OrderItemRequestDTO> detailList = orderDTO.getItems();
			int isAutoOrder = 0;
			for (OrderItemRequestDTO orderItemRequestDTO : detailList) {
				// 0: 자동승인 1:승인요청
				if(orderItemRequestDTO.getItemAutoOrder() == true) {
					isAutoOrder++;
				}
			}
			if (isAutoOrder == 0) {
				orderDTO.setHqOrderStatus(330);	// isAutoOrder 값이 0이면 자동승인
				orderDTO.setStoreOrderApprover(999999);
			}
		}
		// 발주 insert
		insertOrder(orderDTO, isHqOrder);
		// 발주 상세 insert
		insertOrderItemDetail(orderDTO, isHqOrder);

		if (isHqOrder && orderDTO.getHqOrderStatus() == 100) {
		    notificationService.sendOrderNotificationToFinanceTeam(
		        orderDTO.getHqOrderId(),
		        orderType
		  );
		}
		
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
				detail.setVendorId(req.getVendorId());
				detail.setHqOrderItemName(req.getItemName());
				
				orderDAO.insertHqOrderItemDetail(detail);
			}
		} else {
			// 가맹점 발주 상세 insert
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
				detail.setVendorId(req.getVendorId());
				detail.setHqOrderItemName(req.getItemName());
				
				// 발주 상세 insert
				orderDAO.insertStoreOrderItemDetail(detail);
			}
		}
	}

	
	// 발주 목록 
	public List<OrderDTO> listHq(List<Integer> statuses, MemberDTO member) {
		return orderDAO.listHq(statuses, member);
	}
	public List<OrderDTO> listStore(List<Integer> statuses, MemberDTO member) {
		return orderDAO.listStore(statuses, member);
	}
	
	public List<OrderDetailDTO> getHqOrderDetail(String orderNo) {
		return orderDAO.getHqOrderDetail(orderNo);
	}
	public List<OrderDetailDTO> getStoreOrderDetail(String orderNo) {
		return orderDAO.getStoreOrderDetail(orderNo);
	}
	
	public List<OrderDTO> getStoreReleaseTarget(List<Integer> statuses, MemberDTO member){
		return orderDAO.getStoreReleaseTarget(statuses, member);
	}
	public List<OrderDTO> getStoreReleaseRequests(List<Integer> statuses, MemberDTO member){
		return orderDAO.getStoreReleaseRequests(statuses, member);
	}
	
	public void approveOrder(List<OrderRequestDTO> orderNos, MemberDTO member) {
		int orderApprover = member.getMemberId();
		for (OrderRequestDTO orderNo : orderNos) {
			if ("HQ".equals(orderNo.getOrderType())) {
				orderDAO.approveHqOrder(orderNo.getOrderNo(), orderApprover);							
			} else if("STORE".equals(orderNo.getOrderType())){
				orderDAO.approveStoreOrder(orderNo.getOrderNo(), orderApprover);							
			}
		}
	}
	
	public List<OrderDTO> getApprovedOrder() {
		return orderDAO.getApprovedOrder();
	}
	public List<OrderDetailDTO> getApprovedOrderDetail() {
		return orderDAO.getApprovedOrderDetail();
	}
	// 반려
	public void rejectOrder(OrderRejectDTO orderRejectDTO, UserDTO userDTO) {
		// 발주테이블 상태값을 반려로 update
		orderDAO.rejectOrder(orderRejectDTO);
		// 가맹점주 아이디 조회
		OrderRejectDTO result = orderDAO.rejectOrderNotification(orderRejectDTO);
		int senderMemberId = userDTO.getMember().getMemberId(); // 본사 직원 아이디
		int receiverMemberId = result.getStoreMemberId(); // 가맹점주 아이디
		String orderId = result.getRejectId(); // 발주 번호
		
		notificationService.sendOrderRejectNotification(
				senderMemberId,
				receiverMemberId,
				orderId
		);
	}

	@Transactional
	public void inoutOrder(List<OrderRequestDTO> orderNos, String inoutType) {
		
		List<OrderDetailDTO> orderDetailList = new ArrayList<>();
		StockInoutDTO stockInoutDTO = new StockInoutDTO();
		int inputId = 0;
		int warehouseNo = 0;
		
		for (OrderRequestDTO orderNo : orderNos) {
			// 1️ 이미 입고완료인지 체크
			if ("HQ".equals(orderNo.getOrderType())) {
				OrderDTO storeOrder = orderDAO.isHqAlreadyReceived(orderNo.getOrderNo());
				if (storeOrder == null) {
				    // 데이터 자체가 없음 → 방어
					throw new IllegalArgumentException("입고 처리 중 오류가 발생했습니다.");
				}

				int status = storeOrder.getHqOrderStatus();
				System.out.println("HQ STATUS = " + status);

				if (status == 400) {
				    // 이미 입고 완료 → 처리 금지
					throw new IllegalArgumentException("이미 입고된 발주입니다.");
				}

				orderDAO.receiveHqOrder(orderNo.getOrderNo());							
			} else if("STORE".equals(orderNo.getOrderType())){
				OrderDTO storeOrder = orderDAO.isStoreAlreadyReceived(orderNo.getOrderNo());
				if (storeOrder != null && storeOrder.getHqOrderStatus() == 400 ) {
					throw new IllegalArgumentException("이미 입고된 발주입니다.");
				} else if(storeOrder != null && storeOrder.getHqOrderStatus() == 330) {
					throw new IllegalArgumentException("본사 출고 대기중입니다.");
				}
				orderDAO.receiveStoreOrder(orderNo.getOrderNo());							
			}

	        // 2️ 승인/입고완료 상태 변경
	        if ("HQ".equals(orderNo.getOrderType())) {
	            orderDAO.receiveHqOrder(orderNo.getOrderNo());
	            eventPublisher.publishEvent(
                        new OrderReceivedEvent("HQ", orderNo.getOrderNo())
                );
	            orderDetailList = orderDAO.getHqOrderDetail(orderNo.getOrderNo());
	            // order_hq_vendor 테이블에 발주 삽입 로직
	            Map<Integer, OrderHqVendorDTO> vendorMap = new HashMap<>();
	            
	            for (OrderDetailDTO d : orderDetailList) {

	                int vendorId = d.getVendorId();           // 반드시 있어야 함
	                int supplyAmount = d.getHqOrderAmount();  // 공급가

	                OrderHqVendorDTO dto = vendorMap.get(vendorId);

	                if (dto == null) {
	                    dto = new OrderHqVendorDTO();
	                    dto.setHqOrderId(orderNo.getOrderNo());
	                    dto.setVendorId(vendorId);
	                    dto.setOrderSupplyAmount(0);
	                    dto.setOrderTaxAmount(0);
	                    dto.setOrderTotalAmount(0);

	                    vendorMap.put(vendorId, dto);
	                }

	                // 공급가 누적
	                dto.setOrderSupplyAmount(
	                    dto.getOrderSupplyAmount() + supplyAmount
	                );
	            }

	            // 세액 / 합계 계산
	            for (OrderHqVendorDTO dto : vendorMap.values()) {

	                int supply = dto.getOrderSupplyAmount();
	                int tax = (int) (supply * 0.1);   // ⚠️ 세율 다르면 여기 수정 필요
	                int total = supply + tax;

	                dto.setOrderTaxAmount(tax);
	                dto.setOrderTotalAmount(total);
	            }

	            // DB INSERT
	            for (OrderHqVendorDTO dto : vendorMap.values()) {
	                orderDAO.insertOrderHqVendorByDto(dto);
	            }
	            receivableDAO.insertReceivableForHqOrder(orderNo.getOrderNo());
	            // 3 입출고번호 생성(입출고타입, 창고번호, 본사발주번호, 가맹발주번호)
	            warehouseNo = 11;
	            stockInoutDTO = settingStock(orderNo.getOrderType(), 11, orderNo.getOrderNo());
	        } else {
	            orderDAO.receiveStoreOrder(orderNo.getOrderNo());
	            eventPublisher.publishEvent(
	                    new OrderReceivedEvent("STORE", orderNo.getOrderNo())
	            );
	            orderDetailList = orderDAO.getStoreOrderDetail(orderNo.getOrderNo());
	            // 3 입출고번호 생성(입출고타입, 창고번호, 본사발주번호, 가맹발주번호)
	            int storeId = orderDAO.getOrderStoreId(orderNo.getOrderNo());
	            
	            int supplyAmount = 0;
	            for (OrderDetailDTO d : orderDetailList) {
	            	supplyAmount += d.getHqOrderAmount();
	            }
	            receivableDAO.insertReceivableForStoreOrder(orderNo.getOrderNo(), supplyAmount);
	            System.out.println(storeId);
	            warehouseNo = orderDAO.findByWarehouseId(storeId);	            
	            stockInoutDTO = settingStock(orderNo.getOrderType(), warehouseNo, orderNo.getOrderNo());
	        }
		        orderDAO.insertOrderInOut(stockInoutDTO);
	        	inputId = stockInoutDTO.getInputId();
	        	System.out.println(stockInoutDTO.getHqOrderId());
	        	System.out.println(stockInoutDTO.getStoreOrderId());

	        // 4️ 상세 목록 조회 (이게 핵심)
	        List<OrderDetailDTO> details =
	            "HQ".equals(orderNo.getOrderType())
	            ? orderDAO.getHqOrderDetail(orderNo.getOrderNo())
	            : orderDAO.getStoreOrderDetail(orderNo.getOrderNo());

	        // 5️ 상세 기준 재고 처리
	        for (OrderDetailDTO d : details) {
	    		StockDTO stockDTO = new StockDTO();
	        	stockDTO.setWarehouseId(warehouseNo);
	            stockDTO.setInputId(inputId);
	            stockDTO.setStockInoutType("IN");
	            
	            // 5-1️ 재고 이력 INSERT
	            stockDTO = stockService.insertStockHistory(stockDTO, d);

	            // 5-2️ 현재 재고 UPDATE / INSERT
	            if(stockService.existsStock(stockDTO) > 0) {
	            	stockService.updateStockQuantity(stockDTO);	            	
	            } else {
	            	stockService.insertStock(stockDTO);	            		            	
	            }
	        }
		}
	}
	public StockInoutDTO settingStock(String OrderType, int warehouseNo, String orderNo) {
		StockInoutDTO stockInoutDTO = new StockInoutDTO();
		if("HQ".equals(OrderType)) {
			stockInoutDTO.setInputType("IN");
			stockInoutDTO.setWarehouseId(11);
			stockInoutDTO.setHqOrderId(orderNo);
		} else {
			stockInoutDTO.setInputType("IN");
			stockInoutDTO.setWarehouseId(warehouseNo);
			stockInoutDTO.setStoreOrderId(orderNo);
		}
		
		return stockInoutDTO;
	}
	public void cancelApprove(List<OrderRequestDTO> orderNos) {
		
		for (OrderRequestDTO orderNo : orderNos) {
			if ("HQ".equals(orderNo.getOrderType())) {
				orderDAO.cancelApproveHqOrder(orderNo.getOrderNo());							
			} else if("STORE".equals(orderNo.getOrderType())){
				OrderDTO storeOrder = orderDAO.isStoreAlreadyReceived(orderNo.getOrderNo());
				if(storeOrder == null) {
					throw new IllegalArgumentException("취소할 발주건이 없습니다.");
				} else if(storeOrder.getHqOrderStatus() == 350) {
					throw new IllegalArgumentException("이미 본사 출고 완료상태입니다.");
				} else if(storeOrder.getHqOrderStatus() == 330) {
					orderDAO.cancelApproveStoreOrder(orderNo.getOrderNo());							
				}
			}
		}
	}
	// 입고 취소는 본사만 가능
	@Transactional
	public void cancelReceive(List<OrderRequestDTO> orderNos) {
		for (OrderRequestDTO orderNo : orderNos) {	
			OrderDTO storeOrder = orderDAO.isHqAlreadyReceived(orderNo.getOrderNo());
			 if (storeOrder == null || storeOrder.getHqOrderStatus() != 400) {
		            continue; // 입고 완료 상태가 아니면 스킵
		        }
			if(storeOrder != null && storeOrder.getHqOrderStatus() == 400 ) {
				// 입고 이력 조회
				List<OrderStockHistoryDTO> deleteStock = orderDAO.getDeleteStock(orderNo.getOrderNo());
				for (OrderStockHistoryDTO orderRequestDTO : deleteStock) {
					// 본사재고확인
					Integer updated = orderDAO.decreaseStockForCancel(orderRequestDTO.getItemId(),orderRequestDTO.getOrderQty(), orderRequestDTO.getWarehouseId());
					if (updated == null || updated == 0) {
						throw new IllegalStateException("입고 취소 불가(재고 부족): itemId=" + orderRequestDTO.getItemId());
					}
					// 입고 이력 삭제
					orderDAO.deleteStockHistory(orderRequestDTO.getInputID());
					orderDAO.deleteInput(orderRequestDTO.getInputID());
				}
				orderDAO.cancelReceive(orderNo.getOrderNo());
			}
		}
	}
	@Transactional
	public void shipStoreOrder(String storeOrderId) {

	    // 1. 발주 상세 조회
	    List<OrderDetailDTO> items =
	    		orderDAO.getStoreOrderDetail(storeOrderId);

	    if (items.isEmpty()) {
	        throw new IllegalStateException("발주 상세 없음");
	    }

	    // 2. 재고 검증
	    for (OrderDetailDTO item : items) {

	        Integer stockQty = orderDAO.selectStockQty(item.getItemId());

	        if (stockQty < item.getHqOrderQty() || stockQty == null ) {
	            throw new IllegalStateException("재고 부족: itemId=" + item.getItemId());
	        }
	    }

	    // 3. 상태 변경 (여기서만!)
	    orderDAO.updateReceiveStatusByStoreOrder(storeOrderId);
	}
	public void updateReceiveStatusByStoreOrder(List<OrderRequestDTO> orderNos) {
		for (OrderRequestDTO orderNo : orderNos) {
			orderDAO.updateReceiveStatusByStoreOrder(orderNo.getOrderNo());										
		}
	}
	public void updateCancelReceiveStatusByStoreOrder(List<OrderRequestDTO> orderNos) {
		for (OrderRequestDTO orderNo : orderNos) {
			orderDAO.updateCancelReceiveStatusByStoreOrder(orderNo.getOrderNo());										
		}
	}
	
	@Transactional
	public void releaseByHq(List<OrderRequestDTO> orderNos) {
		for (OrderRequestDTO orderNo : orderNos) {
			
			List<OrderDetailDTO> releaseItemList = orderDAO.getStoreOrderDetail(orderNo.getOrderNo());
			for (OrderDetailDTO d : releaseItemList) {

	            int updated = orderDAO.releaseByHq(d);
	            
	            if (updated == 0) {
	                throw new IllegalStateException(
	                    "재고 부족으로 출고 불가 (itemId=" + d.getItemId() + ")"
	                );
	            }
	        }
		}
	}
	

}
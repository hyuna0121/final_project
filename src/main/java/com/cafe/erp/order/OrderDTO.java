package com.cafe.erp.order;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class OrderDTO {
	
	// 공통
	private String hqOrderId;
	private Date hqOrderCreatedAt;
	private Date hqOrderApprovaledAt;
	private Integer hqOrderStatus;
	private Integer vendorId;
	private Integer memberId;
	private Integer hqOrderTotalAmount;
	
	// 가맹
	private Integer storeId;
	private Integer storeOrderApprover;
	private String storeRejectionReason; 
	
	private List<OrderItemRequestDTO> items;
}

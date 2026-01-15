package com.cafe.erp.order;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.ui.Model;

import com.cafe.erp.item.ItemDTO;
import com.cafe.erp.member.MemberDTO;

@Mapper
public interface OrderDAO {
	
	public String selectMaxOrderHqId(String prefix, String orderDate);
	public String selectMaxOrderStoreId(String prefix, String orderDate);
	
	public OrderDTO selectStoreId(int memberId);
	
	public void insertHqOrder(OrderDTO orderDTO);
	public void insertStoreOrder(OrderDTO orderDTO);
	
	public void insertHqOrderItemDetail(OrderDetailDTO orderDetailDTO);
	public void insertStoreOrderItemDetail(OrderDetailDTO orderDetailDTO);
	
	public List<OrderDTO> listHq(@Param("statuses") List<Integer> statuses,@Param("member") MemberDTO member);
	public List<OrderDTO> listStore(@Param("statuses") List<Integer> statuses,@Param("member") MemberDTO member);

	public List<OrderDetailDTO> getHqOrderDetail(@Param("orderNo") String orderNo);
	public List<OrderDetailDTO> getStoreOrderDetail(@Param("orderNo") String orderNo);
	
	public void approveHqOrder(String orderNo, int orderApproverId);
	public void approveStoreOrder(String orderNo, int orderApproverId);
	
	public List<OrderDTO> getApprovedOrder();
	public List<OrderDetailDTO> getApprovedOrderDetail();

	public void rejectOrder(OrderRejectDTO OrderRejectDTO);
	// 발주 반려 시 알림 기능 (가맹점주 아이디 조회)
	public OrderRejectDTO rejectOrderNotification(OrderRejectDTO orderRejectDTO);
	
	public void receiveHqOrder(@Param("orderNo") String orderNo);
	public void receiveStoreOrder(@Param("orderNo") String orderNo);

	public void cancelApproveHqOrder(@Param("orderNo") String orderNo);
	public void cancelApproveStoreOrder(@Param("orderNo") String orderNo);
	
}

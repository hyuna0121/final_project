package com.cafe.erp.order;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.ui.Model;

import com.cafe.erp.item.ItemDTO;

@Mapper
public interface OrderDAO {
	
	public String selectMaxOrderHqId(String prefix, String orderDate);
	public String selectMaxOrderStoreId(String prefix, String orderDate);
	
	public int selectStoreId(int memberId);
	
	public void insertHqOrder(OrderDTO orderDTO);
	public void insertStoreOrder(OrderDTO orderDTO);
	
	public void insertHqOrderItemDetail(OrderDetailDTO orderDetailDTO);
	public void insertStoreOrderItemDetail(OrderDetailDTO orderDetailDTO);
	
	public List<OrderDTO> listHq();
	public List<OrderDTO> listStore();

	public List<OrderDetailDTO> getHqOrderDetail(@Param("orderNo") String orderNo);
	public List<OrderDetailDTO> getStoreOrderDetail(@Param("orderNo") String orderNo);
	
	public void approveHqOrder(@Param("orderNo") String orderNo);
	public void approveStoreOrder(@Param("orderNo") String orderNo);
	
}

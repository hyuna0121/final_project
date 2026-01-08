package com.cafe.erp.order;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.ui.Model;

@Mapper
public interface OrderDAO {
	
	public String selectMaxOrderId(String prefix, String orderDate);
	
	public void insertOrder(OrderDTO orderDTO);
	
	public void insertOrderDetail(OrderDetailDTO orderDetailDTO);
	
	public List<OrderDTO> listRequest();
	
}

package com.cafe.erp.stock;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafe.erp.order.OrderDAO;
import com.cafe.erp.order.OrderDetailDTO;
import com.cafe.erp.order.OrderService;
import com.cafe.erp.stock.StoreInventoryDTO;

@Service
public class StockService {
	
	@Autowired
	private StockDAO stockDAO;
	
	@Autowired
	private OrderDAO orderDAO;

	public StockDTO insertStockHistory(StockDTO stockDTO, OrderDetailDTO orderDetailDTO) {
		stockDTO.setItemId(orderDetailDTO.getItemId());
		stockDTO.setStockQuantity(orderDetailDTO.getHqOrderQty());
		stockDAO.insertStockHistory(stockDTO);
		return stockDTO;
	}
	
	public int  existsStock(StockDTO stockDTO) {
		return stockDAO.existsStock(stockDTO);
	}
	public void updateStockQuantity(StockDTO stockDTO) {
		stockDAO.updateStockQuantity(stockDTO);
	}
	public void insertStock(StockDTO stockDTO) {
		stockDAO.insertStock(stockDTO);
	}
	
	// 재고 정보 가져오기
	public List<StockDTO> getStockByMember(Integer memberId){
		int storeId = 0;
		int warehouseId = 0;
		if(String.valueOf(memberId).charAt(0) == '1' || String.valueOf(memberId).charAt(0) == '9') {
			warehouseId = 11;
		} else {
			storeId = stockDAO.getStoreIdBymemberId(memberId);
			warehouseId = stockDAO.getWarehouseIdByStoreId(storeId);
		}
		
		return stockDAO.getStockByWarehouseId(warehouseId);
	}
	
	// 재고 사용 요청
	// 보유중인 재고 목록 가져오기
	public List<StoreInventoryDTO> getStoreInventory(Integer memberId) {
		int storeId = stockDAO.getStoreIdBymemberId(memberId);
		int warehouseId = stockDAO.getWarehouseIdByStoreId(storeId);
        return stockDAO.selectStoreInventory(warehouseId);
    }
	
	@Transactional
	public void storeStockUse(
	    List<StoreInventoryDTO> items,
	    int memberId,
	    String releaseType,
	    String releaseReason
	) {
		int storeId = stockDAO.getStoreIdBymemberId(memberId);
		int warehouseId = stockDAO.getWarehouseIdByStoreId(storeId);
	    
		// 출고 타입 검증
	    if (!List.of("use", "faulty").contains(releaseType)) {
	        throw new IllegalArgumentException("잘못된 출고 타입");
	    }

	    // faulty일 경우 사유 필수
	    if ("faulty".equals(releaseType) && (releaseReason == null || releaseReason.isBlank())) {
	        throw new IllegalArgumentException("상품불량 사유는 필수입니다");
	    }

	    // 재고 검증
	    for (StoreInventoryDTO item : items) {
	    	StockDTO stockdto = new StockDTO();
	    	stockdto.setWarehouseId(warehouseId);
	    	stockdto.setItemId(item.getItemId());
	    	Integer currentStock = stockDAO.existsStockForRelease(stockdto);
	    	
	    	// 어차피 기입 시 현재 재고보다 많이 못 받음 하지만 null처리 해줌으로서 2중 방지
	        if (currentStock < item.getQuantity() || currentStock == null) {
	            throw new IllegalStateException(
	                "재고 부족: itemId=" + item.getItemId()
	            );
	        }
	    }

	    // 1️ 출고 마스터 생성
	    StockInoutDTO stockInoutDTO = new StockInoutDTO();
	    stockInoutDTO.setInputType("OUT");
	    stockInoutDTO.setWarehouseId(warehouseId);
	    orderDAO.insertOrderInOut(stockInoutDTO);
	    int inputId = stockInoutDTO.getInputId();

	    // 2️ 출고 상세 (사유 포함)
	    StockReleaseDetailDTO stockReleaseDetailDTO = new StockReleaseDetailDTO();
	    stockReleaseDetailDTO.setReleaseType("OUT");
	    stockReleaseDetailDTO.setInputId(inputId);
	    stockReleaseDetailDTO.setReleaseReason(releaseReason);
	    stockDAO.insertReleaseDetail(stockReleaseDetailDTO);

	    // 3️ 재고 차감 + 이력
	    for (StoreInventoryDTO item : items) {
	    	item.setWarehouseId(warehouseId);
	    	stockDAO.updateStock(item);
	    	
	    	StockDTO stockDTO = new StockDTO();
	    	stockDTO.setStockInoutType("OUT");
	    	stockDTO.setStockQuantity(item.getQuantity());
	    	stockDTO.setItemId(item.getItemId());
	    	stockDTO.setWarehouseId(warehouseId);
	    	stockDTO.setInputId(inputId);
	    	stockDAO.insertStockHistory(stockDTO);
	    	
	    }
	}
	
	/**
     * 가맹 출고 마스터 목록
     */
    public List<StockReleaseDTO> getStoreReleaseList(Integer memberId) {
    	
    	Integer storeId = stockDAO.getStoreIdBymemberId(memberId);
    	Integer warehouseId = stockDAO.getWarehouseIdByStoreId(storeId);
    	List<StockReleaseDTO> list = stockDAO.selectStoreReleaseList(warehouseId);
        return list;
    }

    /**
     * 출고 상세 (OUT 내역)
     */
    public List<StockReleaseItemDTO> getStoreReleaseDetail(Integer inputId) {
        return stockDAO.selectStoreReleaseDetail(inputId);
    }
}

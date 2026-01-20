package com.cafe.erp.stock;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.cafe.erp.order.OrderDetailDTO;
import com.cafe.erp.stock.StoreInventoryDTO;

@Mapper
public interface StockDAO {
	
	
	public void insertStockHistory(StockDTO stockDTO);
	
	public int existsStock(StockDTO stockDTO);
	public int existsStockForRelease(StockDTO stockDTO);
	
	public void updateStockQuantity(StockDTO stockDTO);
	
	public void insertStock(StockDTO stockDTO);
	
	public Integer getStoreIdBymemberId(@Param("memberId") Integer memberId);
	public Integer getWarehouseIdByStoreId(@Param("storeId") Integer storeId);
	public List<StockDTO> getStockByWarehouseId(@Param("warehouseId") Integer warehouseId);

	public List<StoreInventoryDTO> selectStoreInventory(@Param("warehouseId") Integer warehouseId);
	
	public List<StoreInventoryDTO> storeStockUse(List<StoreInventoryDTO> items,
			@Param("warehouseId")int warehouseId,
			@Param("releaseType")String releaseType,
			@Param("releaseReason")String releaseReason);
	public void insertReleaseDetail(StockReleaseDetailDTO stockReleaseDetailDTO);
	public void updateStock(StoreInventoryDTO storeInventoryDTO);

    // 출고 마스터
	public List<StockReleaseDTO> selectStoreReleaseList(
            @Param("warehouseId") Integer warehouseId);

    // 출고 상세
	public List<StockReleaseItemDTO> selectStoreReleaseDetail(
            @Param("inputId") Integer inputId);
	
}


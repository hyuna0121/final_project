package com.cafe.erp.store;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.cafe.erp.util.Pager;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface StoreDAO { 
	
	public List<StoreDTO> list(StoreSearchDTO searchDTO) throws Exception;

	public int add(StoreDTO storeDTO) throws Exception;
	
	public Integer maxStoreId(String id) throws Exception;

	public List<StoreDTO> searchStore(String keyword) throws Exception;

	public Long count(StoreSearchDTO searchDTO) throws Exception;

	public List<StoreDTO> excelList(StoreSearchDTO searchDTO) throws Exception;

	public StoreDTO detail(StoreDTO storeDTO) throws Exception;

	public List<StoreManageDTO> manageList(StoreDTO storeDTO) throws Exception;

	public int updateToEnd(StoreManageDTO managerDTO) throws Exception;

	public int addManager(StoreManageDTO managerDTO) throws Exception;

    public StoreDTO findByMemberId(int memberId);

    public List<StoreDTO> searchMyStore(String keyword, String memberId) throws Exception;

    public int isCurrentManager(@Param("storeId") Integer storeId, @Param("memberId") Integer memberId) throws Exception;
}

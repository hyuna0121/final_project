package com.cafe.erp.store;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafe.erp.util.Pager;

@Service
public class StoreService {
	
	@Autowired
	private StoreDAO storeDAO;

	public List<StoreDTO> list(StoreSearchDTO searchDTO) throws Exception {
		Long totalCount = storeDAO.count(searchDTO);
		
		searchDTO.pageing(totalCount);
		
		return storeDAO.list(searchDTO); 
	}

	@Transactional
	public int add(StoreDTO storeDTO) throws Exception {
		String[] addrs = storeDTO.getStoreAddress().split(" ");
		
		String year = LocalDate.now().getYear() + "";
		
		String regionCode = "";
		switch(addrs[0]) {
			case "서울": 
				regionCode += 10; break;
			case "경기": 
			case "인천": 
				regionCode += 11; break;
			case "충북" :
			case "충남" :
			case "대전" :
			case "세종특별자치시": 
				regionCode += 12; break;
			case "강원특별자치도": 
				regionCode += 13; break;
			case "전북특별자치도" : 
			case "전남" : 
			case "광주": 
				regionCode += 14; break;
			case "경북" :
			case "경남" : 
			case "부산" : 
			case "울산" : 
			case "대구" : 
				regionCode += 15; break;
		}
		
		String prefix = regionCode + year.substring(2);
		Integer maxId = storeDAO.maxStoreId(prefix);
		
		int nextId = 1;
		if (maxId != null) nextId = (maxId % 1000) + 1;
		
		String num = String.format("%03d", nextId);
		
		int storeId = Integer.parseInt(prefix + num);
		storeDTO.setStoreId(storeId);
		
		return storeDAO.add(storeDTO);
	}

	public List<StoreDTO> searchStore(String keyword) throws Exception {
		return storeDAO.searchStore(keyword);
	}

	public List<StoreDTO> excelList(StoreSearchDTO searchDTO) throws Exception {
		return storeDAO.excelList(searchDTO);
	}

	public StoreDTO detail(StoreDTO storeDTO) throws Exception {
		return storeDAO.detail(storeDTO);
	}

	public List<StoreManageDTO> manageList(StoreDTO storeDTO) throws Exception {
		return storeDAO.manageList(storeDTO);
	}

	@Transactional
	public int updateManager(StoreManageDTO managerDTO) throws Exception {
		storeDAO.updateToEnd(managerDTO);
		return storeDAO.addManager(managerDTO);
	}
	
}

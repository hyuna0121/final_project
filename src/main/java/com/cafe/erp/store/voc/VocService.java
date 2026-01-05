package com.cafe.erp.store.voc;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VocService {
	
	@Autowired
	private VocDAO vocDAO;
	
	public List<VocDTO> list() throws Exception {
		return vocDAO.list();
	}

	public int add(VocDTO vocDTO) throws Exception {
		vocDTO.setMemberId(122002);
		return vocDAO.add(vocDTO);
	}

	public VocDTO detail(Integer vocId) throws Exception {
		return vocDAO.detail(vocId);
	}

}

package com.cafe.erp.store.contract;

import java.io.File;
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cafe.erp.files.FileManager;

@Service
public class ContractService {
	
	@Autowired
	private ContractDAO contractDAO;
	@Autowired
	private FileManager fileManager;
	
	@Value("${erp.upload.contract}")
	private String uploadPath;
	
	public List<ContractDTO> list() throws Exception {
		return contractDAO.list();
	}

	public int add(ContractDTO contractDTO, List<MultipartFile> files) throws Exception {
		
		int year = LocalDate.now().getYear();
		String id = "CT" + year;
		int count = contractDAO.countContractId(id) + 1;
		String num = String.format("%03d", count);
		contractDTO.setContractId(id + num);
		
		int result = contractDAO.add(contractDTO);
		
		if (files == null) { return result; }
		
		File file = new File(uploadPath);
		for (MultipartFile f: files) {
			if (f == null || f.isEmpty()) { continue; }
			
			String fileName = fileManager.fileSave(file, f);
			
			ContractFileDTO contractFileDTO = new ContractFileDTO();
			contractFileDTO.setFileSavedName(fileName);
			contractFileDTO.setFileOriginalName(f.getOriginalFilename());
			contractFileDTO.setContractId(contractDTO.getContractId());
			
			contractDAO.fileAdd(contractFileDTO);
		}
		
		return result;
	}

	public ContractDTO getDetail(String contractId) {
		return contractDAO.getDetail(contractId);
	}

}

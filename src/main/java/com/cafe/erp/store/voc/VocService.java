package com.cafe.erp.store.voc;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cafe.erp.files.FileManager;
import com.cafe.erp.store.contract.ContractFileDTO;

@Service
public class VocService {
	
	@Autowired
	private VocDAO vocDAO;
	@Autowired
	private FileManager fileManager;
	
	@Value("${erp.upload.voc}")
	private String uploadPath;
	
	public List<VocDTO> list(VocSearchDTO searchDTO) throws Exception {
		Long totalCount = vocDAO.count(searchDTO);
		
		searchDTO.pageing(totalCount);
		
		return vocDAO.list(searchDTO);
	}

	public int add(VocDTO vocDTO) throws Exception {
		vocDTO.setMemberId(122002);
		return vocDAO.add(vocDTO);
	}

	public VocDTO detail(Integer vocId) throws Exception {
		return vocDAO.detail(vocId);
	}

	public List<VocProcessDTO> processList(Integer vocId) throws Exception {
		return vocDAO.processList(vocId);
	}

	public int addProcess(VocProcessDTO processDTO, List<MultipartFile> files) throws Exception {
		processDTO.setMemberId(121001);
		int result = vocDAO.addProcess(processDTO);
		
		uploadFiles(files, processDTO.getProcessId());
		
		return result;
	}

	public List<VocDTO> excelList(VocSearchDTO searchDTO) throws Exception {
		return vocDAO.excelList(searchDTO);
	}
	
	
	private void uploadFiles(List<MultipartFile> files, Integer processId) throws Exception {
		if (files == null || files.isEmpty()) return; 
		
		File dir = new File(uploadPath);
		if (!dir.exists()) dir.mkdirs(); 

		for (MultipartFile f : files) {
			if (f == null || f.isEmpty()) continue;
			
			String fileName = fileManager.fileSave(dir, f);
			
			VocProcessFileDTO processFileDTO = new VocProcessFileDTO();
			processFileDTO.setFileSavedName(fileName);
			processFileDTO.setFileOriginalName(f.getOriginalFilename());
			processFileDTO.setProcessId(processId);
			
			vocDAO.addFile(processFileDTO); 
		}
	}

}

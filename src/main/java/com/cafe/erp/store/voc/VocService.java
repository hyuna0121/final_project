package com.cafe.erp.store.voc;

import java.io.File;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cafe.erp.files.FileManager;

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

	public int addProcess(Integer isFirst, VocProcessDTO processDTO, List<MultipartFile> files) throws Exception {
		if (isFirst == 0) vocDAO.updateToActive(processDTO.getVocId());
		
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

	public List<VocStatDTO> trend(String year, String month) throws Exception {
		return vocDAO.trend(year, month);
	}
	
	public List<VocStatDTO> countByType(String year, String month) throws Exception {
		return vocDAO.countByType(year, month);
	}
	
	public List<VocStatDTO> topComplaintStores(String year, String month) throws Exception {
		return vocDAO.topComplaintStores(year, month);
	}
	
	public Map<String, Object> summary(String year, String month) throws Exception {
	    Map<String, Object> current = vocDAO.summary(year, month);

        LocalDate date = LocalDate.of(Integer.parseInt(year), Integer.parseInt(month), 1);
        LocalDate prevDate = date.minusMonths(1);
        
        String prevYear = String.valueOf(prevDate.getYear());
        String prevMonth = String.format("%02d", prevDate.getMonthValue());

	    Map<String, Object> prev = vocDAO.summary(prevYear, prevMonth);

	    long curTotal = ((Number) current.get("total")).longValue();
	    long prevTotal = ((Number) prev.get("total")).longValue();
	    
	    double curAvg = ((Number) current.get("avgTime")).doubleValue(); 
	    double prevAvg = ((Number) prev.get("avgTime")).doubleValue();

	    double totalRate = 0.0;
	    if (prevTotal > 0) {
	        totalRate = ((double)(curTotal - prevTotal) / prevTotal) * 100;
	    } else if (curTotal > 0) {
	        totalRate = 100.0;
	    }
	    
	    double avgDiff = curAvg - prevAvg;

	    current.put("totalRate", Math.round(totalRate * 10) / 10.0);
	    current.put("avgDiff", Math.round(avgDiff * 10) / 10.0);  

	    return current;
	}
	
	public List<VocStatDTO> managerPerformance(String year, String month) throws Exception {
		return vocDAO.managerPerformance(year, month);
	}
	
}

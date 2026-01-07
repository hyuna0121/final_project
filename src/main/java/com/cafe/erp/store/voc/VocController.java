package com.cafe.erp.store.voc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.cafe.erp.util.ExcelUtil;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/store/voc/")
public class VocController {
	
	@Autowired
	private VocService vocService;
	
	@GetMapping("list")
	public String list(VocSearchDTO searchDTO, Model model) throws Exception {
		List<VocDTO> vocList = vocService.list(searchDTO);
		model.addAttribute("list", vocList);
		model.addAttribute("pager", searchDTO);
		
		return "voc/list";
	}
	
	@PostMapping("add")
	@ResponseBody
	public Map<String, Object> addVoc(@RequestBody VocDTO vocDTO) throws Exception { 
		return result(vocService.add(vocDTO)); 
	}
	
	@GetMapping("detail")
	public String detail(Integer vocId, Model model) throws Exception {
		VocDTO vocDTO = vocService.detail(vocId);
		List<VocProcessDTO> processList = vocService.processList(vocId);
		model.addAttribute("dto", vocDTO);
		model.addAttribute("list", processList);
		model.addAttribute("listSize", processList.size());
		
		return "voc/detail";
	}
	
	@PostMapping("addProcess")
	@ResponseBody
	public Map<String, Object> addVocProcess(Integer isFirst, @ModelAttribute VocProcessDTO processDTO, @RequestParam(value = "files", required = false) List<MultipartFile> files) throws Exception { 
		return result(vocService.addProcess(isFirst, processDTO, files));
	}
	
	private Map<String, Object> result(int result) {
		Map<String, Object> response = new HashMap<>();
		 
		if (result > 0) {  
			response.put("message", "등록 완료"); 
			response.put("status", "success");
		} else {
			response.put("status", "error");
			response.put("message", "등록 실패");
		}
		
		return response; 
	}
	
	@GetMapping("downloadExcel")
	public void downloadExcel(VocSearchDTO searchDTO, HttpServletResponse response) throws Exception {
		List<VocDTO> list = vocService.excelList(searchDTO);
		String[] headers = {"ID", "작성자ID", "작성자", "가맹점ID", "가맹점명", "점주ID", "점주명", "주소", 
				            "불만유형", "제목", "처리상태", "고객연락처", "상세내용", "작성일시", "수정일시"};
		
		ExcelUtil.download(list, headers, "VOC 목록", response, (row, dto) -> {
			row.createCell(0).setCellValue(dto.getVocId());
			row.createCell(1).setCellValue(dto.getMemberId());
			row.createCell(2).setCellValue(dto.getMemName());
			row.createCell(3).setCellValue(dto.getStoreId());
			row.createCell(4).setCellValue(dto.getStoreName());
			row.createCell(5).setCellValue(dto.getOwnerId());
			row.createCell(6).setCellValue(dto.getOwnerName());
			row.createCell(7).setCellValue(dto.getStoreAddress());
			
			row.createCell(8).setCellValue(dto.getVocType());
			row.createCell(9).setCellValue(dto.getVocTitle());
			row.createCell(10).setCellValue(dto.getVocStatusStr());
			row.createCell(11).setCellValue(dto.getVocContact());
			row.createCell(12).setCellValue(dto.getVocContents());
			row.createCell(13).setCellValue(dto.getVocCreatedAtStr());
			row.createCell(14).setCellValue(dto.getVocUpdatedAtStr());
		});
	}
	
	@GetMapping("statistics")
	public String statistics() throws Exception {
		return "voc/statistics";
	}
	
	@GetMapping(value = "statistics", params = "year")
	@ResponseBody
	public Map<String, Object> statistics(@RequestParam("year") String year, @RequestParam(value = "month") String month) throws Exception { 
		Map<String, Object> resultMap = new HashMap<>();
		
		// 일별 추이
		List<VocStatDTO> trendList = vocService.trend(year, month);
		
		List<String> trendLabels = new ArrayList<>();
		List<Integer> trendCounts = new ArrayList<>();
		for (VocStatDTO dto : trendList) {
			String label = (dto.getCategory() == null) ? "기타" : dto.getCategory();
			
			trendLabels.add(label);
			trendCounts.add(dto.getCount());
		}
		
		resultMap.put("trendLabels", trendLabels);
        resultMap.put("trendCounts", trendCounts);
        
        // 유형별 건수
        List<VocStatDTO> typeList = vocService.countByType(year, month);
        
        List<Integer> typeCounts = new ArrayList<>();
        for (VocStatDTO dto : typeList) {
        	typeCounts.add(dto.getCount());
        }
        
        resultMap.put("categoryCounts", typeCounts);
        
        // 불만 다발 가맹점
        List<VocStatDTO> topStores = vocService.topComplaintStores(year, month);
        resultMap.put("topStores", topStores);
        
        // summary
        Map<String, Object> summary = vocService.summary(year, month);
        resultMap.put("summary", summary);
        
        // managerPerformance
        List<VocStatDTO> managerList = vocService.managerPerformance(year, month);
        resultMap.put("managerList", managerList);
        
		return resultMap;
	}

}

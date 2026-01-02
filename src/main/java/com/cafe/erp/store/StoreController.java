package com.cafe.erp.store;

import java.net.URLEncoder;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import jakarta.servlet.http.HttpServletResponse;


@Controller
@RequestMapping("/store/")
public class StoreController {

	@Autowired
	private StoreService storeService;

	@Value("${kakao.appkey}")
	private String kakaoKey;

	@GetMapping("example")
	public String list() throws Exception {
		return "store/example";
	}

	@GetMapping("list")
	public String list(StoreSearchDTO searchDTO, Model model) throws Exception {
		List<StoreDTO> storeList = storeService.list(searchDTO);
		
		model.addAttribute("list", storeList);
		model.addAttribute("kakaoKey", kakaoKey);
		model.addAttribute("pager", searchDTO);
		
		return "store/tab_store";
	}

	@PostMapping("add") 
	@ResponseBody
	public Map<String, Object> addStore(@RequestBody StoreDTO storeDTO) throws Exception { 
		int result = storeService.add(storeDTO);
	 
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
	public void downloadExcel(StoreSearchDTO searchDTO, HttpServletResponse response) throws Exception {
		List<StoreDTO> list = storeService.excelList(searchDTO);
		
		Workbook workbook = new XSSFWorkbook();
		Sheet sheet = workbook.createSheet("가맹점 목");
		
		Row headerRow = sheet.createRow(0);
		String[] headers = {"ID","가맹점명", "점주ID", "점주명", "주소", "상태", "오픈시간", "마감시간"};
		
		for (int i = 0; i < headers.length; i++) {
			Cell cell = headerRow.createCell(i);
			cell.setCellValue(headers[i]);
		}
		
		int rowNum = 1;
		for (StoreDTO dto : list) {
			Row row = sheet.createRow(rowNum++);
			
			row.createCell(0).setCellValue(dto.getStoreId());
			row.createCell(1).setCellValue(dto.getStoreName());
			row.createCell(2).setCellValue(dto.getMemberId());
			row.createCell(3).setCellValue(dto.getMemName());
			row.createCell(4).setCellValue(dto.getStoreAddress());
			row.createCell(5).setCellValue(dto.getStoreStatus());
			row.createCell(6).setCellValue(dto.getStoreStartTime() != null ? dto.getStoreStartTime().toString() : "");
			row.createCell(7).setCellValue(dto.getStoreCloseTime() != null ? dto.getStoreCloseTime().toString() : "");
		}
		
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		String fileName = URLEncoder.encode("가맹점목록_"+ LocalDate.now() +".xlsx", "UTF-8");
		fileName = fileName.replaceAll("\\+", "%20");
		response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
		
		workbook.write(response.getOutputStream());
		workbook.close();
		
	}
	
	
	// contract list tab
	@GetMapping("search")
	@ResponseBody
	public List<StoreDTO> searchStore(@RequestParam String keyword) throws Exception {
		return storeService.searchStore(keyword);
	}

}

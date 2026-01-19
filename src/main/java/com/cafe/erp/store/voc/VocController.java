package com.cafe.erp.store.voc;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cafe.erp.store.StoreDTO;
import com.cafe.erp.store.StoreService;
import com.cafe.erp.store.contract.ContractDTO;
import jakarta.mail.Store;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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

import com.cafe.erp.notification.service.NotificationService;
import com.cafe.erp.security.UserDTO;
import com.cafe.erp.util.ExcelUtil;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/store/voc/")
public class VocController {
	
	@Autowired
	private VocService vocService;
	@Autowired
	private StoreService storeService;

	@GetMapping("list")
	public String list(VocSearchDTO searchDTO, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

		if (isStoreOwner) {
			if (user.getStore() == null) {
				return "error/no_store_info";
			}
			searchDTO.setSearchStoreId(user.getStore().getStoreId());
		}

		List<VocDTO> vocList = vocService.list(searchDTO);
		model.addAttribute("list", vocList);
		model.addAttribute("pager", searchDTO);

		return isStoreOwner ? "view_store/store/voc_list" : "voc/list";
	}

	@PreAuthorize("hasAnyRole('DEPT_SALES')")
	@GetMapping("my-list")
	public String myVocList(VocSearchDTO searchDTO, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
		searchDTO.setManagerId(user.getMember().getMemberId());

		List<VocDTO> vocList = vocService.list(searchDTO);
		model.addAttribute("list", vocList);
		model.addAttribute("pager", searchDTO);

		return "voc/list";
	}

	@PreAuthorize("hasAnyRole('DEPT_CS', 'EXEC', 'MASTER')")
	@PostMapping("add")
	@ResponseBody
	public Map<String, Object> addVoc(
			@RequestBody VocDTO vocDTO,
			@AuthenticationPrincipal UserDTO userDTO
			)
			throws Exception {
		return result(vocService.add(vocDTO , userDTO.getMember().getMemberId()));
	}
	
	@GetMapping("detail")
	public String detail(Integer vocId, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

		VocDTO vocDTO = vocService.detail(vocId);
		if (vocDTO == null) return "error/404";
		if (isStoreOwner) {
			StoreDTO store = user.getStore();
			if (store == null) return "error/no_store_info";
			if (!store.getStoreId().equals(vocDTO.getStoreId())) return "error/403";
		}

		List<VocProcessDTO> processList = vocService.processList(vocId);
		model.addAttribute("dto", vocDTO);
		model.addAttribute("list", processList);
		model.addAttribute("listSize", processList.size());
		
		return "voc/detail";
	}

	@PreAuthorize("hasAnyRole('DEPT_CS', 'EXEC', 'MASTER')")
	@PostMapping("edit")
	@ResponseBody
	public Map<String, Object> editVoc(@RequestBody VocDTO vocDTO, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isCS = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_CS"));

		if (isCS) {
			VocDTO originDTO = vocService.detail(vocDTO.getVocId());
			if (!originDTO.getMemberId().equals(user.getMember().getMemberId())) return result("해당 VOC의 작성자가 아닙니다.");
		}

		return result(vocService.editVoc(vocDTO));
	}

	@PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
	@PostMapping("updateStatus")
	@ResponseBody
	public Map<String, Object> updateStatus(@RequestBody VocDTO vocDTO, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isSALES = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_SALES"));

		if (isSALES) {
			VocDTO originDTO = vocService.detail(vocDTO.getVocId());
			boolean isManager = storeService.isCurrentManager(originDTO.getStoreId(), user.getMember().getMemberId());
			if (!isManager) return result("해당 가맹점의 담당자가 아닙니다.");
		}

		return result(vocService.editStatus(vocDTO.getVocId()));
	}

	@PreAuthorize("hasAnyRole('STORE', 'DEPT_SALES', 'EXEC', 'MASTER')")
	@PostMapping("addProcess")
	@ResponseBody
	public Map<String, Object> addVocProcess(
			Integer isFirst, @ModelAttribute VocProcessDTO processDTO,
			@RequestParam(value = "files", required = false) List<MultipartFile> files,
			@AuthenticationPrincipal UserDTO user) throws Exception {
		Integer writerId = user.getMember().getMemberId();
		boolean isSales = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_SALES"));

		if (isSales) {
			VocDTO vocDTO = vocService.detail(processDTO.getVocId());
			boolean isManager = storeService.isCurrentManager(vocDTO.getStoreId(), writerId);
			if (!isManager) return result("해당 가맹점의 담당자가 아닙니다.");
		}

		processDTO.setMemberId(writerId);
		return result(vocService.addProcess(isFirst, processDTO, files));
	}

	@PreAuthorize("hasAnyRole('STORE', 'DEPT_SALES', 'EXEC', 'MASTER')")
	@PostMapping("deleteProcess")
	@ResponseBody
	public Map<String, Object> deleteVocProcess(@RequestParam Integer processId, @AuthenticationPrincipal UserDTO user) throws Exception {
		Integer logInId = user.getMember().getMemberId();
		boolean isSales = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_SALES"));
		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

		if ((isSales || isStoreOwner)) {
			VocProcessDTO originDTO = vocService.getProcess(processId);
			if (!logInId.equals(originDTO.getMemberId())) return result("본인이 작성한 내역이 아닙니다.");
		}

		return result(vocService.deleteProcess(processId));
	}
	
	@GetMapping("downloadExcel")
	public void downloadExcel(VocSearchDTO searchDTO, HttpServletResponse response, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

		if (isStoreOwner) {
			if (user.getStore() == null) {
				response.sendRedirect("/error/noStoreInfo");
				return;
			}
			searchDTO.setSearchStoreId(user.getStore().getStoreId());
		}

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

	@PreAuthorize("hasRole('DEPT_SALES')")
	@GetMapping("my-downloadExcel")
	public void myStoreDownloadExcel(VocSearchDTO searchDTO, HttpServletResponse response, @AuthenticationPrincipal UserDTO user) throws Exception {
		searchDTO.setManagerId(user.getMember().getMemberId());

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

	@PreAuthorize("hasRole('HQ')")
	@GetMapping("statistics")
	public String statistics() throws Exception {
		return "voc/statistics";
	}

	@PreAuthorize("hasRole('HQ')")
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

	private Map<String, Object> result(int result) {
		Map<String, Object> response = new HashMap<>();

		if (result > 0) {
			response.put("status", "success");
		} else {
			response.put("status", "fail");
		}

		return response;
	}

	private Map<String, Object> result(String message) {
		Map<String, Object> response = new HashMap<>();

		response.put("status", "error");
		response.put("message", message);

		return response;
	}

}

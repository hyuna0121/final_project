package com.cafe.erp.store;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cafe.erp.security.UserDTO;
import com.cafe.erp.store.voc.VocDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cafe.erp.util.ExcelUtil;

import jakarta.servlet.http.HttpServletResponse;


@Controller
@RequestMapping("/store/")
public class StoreController {

	@Autowired
	private StoreService storeService;

	@Value("${kakao.appkey}")
	private String kakaoKey;

	@PreAuthorize("hasRole('HQ')")
	@GetMapping("list")
	public String list(StoreSearchDTO searchDTO, Model model) throws Exception {
		List<StoreDTO> storeList = storeService.list(searchDTO);
		
		model.addAttribute("list", storeList);
		model.addAttribute("kakaoKey", kakaoKey);
		model.addAttribute("pager", searchDTO);
		
		return "store/tab_store";
	}

	@PreAuthorize("hasRole('DEPT_SALES')")
	@GetMapping("my-list")
	public String myStoreList(StoreSearchDTO searchDTO, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
		searchDTO.setManagerId(user.getMember().getMemberId());

		List<StoreDTO> storeList = storeService.list(searchDTO);

		model.addAttribute("list", storeList);
		model.addAttribute("kakaoKey", kakaoKey);
		model.addAttribute("pager", searchDTO);

		return "store/tab_store";
	}

	@PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
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

	@PreAuthorize("hasRole('DEPT_SALES')")
	@GetMapping("my-downloadExcel")
	public void myStoreDownloadExcel(StoreSearchDTO searchDTO, @AuthenticationPrincipal UserDTO user, HttpServletResponse response) throws Exception {
		searchDTO.setManagerId(user.getMember().getMemberId());

		List<StoreDTO> list = storeService.excelList(searchDTO);
		String[] headers = {"ID", "가맹점명", "점주ID", "점주명", "주소", "상태", "오픈시간", "마감시간"};
		
		ExcelUtil.download(list, headers, "가맹점 목록", response, (row, dto) -> {
			row.createCell(0).setCellValue(dto.getStoreId());
			row.createCell(1).setCellValue(dto.getStoreName());
			row.createCell(2).setCellValue(dto.getMemberId());
			row.createCell(3).setCellValue(dto.getMemName());
			row.createCell(4).setCellValue(dto.getStoreAddress());
			row.createCell(5).setCellValue(dto.getStoreStatus());
			row.createCell(6).setCellValue(dto.getStoreStartTime() != null ? dto.getStoreStartTime().toString() : "");
			row.createCell(7).setCellValue(dto.getStoreCloseTime() != null ? dto.getStoreCloseTime().toString() : "");
		});
	}

	@PreAuthorize("hasRole('HQ')")
	@GetMapping("downloadExcel")
	public void downloadExcel(StoreSearchDTO searchDTO, HttpServletResponse response) throws Exception {
		List<StoreDTO> list = storeService.excelList(searchDTO);
		String[] headers = {"ID", "가맹점명", "점주ID", "점주명", "주소", "상태", "오픈시간", "마감시간"};

		ExcelUtil.download(list, headers, "가맹점 목록", response, (row, dto) -> {
			row.createCell(0).setCellValue(dto.getStoreId());
			row.createCell(1).setCellValue(dto.getStoreName());
			row.createCell(2).setCellValue(dto.getMemberId());
			row.createCell(3).setCellValue(dto.getMemName());
			row.createCell(4).setCellValue(dto.getStoreAddress());
			row.createCell(5).setCellValue(dto.getStoreStatus());
			row.createCell(6).setCellValue(dto.getStoreStartTime() != null ? dto.getStoreStartTime().toString() : "");
			row.createCell(7).setCellValue(dto.getStoreCloseTime() != null ? dto.getStoreCloseTime().toString() : "");
		});
	}
	
	@GetMapping("detail")
	public String detail(StoreDTO storeDTO, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

		if (isStoreOwner) {
			if (user.getStore() == null) {
				return "error/no_store_info";
			}
			storeDTO.setStoreId(user.getStore().getStoreId());
		}

		storeDTO = storeService.detail(storeDTO);
		if (storeDTO == null) return "error/store_not_found";

		List<StoreManageDTO> manageList = storeService.manageList(storeDTO);
		
		model.addAttribute("store", storeDTO);
		model.addAttribute("manageList", manageList);
		model.addAttribute("kakaoKey", kakaoKey);

		return isStoreOwner ? "view_store/store/info" : "store/detail";
	}

	@PreAuthorize("hasAnyRole('STORE')")
	@PostMapping("updateTime")
	@ResponseBody
	public Map<String, Object> updateTime(@RequestBody StoreDTO storeDTO, @AuthenticationPrincipal UserDTO user) throws Exception {
		Map<String, Object> response = new HashMap<>();
		if (!user.getStore().getStoreId().equals(storeDTO.getStoreId())) {
			response.put("status", "fail");
			return response;
		}

		int result = storeService.updateTime(storeDTO);

		if (result > 0) {
			response.put("status", "success");
		} else {
			response.put("status", "error");
		}

		return response;
	}

	@PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
	@PostMapping("updateStatus")
	@ResponseBody
	public Map<String, Object> updateStatus(@RequestBody StoreDTO storeDTO, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isSALES = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_DEPT_SALES"));
		Map<String, Object> response = new HashMap<>();

		if (isSALES) {
			boolean isManager = storeService.isCurrentManager(storeDTO.getStoreId(), user.getMember().getMemberId());
			if (!isManager) {
				response.put("status", "error");
				response.put("message", "해당 가맹점의 담당자가 아닙니다.");

				return response;
			}
		}
		int result = storeService.updateInfo(storeDTO);

		if (result > 0) {
			response.put("status", "success");
		} else {
			response.put("status", "error");
		}

		return response;
	}

	@PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
	@PostMapping("manage/update")
	@ResponseBody
	public Map<String, Object> updateManager(@RequestBody StoreManageDTO managerDTO) throws Exception {
		int result = storeService.updateManager(managerDTO);
	 
		Map<String, Object> response = new HashMap<>();
	 
		if (result > 0) {  
			response.put("message", "배정 완료");
			response.put("status", "success");
		} else {
			response.put("status", "error");
			response.put("message", "배정 실패");
		}
		
		return response; 
	}

	// contract list tab
	@GetMapping("search")
	@ResponseBody
	public List<StoreDTO> searchStore(@RequestParam String keyword, @RequestParam String isManager, Authentication authentication) throws Exception {
		return storeService.searchStore(keyword, isManager, authentication.getName());
	}

}

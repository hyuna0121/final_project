package com.cafe.erp.store.contract;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cafe.erp.security.UserDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.cafe.erp.util.ExcelUtil;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/store/contract/")
public class ContractController {
	
	@Autowired ContractService contractService;

	@GetMapping("list")
	public String List(ContractSearchDTO searchDTO, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

		if (isStoreOwner) {
			if (user.getStore() == null) {
				return "error/no_store_info";
			}
			searchDTO.setSearchStoreId(user.getStore().getStoreId());
		}

		List<ContractDTO> contractList = contractService.list(searchDTO);
		model.addAttribute("list", contractList);
		model.addAttribute("pager", searchDTO);

		return isStoreOwner ? "view_store/store/contract" : "store/tab_contract";
	}

	@PreAuthorize("hasRole('DEPT_SALES')")
	@GetMapping("my-list")
	public String myContractList(ContractSearchDTO searchDTO, Model model, @AuthenticationPrincipal UserDTO user) throws Exception {
		searchDTO.setManagerId(user.getMember().getMemberId());

		List<ContractDTO> contractList = contractService.list(searchDTO);
		model.addAttribute("list", contractList);
		model.addAttribute("pager", searchDTO);

		return "store/tab_contract";
	}

	@PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
	@PostMapping("add")
	@ResponseBody
	public Map<String, Object> addContract(@ModelAttribute ContractDTO contractDTO, 
			@RequestParam(value = "files", required = false) List<MultipartFile> files) throws Exception { 
		int result = contractService.add(contractDTO, files);
	 
		Map<String, Object> response = new HashMap<>();
	 
		if (result > 0) {  
			response.put("status", "success");
		} else {
			response.put("status", "error");
		}
		
		return response; 
	}
	
	@GetMapping("detail")
	@ResponseBody
	public ContractDTO getDetail(@RequestParam String contractId, @AuthenticationPrincipal UserDTO user) throws Exception {
		ContractDTO contractDTO = contractService.getDetail(contractId);

		if (contractDTO == null) return null;

		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));
		if (isStoreOwner && (!contractDTO.getStoreId().equals(user.getStore().getStoreId()))) return null;

		return contractDTO;
	}

	@PreAuthorize("hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')")
	@PostMapping("update")
	@ResponseBody
	public Map<String, Object> updateContract(@ModelAttribute ContractDTO contractDTO, 
		    @RequestParam(value = "newFiles", required = false) List<MultipartFile> newFiles,
		    @RequestParam(value = "deleteFileIds", required = false) List<Integer> deleteFileIds) throws Exception {
		int result = contractService.update(contractDTO, newFiles, deleteFileIds);
		
		Map<String, Object> response = new HashMap<>();
		
		if (result > 0) {  
			response.put("status", "success");
		} else {
			response.put("status", "error");
		}
		
		return response;
	}
	
	@GetMapping("downloadExcel")
	public void downloadExcel(ContractSearchDTO searchDTO, HttpServletResponse response, @AuthenticationPrincipal UserDTO user) throws Exception {
		boolean isStoreOwner = user.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals("ROLE_STORE"));

		if (isStoreOwner) {
			if (user.getStore() == null) {
				response.sendRedirect("/error/noStoreInfo");
				return;
			}
			searchDTO.setSearchStoreId(user.getStore().getStoreId());
		}

		List<ContractDTO> list = contractService.excelList(searchDTO);
		String[] headers = {"ID", "가맹점ID", "가맹점명", "점주ID", "점주명", "주소", 
				            "로얄티", "여신(보증금)", "계약시작일", "계약종료일", "계약상태", "생성일시", "수정일시"};
		
		ExcelUtil.download(list, headers, "가맹점 계약 목록", response, (row, dto) -> {
			row.createCell(0).setCellValue(dto.getContractId());
			row.createCell(1).setCellValue(dto.getStoreId());
			row.createCell(2).setCellValue(dto.getStoreName());
			row.createCell(3).setCellValue(dto.getMemberId());
			row.createCell(4).setCellValue(dto.getMemName());
			row.createCell(5).setCellValue(dto.getStoreAddress());
			
			row.createCell(6).setCellValue(dto.getContractRoyalti());
			row.createCell(7).setCellValue(dto.getContractDeposit());
			row.createCell(8).setCellValue(dto.getContractStartDateStr());
			row.createCell(9).setCellValue(dto.getContractEndDateStr());
			row.createCell(10).setCellValue(dto.getContractStatusStr());
			row.createCell(11).setCellValue(dto.getContractCreatedAtStr());
			row.createCell(12).setCellValue(dto.getContractUpdatedAtStr());
		});
	}

	@PreAuthorize("hasRole('DEPT_SALES')")
	@GetMapping("my-downloadExcel")
	public void myStoreDownloadExcel(ContractSearchDTO searchDTO, HttpServletResponse response, @AuthenticationPrincipal UserDTO user) throws Exception {
		searchDTO.setManagerId(user.getMember().getMemberId());

		List<ContractDTO> list = contractService.excelList(searchDTO);
		String[] headers = {"ID", "가맹점ID", "가맹점명", "점주ID", "점주명", "주소",
				"로얄티", "여신(보증금)", "계약시작일", "계약종료일", "계약상태", "생성일시", "수정일시"};

		ExcelUtil.download(list, headers, "가맹점 계약 목록", response, (row, dto) -> {
			row.createCell(0).setCellValue(dto.getContractId());
			row.createCell(1).setCellValue(dto.getStoreId());
			row.createCell(2).setCellValue(dto.getStoreName());
			row.createCell(3).setCellValue(dto.getMemberId());
			row.createCell(4).setCellValue(dto.getMemName());
			row.createCell(5).setCellValue(dto.getStoreAddress());

			row.createCell(6).setCellValue(dto.getContractRoyalti());
			row.createCell(7).setCellValue(dto.getContractDeposit());
			row.createCell(8).setCellValue(dto.getContractStartDateStr());
			row.createCell(9).setCellValue(dto.getContractEndDateStr());
			row.createCell(10).setCellValue(dto.getContractStatusStr());
			row.createCell(11).setCellValue(dto.getContractCreatedAtStr());
			row.createCell(12).setCellValue(dto.getContractUpdatedAtStr());
		});
	}

}

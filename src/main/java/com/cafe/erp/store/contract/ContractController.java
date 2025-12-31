package com.cafe.erp.store.contract;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/store/tab/contract")
public class ContractController {
	
	@Autowired ContractService contractService;
	
	@GetMapping("")
	public String contractList(Model model) throws Exception {
		List<ContractDTO> contractList = contractService.list();
		model.addAttribute("list", contractList);

		return "store/tab_contract";
	}
	
	
	@PostMapping("/add") 
	@ResponseBody
	public Map<String, Object> addContract(@ModelAttribute ContractDTO contractDTO, @RequestParam(value = "files", required = false) List<MultipartFile> files) throws Exception { 
		int result = contractService.add(contractDTO, files);
	 
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
	
	@GetMapping("/detail")
	@ResponseBody
	public ContractDTO getDetail(@RequestParam String contractId) throws Exception {
		return contractService.getDetail(contractId);
	}

}

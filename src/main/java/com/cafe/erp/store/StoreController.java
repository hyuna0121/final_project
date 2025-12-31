package com.cafe.erp.store;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

@Controller
@RequestMapping("/store/")
public class StoreController {

	@Autowired
	private StoreService storeService;

	@Value("${kakao.appkey}")
	private String kakaoKey;

	@GetMapping("example")
	public String list() throws Exception {
		return "/store/example";
	}

	@GetMapping("main")
	public String main(Model model) {
		model.addAttribute("kakaoKey", kakaoKey);
		return "store/main";
	}

//	store list tab
	@GetMapping("tab/store")
	public String storeList(Model model) throws Exception {
		List<StoreDTO> storeList = storeService.list();
		model.addAttribute("list", storeList);

		return "store/tab_store";
	}

	@PostMapping("tab/store/add") 
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
	
	
	// contract list tab
	@GetMapping("tab/store/search/store")
	@ResponseBody
	public List<StoreDTO> searchStore(@RequestParam String keyword) throws Exception {
		return storeService.searchStore(keyword);
	}

}

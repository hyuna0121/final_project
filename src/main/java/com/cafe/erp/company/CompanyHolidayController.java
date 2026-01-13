package com.cafe.erp.company;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.cafe.erp.security.UserDTO;

@Controller
@RequestMapping("/member")
public class CompanyHolidayController {
	
		@Autowired
		private CompanyHolidayService holidayService;
	
	 	@PostMapping("admin_holiday_add")
	 	public String addCompanyHoliday(CompanyHolidayDTO companyHolidayDTO, @AuthenticationPrincipal UserDTO userDTO) {
	 		companyHolidayDTO.setMemberId(userDTO.getMember().getMemberId());
	 	    
	 		companyHolidayDTO.setComHolidayType("회사휴일");

	 	    holidayService.addHoliday(companyHolidayDTO);
	 		return "redirect:/admin_holiday_list";
	 	}
}

package com.cafe.erp.member.commute;

import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cafe.erp.member.MemberDTO;
import com.cafe.erp.security.UserDTO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/commute/*")
public class MemberCommuteController {
	
	@Autowired
	private MemberCommuteService commuteService;
	
	@PostMapping("checkIn")
	@ResponseBody
	public String checkIn(@AuthenticationPrincipal UserDTO userDTO) throws Exception{
		
		if(userDTO == null) {
			return "fail";
		}
		
		int memberId = userDTO.getMember().getMemberId();
		
		MemberCommuteDTO commuteDTO = new MemberCommuteDTO();
		commuteDTO.setMemberId(memberId);
		
		commuteDTO.setMemCommuteInTime(LocalDateTime.now());
		
		int result = commuteService.checkIn(commuteDTO);
		
		if(result > 0) {
			return "success";
		}
		
		return "already";
	}
	
	@PostMapping("checkOut")
	@ResponseBody
	public String checkOut(@AuthenticationPrincipal UserDTO userDTO) throws Exception{
		
		if(userDTO == null) {
			return "fail";
		}
		
		int memberId = userDTO.getMember().getMemberId();
		
		MemberCommuteDTO commuteDTO = new MemberCommuteDTO();
		
		commuteDTO.setMemberId(memberId);
		commuteDTO.setMemCommuteOutTime(LocalDateTime.now());
		
		
		int result = commuteService.checkOut(commuteDTO);
		
		if(result > 0) {
			return "success";
		}
		
		return "already";
	}

}

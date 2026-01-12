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
		
		// 현재 시간
		LocalDateTime now = LocalDateTime.now();
		commuteDTO.setMemCommuteInTime(now);
		
		LocalDateTime in = now.withHour(9).withMinute(0).withSecond(0);
		
		if(now.isAfter(in)) {
			commuteDTO.setMemCommuteState("지각");
		} else {
			commuteDTO.setMemCommuteState("출근");
			
		}
		
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
		
		LocalDateTime now = LocalDateTime.now();
		commuteDTO.setMemCommuteOutTime(now);
		
		LocalDateTime hour1730 = now.withHour(17).withMinute(30).withSecond(0);
		
		if(now.isBefore(hour1730)) {
			commuteDTO.setMemCommuteState("조퇴");
		} else if(now.isAfter(hour1730)) {
			commuteDTO.setMemCommuteState("퇴근");
			
		}
		
		
		int result = commuteService.checkOut(commuteDTO);
		
		if(result > 0) {
			return "success";
		}
		
		return "already";
	}

}

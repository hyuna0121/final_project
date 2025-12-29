package com.cafe.erp.member;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/member/*")
public class MemberController {
	
	@Autowired
	private MemberService memberService;

	@GetMapping("admin_member_list")
	public String list(MemberDTO memberDTO, Model model)throws Exception{
		List<MemberDTO> list = memberService.list(memberDTO);
		model.addAttribute("list", list);
		
		return "member/admin_member_list";
	}
	
	@PostMapping("admin_member_add")
	public String add(MemberDTO memberDTO, Model model) throws Exception{
		int result = memberService.add(memberDTO);
		
		String msg = "등록 성공";
		
		if(result == 0) {
			msg = "등록 실패";
			model.addAttribute("msg", msg);
			model.addAttribute("url", "./admin_member_list");
			return "redirect:./admin_member_list";
		}
		
		model.addAttribute("msg", msg);
		model.addAttribute("url", "./AM_user_detail");
		return "reidrect:./AM_user_detail";
	}
	
}

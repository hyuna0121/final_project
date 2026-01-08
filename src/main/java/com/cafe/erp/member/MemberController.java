package com.cafe.erp.member;

import java.security.PublicKey;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.service.annotation.PatchExchange;

import com.cafe.erp.member.commute.MemberCommuteDTO;
import com.cafe.erp.member.commute.MemberCommuteService;
import com.cafe.erp.security.UserDTO;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
@RequestMapping("/member")
public class MemberController {

    private final PasswordEncoder passwordEncoder;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private MemberCommuteService commuteService; 
	
	@Autowired
	private EmailService emailService;


    MemberController(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }
	
	
	@GetMapping("login")
	public void login()throws Exception{
		
	}
	
	
	@GetMapping("AM_group_chat")
	public String chatList(Model model, @AuthenticationPrincipal UserDTO userDTO)throws Exception{
		int memberId = userDTO.getMember().getMemberId();
		Map<String, Object> count = memberService.deptMemberCount();
		boolean pwPass = memberService.pwPass(memberId);
		model.addAttribute("count", count);
		model.addAttribute("pwPass", pwPass);
		return "member/AM_group_chat";
	}
	
	
	@GetMapping("member/checkCount")
	@ResponseBody
	public List<MemberDTO> checkMemberCount(@RequestParam(name = "deptCode", defaultValue = "0")int deptCode, @RequestParam(name = "check", defaultValue = "false") boolean check) throws Exception{

		Map<String, Object> checkMem = new HashMap<>();
		checkMem.put("deptCode", deptCode);
		checkMem.put("check", check);
		return memberService.chatList(checkMem);
	}
	
	

	@GetMapping("admin_member_list")
	public String list(MemberDTO memberDTO, Model model)throws Exception{
		List<MemberDTO> list = memberService.list(memberDTO);
		model.addAttribute("list", list);
		
		int totalCount = memberService.countAllMember(memberDTO);   // 전체(퇴사 포함)
	    int activeCount = memberService.countActiveMember(memberDTO); // 재직자만

	    model.addAttribute("totalCount", totalCount);
	    model.addAttribute("activeCount", activeCount);
	    
		return "member/admin_member_list";
	}
	
	@PostMapping("admin_member_add")
	public String add(MemberDTO memberDTO, Model model) throws Exception{
		String pw = "1234";
		memberDTO.setMemPassword(pw);
		
		int result = memberService.add(memberDTO);
		
		String msg = "등록 성공";
		
		int memid = memberDTO.getMemberId();
		
		if(result == 0) {
			msg = "등록 실패";
			model.addAttribute("msg", msg);
			model.addAttribute("url", "./admin_member_list");
			return "redirect:./admin_member_list";
		}
		
		model.addAttribute("msg", msg);
		model.addAttribute("url", "./AM_user_detail");
		emailService.sendPasswordEmail(memberDTO.getMemEmail(), pw, memberDTO.getMemName());
		return "redirect:./AM_member_detail?memberId=" + memid;
	}
	
	@GetMapping("AM_member_detail")
	public String detail(MemberDTO memberDTO, Model model) throws Exception{
		MemberDTO member = memberService.detail(memberDTO);
		model.addAttribute("dto", member);
		
		
		
		MemberCommuteDTO commuteDTO = new MemberCommuteDTO();
		commuteDTO.setMemberId(member.getMemberId());
		
		List<MemberCommuteDTO> attendanceList = commuteService.attendanceList(commuteDTO);
		model.addAttribute("attendanceList", attendanceList);
		
		
		return "member/AM_member_detail";
	}
	
	
	@PostMapping("member_info_update")
	@ResponseBody
	public String update(MemberDTO memberDTO, @RequestParam(value = "profileImage", required = false)MultipartFile file)throws Exception{
		String newFileName = memberService.update(memberDTO, file);
		
		if(newFileName != null) {
			Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
			UserDTO userDTO = (UserDTO) authentication.getPrincipal();
			userDTO.getMember().setMemProfileSavedName(newFileName);
		}
	    
	    return "success";
	}
	
	
	@PostMapping("reset_password")
	@ResponseBody
	public String resetPassword(@RequestParam("memberId") int memberId) throws Exception {
		
		MemberDTO searchDTO = new MemberDTO();
		searchDTO.setMemberId(memberId);
		MemberDTO targetMember = memberService.detail(searchDTO);
		
		if (targetMember == null) {
			return "fail";
		}
		
		String pw ="1234";
		
		MemberDTO updateDTO = new MemberDTO();
		updateDTO.setMemberId(memberId);
		updateDTO.setMemPassword("1234");
		
		memberService.resetPw(updateDTO);
		
		emailService.resetPasswordEmail(targetMember.getMemEmail(), pw, targetMember.getMemName());
		
		return "success";
	}
	
	
	@PostMapping("changePassword")
	@ResponseBody
	public String changePassword(@Valid MemberChangePasswordDTO changePasswordDTO, BindingResult bindingResult, @AuthenticationPrincipal UserDTO userDTO) throws Exception{
		
		if(bindingResult.hasErrors()) {
			return bindingResult.getFieldError().getDefaultMessage();
		}
		
		changePasswordDTO.setMemberId(userDTO.getMember().getMemberId());
		
		int result = memberService.changePassword(userDTO.getMember().getMemberId(), changePasswordDTO);
		
		if(result == -1) {
			return "현재 비밀번호가 일치하지 않습니다.";
		} else if(result == 2) {
			return "현재 비밀번호와 일치합니다.";
		}
		return result > 0 ? "success" : "fail";
	}
	
	
	
	
	
	@PostMapping("InActive")
	@ResponseBody
	public String InActive(@RequestParam("memberId") int memberId) throws Exception{
		MemberDTO memberDTO = new MemberDTO();
		memberDTO.setMemberId(memberId);
		memberDTO.setMemIsActive(false);
		memberService.InActive(memberDTO);
		
		return "success";
	}
	
	@GetMapping("sessionCheck")
	@ResponseBody
	public String sessionCheck() {
		return "active";
	}
	
	
	
	
	
	
	
	
	@GetMapping("/search/owner")
	@ResponseBody
	public List<MemberDTO> searchOwner(@RequestParam String keyword) throws Exception {
		return memberService.searchOwner(keyword);
	}
	
	@GetMapping("/search/manager")
	@ResponseBody
	public List<MemberDTO> searchManager(@RequestParam String keyword) throws Exception {
		return memberService.searchManager(keyword);
	}
	
}

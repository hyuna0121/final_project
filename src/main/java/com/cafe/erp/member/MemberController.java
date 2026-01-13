package com.cafe.erp.member;

import java.util.ArrayList;
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

import com.cafe.erp.company.CompanyHolidayDTO;
import com.cafe.erp.company.CompanyHolidayService;
import com.cafe.erp.member.attendance.MemberAttendanceDAO;
import com.cafe.erp.member.attendance.MemberAttendanceDTO;
import com.cafe.erp.member.attendance.MemberLeaveStatsDTO;
import com.cafe.erp.member.commute.MemberCommuteDTO;
import com.cafe.erp.member.commute.MemberCommuteService;
import com.cafe.erp.security.UserDTO;

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
	
	@Autowired
	private CompanyHolidayService companyHolidayService;
	
	@Autowired
	private MemberAttendanceDAO memberAttendanceDAO;

	MemberController(PasswordEncoder passwordEncoder) {
		this.passwordEncoder = passwordEncoder;
	}
	
	
	

	@GetMapping("login")
	public void login() throws Exception {

	}
	
	@GetMapping("member_mypage")
	public void mypage() throws Exception{
		
	}
	
	
	
	@GetMapping("calendar")
	@ResponseBody
	public List<Map<String, Object>> holidayView(@AuthenticationPrincipal UserDTO userDTO) throws Exception{
		List<CompanyHolidayDTO> list = companyHolidayService.selectHolidaysList();
		
		List<Map<String, Object>> view = new ArrayList<>();
		
		for(CompanyHolidayDTO dto : list) {
			Map<String, Object> calendar = new HashMap<>();
			calendar.put("title", dto.getComHolidayName()); // 휴일 이름
			calendar.put("start", dto.getComHolidayDate().toString()); // 휴일 
			
			calendar.put("className", "holiday-event");
			calendar.put("allDay", true);
			view.add(calendar);
		}
		
		
		int memberId = userDTO.getMember().getMemberId();
		
		MemberCommuteDTO commuteDTO = new MemberCommuteDTO();
		commuteDTO.setMemberId(memberId);
		List<MemberCommuteDTO> commuteList = commuteService.attendanceList(commuteDTO);
		
		for(MemberCommuteDTO dto : commuteList) {
			String state = dto.getMemCommuteState();
			if(dto.getMemCommuteWorkDate() != null) {
				Map<String, Object> checkIn = new HashMap<>();
				String checkInDate = dto.getMemCommuteInTime().toString();
				String checkInTime = checkInDate.substring(11, 16);
				
				if ("지각".equals(state) || checkInTime.compareTo("09:00") > 0) {
		            checkIn.put("title", "지각 (" + checkInTime + ")");    
		            checkIn.put("className", "commute-late-event"); 
		        } else {
					checkIn.put("title", "출근 (" + checkInTime + ")") ;
					checkIn.put("className", "commute-go-event");
				}
				checkIn.put("start",checkInDate );
				view.add(checkIn);
			}
			
			if (dto.getMemCommuteOutTime() != null) {
                Map<String, Object> checkout = new HashMap<>();
                String checkOutDate = dto.getMemCommuteOutTime().toString();
                String checkOutTime = checkOutDate.substring(11, 16);
                
                
                if("조퇴".equals(state)) {
                	checkout.put("title", "조퇴 (" + checkOutTime + ")");
                	checkout.put("className", "commute-late-event");
					
				} else {
					checkout.put("title", "퇴근 (" + checkOutTime + ")");
					checkout.put("className", "commute-leave-event");
					
				}
                checkout.put("start",checkOutDate );
				view.add(checkout);
			}
		}
		return view;
	}
	
	

	@GetMapping("AM_group_chart")
	public String chatList(Model model, @AuthenticationPrincipal UserDTO userDTO, MemberDTO memberDTO)
			throws Exception {
		// 로그인 한 유저 확인
		int memberId = userDTO.getMember().getMemberId();

		
		// 초기 조직도 목록
		Map<String, Object> startChart = new HashMap<>();
		startChart.put("deptCode", 0); // 전체 부서
		startChart.put("includeRetired", false); // 활성 사원만
		startChart.put("keyword", ""); // 검색어 X
		// 부서별 활성 인원 수
		List<Map<String, Object>> deptCount = memberService.deptMemberCount(startChart);

		// 전체 활성 사원 수
		int totalCount = memberService.countActiveMember(memberDTO);

		List<MemberDTO> startViewChart = memberService.chatList(startChart);

		model.addAttribute("deptCount", deptCount);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("startViewChart", startViewChart);

		return "member/AM_group_chart";
	}
	
	

	@GetMapping("checkCount")
	@ResponseBody
	public Map<String, Object> checkMemberCount(@RequestParam(name = "deptCode", defaultValue = "0") int deptCode,
			@RequestParam(name = "includeRetired", defaultValue = "false") boolean includeRetired,
			@RequestParam(defaultValue = "") String keyword) throws Exception {

		Map<String, Object> checkMem = new HashMap<>();
		checkMem.put("deptCode", deptCode);
		checkMem.put("includeRetired", includeRetired);
	    checkMem.put("keyword", keyword);

	    Map<String, Object> resultMem = new HashMap<>();
	    
	    List<MemberDTO> memberList = memberService.chatList(checkMem);
	    resultMem.put("memberList", memberList);
	    
		if (!keyword.isEmpty()) {
			checkMem.put("keyword", keyword);
		}
		
		List<Map<String, Object>> deptCounts = memberService.deptMemberCount(checkMem); 
	    resultMem.put("deptCounts", deptCounts);
		return resultMem;
	}
	
	

	@GetMapping("admin_member_list")
	public String list(MemberDTO memberDTO, Model model) throws Exception {
		List<MemberDTO> list = memberService.list(memberDTO);
		model.addAttribute("list", list);

		int totalCount = memberService.countAllMember(memberDTO); // 전체(퇴사 포함)
		int activeCount = memberService.countActiveMember(memberDTO); // 재직자만

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("activeCount", activeCount);

		return "member/admin_member_list";
	}
	
	

	@PostMapping("admin_member_add")
	public String add(MemberDTO memberDTO, Model model) throws Exception {
		String pw = "1234";
		memberDTO.setMemPassword(pw);

		int result = memberService.add(memberDTO);

		String msg = "등록 성공";

		int memid = memberDTO.getMemberId();

		if (result == 0) {
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
	public String detail(MemberDTO memberDTO, Model model, @AuthenticationPrincipal UserDTO userDTO) throws Exception {
		int targetMemberId = memberDTO.getMemberId();
	    
	    if (targetMemberId == 0) {
	        targetMemberId = userDTO.getMember().getMemberId();
	        memberDTO.setMemberId(targetMemberId); 
	    }

	    MemberDTO member = memberService.detail(memberDTO);
	    model.addAttribute("dto", member);

	    if (member != null) {
	        MemberCommuteDTO commuteDTO = new MemberCommuteDTO();
	        commuteDTO.setMemberId(targetMemberId); 
	        List<MemberCommuteDTO> attendanceList = commuteService.attendanceList(commuteDTO);
	        model.addAttribute("attendanceList", attendanceList);

	        List<MemberAttendanceDTO> vacationList = memberAttendanceDAO.attendanceList(targetMemberId);
	        model.addAttribute("vacationList", vacationList);
	        
	        MemberLeaveStatsDTO stats = memberAttendanceDAO.selectLeaveStats(targetMemberId);
	        model.addAttribute("stats", stats);
	    }

	    return "member/AM_member_detail";
	}
	
	

	@PostMapping("member_info_update")
	@ResponseBody
	public String update(MemberDTO memberDTO,
			@RequestParam(value = "profileImage", required = false) MultipartFile file) throws Exception {
		String newFileName = memberService.update(memberDTO, file);
		if (newFileName != null) {
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

		String pw = "1234";

		MemberDTO updateDTO = new MemberDTO();
		updateDTO.setMemberId(memberId);
		updateDTO.setMemPassword("1234");

		memberService.resetPw(updateDTO);

		emailService.resetPasswordEmail(targetMember.getMemEmail(), pw, targetMember.getMemName());

		return "success";
	}

	
	
	@PostMapping("changePassword")
	@ResponseBody
	public String changePassword(@Valid MemberChangePasswordDTO changePasswordDTO, BindingResult bindingResult,
			@AuthenticationPrincipal UserDTO userDTO) throws Exception {

		if (bindingResult.hasErrors()) {
			return bindingResult.getFieldError().getDefaultMessage();
		}

		changePasswordDTO.setMemberId(userDTO.getMember().getMemberId());

		int result = memberService.changePassword(userDTO.getMember().getMemberId(), changePasswordDTO);

		if (result == -1) {
			return "현재 비밀번호가 일치하지 않습니다.";
		} else if (result == 2) {
			return "현재 비밀번호와 일치합니다.";
		}
		return result > 0 ? "success" : "fail";
	}
	

	
	
	
	
	
	
	
	@PostMapping("InActive")
	@ResponseBody
	public String InActive(@RequestParam("memberId") int memberId) throws Exception {
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

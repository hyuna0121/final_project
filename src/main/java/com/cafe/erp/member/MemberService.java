package com.cafe.erp.member;

import java.time.LocalDate;

import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.cafe.erp.files.FileUtils;

import jakarta.validation.Valid;


@Service
public class MemberService {

    private final EmailService emailService;

	@Autowired
	private MemberDAO memberDAO;
	
	@Autowired
	private FileUtils fileUtils;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	

    MemberService(EmailService emailService) {
        this.emailService = emailService;
    }
	
	public MemberDTO login(int memberId)throws Exception{
		return memberDAO.login(memberId);
	}
	
	
	public List<MemberDTO> chatList(Map<String, Object> val) throws Exception{
		return memberDAO.chatList(val);
	}
	
	
	public Map<String, Object> deptMemberCount(){
		List<Map<String, Object>> list = memberDAO.deptMemberCount();
		int total = memberDAO.totalMemberCount();
		
		Map<String, Object> count = new HashMap<>();
		for (Map<String, Object> map : list) {
	        count.put((String) map.get("deptCode"), map.get("count"));
	    }
	    
	    count.put("total", total); 
	    return count;
	}
	
	public List<MemberDTO> list(MemberDTO memberDTO) throws Exception {
		return memberDAO.list(memberDTO);
	}
	
	public int countAllMember(MemberDTO memberDTO )throws Exception {
		return memberDAO.countAllMember(memberDTO);
	}

	
	public int countActiveMember(MemberDTO memberDTO) throws Exception{
		return memberDAO.countActiveMember(memberDTO);
	}
	
	
	
	
	public int add(MemberDTO memberDTO) throws Exception{
		String year = LocalDate.now().format(DateTimeFormatter.ofPattern("yy"));
		String id = memberDTO.getIdPrefix() + year;
		
		String prefixId = memberDAO.getMemberId(id);
		
		int num = 1;
		
		if(prefixId != null) {
			num = Integer.parseInt(prefixId.substring(3)) + 1;
		}
		
		String finalId = id + String.format("%03d", num);

		memberDTO.setMemberId(Integer.parseInt(finalId));
		
		String pw = memberDTO.getMemPassword();		
		if(pw == null) pw = "1234";
		
		String bcpw = passwordEncoder.encode(pw);
		
		memberDTO.setMemPassword(bcpw);
		
		int result = memberDAO.add(memberDTO);
		return result;
	}
	

	public List<MemberDTO> searchOwner(String keyword) {
		return memberDAO.searchOwner(keyword);
	}


	public MemberDTO detail(MemberDTO memberDTO) throws Exception{
		return memberDAO.detail(memberDTO);
	}



	@Transactional
	public String update(MemberDTO memberDTO, MultipartFile file) throws Exception {
		String savedFileName = null;

	    if(file != null && !file.isEmpty()) {
	        int memberId = memberDTO.getMemberId();
	        
	        String oldSavedName = memberDAO.findProfileSavedName(memberId);
	        if(oldSavedName != null) {
	            fileUtils.deleteFile(oldSavedName);
	        }
	        
	        savedFileName = fileUtils.uploadFile(file);
	        String originalName = file.getOriginalFilename();
	        
	        if(memberDAO.checkProfileExist(memberId) > 0) {
	            memberDAO.updateProfile(originalName, savedFileName, memberId);
	        } else {
	            memberDAO.insertProfile(originalName, savedFileName, memberId);
	        }
	    }
	    memberDAO.update(memberDTO); 
	    return savedFileName;
	}

	public int resetPw(MemberDTO memberDTO) throws Exception{
		
		String pw = memberDTO.getMemPassword();		
		
		String bcpw = passwordEncoder.encode(pw);
		
		memberDTO.setMemPassword(bcpw);
		
		
		return memberDAO.resetPw(memberDTO);
	}

	
	public int InActive(MemberDTO memberDTO) throws Exception{
		return memberDAO.InActive(memberDTO);
	}



	public String getMemId(String memberDTO)throws Exception{
		return memberDAO.getMemberId(memberDTO);
	}


	public int changePassword(int memberId, @Valid MemberChangePasswordDTO changePasswordDTO) throws Exception{
		String db = memberDAO.getMemberPassword(memberId);
		
		if(!passwordEncoder.matches(changePasswordDTO.getNowPassword(), db)) {
			return -1;
		};
		
		if(passwordEncoder.matches(changePasswordDTO.getChangePassword(), db)) {
			return 2;
		}
		
		String newPassWordEn = passwordEncoder.encode(changePasswordDTO.getChangePassword());
		changePasswordDTO.setChangePassword(newPassWordEn);
		return memberDAO.changePassword(changePasswordDTO);
	}
	
	
	public Boolean pwPass(int memberId) throws Exception{
		String db = memberDAO.getMemberPassword(memberId);
		return passwordEncoder.matches("1234", db);
	}
	
	
	public List<MemberDTO> searchManager(String keyword) throws Exception {
		return memberDAO.searchManager(keyword);
	}
	
	

}

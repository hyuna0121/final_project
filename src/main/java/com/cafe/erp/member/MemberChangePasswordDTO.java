package com.cafe.erp.member;

import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberChangePasswordDTO {
	
	private int memberId;
	private String nowPassword;
	
	@Pattern(regexp = "^(?=.*[a-z])(?=.*[0-9])(?=.*[^a-zA-Z0-9\\s]).{8,15}$", message = "비밀번호는 소문자, 숫자, 특수문자가 1개 이상 포함되어야 합니다.(8~15자)")
	private String changePassword;
	
}

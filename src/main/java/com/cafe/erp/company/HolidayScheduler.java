package com.cafe.erp.company;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.cafe.erp.member.MemberDAO;

import jakarta.annotation.PostConstruct;

@Component
public class HolidayScheduler {

	@Autowired
	private CompanyHolidayService companyHolidayService;
	
	@Autowired
	private MemberDAO memberDAO;
	
	
	
	@Scheduled(cron = "0 0 0 1 1 ?")
	public void auto() {
		String year = String.valueOf(java.time.LocalDate.now().getYear());
		
		try {
	        companyHolidayService.apiHoliday(year);
	        System.out.println("공휴일 업데이트 성공");
	    } catch (Exception e) {
	        System.err.println("공휴일 업데이트 실패(API 문제 등): " + e.getMessage());
	    }

	    try {
	        memberDAO.yearLeave();
	        System.out.println("전 직원 연차 부여 성공");
	    } catch (Exception e) {
	        System.err.println("연차 부여 실패: " + e.getMessage());
	    }
	}
}

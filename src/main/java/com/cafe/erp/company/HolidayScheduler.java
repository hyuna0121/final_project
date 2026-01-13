package com.cafe.erp.company;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import jakarta.annotation.PostConstruct;

@Component
public class HolidayScheduler {

	@Autowired
	private CompanyHolidayService companyHolidayService;
	
	
	
	@Scheduled(cron = "0 0 0 1 1 ?")
	public void auto() {
		String year = String.valueOf(java.time.LocalDate.now().getYear());
		
		companyHolidayService.apiHoliday(year);
	}
}

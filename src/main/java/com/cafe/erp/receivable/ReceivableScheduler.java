package com.cafe.erp.receivable;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class ReceivableScheduler {
	
	@Autowired
	private ReceivableService service;
	
	@Scheduled(cron = "0 0 0 1 * ?")
	public void createMonthlyReceivable() {
		
		service.createMonlyRoyaltyReceivable();
	}
	
	
	
	
}

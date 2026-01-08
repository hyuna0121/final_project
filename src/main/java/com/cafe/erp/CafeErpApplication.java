package com.cafe.erp;

import jakarta.annotation.PostConstruct;
import java.util.TimeZone;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;


@EnableScheduling
@SpringBootApplication
public class CafeErpApplication {
	@PostConstruct
	public void stard() {
		TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
		System.out.println("현재 시간: " + new java.util.Date());
	}

	
	public static void main(String[] args) {
		SpringApplication.run(CafeErpApplication.class, args);
	}
	

}

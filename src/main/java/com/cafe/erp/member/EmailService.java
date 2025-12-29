package com.cafe.erp.member;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
	
	@Autowired
    private JavaMailSender javaMailSender;

    public void sendPasswordEmail(String Email, String Password, String Name) {
        SimpleMailMessage message = new SimpleMailMessage();
        
        message.setTo(Email); // 받는 사람
        message.setSubject("신규 사원 등록 및 임시 비밀번호 안내");
        
        String text = "안녕하세요, " + Name + "님.\n"
                    + "사원 등록이 완료되었습니다.\n\n"
                    + "임시 비밀번호: " + 1234 + "\n\n"
                    + "로그인 후 반드시 비밀번호를 변경해 주세요.";
        
        message.setText(text); // 내용
        
        javaMailSender.send(message); // 전송!
        System.out.println("메일 전송 완료: " + Email);
    }
}

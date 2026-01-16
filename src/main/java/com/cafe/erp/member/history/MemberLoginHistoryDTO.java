package com.cafe.erp.member.history;

import java.time.LocalDateTime;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberLoginHistoryDTO {
	
	private Long memberLoginHistoryId;
    private LocalDateTime memLogHisCreatedTime;
    private String memLogHisClientIp;
    private String memLogHisRequestUrl;
    private String memLogHisActionType; 
    private boolean memLogHisIsSuccess; 
    private String memLogHisLoginId;    
    private Integer memberId;

    
    private String memName;
}

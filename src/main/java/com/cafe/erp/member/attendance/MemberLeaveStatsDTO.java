package com.cafe.erp.member.attendance;

import java.sql.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberLeaveStatsDTO {
	
	
	private int memberLeaveId;      
    private double memLeaveYear;       
    private double memLeaveTotalDays; 
    private double memLeaveUsedDays;        
    private Date memLeaveCreatedAt;      
    private Date memLeaveUpdatedAt;      
    private int memberId;  
    private double remainingDays; 
    private int usageRate;     
    
    
    public double getRemainingDays() {
        return this.memLeaveTotalDays - this.memLeaveUsedDays;
    }

    public int getUsageRate() {
        if (this.memLeaveTotalDays == 0) return 0; 
        return (int) ((this.memLeaveUsedDays / this.memLeaveTotalDays) * 100);
    }
}
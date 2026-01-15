package com.cafe.erp.member.commute;

import java.sql.Date;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import com.cafe.erp.member.MemberDTO;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MemberCommuteDTO extends MemberDTO{

	private int memberCommuteId;
	private Date memCommuteWorkDate;
	private LocalDateTime memCommuteInTime;
	private LocalDateTime memCommuteOutTime;
	private String memCommuteState;
	private int memberId;
	
	private String note;
	
	public String getFormattedInTime() {
        if (memCommuteInTime == null) return "-";
        return memCommuteInTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }

    public String getFormattedOutTime() {
        if (memCommuteOutTime == null) return "-";
        return memCommuteOutTime.format(DateTimeFormatter.ofPattern("HH:mm"));
    }


}

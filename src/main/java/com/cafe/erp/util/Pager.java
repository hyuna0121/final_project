package com.cafe.erp.util;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Pager {
	private Long page;
	
	private Long startNum;
	
	// 한 페이지당 보여줄 글의 갯수
	private Long perPage;
	
	// 한 블럭당 출력할 번호의 갯수
	private Long perBlock;
	
	private Long begin;
	private Long end;
	
	public Long getPage() {
		if (this.page==null || this.page < 1) {
			this.page = 1L;
		}
		return this.page;
	}
	
	public Long getPerPage() {
		if (this.perPage == null || this.perPage % 5 != 0 || this.perPage < 1) {
			this.perPage = 10L;
		}
		return this.perPage;
	}
	
	public Long getPerBlock() {
		if (this.perBlock == null || this.perBlock < 1 || this.perBlock % 5 != 0) {
			this.perBlock = 5L;
		}
		return this.perBlock;
	}
	
	//1. 페이징 계산
	public void pageing(Long totalCount) throws Exception {
		
		if (totalCount < 1) {
			totalCount=1L;
		}
		
		// 총 글의 갯수로 총 페이지 구하기
		Long totalPage = (long)Math.ceil(((double)totalCount / this.getPerPage()));
		
		
		
		
		// page값이 totalpage의 값이 벗어 난 경우
		if (this.getPage() > totalPage) {
			this.page = totalPage;
		}
		
		// 총 페이지 수로 총 블럭수 구하기
		Long totalBlock = totalPage / this.getPerBlock();
		if (totalPage % perBlock != 0) {
			totalBlock++;
		}
		
		// 페이지 번호로 현재 블럭 번호 구하기
		Long curBlock = this.getPage()/this.perBlock;
		if (this.page % this.perBlock != 0) {
			curBlock++;
		}
		
		// 현재 블럭 번호로 시작 번호와 끝 번호 구하기
		this.begin = (curBlock - 1) * this.perBlock + 1;
		this.end = curBlock * this.perBlock;
		
		// 마지막 블럭이라면 끝번호를 총페이지수로 대입하기
		if (curBlock >= totalBlock) {
			this.begin = (totalBlock - 1) * this.perBlock + 1;
			this.end = totalPage;
		}
		this.makeStartNum();
	}
	
	// 2. DB에서 일정한 갯수만큼 조회하도록 계산
	private void makeStartNum() throws Exception {
		this.startNum = (this.page-1)*perPage;
	}
	
	
	
}

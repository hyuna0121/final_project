<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.time.LocalDate" %>

<html
  lang="ko"
  class="light-style layout-menu-fixed"
  dir="ltr"
  data-theme="theme-default"
  data-assets-path="../assets/"
  data-template="vertical-menu-template-free"
>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <title>사원 관리 - 관리자 | Sneat</title>
    <meta name="description" content="" />
    <link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="/vendor/libs/apex-charts/apex-charts.css" />
    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>
  </head>

  <body>
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
        
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>
        <div class="layout-page">
        <c:import url="/WEB-INF/views/template/header.jsp"></c:import>
        
          <div class="content-wrapper">
            
            <div class="container-xxl flex-grow-1 container-p-y">
              
              <h4 class="fw-bold py-3 mb-4"><span class="text-muted fw-light">인사 관리 /</span> 사원 통합 관리</h4>

              <div class="card mb-4">
                <div class="card-body">
                    <form action="./list" method="get" class="row gx-3 gy-2 align-items-center">
                        <div class="col-md-3">
                            <label class="form-label" for="selectTypeOpt">부서 선택</label>
                            <select id="selectTypeOpt" class="form-select color-dropdown">
                                <option value="" selected>전체 부서</option>
                                <option value="HR">인사팀</option>
                                <option value="DEV">개발팀</option>
                                <option value="SALES">영업팀</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label" for="selectStatusOpt">재직 상태</label>
                            <select id="selectStatusOpt" class="form-select color-dropdown">
                                <option value="" selected>전체</option>
                                <option value="active">재직</option>
                                <option value="leave">휴직</option>
                                <option value="resigned">퇴사</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label" for="searchName">이름/사번 검색</label>
                            <input type="text" class="form-control" id="searchName" placeholder="홍길동 or 124001" />
                        </div>
                        <div class="col-md-2">
                            <label class="form-label d-block">&nbsp;</label>
                            <button type="submit" class="btn btn-primary w-100">
                                <span class="tf-icons bx bx-search"></span> 조회
                            </button>
                        </div>
                    </form>
                </div>
              </div>

              <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">사원 목록 (총 124명)</h5>
                    <div>
                        <button type="button" class="btn btn-outline-success me-2">
                            <i class='bx bx-download me-1'></i> 엑셀 다운로드
                        </button>
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addMemberModal">
                            <span class="tf-icons bx bx-user-plus"></span> 사원 등록
                        </button>
                    </div>
                </div>
                
                <div class="table-responsive text-nowrap">
                  <table class="table table-hover">
                    <thead>
                      <tr>
                        <th>사번</th>
                        <th>이름</th>
                        <th>부서</th>
                        <th>직급</th>
                        <th>입사일</th>
                        <th>퇴사일</th>
                        <th>상태</th>
                      </tr>
                    </thead>
                    <tbody class="table-border-bottom-0">
                    
                    	<c:forEach items="${list}" var="member">
		                    <tr>
        	                	<td><i class="fab fa-angular fa-lg text-danger me-3"></i> <strong>${member.memberId}</strong></td>
            	            	<td><a href="./detail?empId=102401" class="fw-bold text-body">${member.memName}</a></td>
            	            	<td>
	            	            	<c:choose>
    	        	            		<c:when test="${member.deptCode == 10}">
        	    	            			인사팀
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 11}">
        	    	            			회계팀
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 12}">
        	    	            			재무팀
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 13}">
        	    	            			영업팀
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 14}">
        	    	            			CS팀
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 15}">
        	    	            			마케팅팀
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 16}">
        	    	            			개발팀
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 17}">
        	    	            			가맹점
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 20}">
        	    	            			임원
            		            		</c:when>
            		            		<c:when test="${member.deptCode == 99}">
        	    	            			관리자
            		            		</c:when>
            		            		
	            	            	</c:choose>
                	        	</td>            	            	
                    	    	<td>
                    	    		<c:choose>
									    <c:when test="${member.positionCode == 99}">
									        <span class="badge bg-label-info me-1">관리자</span>
									    </c:when>
									    <c:when test="${member.positionCode == 1}">
									        <span class="badge bg-label-primary me-1">팀장</span>
									    </c:when>
									    <c:when test="${member.positionCode == 2}">
									        <span class="badge bg-label-primary me-1">차장</span>
									    </c:when>
									    <c:when test="${member.positionCode == 3}">
									        <span class="badge bg-label-primary me-1">과장</span>
									    </c:when>
									    <c:when test="${member.positionCode == 4}">
									        <span class="badge bg-label-secondary me-1">대리</span>
									    </c:when>
									    <c:when test="${member.positionCode == 5}">
									        <span class="badge bg-label-secondary me-1">주임</span>
									    </c:when>
									    <c:when test="${member.positionCode == 6}">
									        <span class="badge bg-label-secondary me-1">사원</span>
									    </c:when>
									    <c:when test="${member.positionCode == 10}">
									        <span class="badge bg-label-danger me-1">이사</span>
									    </c:when>
									    <c:when test="${member.positionCode == 11}">
									        <span class="badge bg-label-danger me-1">상무</span>
									    </c:when>
									    <c:when test="${member.positionCode == 12}">
									        <span class="badge bg-label-danger me-1">전무</span>
									    </c:when>
									    <c:when test="${member.positionCode == 17}">
									        <span class="badge bg-label-warning me-1">가맹점</span>
									    </c:when>
									</c:choose>
                    	    	</td>
                        		<td>${member.memHireDate}</td>
                        		<td>${member.memLeftDate}</td>
                        		<td>
								    <c:choose>
								        <c:when test="${member.memIsActive}">
								        <span class="badge bg-label-success">
								                재직중
								            </span>
								        </c:when>

								        <c:otherwise>
								            <span class="badge bg-label-dark">
								                퇴사
								            </span>
								        </c:otherwise>
								    </c:choose>
                        		</td>
                      		</tr>
                    	
                    	
                    	</c:forEach>
                      </tbody>
                      
                  </table>
                </div>
                
                <div class="card-footer d-flex justify-content-center">
                    <nav aria-label="Page navigation">
                      <ul class="pagination">
                        <li class="page-item first">
                          <a class="page-link" href="javascript:void(0);"><i class="tf-icon bx bx-chevrons-left"></i></a>
                        </li>
                        <li class="page-item prev">
                          <a class="page-link" href="javascript:void(0);"><i class="tf-icon bx bx-chevron-left"></i></a>
                        </li>
                        <li class="page-item active">
                          <a class="page-link" href="javascript:void(0);">1</a>
                        </li>
                        <li class="page-item next">
                          <a class="page-link" href="javascript:void(0);"><i class="tf-icon bx bx-chevron-right"></i></a>
                        </li>
                        <li class="page-item last">
                          <a class="page-link" href="javascript:void(0);"><i class="tf-icon bx bx-chevrons-right"></i></a>
                        </li>
                      </ul>
                    </nav>
                </div>
                </div>
              </div>
            <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
            <div class="content-backdrop fade"></div>
          </div>
          </div>
        </div>
      <div class="layout-overlay layout-menu-toggle"></div>
    </div>


    <div class="modal fade" id="addMemberModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered  modal-dialog-scrollable">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">신규 사원 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="/member/admin_member_add" method="post">
                	<input type="hidden" id="idPrefix" name="idPrefix" value="1">
                    <div class="modal-body">
                        <div class="row g-2 mb-3">
                            <div class="col mb-0">
                                <label class="form-label">이름 <span class="text-danger">*</span></label>
                                <input type="text" name="memName" class="form-control" placeholder="홍길동" required />
                            </div>
                            <div class="col mb-0">
                                <label class="form-label">이메일 <span class="text-danger">*</span></label>
                                <input type="email" name="memEmail" class="form-control" placeholder="user@company.com" required />
                            </div>
                        </div>
                        
                        <div class="row g-2 mb-3">
	                        <div class="col mb-0">
                                <label class="form-label">전화번호 <span class="text-danger">*</span></label>
								<input type="text" name="memPhone" class="form-control" 
								       placeholder="010-1234-5678" 
								       maxlength="13" 
								       oninput="autoHyphen(this)" />
							</div>
	                    </div>
                        <div class="row g-2 mb-3">
                            <div class="col mb-0">
                                <label class="form-label">부서 <span class="text-danger">*</span></label>
                                <select name="deptCode" id="deptCode" class="form-select" onchange="previewEmpId()" required>
                                    <option value="" selected disabled>선택하세요</option>
                                    <optgroup label="본사 (Prefix: 1)">
                                        <option value="10" data-prefix="1">인사팀</option>
                                        <option value="11" data-prefix="1">회계팀</option>
                                        <option value="12" data-prefix="1">재무팀</option>
                                        <option value="13" data-prefix="1">영업팀</option>
                                        <option value="14" data-prefix="1">CS팀</option>
                                        <option value="15" data-prefix="1">마케팅팀</option>
                                        <option value="16" data-prefix="1">식품개발팀</option>
                                        <option value="20" data-prefix="1">임원</option>
                                    </optgroup>
                                    <optgroup label="가맹점 (Prefix: 2)">
                                        <option value="10" data-prefix="2">서울</option>
                                        <option value="11" data-prefix="2">경기도</option>
                                        <option value="12" data-prefix="2">충청도</option>
                                        <option value="13" data-prefix="2">강원도</option>
                                        <option value="14" data-prefix="2">전라도</option>
                                        <option value="15" data-prefix="2">경상도</option>
                                    </optgroup>
                                </select>
                            </div>
                            <div class="col mb-0">
                                <label class="form-label">직급 <span class="text-danger">*</span></label>
                                <select name="positionCode" class="form-select" required>
                                    <optgroup label="---------------- 임원 -----------------"></optgroup>
                                    <option value="12">전무</option>
                                    <option value="11">상무</option>
                                    <option value="10">이사</option>
                                    <optgroup label="---------------- 사원 -----------------"></optgroup>
                                    <option value="1">팀장</option>
                                    <option value="2">차장</option>
                                    <option value="3">과장</option>
                                    <option value="4">대리</option>
                                    <option value="5">주임</option>
                                    <option value="6" selected>사원</option>
                                    <optgroup label="---------------- 가맹 -----------------"></optgroup>
                                    <option value="17">가맹점주</option>
                                </select>
                            </div>
                            
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col mb-0">
                                <label class="form-label">예상 사번 (자동 생성)</label>
                                <input type="text" id="previewIdInput" class="form-control bg-light" placeholder="부서를 선택하세요" readonly />
                                <div class="form-text" style="font-size: 11px;">* 규칙: 구분(1자리)+연도(2자리)+일련번호</div>
                            </div>
                            <div class="col mb-0">
                                <label class="form-label">입사일</label>
                                <input type="date" name="memHireDate" class="form-control" value="<%= java.time.LocalDate.now() %>" />
                            </div>
                        </div>
                        
                        
                        
                        
                       <!-- 우편번호 -->
                       
                       
                       <div class="row g-2 mb-3">
						    <div class="col mb-0">
						        <label class="form-label">주소 <span class="text-danger">*</span></label>
						        
						        <div class="input-group mb-2">
						            <input type="text" id="memZipCode" name="memZipCode" class="form-control" placeholder="우편번호" aria-label="우편번호" readonly required />
						            <button class="btn btn-outline-primary" type="button" onclick="DaumPostcode()">우편번호 찾기</button>
						        </div>
						        
						        <input type="text" id="memAddress" name="memAddress" class="form-control mb-2" placeholder="기본 주소" readonly required />
						        
						        <input type="text" id="memAddressDetail" name="memAddressDetail" class="form-control" placeholder="상세 주소를 입력하세요" required />
						    </div>
						</div>
						   
					 <!-- 우편번호 끝 -->   
						                    
                    <div class="alert alert-secondary mb-0 p-2 d-flex align-items-center" role="alert">
                        <i class='bx bx-info-circle me-2 fs-4'></i>
                        <div style="font-size: 13px;">
                            등록 즉시 임시 비밀번호가 이메일로 전송됩니다.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="reset" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                        <button type="submit" class="btn btn-primary">등록하기</button>
                    </div>
                   </div>
                </form>
            </div>
        </div>
    </div>

    <script src="/vendor/libs/jquery/jquery.js"></script>
    <script src="/vendor/libs/popper/popper.js"></script>
    <script src="/vendor/js/bootstrap.js"></script>
    <script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="/vendor/js/menu.js"></script>
    <script src="/vendor/libs/apex-charts/apexcharts.js"></script>
    <script src="/js/main.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <script>
        function previewEmpId() {
            const deptSelect = document.getElementById("memDeptCode");
            const previewInput = document.getElementById("previewIdInput");
            const hiddenPrefix = document.getElementById("idPrefix");
            
            // 1. 선택된 옵션 가져오기
            const selectedOption = deptSelect.options[deptSelect.selectedIndex];
            
            // 2. data-prefix 값 확인 (1 또는 2)
            const prefix = selectedOption.getAttribute("data-prefix");
            
            if (prefix) {
            	hiddenPrefix.value = prefix;
                // 3. 현재 연도 2자리 구하기 (2025 -> 25)
                const year = new Date().getFullYear().toString().substr(-2);
                
                // 4. 프리뷰 문자열 생성 (예: 125xxx)
                previewInput.value = prefix + year + "xxx (생성 예정)";
            } else {
                previewInput.value = "";
            }
        }
        
        function DaumPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById("memZipCode").value = data.zonecode;
                    document.getElementById("memAddress").value = data.address;
                    document.getElementById("memAddressDetail").focus(); 
                }
            }).open();
        }
        
        $('#addMemberModal').on('hidden.bs.modal', function () {
			$(this).find('form')[0].reset();
		})
		
		const autoHyphen = (target) => {
		    target.value = target.value
		        .replace(/[^0-9]/g, '')
		        .replace(/^(\d{0,3})(\d{0,4})(\d{0,4})$/g, "$1-$2-$3")
		        .replace(/(\-{1,2})$/g, "");
		}
    </script>
  </body>
</html>
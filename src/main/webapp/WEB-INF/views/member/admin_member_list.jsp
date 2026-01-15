<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="java.time.LocalDate" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
				        <form id="searchForm" action="./admin_member_list" method="get" class="row gx-3 gy-2 align-items-center">
				            <input type="hidden" name="page" id="pageInput" value="${pager.page}">
				            
				            <div class="col-md-3">
							    <label class="form-label" for="selectTypeOpt">부서 선택</label>
							    <select id="selectTypeOpt" name="deptCode" class="form-select color-dropdown">
							        <option value="" ${empty param.deptCode ? 'selected' : ''}>전체 부서</option>
								       <c:forEach var="dept" items="${deptList}">
										    <option value="${dept.deptCode}" ${param.deptCode == dept.deptCode ? 'selected' : ''}>
										        ${dept.memDeptName}
										    </option>
										</c:forEach>
							    </select>
							</div>
				            <div class="col-md-3">
				                <label class="form-label" for="selectStatusOpt">재직 상태</label>
				                <select id="selectStatusOpt" name="memIsActive" class="form-select color-dropdown">
				                    <option value="" ${empty param.memIsActive ? 'selected' : ''}>전체</option>
				                    <option value="true" ${param.memIsActive == 'true' ? 'selected' : ''}>재직</option>
				                    <option value="false" ${param.memIsActive == 'false' ? 'selected' : ''}>퇴사</option>
				                </select>
				            </div>
				            <div class="col-md-4">
				                <label class="form-label" for="searchName">이름/사번 검색</label>
				                <input type="text" name="searchKeyword" class="form-control" id="searchName" 
				                       placeholder="홍길동 or 124001" value="${param.searchKeyword}" />
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
                    <div class="mb-3">
                    	<h5>재직원: ${activeCount}명</h5>
                    	<div>
						    <span>(총 사원: ${totalCount}명 | </span>
						    <span>퇴사자: ${totalCount - activeCount}명)</span>
                    	</div>
					</div>
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
        	                	<td><i class="fab fa-angular fa-lg text-danger me-3"></i>${member.memberId}</td>
            	            	<td><a href="./AM_member_detail?memberId=${member.memberId}"><span class="fw-bold text-primary"> ${member.memName}</span> </a></td>
            	            	<td>${member.memDeptName}</td>
								<td>
								    <span class="badge ${member.positionCode == 99 ? 'bg-label-info' : 'bg-label-primary'}">
								        ${member.memPositionName}
								    </span>
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
								                퇴직
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
					                <li class="page-item ${pager.begin == 1 ? 'disabled' : ''}"><a class="page-link" href="javascript:movePage(${pager.begin - 1})"><i class="bx bx-chevron-left"></i></a></li>
					                <c:forEach begin="${pager.begin}" end="${pager.end}" var="i">
									    <li class="page-item ${pager.page == i ? 'active' : ''}"><a class="page-link" href="javascript:movePage(${i})">${i}</a></li>
							  		</c:forEach>
					                <li class="page-item next"><a class="page-link" href="javascript:movePage(${pager.end + 1})"><i class="bx bx-chevron-right"></i></a></li>
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
						                <c:forEach var="dept" items="${deptList}">
						                    <%-- 본사 부서 코드 범위 (10 ~ 20) --%>
						                    <c:if test="${dept.deptCode ne 17}">
						                        <option value="${dept.deptCode}" data-prefix="1">${dept.memDeptName}</option>
						                    </c:if>
						                </c:forEach>
						            </optgroup>
						
						            <optgroup label="가맹점 (Prefix: 2)">
						                <c:forEach var="dept" items="${deptList}">
						                    <%-- 가맹점 부서 코드 범위 (그 외 또는 특정 코드) --%>
						                    <c:if test="${dept.deptCode == 17}">
						                        <option value="${dept.deptCode}" data-prefix="2">${dept.memDeptName}</option>
						                    </c:if>
						                </c:forEach>
						            </optgroup>
						        </select>
						    </div>
                            <div class="col mb-0">
						        <label class="form-label">직급 <span class="text-danger">*</span></label>
						        <select name="positionCode" class="form-select" required>
						            <option value="" disabled>선택하세요</option>
						            
						            <optgroup label="임원 및 관리자">
						                <c:forEach var="pos" items="${positionList}">
						                    <c:if test="${pos.positionCode >= 10 && pos.positionCode <= 99 && pos.positionCode != 17}">
						                        <option value="${pos.positionCode}">${pos.memPositionName}</option>
						                    </c:if>
						                </c:forEach>
						            </optgroup>
						            
						            <optgroup label="일반 사원">
						                <c:forEach var="pos" items="${positionList}">
						                    <c:if test="${pos.positionCode >= 1 && pos.positionCode <= 9}">
						                        <option value="${pos.positionCode}" ${pos.positionCode == 6 ? 'selected' : ''}>${pos.memPositionName}</option>
						                    </c:if>
						                </c:forEach>
						            </optgroup>
						            
						            <optgroup label="가맹 사업부">
						                <c:forEach var="pos" items="${positionList}">
						                    <c:if test="${pos.positionCode == 17}">
						                        <option value="${pos.positionCode}">${pos.memPositionName}</option>
						                    </c:if>
						                </c:forEach>
						            </optgroup>
						        </select>
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
    <script src="/js/member/admin_member_list.js"></script>
   
  </body>
</html>
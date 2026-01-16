<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>사원 상세 정보 - 인사관리</title>
    <link rel="icon" type="image/x-icon" href="/assets/img/favicon/favicon.ico" />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>
    <link rel="stylesheet" href="/css/member/AM_member_detail.css" />
    
    
</head>

<body>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>

        <div class="layout-page">
        
        <c:import url="/WEB-INF/views/template/header.jsp"></c:import>
        
            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">
                    
                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">사원 관리 /</span> 사원 상세 정보
                    </h4>	

                    <div class="row">
                        <div class="col-md-12">
                            
                            <div class="card mb-4">
                                <div class="card-body">
                                    <div class="d-flex align-items-start align-items-sm-center gap-4">
                                        <div class="position-relative profile-image-container rounded overflow-hidden" style="width: 100px; height: 100px; cursor: pointer;">
										    <div class="position-absolute top-0 start-0 w-100 h-100 bg-dark bg-opacity-50 d-flex align-items-center justify-content-center text-white opacity-0 transition-opacity image-overlay" style="pointer-events: none;">
										        <i class='bx bx-camera fs-3'></i>
										    </div>
									    	<c:choose>
									    		<c:when test="${dto.memProfileSavedName == null}">
												    <img src="/fileDownload/profile?fileSavedName=default_img.jpg"
												        alt="user-avatar" 
												        class="d-block w-100 h-100 object-fit-cover" 
												        id="detailProfileImage" 
												        style="width: 120px; height: 120px; object-fit: cover;"
												    >
									    		</c:when>
									    		<c:otherwise>
												    <img src="/fileDownload/profile?fileSavedName=${dto.memProfileSavedName}"
												        alt="user-avatar" 
												        class="d-block w-100 h-100 object-fit-cover" 
												        id="detailProfileImage" 
												        style="width: 120px; height: 120px; object-fit: cover;"
												    >
									    		</c:otherwise>
									    	</c:choose>
										
										</div>
										
										<input type="file" id="profileFileUpload" name="profileImage" accept="image/*" style="display: none;">
                                        <div class="button-wrapper">
                                            <h3 class="mb-1 text-primary fw-bold">${dto.memName}</h3>
                                            <div class="d-flex align-items-center gap-2 mb-3">
                                            	<c:choose>
                                            		<c:when test="${dto.memIsActive}">
		                                                <span class="badge bg-label-success"><i class='bx bxs-circle me-1' style="font-size: 8px;"></i> 정상 근무</span>
		                                                <span class="badge bg-label-primary">재직 (Active)</span>                                            		
                                            		</c:when>
		                                                <c:otherwise>
													        <span class="badge bg-label-secondary">
													            <i class='bx bxs-circle me-1' style="font-size: 8px;"></i> 퇴직
													        </span>
													        <span class="badge bg-label-danger">퇴직 (Inactive)</span> 
													    </c:otherwise>                                       		
                                            	</c:choose>
                                            </div>

											
											<div class="d-inline-block">
											    <a href="javascript:void(0);" class="btn btn-outline-secondary btn-sm" onclick="resetPassword(${dto.memberId})">
											        <i class="bx bx-reset me-1"></i> 비밀번호 초기화
											    </a>
											    <a href="javascript:void(0);" class="btn btn-outline-secondary btn-sm" onclick="changePassword(${dto.memberId})">
											        <i class="bx bx-edit me-1"></i> 비밀번호 변경
											    </a>
											
											    <button type="button" class="btn btn-icon  btn-sm hide-arrow" data-bs-toggle="dropdown" aria-expanded="false">
											        <i class="bx bx-dots-vertical-rounded"></i>
											    </button>
											    
											    <ul class="dropdown-menu dropdown-menu-end">
											        <li>
											            <a class="dropdown-item text-danger" href="javascript:void(0);" onclick="InActive(${dto.memberId})">
											                <i class="bx bx-trash me-1"></i> 퇴직 처리
											            </a>
											        </li>
											    </ul>
											</div>
									
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="nav-align-top mb-4">
                                <ul class="nav nav-pills mb-3" role="tablist">
                                    <li class="nav-item">
                                        <button type="button" class="nav-link active" role="tab" data-bs-toggle="tab" data-bs-target="#navs-basic-info" aria-controls="navs-basic-info" aria-selected="true">
                                            <i class="bx bx-user me-1"></i> 기본 정보
                                        </button>
                                    </li>
                                    <li class="nav-item">
                                        <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-attendance" aria-controls="navs-attendance" aria-selected="false">
                                            <i class="bx bx-time-five me-1"></i> 근태 기록
                                        </button>
                                    </li>
                                    <li class="nav-item">
                                        <button type="button" class="nav-link" role="tab" data-bs-toggle="tab" data-bs-target="#navs-vacation" aria-controls="navs-vacation" aria-selected="false">
                                            <i class="bx bx-sun me-1"></i> 휴가 현황
                                        </button>
                                    </li>
                                </ul>
                            
                                <div class="tab-content shadow-sm p-4 bg-white rounded">
                                    
                                    <div class="tab-pane fade show active" id="navs-basic-info" role="tabpanel">
									    <div class="p-3">
									
									        <div id="view-area-info">
									            <div class="row g-3 mb-4">
									                <div class="col-sm-4">
									                    <div class="d-flex align-items-center p-3 border rounded h-100 bg-white shadow-sm">
									                        <div class="avatar me-3">
									                            <span class="avatar-initial rounded-circle bg-label-primary"><i class='bx bx-buildings fs-4'></i></span>
									                        </div>
									                        <div>
													            <small class="text-muted d-block mb-1">소속 부서</small>
													            <h6 class="mb-0 fw-bold text-dark" id="txt-dept-name">
													                ${dto.memDeptName} 
													            </h6>
													        </div>
									                    </div>
									                </div>
									                <div class="col-sm-4">
									                    <div class="d-flex align-items-center p-3 border rounded h-100 bg-white shadow-sm">
									                        <div class="avatar me-3">
									                            <span class="avatar-initial rounded-circle bg-label-info"><i class='bx bx-briefcase fs-4'></i></span>
									                        </div>
									                        <div>
													            <small class="text-muted d-block mb-1">직급</small>
													            <h6 class="mb-0 fw-bold text-dark" id="txt-position-name">
													                ${dto.memPositionName}
													            </h6>
													        </div>
									                    </div>
									                </div>
									                <div class="col-sm-4">
									                    <div class="d-flex align-items-center p-3 border rounded h-100 bg-light shadow-sm">
									                        <div class="avatar me-3">
									                            <span class="avatar-initial rounded-circle bg-label-warning"><i class='bx bx-calendar fs-4'></i></span>
									                        </div>
									                        <div>
									                            <small class="text-muted d-block mb-1">입사일</small>
									                            <h6 class="mb-0 fw-bold text-dark">${dto.memHireDate}</h6>
									                        </div>
									                    </div>
									                </div>
									            </div>
									
									            <h6 class="text-muted text-uppercase font-size-sm fw-bold border-bottom pb-2 mb-4">상세 정보</h6>
									            <div class="row g-4">
									                <div class="col-md-6">
									                    <ul class="list-group list-group-flush">
									                        <li class="list-group-item d-flex justify-content-between px-0 pb-3 border-0">
									                            <div class="d-flex align-items-center">
									                                <div class="badge rounded-pill bg-label-secondary me-3 p-2"><i class='bx bx-hash'></i></div>
									                                <div>
									                                    <small class="text-muted d-block">사원 번호</small>
									                                    <span class="fw-semibold text-heading">${dto.memberId}</span>
									                                </div>
									                            </div>
									                        </li>
									                        <li class="list-group-item d-flex px-0 py-3 border-0 align-items-center">
													            <div class="badge rounded-pill bg-label-secondary me-3 p-2"><i class='bx bx-user'></i></div>
													            <div>
													                <small class="text-muted d-block">이름</small>
													                <span class="fw-semibold text-heading" id="txt-name">${dto.memName}</span>
													            </div>
													        </li>
									                    </ul>
									                </div>
									                <div class="col-md-6">
									                    <ul class="list-group list-group-flush">
									                        <li class="list-group-item d-flex px-0 pb-3 border-0 align-items-center">
									                            <div class="badge rounded-pill bg-label-secondary me-3 p-2"><i class='bx bx-envelope'></i></div>
									                            <div>
									                                <small class="text-muted d-block">이메일</small>
									                                <span class="fw-semibold text-heading" id="txt-email">${dto.memEmail}</span>
									                            </div>
									                        </li>
									                        <li class="list-group-item d-flex px-0 py-3 border-0 align-items-center">
									                            <div class="badge rounded-pill bg-label-secondary me-3 p-2"><i class='bx bx-phone'></i></div>
									                            <div>
									                                <small class="text-muted d-block">휴대전화</small>
									                                <span class="fw-semibold text-heading" id="txt-phone">${dto.memPhone}</span>
									                            </div>
									                        </li>
									                        <li class="list-group-item d-flex px-0 py-3 border-0 align-items-center">
									                            <div class="badge rounded-pill bg-label-secondary me-3 p-2"><i class='bx bx-map'></i></div>
									                            <div>
									                                <small class="text-muted d-block">주소</small>
									                                <span class="fw-semibold text-heading">
									                                    (<span id="txt-zip">${dto.memZipCode}</span>) 
									                                    <span id="txt-addr">${dto.memAddress}</span> 
									                                    <span id="txt-addr-detail">${dto.memAddressDetail}</span>
									                                </span>
									                            </div>
									                        </li>
									                    </ul>
									                </div>
									            </div>
									
									            <div class="mt-5 text-end border-top pt-3">
									                <button type="button" class="btn btn-primary me-2" onclick="toggleEditMode(true, 'info')">
									                    <i class='bx bx-edit-alt me-1'></i> 정보 수정
									                </button>
									            </div>
									        </div>
									                
									        <div id="edit-area-info" style="display: none;">
									            <form id="updateForm" action="member_info_update" method="post" enctype="multipart/form-data">
									                
									                <div class="row g-3 mb-4">
									                    <div class="col-sm-4">
														    <label class="form-label text-muted">소속 부서 (관리자 전용)</label>
														    <select class="form-select form-select-lg" id="edit-dept" name="deptCode">
														        <c:forEach var="dept" items="${deptList}"> <option value="${dept.deptCode}" ${dto.deptCode == dept.deptCode ? 'selected' : ''}>
														                ${dept.memDeptName}
														            </option>
														        </c:forEach>
														    </select>
														</div>
														
														<div class="col-sm-4">
														    <label class="form-label text-muted">직급 (관리자 전용)</label>
														    <select class="form-select form-select-lg" id="edit-position" name="positionCode">
														        <c:forEach var="pos" items="${positionList}"> <option value="${pos.positionCode}" ${dto.positionCode == pos.positionCode ? 'selected' : ''}>
														                ${pos.memPositionName}
														            </option>
														        </c:forEach>
														    </select>
														</div>
									                    <div class="col-sm-4">
									                        <label class="form-label text-muted">입사일</label>
									                        <input type="text" class="form-control form-control-lg bg-light" value="${dto.memHireDate}" readonly>
									                    </div>
									                </div>
									
									                <h6 class="text-muted text-uppercase font-size-sm fw-bold border-bottom pb-2 mb-4">정보 수정</h6>
									
									                <div class="row g-4">
									                    <div class="col-md-6">
									                        <div class="mb-3">
									                            <label class="form-label">사원 번호</label>
									                            <input type="text" class="form-control bg-light" id="memberId" name="memberId" value="${dto.memberId}" readonly>
									                        </div>
									                        <div class="mb-3">
													            <label class="form-label">이름</label>
													            <div class="input-group input-group-merge">
													                <span class="input-group-text"><i class='bx bx-user'></i></span>
													                <input type="text" class="form-control" id="memName" name="memName" value="${dto.memName}" placeholder="이름을 입력하세요">
													            </div>
													        </div>
									                    </div>
									
									                    <div class="col-md-6">
									                        <div class="mb-3">
									                            <label class="form-label">이메일</label>
									                            <div class="input-group input-group-merge">
									                                <span class="input-group-text"><i class='bx bx-envelope'></i></span>
									                                <input type="email" class="form-control" id="memEmail" name="memEmail" value="${dto.memEmail}">
									                            </div>
									                        </div>
									                        <div class="mb-3">
									                            <label class="form-label">휴대전화</label>
									                            <div class="input-group input-group-merge">
									                                <span class="input-group-text"><i class='bx bx-phone'></i></span>
									                                <input type="text" name="memPhone" id="memPhone" class="form-control" maxlength="13" oninput="autoHyphen(this)" value="${dto.memPhone}">
									                            </div>
									                        </div>
									                        <div class="mb-3">
									                            <label class="form-label">주소</label>
									                            <div class="input-group mb-2">
														            <input type="text" id="memZipCode" name="memZipCode" class="form-control" value="${dto.memZipCode}" aria-label="우편번호" readonly required />
														            <button class="btn btn-outline-primary" type="button" onclick="DaumPostcode()">우편번호 찾기</button>
														        </div>
														        
														        <input type="text" id="memAddress" name="memAddress" class="form-control mb-2" value="${dto.memAddress}" readonly required />
														        
														        <input type="text" id="memAddressDetail" name="memAddressDetail" class="form-control" value="${dto.memAddressDetail}" required />
									                        </div>
									                    </div>
									                </div>
									
									                <div class="mt-5 text-end border-top pt-3 bg-light p-3 rounded">
									                    <span class="text-danger small me-3">* 부서/직급은 관리자만 수정 가능합니다.</span>
									                    <button type="button" class="btn btn-primary me-2" onclick="saveData('info')" >
									                        <i class='bx bx-save me-1'></i> 저장하기
									                    </button>
									                    <button type="button" class="btn btn-secondary" onclick="toggleEditMode(false, 'info')">
									                        취소
									                    </button>
									                </div>
									            </form>
									        </div>
									    </div>
									</div> 
									
			<!-- 근태 기록 -->
									<div class="tab-pane fade" id="navs-attendance" role="tabpanel">
									    <form action="./AM_member_detail" method="get" id="attForm">
									        <input type="hidden" name="page" id="attPage" value="${empty pager.page ? 1 : pager.page}">
									        <input type="hidden" name="memberId" value="${dto.memberId}">
									        <input type="hidden" name="tab" value="attendance">
									        
									        <div class="card mb-4 border">
									            <div class="card-body">
									                <div class="row gx-3 gy-2 align-items-center ">
									                    <div class="col-md-2">
									                        <label class="form-label">조회 기준</label>
									                        <select id="dateType" name="dateType" class="form-select" onchange="toggleDateInputs()">
									                            <option value="month" ${pager.dateType == 'month' || empty pager.dateType ? 'selected' : ''}>월별 조회</option>
									                            <option value="year" ${pager.dateType == 'year' ? 'selected' : ''}>연도별 조회</option>
									                            <option value="custom" ${pager.dateType == 'custom' ? 'selected' : ''}>기간 지정</option>
									                            <option value="all" ${pager.dateType == 'all' ? 'selected' : ''}>전체</option>
									                        </select>
									                    </div>
									                    
									                    <div class="col-md-4" id="dateInputArea">
									                        
									                        <c:set var="now" value="<%=new java.util.Date()%>" />
									                        <fmt:formatDate value="${now}" pattern="yyyy" var="curYear" />
									
									                        <div id="input-month" class="date-input">
									                            <label class="form-label">대상 월</label>
									                            <input type="month" 
									                                   name="monthDate" 
									                                   class="form-control" 
									                                   value="${pager.monthDate}"
									                                   onclick="this.showPicker()">
									                        </div>
									                    
									                        <div id="input-year" class="date-input d-none">
									                            <label class="form-label">대상 연도</label>
									                            <select id="yearPicker" name="yearDate" class="form-select text-center">
									                                <c:set var="selectedYearOnly" value="${not empty pager.yearDate ? pager.yearDate : curYear}" />
									                                <c:forEach begin="${curYear - 10}" end="${curYear}" var="y">
									                                    <option value="${y}" ${y == selectedYearOnly ? 'selected' : ''}>${y}년</option>
									                                </c:forEach>
									                            </select>
									                        </div>
									                    
									                        <div id="input-custom" class="date-input d-none">
									                            <label class="form-label">기간 설정</label>
									                            <div class="input-group">
									                                <input type="date" name="startDate" class="form-control" value="${pager.startDate}">
									                                <span class="input-group-text">~</span>
									                                <input type="date" name="endDate" class="form-control" value="${pager.endDate}">
									                            </div>
									                        </div>
									                    
									                    </div>
									
									                    <div class="col-md-3">
									                        <label class="form-label">근태 상태</label>
									                        <select name="statusFilter" class="form-select">
									                            <option value="">전체 상태</option>
									                            <option value="normal" ${pager.statusFilter == 'normal' ? 'selected' : ''}>정상</option>
									                            <option value="late" ${pager.statusFilter == 'late' ? 'selected' : ''}>지각/조퇴</option>
									                            <option value="vacation" ${pager.statusFilter == 'vacation' ? 'selected' : ''}>연차/휴가</option>
									                            <option value="half" ${pager.statusFilter == 'half' ? 'selected' : ''}>반차</option>
									                        </select>
									                    </div>
									                    <div class="col-md-3 ms-auto">
														    <label class="form-label d-block">&nbsp;</label>
														    <div class="d-flex gap-2">
														        <button type="button" class="btn btn-primary" onclick="movePage(1)">
														            <i class='bx bx-search me-1'></i> 조회
														        </button>
														        <button type="button" class="btn btn-outline-success flex-grow-1">
														            <i class='bx bx-download me-1'></i> Excel
														        </button>
														    </div>
														</div>
									                </div>
									            </div>
									        </div>
									    </form> 
									
									    <div class="table-responsive text-nowrap bg-white border rounded">
									        <table class="table table-striped table-hover mb-0" id="attendanceTable">
									            <thead class="table-light">
									                <tr>
									                    <th>날짜</th>
									                    <th>출근 시간</th>
									                    <th>퇴근 시간</th>
									                    <th>상태</th>
									                    <th>비고</th>
									                    <th class="text-center">관리</th>
									                </tr>
									            </thead>
									            <tbody>
									                <c:forEach items="${attendanceList}" var="attendance">
									                    <tr>
									                        <td>${attendance.memCommuteWorkDate}</td>
									                        <td class="in-time">
									                             ${not empty attendance.formattedInTime ? attendance.formattedInTime : fn:substring(attendance.memCommuteInTime, 11, 16)}
									                        </td>
									                        <td class="out-time">
									                             ${not empty attendance.formattedOutTime ? attendance.formattedOutTime : fn:substring(attendance.memCommuteOutTime, 11, 16)}
									                        </td>
									                        <td>
									                            <c:choose>
									                                <c:when test="${fn:contains(attendance.memCommuteState, '지각') or fn:contains(attendance.memCommuteState, '조퇴')}">
									                                    <span class="badge bg-label-warning status-badge">${attendance.memCommuteState}</span>
									                                </c:when>
									                                <c:when test="${fn:contains(attendance.memCommuteState, '결근') or fn:contains(attendance.memCommuteState, '무단')}">
									                                    <span class="badge bg-label-danger status-badge">${attendance.memCommuteState}</span>
									                                </c:when>
									                                <c:when test="${fn:contains(attendance.memCommuteState, '반차') or fn:contains(attendance.memCommuteState, '휴가') or fn:contains(attendance.memCommuteState, '연차')}">
									                                    <span class="badge bg-label-primary status-badge">${attendance.memCommuteState}</span>
									                                </c:when>
									                                <c:when test="${fn:contains(attendance.memCommuteState, '출근') or fn:contains(attendance.memCommuteState, '퇴근')}">
									                                    <span class="badge bg-label-secondary status-badge">${attendance.memCommuteState}</span>
									                                </c:when>
									                                <c:otherwise>
									                                    <span class="badge bg-label-success status-badge">${attendance.memCommuteState}</span>
									                                </c:otherwise>
									                            </c:choose>
									                        </td>
									                        <td>
									                            <span class="text-muted small">
									                                <c:out value="${attendance.memCommuteNote}" default="" />
									                            </span>
									                        </td> 
									                        <td class="text-center">
									                            <button type="button" class="btn btn-sm btn-icon btn-outline-primary" 
																    data-commute-id="${attendance.memberCommuteId}"
																    data-date="${attendance.memCommuteWorkDate}"
																    data-in-time="${fn:substring(attendance.memCommuteInTime, 11, 16)}"
																    data-out-time="${fn:substring(attendance.memCommuteOutTime, 11, 16)}"
																    data-state="${attendance.memCommuteState}"
																    data-note="${attendance.memCommuteNote}"
																    onclick="openEditModal(this)">
																    <i class="bx bx-edit-alt"></i>
																</button>
									                        </td>
									                    </tr>
									                </c:forEach>
									                
									                <c:if test="${empty attendanceList}">
									                    <tr>
									                        <td colspan="6" class="text-center py-4">
									                            <i class="bx bx-calendar-x fs-1 text-muted d-block mb-2"></i>
									                            기록이 없습니다.
									                        </td>
									                    </tr>
									                </c:if>
									            </tbody>
									        </table>
									        
									        <div class="card-footer d-flex justify-content-center">
									            <nav aria-label="Page navigation">
									                <ul class="pagination">
									                    <li class="page-item ${pager.begin == 1 ? 'disabled' : ''}">
									                        <a class="page-link" href="javascript:movePage(${pager.begin - 1})">
									                            <i class="bx bx-chevron-left"></i>
									                        </a>
									                    </li>
									        
									                    <c:forEach begin="${pager.begin}" end="${pager.end}" var="i">
									                        <li class="page-item ${pager.page == i ? 'active' : ''}">
									                            <a class="page-link" href="javascript:movePage(${i})">${i}</a>
									                        </li>
									                    </c:forEach>
									        
									                    <li class="page-item next">
									                        <a class="page-link" href="javascript:movePage(${pager.end + 1})">
									                            <i class="bx bx-chevron-right"></i>
									                        </a>
									                    </li>
									                </ul>
									            </nav>
									        </div>
									
									    </div>
									</div>
                    
                    <!-- 휴가 현황 -->
                                   <div class="tab-pane fade" id="navs-vacation" role="tabpanel">

									    <form action="./AM_member_detail" method="get" id="vacForm">
									        <input type="hidden" name="vPage" id="vacPage" value="${empty vacationSearch.page ? 1 : vacationSearch.page}">
									        <input type="hidden" name="memberId" value="${dto.memberId}">
									        <input type="hidden" name="tab" value="vacation">
									
									        <div class="card mb-4 border">
									            <div class="card-body">
									                <div class="row gx-3 gy-2 align-items-center">
    
													    <div class="col-md-3">
													        <label class="form-label">대상 연도</label>
													        <c:set var="nowYear" value="<%=java.time.Year.now().getValue()%>"/>
													        <select name="yearDate" class="form-select text-center">
													            <c:forEach begin="${nowYear - 5}" end="${nowYear + 1}" var="y">
													                <option value="${y}" ${y == vacationSearch.yearDate ? 'selected' : ''}>${y}년</option>
													            </c:forEach>
													        </select>
													    </div>
													
													    <div class="col-md-3">
													        <label class="form-label">결재 상태</label>
													        <select name="statusFilter" class="form-select">
													            <option value="">전체 상태</option>
													            <option value="승인" ${vacationSearch.statusFilter == '승인' ? 'selected' : ''}>승인</option>
													            <option value="반려" ${vacationSearch.statusFilter == '반려' ? 'selected' : ''}>반려</option>
													            <option value="대기" ${vacationSearch.statusFilter == '대기' ? 'selected' : ''}>대기</option>
													        </select>
													    </div>
													
													    <div class="col-md-3 ms-auto">
														    <label class="form-label d-block">&nbsp;</label>
														    <div class="d-flex gap-2">
														        <button type="button" class="btn btn-primary" onclick="movePage(1)">
														            <i class='bx bx-search me-1'></i> 조회
														        </button>
														        <button type="button" class="btn btn-outline-success flex-grow-1">
														            <i class='bx bx-download me-1'></i> Excel
														        </button>
														    </div>
														</div>
													</div>
									            </div>
									        </div>
									    </form>
									
									    <div class="row mb-4 g-3">
									        <div class="col-md-4">
									            <div class="card h-100 border-0 shadow-sm" style="border-top: 4px solid #8592a3 !important;">
									                <div class="card-body">
									                    <span class="d-block text-muted mb-1">총 부여 연차</span>
									                    <div class="d-flex align-items-center justify-content-between">
									                        <h2 class="mb-0 fw-bold text-dark">${stats.memLeaveTotalDays}</h2>
									                        <div class="p-2 rounded-circle bg-label-secondary">
									                            <i class='bx bx-calendar fs-4 text-secondary'></i>
									                        </div>
									                    </div>
									                </div>
									            </div>
									        </div>
									        
									        <div class="col-md-4">
									            <div class="card h-100 border-0 shadow-sm" style="border-top: 4px solid #ffab00 !important;">
									                <div class="card-body">
									                    <span class="d-block text-muted mb-1">사용 연차</span>
									                    <div class="d-flex align-items-center justify-content-between">
									                        <h2 class="mb-0 fw-bold text-warning">${stats.memLeaveUsedDays}</h2>
									                        <div class="p-2 rounded-circle bg-label-warning">
									                            <i class='bx bx-minus fs-4 text-warning'></i>
									                        </div>
									                    </div>
									                </div>
									            </div>
									        </div>
									        
									        <div class="col-md-4">
									            <div class="card h-100 border-0 shadow-sm" style="border-top: 4px solid #71dd37 !important;">
									                <div class="card-body">
									                    <span class="d-block text-muted mb-1">잔여 연차</span>
									                    <div class="d-flex align-items-center justify-content-between">
									                        <h2 class="mb-0 fw-bold text-success">${stats.remainingDays}</h2>
									                        <div class="p-2 rounded-circle bg-label-success">
									                            <i class='bx bx-check fs-4 text-success'></i>
									                        </div>
									                    </div>
									                </div>
									            </div>
									        </div>
									    </div>
									    
									    <div class="card mb-4 border-0 shadow-sm">
									        <div class="card-body py-3">
									            <div class="d-flex justify-content-between mb-1">
									                <small class="fw-semibold text-muted">연차 사용률</small>
									                <small class="fw-bold text-dark">${stats.usageRate}%</small>
									            </div>
									            <div class="progress" style="height: 6px;">
									                <div class="progress-bar bg-success" role="progressbar" 
									                     style="width: ${stats.usageRate}%;" 
									                     aria-valuenow="${stats.usageRate}" aria-valuemin="0" aria-valuemax="100">
									                </div>
									            </div>
									        </div>
									    </div>
									
									    <h6 class="fw-bold text-muted mb-3">사용 내역</h6>
									    
									    <div class="card border-0 shadow-sm">
									        <div class="table-responsive">
									            <table class="table align-middle table-hover">
									                <thead class="table-light">
									                    <tr>
									                        <th class="text-center text-secondary border-bottom-0" style="font-size: 0.85rem;">신청일/기간</th>
									                        <th class="text-center text-secondary border-bottom-0" style="font-size: 0.85rem;">종류</th>
									                        <th class="text-center text-secondary border-bottom-0" style="font-size: 0.85rem;">사용</th>
									                        <th class="text-secondary border-bottom-0 ps-4" style="font-size: 0.85rem;">사유</th>
									                        <th class="text-center text-secondary border-bottom-0" style="font-size: 0.85rem;">상태</th>
									                    </tr>
									                </thead>
									                <tbody class="border-top-0">
									                    <c:if test="${empty vacationList}">
									                        <tr><td colspan="5" class="text-center py-4 text-muted">내역이 없습니다.</td></tr>
									                    </c:if>
									
									                    <c:forEach var="dto" items="${vacationList}">
									                        <tr>
									                            <td class="text-center">
									                                <div class="d-flex flex-column">
									                                    <span class="fw-bold text-dark" style="font-size: 0.9rem;">
									                                        <fmt:formatDate value="${dto.memAttendanceStartDate}" pattern="yyyy-MM-dd"/> 
									                                        ~ 
									                                        <fmt:formatDate value="${dto.memAttendanceEndDate}" pattern="yyyy-MM-dd"/>
									                                    </span>
									                                </div>
									                            </td>
									                            
									                            <td class="text-center">
									                                <span class="text-dark">${dto.memAttendanceType}</span>
									                            </td>
									                            
									                            <td class="text-center">
									                                <c:choose>
									                                    <c:when test="${dto.appStatus eq '반려'}">
									                                        <span class="text-muted text-decoration-line-through">
									                                            -${dto.memAttendanceUsedDays}
									                                        </span>
									                                    </c:when>
									                                    <c:otherwise>
									                                        <span class="text-danger fw-bold">
									                                            -${dto.memAttendanceUsedDays}
									                                        </span>
									                                    </c:otherwise>
									                                </c:choose>
									                            </td>
									
									                            <td class="ps-4">
									                                <span class="text-muted text-truncate d-inline-block" style="max-width: 300px; vertical-align: middle;">
									                                    ${dto.memAttendanceReason}
									                                </span>
									                            </td>
									                            
									                            <td class="text-center">
									                                <c:choose>
									                                    <c:when test="${dto.appStatus eq '승인'}">
									                                        <span class="badge bg-label-success rounded-pill">승인</span>
									                                    </c:when>
									                                    <c:when test="${dto.appStatus eq '반려'}">
									                                        <span class="badge bg-label-danger rounded-pill">반려</span>
									                                    </c:when>
									                                    <c:otherwise>
									                                        <span class="badge bg-label-warning rounded-pill">대기</span>
									                                    </c:otherwise>
									                                </c:choose>
									                            </td>
									                        </tr>
									                    </c:forEach>
									                </tbody>
									            </table>
									        </div>
									        
									        <div class="card-footer d-flex justify-content-center border-top-0 bg-white">
											    <nav aria-label="Page navigation">
											        <ul class="pagination">
											            
											            <li class="page-item ${vacationSearch.begin == 1 ? 'disabled' : ''}">
											                <a class="page-link" href="javascript:moveVacationPage(${vacationSearch.begin - 1})">
											                    <i class="bx bx-chevron-left"></i>
											                </a>
											            </li>
											
											            <c:forEach begin="${vacationSearch.begin}" end="${vacationSearch.end}" var="i">
											                <li class="page-item ${vacationSearch.page == i ? 'active' : ''}">
											                    <a class="page-link" href="javascript:moveVacationPage(${i})">${i}</a>
											                </li>
											            </c:forEach>
											
											            <li class="page-item"> 
											                 <a class="page-link" href="javascript:moveVacationPage(${vacationSearch.end + 1})">
											                    <i class="bx bx-chevron-right"></i>
											                 </a>
											            </li>
											            
											        </ul>
											    </nav>
											</div>
									    </div>
									</div>
									
									
									
									
									
									
									</div>
                                </div>
                            </div>
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

<div class="modal fade" id="modalAttendanceEdit" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">근태 기록 수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="formAttendanceEdit">
                    <div class="row">
                        <div class="col mb-3">
                            <label for="editDate" class="form-label">날짜</label>
                            <input type="text" id="editDate" class="form-control" readonly style="background-color: #f5f5f9;" />
                        </div>
                    </div>
                    <div class="row g-2">
                        <div class="col mb-3">
                            <label for="editInTime" class="form-label">출근 시간</label>
                            <input type="time" id="editInTime" class="form-control" step="1" />
                        </div>
                        <div class="col mb-3">
                            <label for="editOutTime" class="form-label">퇴근 시간</label>
                            <input type="time" id="editOutTime" class="form-control" step="1" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col mb-3">
                            <label for="editStatus" class="form-label">상태 변경</label>
                            <select id="editStatus" class="form-select">
							    <option value="지각">지각</option>
							    <option value="조퇴">조퇴</option>
							    <option value="결근">결근</option>
							    <option value="연차">연차</option>
							    <option value="반차">반차</option>
							    
							    <option value="출근">출근</option>
							    <option value="퇴근">퇴근</option>
							</select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col mb-3">
                            <label for="editNote" class="form-label">수정 사유 / 비고</label>
                            <input type="text" id="editNote" class="form-control" placeholder="수정 사유를 입력하세요." />
                        </div>
                    </div>
                    
                    <input type="hidden" id="editCommuteId" name="memberCommuteId" />
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="saveAttendanceChanges()">수정 내용 저장</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="changePasswordModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered  modal-dialog-scrollable" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="modalCenterTitle">비밀번호 변경</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" id="modalMemberId">

                <div class="row">
                    <div class="col mb-3">
                        <label for="nowPassword" class="form-label">현재 비밀번호</label>
                        <input type="password" id="nowPassword" class="form-control" placeholder="현재 비밀번호를 입력하세요">
                    </div>
                </div>
                <div class="row">
                    <div class="col mb-3">
                        <label for="newPassword" class="form-label">새 비밀번호</label>
                        <input type="password" id="newPassword" class="form-control" placeholder="새로운 비밀번호">
                    </div>
                </div>
                <div class="row">
                    <div class="col mb-0">
                        <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
                        <input type="password" id="confirmPassword" class="form-control" placeholder="새로운 비밀번호 확인">
                        <div id="pwErrorMsg" class="form-text text-danger mt-1" style="display:none;"></div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="submitPasswordChange()">변경 저장</button>
            </div>
        </div>
    </div>
</div>

<script src="/vendor/libs/jquery/jquery.js"></script>
<script src="/vendor/libs/popper/popper.js"></script>
<script src="/vendor/js/bootstrap.js"></script>
<script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
<script src="/vendor/js/menu.js"></script>
<script src="/js/main.js"></script>
<script type="text/javascript" src="/js/member/AM_member_detail.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</body>
</html>
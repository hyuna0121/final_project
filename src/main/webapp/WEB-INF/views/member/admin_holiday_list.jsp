<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<%@ taglib prefix="fn" uri="jakarta.tags.functions"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<html 
	lang="ko" 
	class="light-style layout-menu-fixed" 
	dir="ltr"
	data-theme="theme-default" 
	data-assets-path="../assets/"
	data-template="vertical-menu-template-free">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>회사 휴무 관리</title>

<link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />

<link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
<link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
<link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
<link rel="stylesheet" href="/css/demo.css" />
<link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />

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

						<h4 class="fw-bold py-3 mb-4">
							<span class="text-muted fw-light">회사 관리 /</span> 회사 휴무일 관리
						</h4>

						<div class="card mb-4">
							<div class="card-body">
								<form id="searchForm" action="./admin_holiday_list" method="get" class="row gx-3 gy-2 align-items-end">
									<input type="hidden" name="page" id="pageInput" value="${pager.page}"> 
									<input type="hidden" name="perPage" id="perPageInput" value="${empty param.perPage ? 10 : param.perPage}">

									<div class="col-md-4">
										<label class="form-label">기간</label>
										<div class="input-group">
											<input type="date" name="startDate" class="form-control" value="${param.startDate}"> 
											<span class="input-group-text">~</span> 
											<input type="date" name="endDate" class="form-control" value="${param.endDate}">
										</div>
									</div>

									<div class="col-md-3">
										<label class="form-label">유형</label> <select name="type"
											class="form-select">
											<option value="" ${empty param.type ? 'selected' : ''}>전체</option>
											<option value="법정공휴일" ${param.type == '법정공휴일' ? 'selected' : ''}>법정공휴일</option>
											<option value="회사휴일" ${param.type == '회사휴일' ? 'selected' : ''}>회사휴일</option>
										</select>
									</div>

									<div class="col-md-3">
										<label class="form-label">검색어 (휴무명)</label> 
										<input type="text" name="keyword" class="form-control" value="${param.keyword}" placeholder="예: 창립기념일" />
									</div>

									<div class="col-md-2">
										<label class="form-label d-block">&nbsp;</label>
										<button type="submit" class="btn btn-primary w-100">
											<i class="bx bx-search"></i> 검색
										</button>
									</div>
								</form>
							</div>
						</div>


						<div class="card">
							<div class="card-header">
								<div class="d-flex justify-content-between align-items-start">
									<div>
										<h5 class="mb-1">휴무 목록</h5>
									</div>

									<div class="d-flex align-items-center gap-2">
										<button type="button" class="btn btn-outline-success" id="btnExcel">
											<i class="bx bx-download me-1"></i> 엑셀 다운
										</button>

										<sec:authorize access="hasAnyRole('MASTER','DEPT_HR')">
											<button type="button" class="btn btn-primary" onclick="openAddModal()">
												<i class="bx bx-plus"></i> 휴무 등록
											</button>
										</sec:authorize>
									</div>
								</div>
								<div class="mt-3 text-muted small">총 ${totalCount}건</div>

								<div class="mt-3">
									<select id="perPageSelect" class="form-select"
										style="width: 160px;">
										<option value="10" ${param.perPage == 10 ? 'selected' : ''}>10개씩 보기</option>
										<option value="20" ${param.perPage == 20 ? 'selected' : ''}>20개씩 보기</option>
										<option value="50" ${param.perPage == 50 ? 'selected' : ''}>50개씩 보기</option>
										<option value="100" ${param.perPage == 100 ? 'selected' : ''}>100개씩 보기</option>
									</select>
								</div>

							</div>

							<div class="table-responsive text-nowrap">
								<table class="table table-hover" id="holidayTable">
									<thead>
										<tr class="table-light">
											<th style="width: 160px;">날짜</th>
											<th style="width: 140px;">유형</th>
											<th>휴무명</th>
											<th style="width: 160px;">등록자</th>
											<th class="text-center" style="width: 120px;">관리</th>
										</tr>
									</thead>
									<tbody class="table-border-bottom-0" id="holidayTbody">

										<c:forEach items="${list}" var="h">
											<tr class="holiday-row" data-date="${h.comHolidayDate}"
												data-type="${h.comHolidayType}"
												data-name="${fn:escapeXml(h.comHolidayName)}">
												<td><fmt:formatDate value="${h.comHolidayDate}"
														pattern="yyyy-MM-dd" /></td>
												<td><c:choose>
														<c:when test="${h.comHolidayType eq '회사휴일'}">
															<span class="badge bg-label-primary">회사휴일</span>
														</c:when>
														<c:otherwise>
															<span class="badge bg-label-secondary">법정공휴일</span>
														</c:otherwise>
													</c:choose></td>
												<td class="fw-semibold text-dark">${h.comHolidayName}</td>
												<td class="text-muted">${h.memberId}</td>
												<td class="text-center"><sec:authorize
														access="hasAnyRole('MASTER','DEPT_HR')">
														<button type="button"
															class="btn btn-sm btn-icon btn-outline-secondary"
															title="${h.comHolidayIsActive ? '숨김' : '노출'}"
															onclick="toggleActive(${h.companyHolidayId}, ${h.comHolidayIsActive ? 'false' : 'true'})">
															<i
																class="bx ${h.comHolidayIsActive ? 'bx-show' : 'bx-hide'}"></i>
														</button>

														<button type="button"
															class="btn btn-sm btn-icon btn-outline-primary"
															title="수정"
															onclick="openEditModal(${h.companyHolidayId}, '${h.comHolidayDate}', '${fn:escapeXml(h.comHolidayName)}', '${h.comHolidayType}')">
															<i class="bx bx-pencil"></i>
														</button>
													</sec:authorize></td>


											</tr>
										</c:forEach>

										<c:if test="${empty list}">
											<tr>
												<td colspan="5" class="text-center py-4">등록된 휴무일이 없습니다.</td>
											</tr>
										</c:if>

									</tbody>
								</table>
								<div class="card-footer d-flex justify-content-center">
									<nav aria-label="Page navigation">
										<ul class="pagination">
											<li class="page-item ${pager.begin == 1 ? 'disabled' : ''}">
												<a class="page-link"
												href="javascript:movePage(${pager.begin - 1})"><i
													class="bx bx-chevron-left"></i></a>
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

					</div>

				</div>

				<c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
				<div class="content-backdrop fade"></div>
			</div>
		</div>
	</div>

	<div class="layout-overlay layout-menu-toggle"></div>
	</div>


	<sec:authorize access="hasAnyRole('MASTER','DEPT_HR')">
		<div class="modal fade" id="holidayAddModal" tabindex="-1"
			aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-sm">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title fw-bold">회사 휴무일 추가</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
					</div>

					<div class="modal-body">
						<div class="mb-3">
							<label class="form-label">날짜</label> 
							<input type="date" id="addDate" class="form-control" />
						</div>

						<div class="mb-2">
							<label class="form-label">휴무명</label> 
							<input type="text" id="addName" class="form-control" placeholder="예: 창립기념일" maxlength="50" />
							<div class="text-danger small mt-2" id="addError" style="display: none;"></div>
						</div>
					</div>

					<div class="modal-footer">
						<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary" onclick="submitAddHoliday()">저장</button>
					</div>
				</div>
			</div>
		</div>
	</sec:authorize>

	<div class="modal fade" id="holidayEditModal" tabindex="-1">
		<div class="modal-dialog modal-sm modal-dialog-scrollable">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">회사 휴무일 수정</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<div class="modal-body">
					<input type="hidden" id="editId">
					<div class="mb-3">
						<label class="form-label">날짜</label> <input type="date" id="editDate" class="form-control">
					</div>
					<div class="mb-2">
						<label class="form-label">휴무명</label> <input type="text" id="editName" class="form-control">
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
					<button class="btn btn-primary" onclick="submitEditHoliday()">저장</button>
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
	<script src="/js/member/admin_holiday_list.js"></script>


</body>
</html>

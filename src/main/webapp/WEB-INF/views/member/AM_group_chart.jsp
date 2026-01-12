<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>조직도 관리 - 인사관리</title>
    
    <link rel="icon" type="image/x-icon" href="/assets/img/favicon/favicon.ico" />
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
                        <span class="text-muted fw-light">부서 관리 /</span> 조직도 및 부서 관리
                    </h4>

                    <div class="row">
                        <div class="col-md-4 col-lg-3 mb-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header d-flex justify-content-between align-items-center border-bottom pb-3">
                                    <h5 class="mb-0 fw-bold text-dark"><i class='bx bx-buildings me-2 text-primary'></i>부서 목록</h5>
                                    <button type="button" class="btn btn-sm btn-icon btn-light text-primary" 
                                            data-bs-toggle="modal" data-bs-target="#modalDeptAdd" title="부서 추가">
                                        <i class='bx bx-plus'></i>
                                    </button>
                                </div>
                                
                                <div class="card-body pt-3 px-2">
                                    <div class="list-group list-group-flush" id="deptList">
                                        <a class="list-group-item list-group-item-action dept-item active mb-2" data-dept="0">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <span><i class='bx bx-globe me-2'></i>전체 부서</span>
                                                <span class="badge bg-white text-primary shadow-sm rounded-pill">${totalCount}</span>
                                            </div>
                                        </a>

                                        <c:set var="currentGroup" value=""/>
                                        <c:forEach var="dept" items="${deptCount}">
                                            <c:choose>
                                                <c:when test="${dept.deptCode == 99 || dept.deptCode == 20}">
                                                    <c:set var="groupName" value="임원 및 관리자"/>
                                                </c:when>
                                                <c:when test="${dept.deptCode >= 10 && dept.deptCode <= 12}">
                                                    <c:set var="groupName" value="경영지원본부"/>
                                                </c:when>
                                                <c:when test="${dept.deptCode >= 13 && dept.deptCode <= 15}">
                                                    <c:set var="groupName" value="영업 / 마케팅"/>
                                                </c:when>
                                                <c:when test="${dept.deptCode == 16}">
                                                    <c:set var="groupName" value="기술연구소"/>
                                                </c:when>
                                                <c:when test="${dept.deptCode == 17}">
                                                    <c:set var="groupName" value="가맹 사업부"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:set var="groupName" value="기타 부서"/>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:if test="${currentGroup != groupName}">
                                                <div class="list-group-header">${groupName}</div>
                                                <c:set var="currentGroup" value="${groupName}"/>
                                            </c:if>

                                            <a class="list-group-item list-group-item-action dept-item sub-dept" data-dept="${dept.deptCode}" data-name="${dept.memDeptName}">
                                                <div class="d-flex w-100 justify-content-between align-items-center">
                                                    <span>${dept.memDeptName}</span>
                                                    <span class="badge bg-label-secondary rounded-pill" style="font-size:0.75rem;">${dept.count}</span>
                                                </div>
                                            </a>
                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-8 col-lg-9 mb-4">
                            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                                
                                <div class="d-flex align-items-baseline">
                                    <h4 class="mb-0 fw-bold text-dark me-2" id="selectedDeptTitle">전체 사원</h4>
                                    <span class="text-muted fs-6" id="selectedDeptCount">(총 ${totalCount}명)</span>
                                </div>

                                <div class="top-controls">
                                    <div class="form-check form-switch m-0 d-flex align-items-center">
                                        <input class="form-check-input my-0 me-2" type="checkbox" id="checkRetired" style="cursor: pointer;">
                                        <label class="form-check-label text-nowrap text-muted fw-semibold" for="checkRetired" style="cursor: pointer;">퇴사자 포함</label>
                                    </div>

                                    <div class="input-group input-group-merge shadow-sm" style="width: 280px; border-radius: 10px; overflow: hidden; height: 45px;">
                                        <span class="input-group-text border-0 ps-3 bg-white"><i class="bx bx-search"></i></span>
                                        <input type="text" class="form-control border-0 bg-white" placeholder="이름, 부서, 사번 검색" id="searchMember">
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive text-nowrap" style="min-height: 500px;">
                                <table class="table table-borderless">
                                    <colgroup>
                                        <col style="width: 25%;">
                                        <col style="width: 15%;">
                                        <col style="width: 15%;">
                                        <col style="width: 15%;">
                                        <col style="width: 30%;">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>이름 / 사번</th>
                                            <th>부서</th>
                                            <th class="text-center">직급</th>
                                            <th class="text-center">상태</th>
                                            <th class="text-center">연락처 / 이메일</th>
                                        </tr>
                                    </thead>
                                    <tbody id="memberTableBody">
                                        </tbody>
                                </table>
                                
                                <div id="noDataMessage" class="text-center py-5" style="display: none;">
                                    <div class="py-5">
                                        <div class="mb-3">
                                            <span class="badge bg-label-secondary p-3 rounded-circle">
                                                <i class="bx bx-user-x fs-1"></i>
                                            </span>
                                        </div>
                                        <h5 class="text-muted mb-1">표시할 사원이 없습니다.</h5>
                                        <p class="text-muted small">검색 조건을 확인하거나 부서를 선택해주세요.</p>
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

<div class="modal fade" id="modalMemberDetail" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg">
	    <div class="modal-content">
            <div class="modal-header bg-light border-bottom py-3">
                <div class="d-flex align-items-center gap-3 w-100">
                    <ul class="nav nav-pills modal-header-tabs" role="tablist">
                        <li class="nav-item">
                            <button class="nav-link active btn-sm" data-bs-toggle="tab" data-bs-target="#tab-basic" type="button">
                                <i class="bx bx-user me-1"></i>기본 정보
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link btn-sm" data-bs-toggle="tab" data-bs-target="#tab-work" type="button">
                                <i class="bx bx-time me-1"></i>근태 기록
                            </button>
                        </li>
                        <li class="nav-item">
                            <button class="nav-link btn-sm" data-bs-toggle="tab" data-bs-target="#tab-vacation" type="button">
                                <i class="bx bx-sun me-1"></i>휴가 현황
                            </button>
                        </li>
                    </ul>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body p-4">
                <div class="tab-content p-0">
                    <div class="tab-pane fade show active" id="tab-basic" role="tabpanel">
                        <form id="memberDetailForm">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="form-label">사원 번호</label>
                                    <input type="text" class="form-control readonly-input" id="modalId" readonly>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">이름</label>
                                    <input type="text" class="form-control" id="modalName">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">소속 부서</label>
                                    <select class="form-select" id="modalDeptCode">
                                        <option value="D001">인사팀</option>
                                        <option value="D002">총무팀</option>
                                        <option value="D003">개발 1팀</option>
                                        <option value="D004">개발 2팀</option>
                                        <option value="D005">국내영업팀</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">직급</label>
                                    <select class="form-select" id="modalPosition">
                                        <option value="사원">사원</option>
                                        <option value="대리">대리</option>
                                        <option value="과장">과장</option>
                                        <option value="차장">차장</option>
                                        <option value="부장">부장</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">이메일</label>
                                    <input type="email" class="form-control" id="modalEmail">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">연락처</label>
                                    <input type="text" class="form-control" id="modalPhone">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">입사일</label>
                                    <div class="input-group">
                                        <input type="date" class="form-control" id="modalJoinDate">
                                        <span class="input-group-text cursor-pointer"><i class="bx bx-calendar"></i></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">상태</label>
                                    <select class="form-select" id="modalStatus">
                                        <option value="active">재직 중</option>
                                        <option value="vacation">휴가 중</option>
                                        <option value="out">외근 중</option>
                                        <option value="leave">퇴사</option>
                                    </select>
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="tab-pane fade" id="tab-work" role="tabpanel">
                        <div class="text-center py-5">
                            <i class="bx bx-time-five fs-1 text-muted mb-3"></i>
                            <p class="text-muted">이번 달 근태 기록이 표시됩니다.</p>
                        </div>
                    </div>
                    <div class="tab-pane fade" id="tab-vacation" role="tabpanel">
                        <div class="d-flex justify-content-between mb-3 bg-lighter p-3 rounded">
                            <div class="text-center">
                                <span class="d-block text-muted small">총 연차</span>
                                <span class="fs-4 fw-bold text-primary">15</span>
                            </div>
                            <div class="text-center border-start border-end px-4">
                                <span class="d-block text-muted small">사용 연차</span>
                                <span class="fs-4 fw-bold text-danger">3.5</span>
                            </div>
                            <div class="text-center">
                                <span class="d-block text-muted small">잔여 연차</span>
                                <span class="fs-4 fw-bold text-success">11.5</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer border-top">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="saveMemberDetails()">저장</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalDeptAdd" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">새 부서 추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">상위 본부</label>
                    <select class="form-select">
                        <option value="HEAD">본부 직속</option>
                        <option value="MGT">경영지원본부</option>
                        <option value="RND">기술연구소</option>
                    </select>
                </div>
                <div class="mb-0">
                    <label class="form-label">부서명</label>
                    <input type="text" class="form-control" placeholder="예: 전략기획팀" />
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary">추가</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalDeptEdit" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">부서명 수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-0">
                    <label class="form-label">부서명</label>
                    <input type="text" id="editDeptName" class="form-control" />
                    <input type="hidden" id="editDeptId" />
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="alert('수정되었습니다.')">저장</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalAuth" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">접근 권한 설정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="mb-3">대상 부서: <span id="authTargetDept" class="fw-bold text-primary">인사팀</span></p>
                <input type="hidden" id="authTargetDeptId" />
                
                <form id="authForm">
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="checkbox" name="menuId" value="M01" checked disabled>
                        <label class="form-check-label">마이페이지 (기본)</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="checkbox" name="menuId" value="M02">
                        <label class="form-check-label">인사/급여 관리</label>
                    </div>
                    <div class="form-check mb-2">
                        <input class="form-check-input" type="checkbox" name="menuId" value="M03">
                        <label class="form-check-label">매출/영업 관리</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" name="menuId" value="M04">
                        <label class="form-check-label">시스템 설정</label>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="saveAuth()">저장</button>
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
<script src="/js/member/AM_member_detail.js"></script>
<script src="/js/member/AM_group_chat.js"></script>
<link rel="stylesheet" href="/css/member/AM_group_chart.css" />
</body>
</html>
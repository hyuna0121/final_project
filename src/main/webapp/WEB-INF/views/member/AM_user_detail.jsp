<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

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
    
    <style>
        /* 탭 전환 시 부드러운 효과 */
        .tab-content { padding-top: 20px; }
    </style>
</head>

<body>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>

        <div class="layout-page">
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
                                        <img src="/assets/img/avatars/1.png" alt="user-avatar" class="d-block rounded" height="100" width="100" />
                                        <div class="button-wrapper">
                                            <h3 class="mb-1 text-primary fw-bold">김철수 (대리)</h3>
                                            <p class="text-muted mb-2">개발팀 / 백엔드 파트</p>
                                            
                                            <div class="d-flex align-items-center gap-2 mb-3">
                                                <span class="badge bg-label-success"><i class='bx bxs-circle me-1' style="font-size: 8px;"></i> 정상 근무</span>
                                                <span class="badge bg-label-primary">재직 (Active)</span>
                                            </div>

                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="alert('비밀번호 초기화 메일을 발송했습니다.')">
                                                <i class="bx bx-reset me-1"></i> 비밀번호 초기화
                                            </button>
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
                                        <form id="formAccountSettings" onsubmit="return false">
                                            <div class="row">
                                                <div class="mb-3 col-md-6">
                                                    <label for="empId" class="form-label">사번</label>
                                                    <input class="form-control" type="text" id="empId" value="124001" readonly />
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label for="email" class="form-label">이메일</label>
                                                    <input class="form-control" type="text" id="email" value="cs.kim@company.com" />
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label class="form-label">부서</label>
                                                    <select class="form-select">
                                                        <option value="D001" selected>개발팀</option>
                                                        <option value="D002">영업팀</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label class="form-label">직급</label>
                                                    <select class="form-select">
                                                        <option value="R002" selected>대리</option>
                                                        <option value="R003">과장</option>
                                                    </select>
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label class="form-label">입사일</label>
                                                    <input class="form-control" type="date" value="2024-01-02" />
                                                </div>
                                                <div class="mb-3 col-md-6">
                                                    <label class="form-label">연락처</label>
                                                    <input type="text" class="form-control" value="010-1234-5678" />
                                                </div>
                                            </div>
                                            <div class="mt-2">
                                                <button type="button" class="btn btn-primary me-2" onclick="alert('수정 내용이 저장되었습니다.')">저장</button>
                                                <button type="button" class="btn btn-outline-danger" onclick="confirm('정말 퇴사 처리 하시겠습니까?')">퇴사 처리</button>
                                            </div>
                                        </form>
                                    </div>
                            
                                    <div class="tab-pane fade" id="navs-attendance" role="tabpanel">
                                        
                                        <div class="card mb-4 border">
                                            <div class="card-body">
                                                <div class="row gx-3 gy-2 align-items-center">
                                                    <div class="col-md-2">
                                                        <label class="form-label">조회 기준</label>
                                                        <select id="dateType" class="form-select" onchange="toggleDateInputs()">
                                                            <option value="month" selected>월별 조회</option>
                                                            <option value="year">연도별 조회</option>
                                                            <option value="custom">기간 지정</option>
                                                            <option value="all">전체 (입사~현재)</option>
                                                        </select>
                                                    </div>

                                                    <div class="col-md-4" id="dateInputArea">
                                                        <div id="input-month">
                                                            <label class="form-label">대상 월</label>
                                                            <input type="month" id="filterMonth" class="form-control" value="2024-12">
                                                        </div>
                                                        <div id="input-year" style="display:none;">
                                                            <label class="form-label">대상 연도</label>
                                                            <select id="filterYear" class="form-select">
                                                                <option value="2025">2025년</option>
                                                                <option value="2024" selected>2024년</option>
                                                            </select>
                                                        </div>
                                                        <div id="input-custom" style="display:none;">
                                                            <label class="form-label">기간 설정</label>
                                                            <div class="input-group">
                                                                <input type="date" id="filterStartDate" class="form-control" value="2024-12-01">
                                                                <span class="input-group-text">~</span>
                                                                <input type="date" id="filterEndDate" class="form-control" value="2024-12-31">
                                                            </div>
                                                        </div>
                                                    </div>
                                                    
                                                    <div class="col-md-3">
                                                        <label class="form-label">근태 상태</label>
                                                        <select id="attendanceStatusFilter" class="form-select">
                                                            <option value="all">전체 상태</option>
                                                            <option value="normal">정상</option>
                                                            <option value="late">지각/조퇴</option>
                                                            <option value="vacation">연차/휴가</option>
                                                            <option value="half">반차</option>
                                                        </select>
                                                    </div>

                                                    <div class="col-md-3">
                                                        <label class="form-label d-block">&nbsp;</label>
                                                        <div class="d-flex gap-2">
                                                            <button type="button" class="btn btn-primary flex-grow-1" onclick="applyFilters()">
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
                                                    <tr data-date="2024-08-01" data-status="vacation" data-in="" data-out="" data-note="하계 휴가">
                                                        <td>2024-08-01 (목)</td><td class="in-time">-</td><td class="out-time">-</td>
                                                        <td><span class="badge bg-label-primary status-badge">여름 휴가</span></td><td class="note-text">하계 휴가</td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-sm btn-icon btn-outline-primary" onclick="openEditModal(this)">
                                                                <i class="bx bx-edit-alt"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <tr data-date="2024-12-16" data-status="vacation" data-in="" data-out="" data-note="개인 사유">
                                                        <td>2024-12-16 (월)</td><td class="in-time">-</td><td class="out-time">-</td>
                                                        <td><span class="badge bg-label-primary status-badge">연차</span></td><td class="note-text">개인 사유</td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-sm btn-icon btn-outline-primary" onclick="openEditModal(this)">
                                                                <i class="bx bx-edit-alt"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <tr data-date="2024-12-17" data-status="normal" data-in="08:55:12" data-out="18:05:00" data-note="">
                                                        <td>2024-12-17 (화)</td><td class="in-time">08:55:12</td><td class="out-time">18:05:00</td>
                                                        <td><span class="badge bg-label-success status-badge">정상</span></td><td class="note-text"></td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-sm btn-icon btn-outline-primary" onclick="openEditModal(this)">
                                                                <i class="bx bx-edit-alt"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <tr data-date="2024-12-18" data-status="half" data-in="08:55:00" data-out="14:00:00" data-note="병원 진료">
                                                        <td>2024-12-18 (수)</td><td class="in-time">08:55:00</td><td class="out-time">14:00:00</td>
                                                        <td><span class="badge bg-label-info status-badge">오후 반차</span></td><td class="note-text">병원 진료</td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-sm btn-icon btn-outline-primary" onclick="openEditModal(this)">
                                                                <i class="bx bx-edit-alt"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <tr data-date="2024-12-22" data-status="late" data-in="09:15:00" data-out="18:05:00" data-note="교통 체증">
                                                        <td>2024-12-22 (월)</td><td class="in-time">09:15:00</td><td class="out-time">18:05:00</td>
                                                        <td><span class="badge bg-label-warning status-badge">지각</span></td><td class="note-text">교통 체증</td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-sm btn-icon btn-outline-primary" onclick="openEditModal(this)">
                                                                <i class="bx bx-edit-alt"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                    <tr data-date="2025-01-02" data-status="normal" data-in="08:40:00" data-out="18:00:00" data-note="">
                                                        <td>2025-01-02 (목)</td><td class="in-time">08:40:00</td><td class="out-time">18:00:00</td>
                                                        <td><span class="badge bg-label-success status-badge">정상</span></td><td class="note-text"></td>
                                                        <td class="text-center">
                                                            <button type="button" class="btn btn-sm btn-icon btn-outline-primary" onclick="openEditModal(this)">
                                                                <i class="bx bx-edit-alt"></i>
                                                            </button>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div id="noDataMessage" class="text-center py-5" style="display: none;">
                                                <div class="mb-2"><i class="bx bx-calendar-x fs-1 text-muted"></i></div>
                                                <p class="text-muted fw-bold">선택한 기간/조건에 해당하는 기록이 없습니다.</p>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="tab-pane fade" id="navs-vacation" role="tabpanel">
    
									    <div class="row mb-4">
									        <div class="col-md-4">
									            <div class="card bg-label-secondary border-0 text-center">
									                <div class="card-body">
									                    <i class='bx bx-calendar-star mb-2' style="font-size: 2rem;"></i>
									                    <h5 class="card-title mb-1">총 부여 연차</h5>
									                    <h3 class="card-text text-secondary fw-bold">15.0 <span class="fs-6 fw-normal">일</span></h3>
									                </div>
									            </div>
									        </div>
									        <div class="col-md-4">
									            <div class="card bg-label-warning border-0 text-center">
									                <div class="card-body">
									                    <i class='bx bx-calendar-minus mb-2' style="font-size: 2rem;"></i>
									                    <h5 class="card-title mb-1">사용 연차</h5>
									                    <h3 class="card-text text-warning fw-bold">3.5 <span class="fs-6 fw-normal">일</span></h3>
									                </div>
									            </div>
									        </div>
									        <div class="col-md-4">
									            <div class="card bg-label-success border-0 text-center">
									                <div class="card-body">
									                    <i class='bx bx-calendar-check mb-2' style="font-size: 2rem;"></i>
									                    <h5 class="card-title mb-1">잔여 연차</h5>
									                    <h3 class="card-text text-success fw-bold">11.5 <span class="fs-6 fw-normal">일</span></h3>
									                </div>
									            </div>
									        </div>
									    </div>
									
									    <div class="card mb-4">
									        <div class="card-body">
									            <div class="d-flex justify-content-between mb-1">
									                <span class="fw-semibold">연차 소진율</span>
									                <span class="fw-semibold">23%</span>
									            </div>
									            <div class="progress" style="height: 10px;">
									                <div class="progress-bar bg-warning" role="progressbar" style="width: 23%;" aria-valuenow="23" aria-valuemin="0" aria-valuemax="100"></div>
									            </div>
									            <small class="text-muted mt-1 d-block">총 15일 중 3.5일 사용</small>
									        </div>
									    </div>
									
									    <h5 class="fw-bold py-2 mb-2"><i class='bx bx-list-ul me-1'></i> 휴가 사용 내역</h5>
									    <div class="table-responsive text-nowrap bg-white border rounded">
									        <table class="table table-hover">
									            <thead class="table-light">
									                <tr>
									                    <th>기간</th>
									                    <th>휴가 종류</th>
									                    <th>차감 일수</th>
									                    <th>사유</th>
									                    <th>상태</th>
									                </tr>
									            </thead>
									            <tbody>
									                <tr>
									                    <td>2024-08-01 ~ 2024-08-03</td>
									                    <td><span class="badge bg-label-primary">연차</span></td>
									                    <td class="fw-bold text-danger">- 3.0</td>
									                    <td>하계 휴가</td>
									                    <td><span class="badge bg-success">승인완료</span></td>
									                </tr>
									                <tr>
									                    <td>2024-12-18 (오후)</td>
									                    <td><span class="badge bg-label-info">반차</span></td>
									                    <td class="fw-bold text-danger">- 0.5</td>
									                    <td>개인 병원 진료</td>
									                    <td><span class="badge bg-success">승인완료</span></td>
									                </tr>
									                <tr>
									                    <td>2025-01-20 (예정)</td>
									                    <td><span class="badge bg-label-primary">연차</span></td>
									                    <td class="fw-bold text-danger">- 1.0</td>
									                    <td>가족 여행</td>
									                    <td><span class="badge bg-warning">결재중</span></td>
									                </tr>
									            </tbody>
									        </table>
									        <div class="text-center py-4" style="display:none;">
									            <p class="text-muted">사용 내역이 없습니다.</p>
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
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">근태 기록 수정 (관리자)</h5>
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
                                <option value="normal">정상</option>
                                <option value="late">지각</option>
                                <option value="early">조퇴</option>
                                <option value="absent">결근</option>
                                <option value="vacation">연차/휴가</option>
                                <option value="half">반차</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col mb-3">
                            <label for="editNote" class="form-label">수정 사유 / 비고</label>
                            <input type="text" id="editNote" class="form-control" placeholder="수정 사유를 입력하세요." />
                        </div>
                    </div>
                    
                    <input type="hidden" id="currentRowIndex" />
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="saveAttendanceChanges()">수정 내용 저장</button>
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

<script>
    function toggleDateInputs() {
        const type = document.getElementById("dateType").value;
        const areaMonth = document.getElementById("input-month");
        const areaYear = document.getElementById("input-year");
        const areaCustom = document.getElementById("input-custom");
        const dateInputArea = document.getElementById("dateInputArea");

        areaMonth.style.display = "none";
        areaYear.style.display = "none";
        areaCustom.style.display = "none";
        
        // 기본적으로 영역을 보이게 설정하고, 'all'일 때만 숨김
        if (type === "all") {
            dateInputArea.style.display = "none";
        } else {
            dateInputArea.style.display = "block";
            if (type === "month") areaMonth.style.display = "block";
            else if (type === "year") areaYear.style.display = "block";
            else if (type === "custom") areaCustom.style.display = "block";
        }
    }

    function applyFilters() {
        const type = document.getElementById("dateType").value;
        const statusFilter = document.getElementById("attendanceStatusFilter").value;
        const table = document.getElementById("attendanceTable");
        const rows = table.getElementsByTagName("tr");
        let visibleCount = 0;

        const valMonth = document.getElementById("filterMonth").value;
        const valYear = document.getElementById("filterYear").value;
        const valStart = document.getElementById("filterStartDate").value;
        const valEnd = document.getElementById("filterEndDate").value;

        for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const rowDate = row.getAttribute("data-date");
            const rowStatus = row.getAttribute("data-status");
            let dateMatch = false;
            let statusMatch = false;

            if (type === "all") dateMatch = true;
            else if (type === "month" && rowDate.startsWith(valMonth)) dateMatch = true;
            else if (type === "year" && rowDate.startsWith(valYear)) dateMatch = true;
            else if (type === "custom" && rowDate >= valStart && rowDate <= valEnd) dateMatch = true;

            if (statusFilter === "all" || rowStatus === statusFilter) statusMatch = true;

            if (dateMatch && statusMatch) {
                row.style.display = "";
                visibleCount++;
            } else {
                row.style.display = "none";
            }
        }

        const noDataMsg = document.getElementById("noDataMessage");
        if (visibleCount === 0) {
            noDataMsg.style.display = "block";
            table.style.display = "none";
        } else {
            noDataMsg.style.display = "none";
            table.style.display = "";
        }
    }
    function openEditModal(btn) {
        const tr = btn.closest('tr');
        
        const date = tr.getAttribute('data-date');
        const inTime = tr.getAttribute('data-in');
        const outTime = tr.getAttribute('data-out');
        const status = tr.getAttribute('data-status');
        const note = tr.getAttribute('data-note');
        
        document.getElementById('editDate').value = date;
        document.getElementById('editInTime').value = inTime; 
        document.getElementById('editOutTime').value = outTime;
        document.getElementById('editStatus').value = status;
        document.getElementById('editNote').value = note ? note : "";

        document.getElementById('currentRowIndex').value = tr.rowIndex;

        const myModal = new bootstrap.Modal(document.getElementById('modalAttendanceEdit'));
        myModal.show();
    }

    function saveAttendanceChanges() {
        const rowIndex = document.getElementById('currentRowIndex').value;
        const newInTime = document.getElementById('editInTime').value;
        const newOutTime = document.getElementById('editOutTime').value;
        const newStatus = document.getElementById('editStatus').value;
        const newNote = document.getElementById('editNote').value;
        
        alert("수정되었습니다. (DB 반영 로직 필요)");

        const table = document.getElementById('attendanceTable');
        const tr = table.rows[rowIndex]; 

        tr.querySelector('.in-time').innerText = newInTime ? newInTime : "-";
        tr.querySelector('.out-time').innerText = newOutTime ? newOutTime : "-";
        tr.querySelector('.note-text').innerText = newNote;

        const badge = tr.querySelector('.status-badge');
        let badgeClass = "bg-label-primary";
        let badgeText = "기타";

        if(newStatus === 'normal') { badgeClass="bg-label-success"; badgeText="정상"; }
        else if(newStatus === 'late') { badgeClass="bg-label-warning"; badgeText="지각"; }
        else if(newStatus === 'early') { badgeClass="bg-label-info"; badgeText="조퇴"; }
        else if(newStatus === 'absent') { badgeClass="bg-label-danger"; badgeText="결근"; }
        else if(newStatus === 'vacation') { badgeClass="bg-label-primary"; badgeText="연차/휴가"; }
        else if(newStatus === 'half') { badgeClass="bg-label-info"; badgeText="반차"; }

        badge.className = `badge ${badgeClass} status-badge`;
        badge.innerText = badgeText;

        tr.setAttribute('data-in', newInTime);
        tr.setAttribute('data-out', newOutTime);
        tr.setAttribute('data-status', newStatus);
        tr.setAttribute('data-note', newNote);

        // 모달 닫기
        const modalEl = document.getElementById('modalAttendanceEdit');
        const modalInstance = bootstrap.Modal.getInstance(modalEl);
        modalInstance.hide();
    }
</script>
</body>
</html>
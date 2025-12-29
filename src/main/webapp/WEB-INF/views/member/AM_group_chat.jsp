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

    <style>
        .dept-item { cursor: pointer; transition: all 0.2s; }
        .dept-item:hover { background-color: #f5f5f9; }
        .dept-item.active { background-color: #696cff !important; color: white !important; border-color: #696cff; }
        .sub-dept { padding-left: 2rem !important; font-size: 0.95rem; }
        .dept-actions { display: none; }
        .dept-item:hover .dept-actions { display: inline-block; }
        .btn-action-icon { padding: 0 5px; color: #8592a3; transition: color 0.2s; }
        .btn-action-icon:hover { color: #696cff; transform: scale(1.1); }
        .btn-action-icon.delete:hover { color: #ff3e1d; }
        .dept-item.active .btn-action-icon { color: #e0e0e0; }
        .dept-item.active .btn-action-icon:hover { color: #fff; }
        
        /* 상세 모달 스타일 커스텀 */
        .modal-header-tabs .nav-link { color: #697a8d; font-weight: 500; }
        .modal-header-tabs .nav-link.active { background-color: #696cff; color: #fff; }
        .form-label { font-weight: 600; color: #566a7f; font-size: 0.85rem; }
        .readonly-input { background-color: #f5f5f9 !important; cursor: not-allowed; }
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
                        <span class="text-muted fw-light">조직 관리 /</span> 조직도 및 부서 관리
                    </h4>

                    <div class="row">
                        <div class="col-md-4 col-lg-3 mb-4">
                            <div class="card h-100">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0 fw-bold"><i class='bx bx-buildings me-2'></i>부서 목록</h5>
                                    <button type="button" class="btn btn-sm btn-icon btn-outline-primary" 
                                            data-bs-toggle="modal" data-bs-target="#modalDeptAdd" title="부서 추가">
                                        <i class='bx bx-plus'></i>
                                    </button>
                                </div>
                                <div class="card-body p-0">
                                    <div class="list-group list-group-flush" id="deptList">
                                        <a class="list-group-item list-group-item-action dept-item active" data-dept="ALL">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <span><i class='bx bx-globe me-2'></i> 전체 조직</span>
                                                <span class="badge bg-label-primary rounded-pill">36</span>
                                            </div>
                                        </a>
                                        <div class="list-group-item fw-bold bg-light d-flex justify-content-between align-items-center" style="pointer-events: none;">
                                            경영지원본부
                                        </div>
                                        <a class="list-group-item list-group-item-action dept-item sub-dept" data-dept="D001" data-name="인사팀">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <span>└ 인사팀</span>
                                                <span class="badge bg-label-primary rounded-pill">12</span>
                                                <div class="dept-actions">
                                                    <i class='bx bx-key btn-action-icon' onclick="openAuthModal(event, 'D001', '인사팀')"></i>
                                                    <i class='bx bx-edit-alt btn-action-icon' onclick="openDeptEdit(event, 'D001', '인사팀')"></i>
                                                    <i class='bx bx-trash btn-action-icon delete' onclick="deleteDept(event, 'D001')"></i>
                                                </div>
                                            </div>
                                        </a>
                                        <a class="list-group-item list-group-item-action dept-item sub-dept" data-dept="D002" data-name="총무팀">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <span>└ 총무팀</span>
                                                <span class="badge bg-label-primary rounded-pill">12</span>
                                                <div class="dept-actions">
                                                    <i class='bx bx-key btn-action-icon' onclick="openAuthModal(event, 'D002', '총무팀')"></i>
                                                    <i class='bx bx-edit-alt btn-action-icon' onclick="openDeptEdit(event, 'D002', '총무팀')"></i>
                                                    <i class='bx bx-trash btn-action-icon delete' onclick="deleteDept(event, 'D002')"></i>
                                                </div>
                                            </div>
                                        </a>
                                        <div class="list-group-item fw-bold bg-light d-flex justify-content-between align-items-center" style="pointer-events: none;">
                                            기술연구소
                                        </div>
                                        <a class="list-group-item list-group-item-action dept-item sub-dept" data-dept="D003" data-name="개발 1팀">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <span>└ 개발 1팀 (Backend)</span>
                                                <span class="badge bg-label-primary rounded-pill">12</span>
                                                <div class="dept-actions">
                                                    <i class='bx bx-key btn-action-icon' onclick="openAuthModal(event, 'D003', '개발 1팀')"></i>
                                                    <i class='bx bx-edit-alt btn-action-icon' onclick="openDeptEdit(event, 'D003', '개발 1팀')"></i>
                                                    <i class='bx bx-trash btn-action-icon delete' onclick="deleteDept(event, 'D003')"></i>
                                                </div>
                                            </div>
                                        </a>
                                        <a class="list-group-item list-group-item-action dept-item sub-dept" data-dept="D004" data-name="개발 2팀">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <span>└ 개발 2팀 (Frontend)</span>
                                                <span class="badge bg-label-primary rounded-pill">12</span>
                                                <div class="dept-actions">
                                                    <i class='bx bx-key btn-action-icon' onclick="openAuthModal(event, 'D004', '개발 2팀')"></i>
                                                    <i class='bx bx-edit-alt btn-action-icon' onclick="openDeptEdit(event, 'D004', '개발 2팀')"></i>
                                                    <i class='bx bx-trash btn-action-icon delete' onclick="deleteDept(event, 'D004')"></i>
                                                </div>
                                            </div>
                                        </a>
                                        <div class="list-group-item fw-bold bg-light d-flex justify-content-between align-items-center" style="pointer-events: none;">
                                            영업본부
                                        </div>
                                        <a class="list-group-item list-group-item-action dept-item sub-dept" data-dept="D005" data-name="국내영업팀">
                                            <div class="d-flex w-100 justify-content-between align-items-center">
                                                <span>└ 국내영업팀</span>
                                                <div class="dept-actions">
                                                    <i class='bx bx-key btn-action-icon' onclick="openAuthModal(event, 'D005', '국내영업팀')"></i>
                                                    <i class='bx bx-edit-alt btn-action-icon' onclick="openDeptEdit(event, 'D005', '국내영업팀')"></i>
                                                    <i class='bx bx-trash btn-action-icon delete' onclick="deleteDept(event, 'D005')"></i>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-8 col-lg-9 mb-4">
                            <div class="card h-100">
                                <div class="card-header border-bottom d-flex justify-content-between align-items-center">
                                    <div>
                                        <h5 class="mb-0 fw-bold" id="selectedDeptTitle">전체 조직원</h5>
                                        <small class="text-muted" id="selectedDeptCount">총 12명</small>
                                    </div>
                                    <div class="input-group input-group-sm w-auto">
                                        <span class="input-group-text"><i class="bx bx-search"></i></span>
                                        <input type="text" class="form-control" placeholder="이름, 직급 검색..." id="searchMember">
                                    </div>
                                </div>

                                <div class="table-responsive text-nowrap">
                                    <table class="table table-hover">
                                        <thead class="table-light">
                                            <tr>
                                                <th>이름 / 사번</th>
                                                <th>부서</th>
                                                <th>직급</th>
                                                <th>상태</th>
                                                <th>연락처</th>
                                                <th class="text-center">상세</th>
                                            </tr>
                                        </thead>
                                        <tbody id="memberTableBody">
                                            </tbody>
                                    </table>
                                </div>
                                
                                <div id="noDataMessage" class="text-center py-5" style="display: none;">
                                    <i class="bx bx-user-x fs-1 text-muted mb-2"></i>
                                    <p class="text-muted">해당 부서에 소속된 사원이 없습니다.</p>
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
    <div class="modal-dialog modal-dialog-centered modal-lg"> <div class="modal-content">
            
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
    <div class="modal-dialog modal-dialog-centered modal-sm">
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
    <div class="modal-dialog modal-dialog-centered modal-sm">
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

<script>
    // [가상 데이터] - let으로 변경 (수정 가능하게)
    let allMembers = [
        { id: "24001", name: "김철수", deptCode: "D003", deptName: "개발 1팀", position: "대리", status: "active", phone: "010-1111-2222", email: "cs.kim@company.com", joinDate: "2021-03-02" },
        { id: "24002", name: "이영희", deptCode: "D001", deptName: "인사팀", position: "과장", status: "active", phone: "010-3333-4444", email: "yh.lee@company.com", joinDate: "2019-11-15" },
        { id: "24003", name: "박부장", deptCode: "D003", deptName: "개발 1팀", position: "부장", status: "active", phone: "010-5555-6666", email: "park@company.com", joinDate: "2010-05-01" },
        { id: "24004", name: "최사원", deptCode: "D004", deptName: "개발 2팀", position: "사원", status: "vacation", phone: "010-7777-8888", email: "choi@company.com", joinDate: "2023-01-10" },
        { id: "24005", name: "정팀장", deptCode: "D002", deptName: "총무팀", position: "차장", status: "active", phone: "010-9999-0000", email: "jung@company.com", joinDate: "2015-08-20" },
        { id: "24006", name: "강대리", deptCode: "D005", deptName: "국내영업팀", position: "대리", status: "out", phone: "010-1212-3434", email: "kang@company.com", joinDate: "2020-04-12" }
    ];

    let currentDeptFilter = "ALL";
    let currentDeptName = "전체 조직원";

    $(document).ready(function() {
        renderTable("ALL");

        $(".dept-item").click(function() {
            $(".dept-item").removeClass("active");
            $(this).addClass("active");

            currentDeptFilter = $(this).data("dept");
            let deptName = $(this).find("span").first().text().trim();
            if(deptName.startsWith("└")) deptName = deptName.substring(1).trim();
            currentDeptName = deptName;

            renderTable(currentDeptFilter, currentDeptName);
        });

        $("#searchMember").on("keyup", function() {
            const value = $(this).val().toLowerCase();
            $("#memberTableBody tr").filter(function() {
                $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
            });
        });
    });

    // 테이블 렌더링 함수
    function renderTable(filterDeptCode, deptName = currentDeptName) {
        const tbody = $("#memberTableBody");
        tbody.empty();
        let filteredData = [];
        
        if (filterDeptCode === "ALL") {
            filteredData = allMembers;
            $("#selectedDeptTitle").text("전체 조직원");
        } else {
            filteredData = allMembers.filter(m => m.deptCode === filterDeptCode);
            $("#selectedDeptTitle").text(deptName);
        }

        $("#selectedDeptCount").text(`총 ${filteredData.length}명`);

        if (filteredData.length === 0) {
            $("#noDataMessage").show();
        } else {
            $("#noDataMessage").hide();
        }

        filteredData.forEach(member => {
            let statusBadge = '';
            if(member.status === 'active') statusBadge = '<span class="badge bg-label-success">재직</span>';
            else if(member.status === 'vacation') statusBadge = '<span class="badge bg-label-warning">휴가</span>';
            else if(member.status === 'out') statusBadge = '<span class="badge bg-label-secondary">외근</span>';
            else if(member.status === 'leave') statusBadge = '<span class="badge bg-label-danger">퇴사</span>';

            const row = `
                <tr>
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="avatar avatar-sm me-2">
                                <span class="avatar-initial rounded-circle bg-label-primary">${member.name.charAt(0)}</span>
                            </div>
                            <div>
                                <h6 class="mb-0 text-truncate">${member.name}</h6>
                                <small class="text-muted">${member.id}</small>
                            </div>
                        </div>
                    </td>
                    <td>${member.deptName}</td>
                    <td><span class="fw-semibold">${member.position}</span></td>
                    <td>${statusBadge}</td>
                    <td>${member.phone}</td>
                    <td class="text-center">
                        <button onclick="openMemberDetail('${member.id}')" class="btn btn-sm btn-icon btn-outline-secondary" title="상세 정보">
                            <i class="bx bx-show"></i>
                        </button>
                    </td>
                </tr>
            `;
            tbody.append(row);
        });
    }

    // ==========================================
    // [UPDATED] 사원 상세 모달 열기 (FORM 바인딩)
    // ==========================================
    function openMemberDetail(memberId) {
        // 1. 데이터 찾기
        const member = allMembers.find(m => m.id === memberId);
        
        if (member) {
            // 2. 모달 Form에 값 채우기 (val() 사용)
            $("#modalId").val(member.id);
            $("#modalName").val(member.name);
            $("#modalDeptCode").val(member.deptCode); // Select Box 자동 선택
            $("#modalPosition").val(member.position); // Select Box 자동 선택
            $("#modalEmail").val(member.email);
            $("#modalPhone").val(member.phone);
            $("#modalJoinDate").val(member.joinDate);
            $("#modalStatus").val(member.status);     // Select Box 자동 선택

            // 3. 모달 표시
            const myModal = new bootstrap.Modal(document.getElementById('modalMemberDetail'));
            myModal.show();
        }
    }

    // ==========================================
    // [NEW] 상세정보 저장 (프론트엔드 반영)
    // ==========================================
    function saveMemberDetails() {
        const id = $("#modalId").val();
        
        // 1. 현재 입력된 값 가져오기
        const updatedData = {
            id: id,
            name: $("#modalName").val(),
            deptCode: $("#modalDeptCode").val(),
            deptName: $("#modalDeptCode option:selected").text(), // Select text 가져오기
            position: $("#modalPosition").val(),
            email: $("#modalEmail").val(),
            phone: $("#modalPhone").val(),
            joinDate: $("#modalJoinDate").val(),
            status: $("#modalStatus").val()
        };

        // 2. 배열(DB대용) 업데이트
        const index = allMembers.findIndex(m => m.id === id);
        if(index !== -1) {
            allMembers[index] = updatedData;
        }

        // 3. 테이블 다시 그리기 (화면 갱신)
        renderTable(currentDeptFilter, currentDeptName);

        // 4. 모달 닫기
        const modalEl = document.getElementById('modalMemberDetail');
        const modal = bootstrap.Modal.getInstance(modalEl);
        modal.hide();

        // 5. 알림 (DB 연동 위치)
        // alert("저장되었습니다. (여기서 Ajax로 DB 업데이트)");
        console.log("DB 전송 데이터:", updatedData);
    }

    // ==========================================
    // 기타 관리자 기능
    // ==========================================
    function openDeptEdit(event, deptId, deptName) {
        event.stopPropagation();
        $("#editDeptId").val(deptId);
        $("#editDeptName").val(deptName);
        new bootstrap.Modal(document.getElementById('modalDeptEdit')).show();
    }

    function deleteDept(event, deptId) {
        event.stopPropagation();
        if(confirm("정말 이 부서를 삭제하시겠습니까?")) {
            alert("삭제 요청 (DB 연동 필요): " + deptId);
        }
    }

    function openAuthModal(event, deptId, deptName) {
        event.stopPropagation();
        $("#authTargetDept").text(deptName);
        $("#authTargetDeptId").val(deptId);
        $("input[name='menuId']").not(":disabled").prop('checked', false);
        if(deptId === 'D001') {
            $("input[value='M02']").prop('checked', true);
        }
        new bootstrap.Modal(document.getElementById('modalAuth')).show();
    }

    function saveAuth() {
        alert("권한 설정이 저장되었습니다.");
        const modalEl = document.getElementById('modalAuth');
        const modal = bootstrap.Modal.getInstance(modalEl);
        modal.hide();
    }
</script>
</body>
</html>
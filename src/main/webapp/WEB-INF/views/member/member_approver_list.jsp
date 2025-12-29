<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>전자결재 - 받은 결재함</title>
    
    <link rel="icon" type="image/x-icon" href="/assets/img/favicon/favicon.ico" />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>

        <div class="layout-page">
            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">
                    
                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">전자결재 /</span> 받은 결재함
                    </h4>

                    <div class="card mb-4">
                        <div class="card-body">
                            <form id="searchForm" class="row gx-3 gy-2 align-items-center" onsubmit="return filterTable(event)">
                                <div class="col-md-3">
                                    <label class="form-label mb-1">기간 조회</label>
                                    <input type="date" class="form-control" id="searchDate">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label mb-1">상태</label>
                                    <select class="form-select" id="searchStatus">
                                        <option value="all">전체</option>
                                        <option value="wait" selected>결재 대기</option>
                                        <option value="approve">승인 완료</option>
                                        <option value="reject">반려됨</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label mb-1">검색어 (제목/기안자)</label>
                                    <div class="input-group input-group-merge">
                                        <span class="input-group-text"><i class="bx bx-search"></i></span>
                                        <input type="text" class="form-control" id="searchText" placeholder="검색어를 입력하세요">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label mb-1 d-block">&nbsp;</label>
                                    <button type="submit" class="btn btn-primary w-100">조회</button>
                                </div>
                            </form>
                        </div>
                    </div>
                    <div class="card">
                        <div class="card-header border-bottom d-flex justify-content-between align-items-center">
                            <h5 class="mb-0 fw-bold">문서 목록</h5>
                            <span class="badge bg-label-primary" id="totalCount">총 3건</span>
                        </div>
                        <div class="table-responsive text-nowrap">
                            <table class="table table-hover" id="approvalTable">
                                <thead class="table-light">
                                    <tr>
                                        <th>문서 번호</th>
                                        <th>기안일</th>
                                        <th>제목</th>
                                        <th>기안자</th>
                                        <th>상태</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr class="doc-row" data-status="wait" data-title="여름 정기 휴가 신청의 건" data-writer="김철수">
                                        <td><span class="fw-bold">DOC-2024-001</span></td>
                                        <td>2024-05-20</td>
                                        <td><strong>여름 정기 휴가 신청의 건</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar avatar-xs me-2">
                                                    <span class="avatar-initial rounded-circle bg-label-success">김</span>
                                                </div>
                                                <span>김철수 대리</span>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-label-warning" id="status-badge-1001">결재 대기</span></td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-primary"
                                                    onclick="openApprovalModal(this)"
                                                    data-id="1001"
                                                    data-title="여름 정기 휴가 신청의 건"
                                                    data-writer="김철수 대리 (개발 1팀)"
                                                    data-date="2024-05-20"
                                                    data-content="아래와 같이 연차 휴가를 신청하오니 재가 바랍니다.<br><br>- 기간: 2024.06.01 ~ 2024.06.05 (5일간)<br>- 사유: 개인 휴식 및 재충전"
                                                    data-filename="휴가신청서_증빙서류.pdf" 
                                                    data-status="wait">
                                                결재하기
                                            </button>
                                        </td>
                                    </tr>

                                    <tr class="doc-row" data-status="wait" data-title="신규 입사자 노트북 구매 요청" data-writer="이영희">
                                        <td><span class="fw-bold">DOC-2024-002</span></td>
                                        <td>2024-05-21</td>
                                        <td><strong>신규 입사자 노트북 구매 요청</strong></td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar avatar-xs me-2">
                                                    <span class="avatar-initial rounded-circle bg-label-info">이</span>
                                                </div>
                                                <span>이영희 과장</span>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-label-warning" id="status-badge-1002">결재 대기</span></td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-primary"
                                                    onclick="openApprovalModal(this)"
                                                    data-id="1002"
                                                    data-title="신규 입사자 노트북 구매 요청"
                                                    data-writer="이영희 과장 (인사팀)"
                                                    data-date="2024-05-21"
                                                    data-content="신규 입사자(박신입) 개발 장비 구매 요청 건입니다.<br><br>- 품목: MacBook Pro 16inch<br>- 금액: 3,500,000원"
                                                    data-filename="MacBook_Pro_견적서.pdf"
                                                    data-status="wait">
                                                결재하기
                                            </button>
                                        </td>
                                    </tr>
                                    
                                    <tr class="doc-row table-light" data-status="approve" data-title="4월 회식비 지출 결의서" data-writer="박부장">
                                        <td><span class="fw-bold text-muted">DOC-2024-000</span></td>
                                        <td>2024-05-10</td>
                                        <td class="text-muted">4월 회식비 지출 결의서</td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar avatar-xs me-2">
                                                    <span class="avatar-initial rounded-circle bg-label-secondary">박</span>
                                                </div>
                                                <span class="text-muted">박부장</span>
                                            </div>
                                        </td>
                                        <td><span class="badge bg-label-success">승인 완료</span></td>
                                        <td>
                                            <button type="button" class="btn btn-sm btn-outline-secondary" disabled>완료됨</button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div id="noResult" class="text-center p-4" style="display: none;">
                                <p class="text-muted mb-0">검색 결과가 없습니다.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalApproval" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header border-bottom">
                <h5 class="modal-title fw-bold" id="modalDocTitle">문서 제목</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            
            <div class="modal-body p-4">
                <table class="table table-bordered mb-4">
                    <tbody>
                        <tr>
                            <th class="bg-light w-25">문서번호</th>
                            <td id="modalDocId"></td>
                            <th class="bg-light w-25">기안일자</th>
                            <td id="modalDocDate"></td>
                        </tr>
                        <tr>
                            <th class="bg-light">기안자</th>
                            <td colspan="3" id="modalDocWriter"></td>
                        </tr>
                    </tbody>
                </table>

                <div class="border rounded p-3 bg-light mb-3" style="min-height: 200px;">
                    <p id="modalDocContent" class="mb-0"></p>
                </div>

                <div id="fileArea" class="mt-4 mb-3 p-3 bg-label-secondary rounded d-flex justify-content-between align-items-center" style="display: none;">
                    <div class="d-flex align-items-center">
                        <i class='bx bxs-file-pdf fs-3 me-3 text-danger'></i> 
                        <div>
                            <h6 class="mb-0 fw-bold" id="modalFileName">파일명.pdf</h6>
                            <small class="text-muted">1.2 MB</small>
                        </div>
                    </div>
                    <button type="button" class="btn btn-sm btn-outline-primary" onclick="alert('다운로드 테스트입니다.')">
                        <i class='bx bx-download me-1'></i> 다운로드
                    </button>
                </div>

            </div>

            <div class="modal-footer border-top bg-lighter">
                <input type="hidden" id="currentDocId">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-danger" onclick="openRejectModal()">반려</button>
                <button type="button" class="btn btn-success" onclick="processApproval()">승인</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalReject" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold text-danger">반려 사유 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p class="mb-2">반려 사유를 반드시 작성해야 합니다.</p>
                <textarea id="rejectReason" class="form-control" rows="4" placeholder="예: 휴가 일정이 프로젝트 기간과 겹칩니다."></textarea>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" onclick="backToDetail()">취소</button>
                <button type="button" class="btn btn-danger" onclick="confirmReject()">반려 확정</button>
            </div>
        </div>
    </div>
</div>

<script>
    // ★★★ [추가됨] 프론트엔드 검색 필터 로직 ★★★
    // 페이지 로드 시 '결재 대기'만 보여주기 위해 필터 실행
    document.addEventListener("DOMContentLoaded", function() {
        filterTable(null); 
    });

    function filterTable(e) {
        if(e) e.preventDefault(); // 폼 전송 막기

        const statusFilter = $("#searchStatus").val(); // 선택된 상태 (wait, approve, all)
        const searchText = $("#searchText").val().toLowerCase(); // 검색어
        let visibleCount = 0;

        $(".doc-row").each(function() {
            const rowStatus = $(this).data("status"); // 행의 상태 데이터
            const rowTitle = $(this).data("title");   // 행의 제목 데이터
            const rowWriter = $(this).data("writer"); // 행의 작성자 데이터
            
            // 1. 상태 일치 여부 확인
            let statusMatch = (statusFilter === "all") || (statusFilter === rowStatus);
            
            // 2. 검색어 포함 여부 확인 (제목 or 작성자)
            let textMatch = rowTitle.includes(searchText) || rowWriter.includes(searchText);

            if(statusMatch && textMatch) {
                $(this).show();
                visibleCount++;
            } else {
                $(this).hide();
            }
        });

        // 결과 개수 업데이트
        $("#totalCount").text("총 " + visibleCount + "건");
        
        // 결과 없음 표시
        if(visibleCount === 0) $("#noResult").show();
        else $("#noResult").hide();
    }

    // ========== 기존 로직들 (상세, 승인, 반려) ==========
    
    function openApprovalModal(btn) {
        const data = $(btn).data();
        
        $("#modalDocTitle").text(data.title);
        $("#modalDocId").text("DOC-" + data.id);
        $("#modalDocDate").text(data.date);
        $("#modalDocWriter").text(data.writer);
        $("#modalDocContent").html(data.content);
        $("#currentDocId").val(data.id);

        if(data.filename) {
            $("#modalFileName").text(data.filename);
            $("#fileArea").css("display", "flex");
        } else {
            $("#fileArea").hide();
        }

        const myModal = new bootstrap.Modal(document.getElementById('modalApproval'));
        myModal.show();
    }

    function processApproval() {
        if(!confirm("이 문서를 승인하시겠습니까?")) return;
        const docId = $("#currentDocId").val();
        updateStatus(docId, "approve");
        bootstrap.Modal.getInstance(document.getElementById('modalApproval')).hide();
    }

    function openRejectModal() {
        const detailModal = bootstrap.Modal.getInstance(document.getElementById('modalApproval'));
        detailModal.hide();
        $("#rejectReason").val(""); 
        const rejectModal = new bootstrap.Modal(document.getElementById('modalReject'));
        rejectModal.show();
    }

    function confirmReject() {
        const reason = $("#rejectReason").val().trim();
        if (reason === "") {
            alert("반려 사유를 반드시 입력해주세요!");
            $("#rejectReason").focus();
            return;
        }
        const docId = $("#currentDocId").val();
        updateStatus(docId, "reject");
        bootstrap.Modal.getInstance(document.getElementById('modalReject')).hide();
    }

    function backToDetail() {
        bootstrap.Modal.getInstance(document.getElementById('modalReject')).hide();
        setTimeout(() => {
            const myModal = new bootstrap.Modal(document.getElementById('modalApproval'));
            myModal.show();
        }, 200);
    }

    function updateStatus(docId, type) {
        const badgeId = "#status-badge-" + docId;
        const btnSelector = "#doc-" + docId + " button";
        const rowSelector = "#doc-" + docId;

        if(type === 'approve') {
            alert("정상적으로 승인 처리되었습니다.");
            $(badgeId).removeClass("bg-label-warning").addClass("bg-label-success").text("승인 완료");
            $(btnSelector).removeClass("btn-primary").addClass("btn-outline-secondary").text("완료됨").prop("disabled", true);
            
            // 데이터 속성도 변경해줘야 검색 필터에서 바로 반영됨
            $(rowSelector).data("status", "approve"); 
            $(rowSelector).attr("data-status", "approve"); // DOM 속성도 변경

        } else {
            alert("문서가 반려되었습니다.");
            $(badgeId).removeClass("bg-label-warning").addClass("bg-label-danger").text("반려됨");
            $(btnSelector).removeClass("btn-primary").addClass("btn-outline-danger").text("반려됨").prop("disabled", true);
            
            $(rowSelector).data("status", "reject");
            $(rowSelector).attr("data-status", "reject");
        }
        
        // 상태 변경 후 현재 필터 기준에 맞춰 다시 필터링 (선택사항 - 바로 사라지게 할지 말지)
        // filterTable(null); // 이 줄 주석을 풀면, '대기' 상태에서 승인하는 순간 목록에서 사라집니다.
    }
</script>

<script src="/vendor/js/menu.js"></script>
<script src="/js/main.js"></script>

</body>
</html>
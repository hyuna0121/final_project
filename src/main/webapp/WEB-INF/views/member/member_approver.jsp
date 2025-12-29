<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>전자결재 - 기안문 작성</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />

    <style>
        /* 작성자 정보 스타일 (읽기 전용 느낌 강조) */
        .writer-info {
            font-size: 15px;
            font-weight: 500;
            color: #566a7f;
            padding-top: 7px; /* 라벨과 높이 맞춤 */
        }

        /* 결재선 박스 스타일 (카드형) */
        .approver-container {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .approver-box {
            display: flex;
            align-items: center;
            background-color: #fff;
            border: 1px solid #d9dee3;
            border-left: 4px solid #696cff; /* 포인트 컬러 */
            border-radius: 4px;
            padding: 8px 12px;
            box-shadow: 0 2px 6px rgba(67, 89, 113, 0.06);
            transition: all 0.2s;
        }
        .approver-box:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(67, 89, 113, 0.1);
        }
        .approver-step {
            font-size: 11px;
            color: #696cff;
            font-weight: bold;
            margin-right: 8px;
            background: #e7e7ff;
            padding: 2px 6px;
            border-radius: 4px;
        }
        .approver-text { font-size: 13px; font-weight: 600; color: #384551; }
        .approver-box .btn-close { font-size: 10px; margin-left: 10px; }
        
        /* 텍스트 에디터 스타일 (깔끔하게) */
        .editor-textarea {
            resize: none;
            border: 1px solid #d9dee3;
            border-radius: 6px;
            padding: 20px;
            font-size: 14px;
            line-height: 1.6;
            height: 500px;
            min-height: 400px;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.03);
        }
        .editor-textarea:focus {
            border-color: #696cff;
            outline: none;
            box-shadow: 0 0 0 0.25rem rgba(105, 108, 255, 0.1);
        }
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
                        <span class="text-muted fw-light">전자결재 /</span> 기안문 작성
                    </h4>

                    <div class="card mb-4">
                        <div class="card-body p-4"> <form id="approvalForm" action="/approval/write" method="post" enctype="multipart/form-data">
                                
                                <div class="row mb-4">
                                    <label class="col-sm-2 col-form-label fw-bold text-uppercase text-muted" style="font-size:0.85rem">작성자</label>
                                    <div class="col-sm-10">
                                        <div class="writer-info">
                                            <i class='bx bxs-user-circle me-1'></i> 개발 1팀 &nbsp;|&nbsp; 대리 &nbsp;|&nbsp; 김철수
                                        </div>
                                    </div>
                                </div>

                                <hr class="my-4 border-light">

                                <div class="row mb-4">
                                    <label class="col-sm-2 col-form-label fw-bold text-uppercase text-muted" style="font-size:0.85rem">결재선 지정</label>
                                    <div class="col-sm-10">
                                        <div class="d-flex mb-3 gap-2">
                                            <button type="button" class="btn btn-primary btn-sm" onclick="openApproverModal()">
                                                <i class='bx bx-plus'></i> 결재자 추가
                                            </button>
                                            <button type="button" class="btn btn-outline-secondary btn-sm" onclick="openFavoritesModal()">
                                                <i class='bx bx-star'></i> 나의 결재선 불러오기
                                            </button>
                                        </div>

                                        <div id="selectedApprovers" class="approver-container p-3 bg-lighter border rounded" style="min-height: 80px; align-items: center;">
                                            <span class="text-muted small ms-2" id="emptyMsg">결재자를 추가하거나 즐겨찾기를 불러오세요.</span>
                                            </div>
                                    </div>
                                </div>

                                <hr class="my-4 border-light">

                                <div class="row mb-3">
                                    <label class="col-sm-2 col-form-label fw-bold text-uppercase text-muted" style="font-size:0.85rem">근태 종류</label>
                                    <div class="col-sm-4">
                                        <select class="form-select" name="leaveType" id="leaveType">
                                            <option value="" selected disabled>근태 종류를 선택하세요</option>
                                            <option value="연차">연차/휴가</option>
                                            <option value="반차">반차</option>
                                            <option value="병가">병가</option>
                                            <option value="경조사">경조사</option>
                                            <option value="교육">교육/훈련</option>
                                            <option value="출장">출장</option>
                                            <option value="기타">기타</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label class="col-sm-2 col-form-label fw-bold text-uppercase text-muted" style="font-size:0.85rem">제목</label>
                                    <div class="col-sm-10">
                                        <input type="text" class="form-control" name="title" placeholder="제목을 입력하세요 (예: 5월 정기 연차 사용)">
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <label class="col-sm-2 col-form-label fw-bold text-uppercase text-muted" style="font-size:0.85rem">상세 내용</label>
                                    <div class="col-sm-10">
                                        <textarea class="form-control editor-textarea" name="content" placeholder="상세 사유 및 업무 대행자 등을 입력하세요."></textarea>
                                    </div>
                                </div>

                                <div class="row mb-4">
                                    <label class="col-sm-2 col-form-label fw-bold text-uppercase text-muted" style="font-size:0.85rem">첨부파일</label>
                                    <div class="col-sm-10">
                                        <div class="input-group">
                                            <input type="file" class="form-control" id="inputGroupFile02" name="file">
                                            <label class="input-group-text" for="inputGroupFile02">Upload</label>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mt-5">
                                    <div class="col-12 text-center">
                                        <button type="button" class="btn btn-label-secondary me-2">임시 저장</button>
                                        <button type="submit" class="btn btn-primary px-5">결재 요청</button>
                                    </div>
                                </div>

                            </form>
                        </div>
                    </div>

                </div>
                <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalSelectApprover" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">결재자 검색/추가</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label class="form-label">부서</label>
                    <select class="form-select" id="selectTeam">
                        <option value="개발팀">개발팀</option>
                        <option value="인사팀">인사팀</option>
                        <option value="영업팀">영업팀</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">사원 선택</label>
                    <select class="form-select" id="selectPerson">
                        <option selected disabled>결재자를 선택하세요</option>
                        <option value="2001001|박이사|이사|개발팀">박이사 (이사)</option>
                        <option value="2005002|최팀장|팀장|개발팀">최팀장 (팀장)</option>
                        <option value="2010003|이부장|부장|인사팀">이부장 (부장)</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="addApproverFromModal()">추가</button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalFavorites" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold"><i class='bx bx-star text-warning'></i> 나의 결재선</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="list-group">
                    <a href="#" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" onclick="loadFavoriteLine(1)">
                        <div>
                            <div class="fw-bold">휴가 신청용</div>
                            <small class="text-muted">최팀장 > 박이사</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">불러오기</span>
                    </a>
                    <a href="#" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" onclick="loadFavoriteLine(2)">
                        <div>
                            <div class="fw-bold">비품 구매용</div>
                            <small class="text-muted">이대리 > 김과장 > 최팀장</small>
                        </div>
                        <span class="badge bg-primary rounded-pill">불러오기</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 결재자 모달 열기
    function openApproverModal() {
        new bootstrap.Modal(document.getElementById('modalSelectApprover')).show();
    }
    
    // 즐겨찾기 모달 열기
    function openFavoritesModal() {
        new bootstrap.Modal(document.getElementById('modalFavorites')).show();
    }

    // [로직 1] 모달에서 한 명 추가하기
    function addApproverFromModal() {
        const rawValue = $("#selectPerson").val(); // 예: "2001001|박이사|이사|개발팀"
        
        if(!rawValue) {
            alert("결재자를 선택해주세요.");
            return;
        }

        // 데이터 파싱
        const [empId, name, rank, dept] = rawValue.split("|");
        
        // 화면에 그리기
        renderApproverBox(empId, name, rank, dept);
        
        // 모달 닫기 및 초기화
        const modal = bootstrap.Modal.getInstance(document.getElementById('modalSelectApprover'));
        modal.hide();
        $("#selectPerson").val("");
    }

    // [로직 2] 즐겨찾기 불러오기 (Mockup 데이터)
    function loadFavoriteLine(typeId) {
        // 기존 결재선 초기화
        $("#selectedApprovers").empty();
        $("#emptyMsg").hide();

        // 실제로는 AJAX로 서버에서 데이터를 받아와야 합니다.
        // 여기서는 하드코딩된 예시입니다.
        let data = [];
        if(typeId === 1) { // 휴가 신청용
            data = [
                {id: "2005002", name: "최팀장", rank: "팀장", dept: "개발팀"},
                {id: "2001001", name: "박이사", rank: "이사", dept: "개발팀"}
            ];
            // 제목도 자동으로 세팅해주면 좋음
            $("input[name='title']").val("연차 휴가 신청합니다.");
            $("#leaveType").val("연차");
        } else if (typeId === 2) { // 비품 구매용
            data = [
                {id: "2024009", name: "이대리", rank: "대리", dept: "총무팀"},
                {id: "2024008", name: "김과장", rank: "과장", dept: "총무팀"},
                {id: "2005002", name: "최팀장", rank: "팀장", dept: "총무팀"}
            ];
        }

        // 반복문으로 그리기
        data.forEach(p => {
            renderApproverBox(p.id, p.name, p.rank, p.dept);
        });

        // 모달 닫기
        bootstrap.Modal.getInstance(document.getElementById('modalFavorites')).hide();
    }

    // [공통] 결재선 박스 그리는 함수
    function renderApproverBox(empId, name, rank, dept) {
        $("#emptyMsg").hide();
        const count = $(".approver-box").length + 1;

        // 원하는 포맷: [개발팀] [팀장] [이름]
        const displayText = `\${dept} &nbsp;|&nbsp; \${rank} &nbsp;|&nbsp; \${name}`;

        const html = `
            <div class="approver-box">
                <span class="approver-step">\${count}차</span>
                <span class="approver-text">\${displayText}</span>
                <button type="button" class="btn-close" onclick="removeApprover(this)"></button>
                <input type="hidden" name="approvers" value="\${empId}">
            </div>
        `;
        
        $("#selectedApprovers").append(html);
    }

    // 삭제 기능
    function removeApprover(btn) {
        $(btn).parent().remove();
        
        // 순서 번호(1차, 2차...) 재정렬
        $(".approver-box").each(function(index) {
            $(this).find(".approver-step").text((index + 1) + "차");
        });

        if($(".approver-box").length === 0) {
            $("#emptyMsg").show();
        }
    }
</script>

<script src="/vendor/js/menu.js"></script>
<script src="/js/main.js"></script>
</body>
</html>
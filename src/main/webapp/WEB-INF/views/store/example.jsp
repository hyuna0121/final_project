<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="../assets/" data-template="vertical-menu-template-free">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <title>가맹점 통합 관리</title>
    
    <link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>
    
    <style>
        /* 탭 스타일 */
        .browser-tab-container { background-color: #dfe3e8; padding: 12px 12px 0 12px; border-radius: 10px 10px 0 0; margin-bottom: 0; }
        .browser-tab-nav .nav-link { border: none; border-radius: 12px 12px 0 0 !important; margin-right: 4px; background-color: #cbced4; color: #697a8d; font-weight: 600; padding: 10px 24px; transition: all 0.2s ease; cursor: pointer; }
        .browser-tab-nav .nav-link:hover { background-color: #e6e8eb; color: #566a7f; }
        .browser-tab-nav .nav-link.active { background-color: #fff !important; color: #696cff; box-shadow: 0 -2px 6px rgba(0,0,0,0.05); z-index: 2; }
        .browser-content-panel { background-color: #fff; padding: 24px; border-radius: 0 0 10px 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); min-height: 600px; border-top: none; }
        
        /* 테이블 정렬 스타일 */
        .sortable { cursor: pointer; user-select: none; position: relative; }
        .sortable:hover { background-color: #f0f2f4; color: #696cff; }
        .sort-icon { font-size: 0.8em; margin-left: 5px; color: #bbb; position: absolute; right: 8px; top: 50%; transform: translateY(-50%); }
        .sort-active { color: #696cff; } 
    </style>
  </head>

  <body>
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>
        <div class="layout-page">
          <div class="content-wrapper">
            <div class="container-xxl flex-grow-1 container-p-y">
              
              <div class="row">
                <div class="col-12">
                    

                    <div class="browser-content-panel">
                        
                        <div id="view-store" class="tab-view">
                            
                            <div class="card shadow-none border bg-transparent mb-4">
                                <div class="card-body py-3 px-3">
                                    <form id="storeSearchForm" onsubmit="return false;">
                                        <div class="row g-3">
                                            <div class="col-md-2">
                                                <label class="form-label small text-muted">운영 상태</label>
                                                <select class="form-select" id="filterStatus">
                                                    <option value="">전체</option>
                                                    <option value="OPEN">운영중</option>
                                                    <option value="CLOSED">폐업</option>
                                                    <option value="RENOVATION">인테리어 공사</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label small text-muted">주소 (지역)</label>
                                                <input type="text" class="form-control" placeholder="예: 서울 강남구" id="filterAddress" />
                                            </div>
                                            <div class="col-md-2">
                                                <label class="form-label small text-muted">오픈 시간</label>
                                                <input type="time" class="form-control" id="filterOpenTime" />
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label small text-muted">가맹점명</label>
                                                <input type="text" class="form-control" placeholder="검색어 입력" id="filterKeyword" />
                                            </div>
                                            <div class="col-md-2 d-flex align-items-end">
                                                <button class="btn btn-primary w-100" onclick="searchStores()">
                                                    <i class="bx bx-search me-1"></i> 조회
                                                </button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="card shadow-none border bg-transparent">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">가맹점 목록</h5>
                                    <div>
                                        <button class="btn btn-label-success me-2" onclick="downloadStoreExcel()">
                                            <i class="bx bxs-file-export me-1"></i> 엑셀 저장
                                        </button>
                                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerStoreModal">
                                            <i class="bx bx-plus me-1"></i> 가맹점 등록
                                        </button>
                                    </div>
                                </div>
                                <div class="table-responsive">
                                    <table class="table table-hover table-striped">
                                        <thead>
                                            <tr>
                                                <th width="5%">No</th>
                                                <th class="sortable" onclick="toggleSort(this, 'store_name')">
                                                    가맹점명 <i class="bx bx-sort-alt-2 sort-icon"></i>
                                                </th>
                                                <th class="sortable" onclick="toggleSort(this, 'store_address')">
                                                    가맹점 주소 <i class="bx bx-sort-alt-2 sort-icon"></i>
                                                </th>
                                                <th class="sortable" onclick="toggleSort(this, 'operation_status')">
                                                    운영 상태 <i class="bx bx-sort-alt-2 sort-icon"></i>
                                                </th>
                                                <th class="sortable" onclick="toggleSort(this, 'open_time')">
                                                    운영 시간 <i class="bx bx-sort-alt-2 sort-icon"></i>
                                                </th>
                                                <!-- <th>점주 정보 (ID)</th> -->
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>1</td>
                                                <td><span class="fw-bold text-primary">강남 본점</span></td>
                                                <td>서울 강남구 테헤란로 123</td>
                                                <td><span class="badge bg-label-success">오픈</span></td>
                                                <td>09:00 ~ 22:00</td>
                                                <!-- <td>김철수 (101)</td> -->
                                                <td>
                                                    <button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>2</td>
                                                <td>부산 서면점</td>
                                                <td>부산 부산진구 중앙대로 456</td>
                                                <td><span class="badge bg-label-success">오픈</span></td>
                                                <td>10:00 ~ 23:00</td>
                                                <!-- <td>이영희 (102)</td> -->
                                                <td>
                                                    <button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>3</td>
                                                <td>제주 공항점</td>
                                                <td>제주 제주시 공항로 1</td>
                                                <td><span class="badge bg-label-danger">폐업</span></td>
                                                <td>08:00 ~ 20:00</td>
                                                <!-- <td>박지성 (103)</td> -->
                                                <td>
                                                    <button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <!-- <div class="card-footer d-flex justify-content-center">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination">
                                            <li class="page-item prev"><a class="page-link" href="#"><i class="bx bx-chevron-left"></i></a></li>
                                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                            <li class="page-item"><a class="page-link" href="#">2</a></li>
                                            <li class="page-item next"><a class="page-link" href="#"><i class="bx bx-chevron-right"></i></a></li>
                                        </ul>
                                    </nav>
                                </div> -->
                            </div>
                        </div>

                        <div id="view-contract" class="tab-view" style="display:none;">
                            <div class="alert alert-secondary">계약 조회 화면 (기존 코드 유지)</div>
                        </div>

                        <div id="view-evaluation" class="tab-view" style="display:none;">
                            <div class="alert alert-secondary">평가 조회 화면 (기존 코드 유지)</div>
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

    <div class="modal fade" id="registerStoreModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">🏢 신규 가맹점 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="registerStoreForm">
                        <div class="row g-3">
                            
                            <div class="col-md-6">
                                <label class="form-label" for="storeName">가맹점명 <span class="text-danger">*</span></label>
                                <div class="input-group input-group-merge">
                                    <span class="input-group-text"><i class="bx bx-store"></i></span>
                                    <input type="text" id="storeName" class="form-control" placeholder="가맹점 이름 입력" required />
                                </div>
                            </div>

                            <!-- <div class="col-md-6">
                                <label class="form-label" for="memberId">점주(사원) 선택 <span class="text-danger">*</span></label>
                                <select id="memberId" class="form-select" required>
                                    <option value="">점주를 선택하세요</option>
                                    <option value="101">김철수 (ID: 101)</option>
                                    <option value="102">이영희 (ID: 102)</option>
                                    <option value="103">박지성 (ID: 103)</option>
                                </select>
                            </div> -->

                            <div class="col-md-12">
                                <label class="form-label" for="storeAddress">가맹점 주소 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" id="storeAddress" class="form-control" placeholder="주소 검색 버튼을 클릭하세요" readonly required />
                                    <button class="btn btn-outline-primary" type="button" onclick="openAddressApi()">
                                        <i class="bx bx-map me-1"></i> 주소 검색
                                    </button>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-muted">위도 (Latitude)</label>
                                <input type="text" id="latitude" class="form-control bg-light" placeholder="주소 선택 시 자동 입력" readonly />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">경도 (Longitude)</label>
                                <input type="text" id="longitude" class="form-control bg-light" placeholder="주소 선택 시 자동 입력" readonly />
                            </div>

                            <hr class="my-4" />

                            <div class="col-md-4">
                                <label class="form-label" for="operationStatus">운영 상태</label>
                                <select id="operationStatus" class="form-select">
                                    <option value="OPEN">운영중 (OPEN)</option>
                                    <option value="CLOSED">폐업 (CLOSED)</option>
                                    <option value="RENOVATION">인테리어 공사중</option>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label" for="openTime">오픈 시간</label>
                                <input type="time" id="openTime" class="form-control" value="09:00" />
                            </div>

                            <div class="col-md-4">
                                <label class="form-label" for="closeTime">마감 시간</label>
                                <input type="time" id="closeTime" class="form-control" value="22:00" />
                            </div>

                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitStoreRegistration()">저장</button>
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
    // 1. 탭 전환
    function switchTab(tabName) {
        $('.browser-tab-nav .nav-link').removeClass('active');
        event.currentTarget.classList.add('active');
        $('.tab-view').hide();
        $('#view-' + tabName).fadeIn(200);
    }

    // 2. 테이블 정렬 (오름차순/내림차순 토글)
    function toggleSort(thElement, column) {
        // 모든 아이콘 초기화
        $('.sort-icon').removeClass('bx-sort-up bx-sort-down sort-active').addClass('bx-sort-alt-2');
        
        const icon = $(thElement).find('i');
        let currentOrder = $(thElement).data('order') || 'none';
        
        // 정렬 상태 토글
        if (currentOrder === 'asc') {
            $(thElement).data('order', 'desc');
            icon.removeClass('bx-sort-alt-2').addClass('bx-sort-down sort-active');
            console.log(`Sort by ${column} DESC`); // 서버 요청 시 사용
        } else {
            $(thElement).data('order', 'asc');
            icon.removeClass('bx-sort-alt-2').addClass('bx-sort-up sort-active');
            console.log(`Sort by ${column} ASC`); // 서버 요청 시 사용
        }
    }

    // 3. 검색 기능 (콘솔 확인용)
    function searchStores() {
        const params = {
            status: $('#filterStatus').val(),
            address: $('#filterAddress').val(),
            openTime: $('#filterOpenTime').val(),
            keyword: $('#filterKeyword').val()
        };
        console.log("검색 요청:", params);
        alert("검색 조건으로 조회합니다. (콘솔 확인)");
    }

    // 4. 엑셀 다운로드
    function downloadStoreExcel() {
        if(confirm("전체 가맹점 목록을 엑셀로 저장하시겠습니까?\n(포함 항목: 가맹점명, 주소, 운영상태, 운영시간, 점주정보)")) {
            // 실제 구현: window.location.href = '/store/excel/download';
            alert("가맹점_목록.xlsx 다운로드가 시작되었습니다.");
        }
    }

    // 5. 주소 API (Daum/Kakao 주소 API 연동 예시)
    function openAddressApi() {
        // 실제 API 연동 시: new daum.Postcode({...}).open();
        alert("주소 검색 API 팝업이 열립니다.");
        
        // (더미 데이터 세팅)
        $('#storeAddress').val("서울 강남구 테헤란로 123");
        $('#latitude').val("37.5665");
        $('#longitude').val("126.9780");
    }

    // 6. 가맹점 등록 저장
    function submitStoreRegistration() {
        // 폼 유효성 검사
        if(!$('#storeName').val() || !$('#memberId').val() || !$('#storeAddress').val()) {
            alert("필수 항목(가맹점명, 점주, 주소)을 입력해주세요.");
            return;
        }
        
        // AJAX 요청 로직 들어갈 자리
        const formData = {
            store_name: $('#storeName').val(),
            member_id: $('#memberId').val(),
            store_address: $('#storeAddress').val(),
            latitude: $('#latitude').val(),
            longitude: $('#longitude').val(),
            operation_status: $('#operationStatus').val(),
            open_time: $('#openTime').val(),
            close_time: $('#closeTime').val()
        };
        
        console.log("등록 데이터:", formData);
        alert("신규 가맹점이 등록되었습니다.");
        $('#registerStoreModal').modal('hide');
        // location.reload();
    }
    </script>
  </body>
</html>
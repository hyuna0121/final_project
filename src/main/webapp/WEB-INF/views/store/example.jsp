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
                    
                    <div class="browser-tab-container">
                        <ul class="nav nav-tabs browser-tab-nav border-0" role="tablist">
                            <li class="nav-item">
                                <button type="button" class="nav-link" onclick="switchTab('store')">
                                    <i class="bx bx-store me-1"></i> 가맹점 조회
                                </button>
                            </li>
                            <li class="nav-item">
                                <button type="button" class="nav-link active" onclick="switchTab('contract')">
                                    <i class="bx bx-file me-1"></i> 계약 조회
                                </button>
                            </li>
                            <li class="nav-item">
                                <button type="button" class="nav-link" onclick="switchTab('evaluation')">
                                    <i class="bx bx-clipboard me-1"></i> 평가 조회
                                </button>
                            </li>
                        </ul>
                    </div>

                    <div class="browser-content-panel">
                        
                        <div id="view-store" class="tab-view" style="display:none;">
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
                                                <label class="form-label small text-muted">가맹점명 / 점주명</label>
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
                                                <th class="sortable" onclick="toggleSort(this, 'store_name')">가맹점명 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th class="sortable" onclick="toggleSort(this, 'store_address')">주소 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th class="sortable" onclick="toggleSort(this, 'operation_status')">상태 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th class="sortable" onclick="toggleSort(this, 'open_time')">운영 시간 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th>점주 정보</th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>1</td>
                                                <td><span class="fw-bold text-primary">강남 본점</span></td>
                                                <td>서울 강남구 테헤란로 123</td>
                                                <td><span class="badge bg-label-success">OPEN</span></td>
                                                <td>09:00 ~ 22:00</td>
                                                <td>김철수 (101)</td>
                                                <td><button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div id="view-contract" class="tab-view">
                            
                            <div class="card shadow-none border bg-transparent mb-4">
                                <div class="card-body py-3 px-3">
                                    <form id="contractSearchForm" onsubmit="return false;">
                                        <div class="row g-3">
                                            <div class="col-md-2">
                                                <label class="form-label small text-muted">계약 상태</label>
                                                <select class="form-select" id="searchContractStatus">
                                                    <option value="">전체</option>
                                                    <option value="ACTIVE">유효 (Active)</option>
                                                    <option value="EXPIRED">만료 (Expired)</option>
                                                    <option value="TERMINATED">해지 (Terminated)</option>
                                                </select>
                                            </div>
                                            <div class="col-md-4">
                                                <label class="form-label small text-muted">계약 시작일 구간</label>
                                                <div class="input-group">
                                                    <input type="date" class="form-control" id="searchStartDateFrom" />
                                                    <span class="input-group-text">~</span>
                                                    <input type="date" class="form-control" id="searchStartDateTo" />
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <label class="form-label small text-muted">가맹점 주소</label>
                                                <input type="text" class="form-control" placeholder="시/군/구 입력" id="searchStoreAddress" />
                                            </div>

                                            <div class="col-md-3">
                                                <label class="form-label small text-muted">로얄티 / 여신(보증금)</label>
                                                <div class="input-group">
                                                    <select class="form-select" style="flex: 0 0 40%;">
                                                        <option value="royalti">로얄티</option>
                                                        <option value="deposit">여신</option>
                                                    </select>
                                                    <input type="number" class="form-control" placeholder="최소 금액" />
                                                </div>
                                            </div>
                                            <div class="col-md-3">
                                                <label class="form-label small text-muted">가맹점명 검색</label>
                                                <div class="input-group input-group-merge">
                                                    <span class="input-group-text"><i class="bx bx-search"></i></span>
                                                    <input type="text" class="form-control" placeholder="가맹점 이름" id="searchStoreName" />
                                                </div>
                                            </div>
                                            <div class="col-md-6 d-flex align-items-end justify-content-end gap-2">
                                                <button class="btn btn-outline-secondary" type="reset"><i class="bx bx-refresh"></i> 초기화</button>
                                                <button class="btn btn-primary px-5" onclick="searchContracts()"><i class="bx bx-search"></i> 조회</button>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>

                            <div class="card shadow-none border bg-transparent">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">가맹점 계약 목록</h5>
                                    <div>
                                        <button class="btn btn-label-success me-2" onclick="downloadContractExcel()">
                                            <i class="bx bxs-file-export me-1"></i> 엑셀 저장
                                        </button>
                                        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerContractModal">
                                            <i class="bx bx-plus me-1"></i> 계약 등록
                                        </button>
                                    </div>
                                </div>
                                <div class="table-responsive text-nowrap">
                                    <table class="table table-hover table-striped">
                                        <thead>
                                            <tr>
                                                <th width="5%">No</th>
                                                <th class="sortable" onclick="toggleSort(this, 'contract_id')">계약번호 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th class="sortable" onclick="toggleSort(this, 'store_name')">가맹점명 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th class="sortable" onclick="toggleSort(this, 'royalti')">로얄티 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th class="sortable" onclick="toggleSort(this, 'deposit')">여신(보증금) <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th class="sortable" onclick="toggleSort(this, 'start_date')">계약 시작일 <i class="bx bx-sort-alt-2 sort-icon"></i></th>
                                                <th>계약 종료일</th>
                                                <th>상태</th>
                                                <th>관리</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>1</td>
                                                <td>
                                                    <a href="javascript:void(0);" class="fw-bold" 
                                                       onclick="openContractDetail('CT-2024-001', '강남 본점', '150,000', '50,000,000', '2024-01-01', '2026-01-01', 'ACTIVE')">
                                                        CT-2024-001
                                                    </a>
                                                </td>
                                                <td><a href="javascript:void(0);" class="text-dark">강남 본점</a></td>
                                                <td>150,000원</td>
                                                <td>50,000,000원</td>
                                                <td>2024-01-01</td>
                                                <td>2026-01-01</td>
                                                <td><span class="badge bg-label-primary">ACTIVE</span></td>
                                                <td><button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button></td>
                                            </tr>
                                            <tr>
                                                <td>2</td>
                                                <td>
                                                    <a href="javascript:void(0);" class="fw-bold"
                                                       onclick="openContractDetail('CT-2023-088', '부산 서면점', '150,000', '30,000,000', '2023-05-01', '2025-05-01', 'ACTIVE')">
                                                        CT-2023-088
                                                    </a>
                                                </td>
                                                <td><a href="javascript:void(0);" class="text-dark">부산 서면점</a></td>
                                                <td>150,000원</td>
                                                <td>30,000,000원</td>
                                                <td>2023-05-01</td>
                                                <td>2025-05-01</td>
                                                <td><span class="badge bg-label-primary">ACTIVE</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>3</td>
                                                <td>
                                                    <a href="javascript:void(0);" class="fw-bold text-muted"
                                                       onclick="openContractDetail('CT-2020-012', '제주 공항점', '150,000', '20,000,000', '2020-03-01', '2022-03-01', 'EXPIRED')">
                                                        CT-2020-012
                                                    </a>
                                                </td>
                                                <td><a href="javascript:void(0);" class="text-dark">제주 공항점</a></td>
                                                <td>150,000원</td>
                                                <td>20,000,000원</td>
                                                <td>2020-03-01</td>
                                                <td>2022-03-01</td>
                                                <td><span class="badge bg-label-danger">EXPIRED</span></td>
                                                <td>
                                                    <button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <div class="card-footer d-flex justify-content-center">
                                    <nav aria-label="Page navigation">
                                        <ul class="pagination">
                                            <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                        </ul>
                                    </nav>
                                </div>
                            </div>
                        </div>

                        <div id="view-evaluation" class="tab-view" style="display:none;">
                            <div class="alert alert-secondary">평가 조회 화면</div>
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
                                <label class="form-label">가맹점명 <span class="text-danger">*</span></label>
                                <input type="text" id="storeName" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">점주 선택 <span class="text-danger">*</span></label>
                                <select id="memberId" class="form-select" required>
                                    <option value="">점주를 선택하세요</option>
                                    <option value="101">김철수</option>
                                </select>
                            </div>
                            <div class="col-md-12">
                                <label class="form-label">가맹점 주소 <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <input type="text" id="storeAddress" class="form-control" readonly required />
                                    <button class="btn btn-outline-primary" type="button" onclick="alert('주소 API')">주소 검색</button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">위도</label>
                                <input type="text" id="latitude" class="form-control bg-light" readonly />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-muted">경도</label>
                                <input type="text" id="longitude" class="form-control bg-light" readonly />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">운영 상태</label>
                                <select id="operationStatus" class="form-select">
                                    <option value="OPEN">운영중</option>
                                    <option value="CLOSED">폐업</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">오픈 시간</label>
                                <input type="time" id="openTime" class="form-control" value="09:00" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">마감 시간</label>
                                <input type="time" id="closeTime" class="form-control" value="22:00" />
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary">저장</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="registerContractModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">📑 가맹점 계약 등록</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="registerContractForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label" for="contractId">계약 번호 <span class="text-danger">*</span></label>
                                <input type="text" id="contractId" class="form-control" placeholder="예: CT-2025-001" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="contractStoreId">가맹점 선택 <span class="text-danger">*</span></label>
                                <select id="contractStoreId" class="form-select" required>
                                    <option value="">가맹점을 선택하세요</option>
                                    <option value="1">강남 본점</option>
                                </select>
                            </div>
                            <div class="col-12"><hr class="my-2"></div>
                            
                            <div class="col-md-6">
                                <label class="form-label" for="royalty">로얄티 (금액)</label>
                                <div class="input-group">
                                    <input type="number" id="royalty" class="form-control" placeholder="150000" />
                                    <span class="input-group-text">원</span>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label" for="deposit">여신 (보증금)</label>
                                <div class="input-group">
                                    <span class="input-group-text">₩</span>
                                    <input type="number" id="deposit" class="form-control" placeholder="50000000" />
                                    <span class="input-group-text">원</span>
                                </div>
                            </div>
                            <div class="col-12"><hr class="my-2"></div>
                            <div class="col-md-6">
                                <label class="form-label" for="startDate">계약 시작일</label>
                                <input type="date" id="startDate" class="form-control" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label" for="endDate">계약 종료일</label>
                                <input type="date" id="endDate" class="form-control" required />
                            </div>
                            <div class="col-md-12">
                                <label class="form-label" for="contractStatus">초기 계약 상태</label>
                                <select id="contractStatus" class="form-select">
                                    <option value="ACTIVE">ACTIVE (유효)</option>
                                    <option value="PENDING">PENDING (대기)</option>
                                </select>
                            </div>

                            <div class="col-12 mt-3">
                                <label class="form-label">계약서 및 첨부파일</label>
                                <div id="fileContainer">
                                    <div class="input-group mb-2">
                                        <input type="file" class="form-control" name="contractFiles">
                                        <button type="button" class="btn btn-outline-primary" onclick="addFileField()">
                                            <i class="bx bx-plus"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="form-text small text-muted">
                                    ※ 버튼을 누르면 첨부파일 칸이 추가됩니다.
                                </div>
                            </div>

                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary" onclick="submitContractRegistration()">계약 저장</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="detailContractModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">📋 계약 상세 정보</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label text-muted small">계약 번호</label>
                            <input type="text" id="detailContractId" class="form-control bg-white fw-bold" readonly />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small">가맹점명</label>
                            <input type="text" id="detailStoreName" class="form-control bg-white" readonly />
                        </div>
                        <div class="col-12"><hr class="my-1 border-light"></div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small">로얄티</label>
                            <input type="text" id="detailRoyalty" class="form-control bg-white" readonly />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label text-muted small">여신(보증금)</label>
                            <input type="text" id="detailDeposit" class="form-control bg-white" readonly />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted small">시작일</label>
                            <input type="text" id="detailStartDate" class="form-control bg-white" readonly />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted small">종료일</label>
                            <input type="text" id="detailEndDate" class="form-control bg-white" readonly />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label text-muted small">상태</label>
                            <input type="text" id="detailStatus" class="form-control bg-white" readonly />
                        </div>
                        
                        <div class="col-12 mt-4">
                            <h6 class="text-muted mb-3"><i class="bx bx-file"></i> 첨부파일 다운로드</h6>
                            <ul class="list-group">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        <i class="bx bxs-file-pdf text-danger me-2 fs-4"></i>
                                        <span>2024_표준가맹계약서.pdf</span>
                                    </div>
                                    <button class="btn btn-sm btn-outline-primary" onclick="downloadAttachment('contract.pdf')">
                                        <i class="bx bx-download"></i> 다운로드
                                    </button>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        <i class="bx bxs-file-image text-primary me-2 fs-4"></i>
                                        <span>사업자등록증_사본.jpg</span>
                                    </div>
                                    <button class="btn btn-sm btn-outline-primary" onclick="downloadAttachment('license.jpg')">
                                        <i class="bx bx-download"></i> 다운로드
                                    </button>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <button type="button" class="btn btn-danger" onclick="downloadContractPdf()">
                        <i class="bx bxs-file-pdf me-1"></i> 계약서 PDF 저장
                    </button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
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

    // 2. 테이블 정렬
    function toggleSort(thElement, column) {
        $('.sort-icon').removeClass('bx-sort-up bx-sort-down sort-active').addClass('bx-sort-alt-2');
        const icon = $(thElement).find('i');
        let currentOrder = $(thElement).data('order') || 'none';
        
        if (currentOrder === 'asc') {
            $(thElement).data('order', 'desc');
            icon.removeClass('bx-sort-alt-2').addClass('bx-sort-down sort-active');
        } else {
            $(thElement).data('order', 'asc');
            icon.removeClass('bx-sort-alt-2').addClass('bx-sort-up sort-active');
        }
    }

    // 3. 계약 조회 (더미)
    function searchContracts() {
        alert("계약 정보를 조회합니다. (콘솔 로그 확인)");
    }

    // 4. 엑셀 다운로드 (더미)
    function downloadContractExcel() {
        if(confirm("조회된 계약 목록을 엑셀로 저장하시겠습니까?")) {
            alert("contract_list.xlsx 다운로드가 시작되었습니다.");
        }
    }
    
    function downloadStoreExcel() {
        if(confirm("가맹점 목록을 엑셀로 저장하시겠습니까?")) {
            alert("store_list.xlsx 다운로드가 시작되었습니다.");
        }
    }

    // 5. 계약 등록 저장
    function submitContractRegistration() {
        alert("신규 계약이 등록되었습니다.");
        $('#registerContractModal').modal('hide');
    }

    /* =========================================
       [파일 첨부 기능] 동적 추가/삭제
       ========================================= */
    function addFileField() {
        const container = document.getElementById('fileContainer');
        const newDiv = document.createElement('div');
        newDiv.className = 'input-group mb-2';
        newDiv.innerHTML = `
            <input type="file" class="form-control" name="contractFiles">
            <button type="button" class="btn btn-outline-danger" onclick="removeFileField(this)">
                <i class="bx bx-minus"></i>
            </button>
        `;
        container.appendChild(newDiv);
    }

    function removeFileField(button) {
        button.parentElement.remove();
    }
    
    /* =========================================
       [계약 상세 조회 기능] (NEW)
       ========================================= */
    function openContractDetail(id, store, royalty, deposit, start, end, status) {
        // 모달 필드에 값 채워넣기
        $('#detailContractId').val(id);
        $('#detailStoreName').val(store);
        $('#detailRoyalty').val(royalty + "원");
        $('#detailDeposit').val(deposit + "원");
        $('#detailStartDate').val(start);
        $('#detailEndDate').val(end);
        $('#detailStatus').val(status);
        
        // 모달 띄우기
        $('#detailContractModal').modal('show');
    }

    // PDF 다운로드 (shell)
    function downloadContractPdf() {
        const id = $('#detailContractId').val();
        alert(`[${id}] 계약서 문서를 PDF로 생성하여 다운로드합니다.`);
    }

    // 첨부파일 다운로드 (shell)
    function downloadAttachment(fileName) {
        alert(`첨부파일 [${fileName}] 을(를) 다운로드합니다.`);
    }
    
    // 가맹점 조회 로직 (기존)
    function searchStores() { alert("가맹점 조회"); }
    </script>
  </body>
</html>
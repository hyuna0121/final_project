<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html
  lang="en"
  class="light-style layout-menu-fixed"
  dir="ltr"
  data-theme="theme-default"
  data-assets-path="../assets/"
  data-template="vertical-menu-template-free"
>
  <head>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0"
    />

    <title>HQ Payable List</title> 

    <!-- flatpickr -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/style.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>

    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
      rel="stylesheet"
    />

    <!-- Icons -->
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />

    <!-- Core CSS -->
    <link rel="stylesheet" href="/vendor/css/core.css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" />
    <link rel="stylesheet" href="/css/demo.css" />

    <!-- Vendors CSS -->
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="/vendor/libs/apex-charts/apex-charts.css" />


    <link rel="stylesheet" href="/css/receivable/receivable-vendor.css" />
    <!-- Helpers -->
    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>
  </head>

  <body>
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">

        <c:import url="/WEB-INF/views/template/aside.jsp"/>

        <div class="layout-page">
          <c:import url="/WEB-INF/views/template/header.jsp"/>

          <div class="content-wrapper d-flex flex-column">
<div class="container-xxl flex-grow-1 container-p-y">
  <div class="row">
    <div class="col-12">
      <div class="card mb-4 shadow-sm border-0">
        <div class="card-header d-flex align-items-center justify-content-between">
          <h5 class="mb-0 fw-bold"><i class="bx bx-search-alt me-2 text-primary"></i>미지급금 조회 조건</h5>
        </div>
        <div class="card-body">
          <form id="searchForm" class="row g-3">
            <div class="col-md-3">
              <label class="form-label fw-semibold">지급 상태</label>
              <select name="payStatus" class="form-select border-primary-subtle">
                <option value="">전체 상태</option>
                <option value="UNPAID">미지급</option>
                <option value="PARTIAL">부분 지급</option>
              </select>
            </div>
            <div class="col-md-3">
              <label class="form-label fw-semibold">기준 월</label>
              <div class="input-group input-group-merge">
                <span class="input-group-text"><i class="bx bx-calendar"></i></span>
                <input type="text" id="baseMonth" name="baseMonth" class="form-control border-primary-subtle" placeholder="YYYY-MM" />
              </div>
            </div>
            <div class="col-md-3">
              <label class="form-label fw-semibold">거래처명</label>
              <div class="input-group input-group-merge">
                <span class="input-group-text"><i class="bx bx-buildings"></i></span>
                <input type="text" name="vendorName" class="form-control border-primary-subtle" placeholder="거래처 검색" />
              </div>
            </div>
            <div class="col-md-3 d-flex align-items-end">
              <button type="button" class="btn btn-primary w-100 fw-bold shadow-sm" onclick="searchPayables()">
                <i class="bx bx-search-alt-2 me-1"></i> 데이터 조회
              </button>
            </div>
            <input type="hidden" name="pager.page" value="1">
          </form>
        </div>
      </div>
    </div>

    <div id="summaryArea" class="row mb-4 d-none">
      <div class="col-md-4">
        <div class="card bg-label-danger border-0 shadow-none">
          <div class="card-body d-flex align-items-center">
            <div class="avatar flex-shrink-0 me-3">
              <span class="avatar-initial rounded bg-danger shadow-sm"><i class="bx bx-error"></i></span>
            </div>
            <div>
              <small class="text-danger fw-semibold d-block">총 미지급금 합계</small>
              <h4 class="fw-bold mb-0 text-dark" id="totalUnpaidAmount">0</h4>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card bg-label-info border-0 shadow-none">
          <div class="card-body d-flex align-items-center">
            <div class="avatar flex-shrink-0 me-3">
              <span class="avatar-initial rounded bg-info shadow-sm"><i class="bx bx-spreadsheet"></i></span>
            </div>
            <div>
              <small class="text-info fw-semibold d-block">미지급 발주 건수</small>
              <h4 class="fw-bold mb-0 text-dark" id="payableCount">0</h4>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card bg-label-secondary border-0 shadow-none">
          <div class="card-body d-flex align-items-center">
            <div class="avatar flex-shrink-0 me-3">
              <span class="avatar-initial rounded bg-secondary shadow-sm"><i class="bx bx-calendar-check"></i></span>
            </div>
            <div>
              <small class="text-secondary fw-semibold d-block">조회 대상 월</small>
              <h4 class="fw-bold mb-0 text-dark" id="summaryBaseMonth">-</h4>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="col-12">
      <div class="card shadow-sm border-0">
        <div class="card-header border-bottom d-flex justify-content-between align-items-center">
          <h5 class="mb-0 fw-bold">본사 발주 미지급금 목록</h5>
          <span class="badge bg-label-secondary">Search Result</span>
        </div>
        <div class="card-body p-0">
          <div id="emptyMessage" class="text-center text-muted py-5">
            <i class="bx bx-search-alt-2 fs-1 d-block mb-3 opacity-25"></i>
            조회 조건을 선택한 후 검색하세요.
          </div>
          <div id="payableTableArea" class="table-responsive d-none">
             </div>
        </div>
      </div>
    </div>
  </div>
</div>

            <c:import url="/WEB-INF/views/template/footer.jsp"/>
            <div class="content-backdrop fade"></div>
          </div>
        </div>
      </div>

      <div class="layout-overlay layout-menu-toggle"></div>
    </div>


	
<div class="modal fade" id="payModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content border-0 shadow-lg">
      <div class="modal-header bg-primary">
        <h5 class="modal-title text-white fw-bold"><i class="bx bx-wallet me-2"></i>미지급금 지급 등록</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body p-4">
        <form id="payForm">
          <input type="hidden" name="vendorId">
          <input type="hidden" name="vendorCode">
          <input type="hidden" name="baseMonth">
          <input type="hidden" name="remainAmount">

          <div class="mb-3">
            <label class="form-label fw-bold">대상 채권 선택</label>
            <div class="input-group input-group-merge">
              <span class="input-group-text"><i class="bx bx-list-check"></i></span>
              <select class="form-select border-primary-subtle fw-bold" name="receivableId" id="receivableSelect">
                <option value="">채권을 선택하세요</option>
              </select>
            </div>
          </div>

          <div class="row g-3 mb-3">
            <div class="col-md-6">
              <label class="form-label">거래처</label>
              <input type="text" class="form-control bg-light border-0 fw-bold" name="vendorName" readonly>
            </div>
            <div class="col-md-6">
              <label class="form-label">기준월</label>
              <input type="text" class="form-control bg-light border-0 fw-bold" name="baseMonthView" readonly>
            </div>
          </div>

          <div class="p-3 bg-label-secondary rounded mb-3 border border-dashed border-secondary">
            <div class="d-flex justify-content-between align-items-center mb-1">
              <span class="small fw-semibold">남은 미지급 잔액</span>
              <input type="text" class="form-control-plaintext text-end fw-bold text-danger fs-5 py-0" name="remainAmountView" value="0" readonly>
            </div>
          </div>

          <div class="mb-3">
            <label class="form-label fw-bold text-primary">금회 지급 금액</label>
            <div class="input-group input-group-merge border-primary">
              <span class="input-group-text"><i class="bx bx-won"></i></span>
              <input type="text" class="form-control form-control-lg fw-bold text-primary border-primary-subtle" name="payAmount" value="0" inputmode="numeric">
            </div>
          </div>

          <div class="mb-3 d-flex flex-wrap gap-1">
            <button type="button" class="btn btn-outline-secondary btn-sm pay-btn" data-amount="10000">+1만</button>
            <button type="button" class="btn btn-outline-secondary btn-sm pay-btn" data-amount="50000">+5만</button>
            <button type="button" class="btn btn-outline-secondary btn-sm pay-btn" data-amount="100000">+10만</button>
            <button type="button" class="btn btn-label-primary btn-sm px-3" id="btnPayAll">전액 완납</button>
            <button type="button" class="btn btn-label-danger btn-sm" id="btnPayReset"><i class="bx bx-refresh"></i></button>
          </div>

          <div class="mb-0">
            <label class="form-label">지급 비고 (메모)</label>
            <textarea class="form-control" name="memo" rows="2" placeholder="전달사항 입력"></textarea>
          </div>
        </form>
      </div>
      <div class="modal-footer bg-light border-top">
        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary fw-bold" id="btnPaySubmit">지급 확정</button>
      </div>
    </div>
  </div>
</div>

	
    <!-- Core JS -->
    <script src="/vendor/libs/jquery/jquery.js"></script>
    <script src="/vendor/libs/popper/popper.js"></script>
    <script src="/vendor/js/bootstrap.js"></script>
    <script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="/vendor/js/menu.js"></script>

    <script src="/vendor/libs/apex-charts/apexcharts.js"></script>
    <script src="/js/main.js"></script>
    <script src="/js/dashboards-analytics.js"></script>

    <script src="/js/pager/pagination.js"></script>
	<script type="text/javascript" src="/js/receivable/receivable-vendor.js"></script>
	<script type="text/javascript" src="/js/receivable/receivable-vendor-payment.js"></script>
	
  </body>
</html>

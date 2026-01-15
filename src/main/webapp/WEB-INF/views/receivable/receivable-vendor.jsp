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

    <title>HQ Payable List</title> <!-- ★ HQ 변경 -->

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

          <div class="content-wrapper">
            <div class="container-xxl flex-grow-1 container-p-y">
              <div class="row">

                <!-- 조회 조건 -->
                <div class="card mb-4">
                  <div class="card-header">
                    <h5 class="mb-0">조회 조건</h5>
                  </div>

                  <div class="card-body">
					<form id="searchForm" class="row g-3">
					
					
					<!-- 지급 상태 -->
					  <div class="col-md-3">
					    <label class="form-label">지급 상태</label>
					    <select name="payStatus" class="form-select">
					      <option value="">전체</option>
					      <option value="UNPAID">미지급</option>
					      <option value="PARTIAL">부분 지급</option>
					    </select>
					  </div>
					
					  <!-- 기준 월 -->
					  <div class="col-md-3">
					    <label class="form-label">기준 월</label>
					    <input type="text"
					           id="baseMonth"
					           name="baseMonth"
					           class="form-control"
					           placeholder="기준 월 선택" />
					  </div>
					
					  <!-- 거래처명 -->
					  <div class="col-md-3">
					    <label class="form-label">거래처명</label>
					    <input type="text"
					           name="vendorName"
					           class="form-control"
					           placeholder="거래처명 입력" />
					  </div>
					

					
					  <!-- 조회 -->
					  <div class="col-md-3 d-flex align-items-end">
					    <button type="button"
					            class="btn btn-primary w-100"
					            onclick="searchPayables()">
					      조회
					    </button>
					  </div>
					
					  <input type="hidden" name="pager.page" value="1">
					</form>
                  </div>
                </div>

                <!-- 요약 -->
                <div id="summaryArea" class="row mb-4 d-none">

                  <div class="col-md-4">
                    <div class="card h-100">
                      <div class="card-body">
                        <div class="text-muted small">총 미지급금</div>
                        <h4 class="fw-bold text-danger mb-0" id="totalUnpaidAmount">0</h4>
                      </div>
                    </div>
                  </div>

                  <div class="col-md-4">
                    <div class="card h-100">
                      <div class="card-body">
                        <div class="text-muted small">미지급 발주 수</div>
                        <h4 class="fw-bold mb-0" id="payableCount">0</h4>
                      </div>
                    </div>
                  </div>

                  <div class="col-md-4">
                    <div class="card h-100">
                      <div class="card-body">
                        <div class="text-muted small">기준 월</div>
                        <h4 class="fw-bold mb-0" id="summaryBaseMonth">-</h4>
                      </div>
                    </div>
                  </div>

                </div>

                <!-- 리스트 -->
                <div class="card">
                  <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">본사 발주 미지급금 목록</h5>
                    <small class="text-muted">※ 조회 조건 선택 후 조회</small>
                  </div>

                  <div class="card-body">
                    <div id="emptyMessage" class="text-center text-muted py-5">
                      조회 조건을 선택한 후 검색하세요.
                    </div>

                    <div id="payableTableArea" class="table-responsive d-none"></div>
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
    
  </body>
</html>

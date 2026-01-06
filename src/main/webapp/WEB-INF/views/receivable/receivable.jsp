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

    <title>Receivable List</title>

    <meta name="description" content="" />
	
	
	<!-- flatpickr 기본 -->
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
	<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	
	<!-- 월 선택 플러그인 -->
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

    <!-- Icons. Uncomment required icon fonts -->
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />

    <!-- Core CSS -->
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />

    <!-- Vendors CSS -->
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />

    <link rel="stylesheet" href="/vendor/libs/apex-charts/apex-charts.css" />

    <!-- Page CSS -->

    <!-- Helpers -->
    <script src="/vendor/js/helpers.js"></script>

    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <script src="/js/config.js"></script>
  </head>

  <body>
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
        <!-- Menu -->
		<c:import url="/WEB-INF/views/template/aside.jsp"></c:import>
        <!-- / Menu -->

        <!-- Layout container -->
        <div class="layout-page">
		<c:import url="/WEB-INF/views/template/header.jsp"></c:import>
        
          <!-- Content wrapper -->
          <div class="content-wrapper">
            <!-- Content -->

            <div class="container-xxl flex-grow-1 container-p-y">
              <div class="row">
              
				<!-- 조회 조건 -->
				<div class="card mb-4">
				  <div class="card-header">
				    <h5 class="mb-0">조회 조건</h5>
				  </div>
				
				  <div class="card-body">
				    <form id="searchForm" class="row g-3">
				      <!-- 채권 발생 구분 -->
				      <div class="col-md-3">
				        <label class="form-label">채권 발생 구분</label>
				        <select name="sourceType" class="form-select">
				          <option value="">전체</option>
				          <option value="CONTRACT">계약 미수금</option>
				          <option value="ORDER">발주 미수금</option>
				        </select>
				      </div>
				
				      <!-- 기준 월 -->
				      <div class="col-md-3">
				        <label class="form-label">기준 월</label>
				        <input 
				        	type="text"
				        	id="baseMonth" 
				        	name="baseMonth"
				        	placeholder="기준 월 선택"
				        	class="form-control" />
				      </div>
				
				      <!-- 지점명 -->
				      <div class="col-md-3">
				        <label class="form-label">지점명</label>
				        <input type="text"
				               name="storeName"
				               class="form-control"
				               placeholder="지점명 입력" />
				      </div>
				      <!-- 조회 버튼 -->
				      <div class="col-md-3 d-flex align-items-end">
				        <button type="button"
				                class="btn btn-primary w-100"
				                onclick="searchReceivables()">
				          조회
				        </button>
				      </div>
				      <input type="hidden" name="pager.page" value="1">
				    </form>
				  </div>
				</div>
				<!-- 조회 조건 끝 -->
				
				<div class="card">
				  <div class="card-header d-flex justify-content-between align-items-center">
				    <h5 class="mb-0">채권 목록 (미수금)</h5>
				    <small class="text-muted">※ 조회 조건 선택 후 조회</small>
				  </div>
				
				  <div class="card-body">
				
				    <!-- 조회 전 안내 -->
				    <div id="emptyMessage"
				         class="text-center text-muted py-5">
				      조회 조건을 선택한 후 검색하세요.
				    </div>
				
				    <!-- 조회 결과 테이블 -->
				    <div id="receivableTableArea" class="table-responsive d-none">
				      <!-- AJAX로 테이블 삽입 -->
				    </div>
				
				  </div>
				</div>
              </div>
            </div>
            <!-- / Content -->

            <!-- Footer -->
            <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
            <!-- / Footer -->

            <div class="content-backdrop fade"></div>
          </div>
          <!-- Content wrapper -->
        </div>
        <!-- / Layout page -->
      </div>

      <!-- Overlay -->
      <div class="layout-overlay layout-menu-toggle"></div>
    </div>
    <!-- / Layout wrapper -->
    <!-- Core JS -->
    <!-- build:js assets/vendor/js/core.js -->
    <script src="/vendor/libs/jquery/jquery.js"></script>
    <script src="/vendor/libs/popper/popper.js"></script>
    <script src="/vendor/js/bootstrap.js"></script>
    <script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="/vendor/js/menu.js"></script>
    
    
    
    <!-- endbuild -->

    <!-- Vendors JS -->
    <script src="/vendor/libs/apex-charts/apexcharts.js"></script>

    <!-- Main JS -->
    <script src="/js/main.js"></script>

    <!-- Page JS -->
    <script src="/js/dashboards-analytics.js"></script>

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    
    
    <script type="text/javascript" src="/js/pager/pagination.js"></script>
    <script type="text/javascript" src="/js/receivable/receivable.js"></script>
  </body>
</html>



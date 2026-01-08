<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>

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

    <title>Dashboard - Analytics | Sneat - Bootstrap 5 HTML Admin Template - Pro</title>

    <meta name="description" content="" />

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
    <link rel="stylesheet" href="/css/order/list.css"/>
    <link rel="stylesheet" href="/css/order/main.css"/>

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
          <!-- Content wrapper -->
          <div class="content-wrapper">
            
            <!-- Content -->	
            <div class="container-xxl flex-grow-1 container-p-y">
              <div class="row">
              
              <div class="row mb-3">
				  <div class="col d-flex justify-content-between align-items-center">
				    <h4 class="fw-bold mb-0">
				      <span class="text-muted fw-light">발주 관리 /</span> 발주 승인 요청 목록
				    </h4>
				  </div>
			  </div>
			  
			  
           	<div class="card p-3">
  				<div class="row g-3">  
					<div class="col-lg-7">
					  <div class="card border shadow-none h-100 mb-3">
					  
					    <!-- 카드 헤더 -->
					    <div class="card-header order-card-header border-bottom bg-white">
						  <h5 class="mb-0">발주 목록</h5>
						
						  <div class="d-flex gap-2">
						    <button class="btn btn-outline-success btn-sm">
						      <i class="bx bx-check-circle me-1 "></i> 승인
						    </button>
						    <button class="btn btn-outline-warning btn-sm">
						      <i class="bx bx-x-circle me-1"></i> 반려
						    </button>
						    <button class="btn btn-outline-danger btn-sm">
						      <i class="bx bx-trash me-1"></i> 취소
						    </button>
						  </div>
						</div>
					
					    <div class="table-responsive">
					      <table class="table table-hover table-bordered text-center align-middle mb-0">
					        <thead class="table-light">
					          <tr>
					            <th style="width:40px;">
					              <input type="checkbox" id="checkAll">
					            </th>
					            <th>발주번호</th>
					            <th>금액</th>
					            <th>요청자</th>
					            <th>승인자</th>
					            <th>상태</th>
					            <th>사유</th>
					          </tr>
					        </thead>
					        <tbody>
					          <c:forEach var="o" items="${orderList}">
						          <tr onclick="selectOrder('PO202312010001')" style="cursor:pointer">
						            <td><input type="checkbox" class="order-check"></td>
						            <td>${o.hqOrderId}</td>
						            <td class="text-end">15,000,000</td>
						            <td>${o.memberId}</td>
						            <td></td>
						            <td>
						              <span class="badge bg-label-warning">요청</span>
						            </td>
						            <td></td>
						          </tr>
					          </c:forEach>
					        </tbody>
					      </table>
					    </div>
					  </div>
					</div>
					
					<div class="col-lg-5">
					  <div class="card border shadow-none h-100 mb-3">
					
					    <div class="card-header order-card-header border-bottom bg-white">
						  <div>
						    <h5 class="mb-0">발주 상세</h5>
						    <small class="text-muted">발주번호: PO202312010001</small>
						  </div>
						</div>
					
					    <div class="table-responsive">
					      <table class="table table-bordered table-hover mb-0">
					        <thead class="table-light">
					          <tr>
					            <th>상품명</th>
					            <th class="text-end">수량</th>
					            <th class="text-end">단가</th>
					            <th class="text-end">금액</th>
					          </tr>
					        </thead>
					        <tbody id="orderDetailBody">
					          <tr>
					            <td>원두 1kg</td>
					            <td class="text-end">20</td>
					            <td class="text-end">25,000</td>
					            <td class="text-end">500,000</td>
					          </tr>
					        </tbody>
					      </table>
					    </div>
					
					  </div>
					</div>
				  </div> <!-- row -->
				</div> <!-- card -->
			</div>
				
            <!-- / Content -->

            <!-- Footer -->
            <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
            <!-- / Footer -->

            <div class="content-backdrop fade"></div>
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
  </body>
</html>

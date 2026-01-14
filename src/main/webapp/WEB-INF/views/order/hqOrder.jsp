<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
        <c:import url="/WEB-INF/views/template/header.jsp"></c:import>
          <!-- Content wrapper -->
          <div class="content-wrapper">
            
            <!-- Content -->	
            <div class="container-xxl flex-grow-1 container-p-y">
              <!-- form 시작 -->
              <form action="/order/request" method="post" id="orderForm">
	              <div class="row">
				  	<div class="row mb-4">
					  <div class="col">
					    <h4 class="fw-bold">
					      <span class="text-muted fw-light">발주 관리 /</span> 발주 등록
					    </h4>
					  </div>
					</div>
					
					<!-- 주요버튼 -->
					<div class="d-flex justify-content-end gap-2 mb-3">
					  <!-- 보조 액션 -->
					  <div class="d-flex gap-2">
					    <button button type="button" class="btn btn-sm btn-outline-secondary">
					      취소
					    </button>
					  </div>
					
					  <!-- 주요 액션 -->
					  <button button type="submit" class="btn btn-sm btn-primary">
					    발주 요청
					  </button>
					</div>
					
				    <div class="card mb-4">
						<!-- 발주 정보 -->
					    <div class="card mb-4 mt-4 card-border">
						  <h6 class="card-header" style="padding-left: 28px;">발주 기본 정보</h6>
						  <div class="card-body">
						    <div class="row g-3">
							    <div class="row align-items-center">
							
							      <!-- 발주 요청일 -->
							      <div class="col-md-4">
							        <div class="text-muted small">발주 요청일</div>
							        <div class="fw-semibold">
							          <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd"/>
							        </div>
							      </div>
								  <!-- 발주 요청자 -->
							      <div class="col-md-4">
							        <div class="text-muted small">요청자</div>
							        <div class="fw-semibold">
							          ${member.memberId}
							        </div>
							      </div>
								  <!-- 창고정보 -->
							      <div class="col-md-4">
							        <div class="text-muted small">입고 창고</div>
							        <select class="form-select form-select-sm w-75 mt-1">
							        <c:choose>
							          <c:when test = "${fn:startsWith(member.memberId, 1)}">
							          	<option>본사 창고</option>							          
							          </c:when>
							          <c:otherwise>
								        <option>가맹점 창고</option>							          
							          </c:otherwise>
							        </c:choose>
							        </select>
							      </div>
							    </div>
						    </div>
						  </div>
						</div>
						
					
			
						<div class="card mb-4 card-border">
						  <div class="card-header d-flex justify-content-between align-items-center">
						    <h5 class="mb-0">물품 선택</h5>
						
						    <div class="d-flex gap-2">
						      <button button type="button" class="btn btn-sm btn-outline-secondary"
						      			onclick="removeSelectedItems()">물품 삭제
						      </button>
						      <button button type="button" class="btn btn-sm btn-outline-success">
						        <i class="bx bx-download"></i> 엑셀 다운
						      </button>
						      <button button type="button" class="btn btn-sm btn-outline-primary" 
						      			data-bs-toggle="modal"
						      			data-bs-target="#productSearchModal">
						        <i class="bx bx-search"></i> 물품 검색
						      </button>
						    </div>
						  </div>
						  
						  <!-- 물품검색 공지 -->
						  <div class="px-3 py-2 border-bottom d-flex justify-content-between align-items-center">
							  <div class="text-muted small">
							    <span class="badge bg-primary me-2">STEP 1</span>
							    발주할 물품을 검색하여 선택하고 수량을 입력하세요
							  </div>
						  </div>
		
						  
						  <!-- 물품 목록 -->
						  <div class="table-responsive">
						    <table class="table table-bordered table-hover text-center">
						      <thead class="table-light">
						        <tr>
						          <th class="chk-td">
								      <input type="checkbox" id="checkAll" onclick="toggleAllCheckboxes()">
								  </th>
						          <th>물품코드</th>
						          <th>물품명</th>
						          <th>단가</th>
						          <th style="width:120px;">수량</th>
						          <th>합계</th>
						        </tr>
						      </thead>
						      <tbody id="orderItemBody">
						       <!-- JS로 렌더링 -->
						       
						      </tbody>
						    </table>
						  </div>
						  
						  <div class="card-body text-end">
						    <h5 class="mb-0">
						      총 발주 금액 :
						      <!-- 화면 표시용 -->
							  <input type="text"
								     class="text-primary fw-bold totalAmount"
								     id="grandTotalView"
								       readonly>
						      <!-- 서버 전송용 (순수 숫자) -->
							  <input type="hidden" id="grandTotal" name="hqOrderTotalAmount">
						    </h5>
						  </div>
						</div>
					  </div>
					</div>
				</form>
				<!-- form 끝 -->
				
				<c:if test="${not empty msg}">
				  <script>
				    alert('${msg}');
				  </script>
				</c:if>
				
				<c:if test="${not empty errorMsg}">
				  <script>
				    alert('${errorMsg}');
				  </script>
				</c:if>
			</div>
			
			<!-- 모달창 -->
			<c:import url="/WEB-INF/views/order/itemSearchModal.jsp"/>
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
    

    <!-- order JS -->
    <script src="/js/order/orderRequest.js"></script>
  </body>
</html>

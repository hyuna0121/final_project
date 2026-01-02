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

	<!-- Custom CSS -->	
    <link rel="stylesheet" href="/css/receivable/receivableDetail.css" />
	
	
	
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
				<div class="col-12">
				
				  <!-- ================= 상단 요약 ================= -->
				  <div class="card mb-4">
				    <div class="card-body d-flex justify-content-between">
				      <div>가맹점 코드 : <strong>${receivableSummaryDTO.storeId}</strong></div>
				      <div>지점명 : <strong>${receivableSummaryDTO.storeName}</strong></div>
				      <div>조회 월 : <strong>${receivableSummaryDTO.baseMonth}</strong></div>
				    </div>
				  </div>
				
					<!-- ================= 물품대금 미수 내역 ================= -->
					<div class="card mb-4">
					  <h5 class="card-header">물품대금 미수 내역</h5>
					
					  <div class="table-responsive">
					    <table class="table align-middle receivable-table">
					
					      <!-- ✅ CSS 기준 컬럼 정의 -->
					      <colgroup>
					        <col class="col-receivable">
					        <col class="col-date">
					        <col> <!-- 품목명 (가변) -->
					        <col class="col-qty">
					        <col class="col-unit">
					        <col class="col-amount">
					        <col class="col-tax">
					        <col class="col-total">
					      </colgroup>
					
					      <thead>
					        <tr>
					          <th class="text-center">채권코드</th>
					          <th class="text-center">발주일자</th>
					          <th>품목명</th>
					          <th class="text-end">수량</th>
					          <th class="text-end">단가</th>
					          <th class="text-end">공급가액</th>
					          <th class="text-end">세액</th>
					          <th class="text-end">합계</th>
					        </tr>
					      </thead>
					
					      <tbody>
					        <c:choose>
					
					          <c:when test="${empty receivableItemList}">
					            <tr>
					              <td colspan="8" class="text-center text-muted">
					                데이터가 없습니다.
					              </td>
					            </tr>
					          </c:when>
					
					          <c:otherwise>
					            <c:forEach var="item" items="${receivableItemList}">
					              <tr>
					                <td class="text-center">
					                  ${item.receivableId}
					                </td>
					
					                <td class="text-center">
					                  <fmt:formatDate value="${item.orderDate}" pattern="yyyy-MM-dd"/>
					                </td>
					
					                <!-- ✅ CSS에서 ellipsis 처리 -->
					                <td class="item-name">
					                  ${item.itemName}
					                </td>
					
					                <td class="text-end">
					                  <fmt:formatNumber value="${item.quantity}" />
					                </td>
					
					                <td class="text-end">
					                  <fmt:formatNumber value="${item.unitPrice}" />
					                </td>
					
					                <td class="text-end">
					                  <fmt:formatNumber value="${item.supplyAmount}" />
					                </td>
					
					                <td class="text-end">
					                  <fmt:formatNumber value="${item.taxAmount}" />
					                </td>
					
					                <td class="text-end fw-bold">
					                  <fmt:formatNumber value="${item.totalAmount}" />
					                </td>
					              </tr>
					            </c:forEach>
					          </c:otherwise>
					
					        </c:choose>
					      </tbody>
					
					    </table>
					  </div>
					</div>

				
				  <!-- ================= 가맹비 미수 내역 ================= -->
				  <div class="card mb-4">
				    <h5 class="card-header">가맹비 미수 내역</h5>
				    <div class="table-responsive text-nowrap">
				      <table class="table">
				        <thead>
				          <tr>
				            <th>계약일</th>
				            <th>계약 구분</th>
				            <th>공급가액</th>
				            <th>세액</th>
				            <th>합계</th>
				            <th>상태</th>
				          </tr>
				        </thead>
				        <tbody>
				          <tr>
				            <td colspan="6" class="text-center text-muted">
				              데이터가 없습니다.
				            </td>
				          </tr>
				        </tbody>
				      </table>
				    </div>
				  </div>
				
				  <!-- ================= 지급 이력 ================= -->
				  <div class="card mb-4">
				    <h5 class="card-header">지급 이력</h5>
				    <div class="table-responsive text-nowrap">
				      <table class="table">
				        <thead>
				          <tr>
				            <th>지급일</th>
				            <th>지급 금액</th>
				            <th>지급 구분</th>
				            <th>비고</th>
				          </tr>
				        </thead>
				        <tbody>
				          <tr>
				            <td colspan="4" class="text-center text-muted">
				              데이터가 없습니다.
				            </td>
				          </tr>
				        </tbody>
				      </table>
				    </div>
				  </div>
				
				  <!-- ================= 금액 요약 ================= -->
				  <div class="card">
				    <h5 class="card-header">금액 요약</h5>
				    <div class="table-responsive text-nowrap">
				      <table class="table">
				        <tbody>
				          <tr>
				            <th>물품대금 합계</th>
				            <td class="text-end">0</td>
				          </tr>
				          <tr>
				            <th>가맹비 합계</th>
				            <td class="text-end">0</td>
				          </tr>
				          <tr>
				            <th>총 거래 금액</th>
				            <td class="text-end">0</td>
				          </tr>
				          <tr>
				            <th>지급 금액</th>
				            <td class="text-end">0</td>
				          </tr>
				          <tr>
				            <th class="text-danger">미지급 금액</th>
				            <td class="text-end text-danger fw-bold">0</td>
				          </tr>
				        </tbody>
				      </table>
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

  </body>
</html>
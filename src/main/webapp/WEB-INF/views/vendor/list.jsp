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
	            <div class="card">
				  <h5 class="card-header">거래처 목록</h5>
				  <div class="table-responsive">
				    <table class="table">
				      <thead>
				        <tr>
				          <th>거래처코드</th>
				          <th>업체명</th>
				          <th>사업자번호</th>
				          <th>대표자명</th>
				          <th>전화번호</th>
				          <th>관리</th>
				        </tr>
				      </thead>
				      <tbody>
				        <%-- <c:forEach var="v" items="${vendorList}">
				          <tr>
				            <td>${v.vendorCode}</td>
				            <td>${v.companyName}</td>
				            <td>${v.bizNo}</td>
				            <td>${v.ceoName}</td>
				            <td>${v.tel}</td>
				            <td>
				              <button class="btn btn-sm btn-warning"
				                data-bs-toggle="modal"
				                data-bs-target="#editModal"
				                onclick="setVendorEdit(
				                  '${v.id}',
				                  '${v.tel}',
				                  '${v.managerTel}',
				                  '${v.managerEmail}'
				                )">
				                수정
				              </button>
				            </td>
				          </tr>
				        </c:forEach> --%>
				          <tr>
				            <td>12854215</td>
				            <td>롯데제과</td>
				            <td>123-45-789</td>
				            <td>주아안</td>
				            <td>02-1234-5678</td>
				            <td>
				              <button class="btn btn-sm btn-warning"
				                data-bs-toggle="modal"
				                data-bs-target="#editModal"
				                onclick="setVendorEdit(
				                  '${v.id}',
				                  '${v.tel}',
				                  '${v.managerTel}',
				                  '${v.managerEmail}'
				                )">
				                수정
				              </button>
				            </td>
				          </tr>
				          <tr>
				            <td>17854785</td>
				            <td>해태제과</td>
				            <td>158-75-612</td>
				            <td>홍길동</td>
				            <td>02-1751-9874</td>
				            <td>
				              <button class="btn btn-sm btn-warning"
				                data-bs-toggle="modal"
				                data-bs-target="#editModal"
				                onclick="setVendorEdit(
				                  '${v.id}',
				                  '${v.tel}',
				                  '${v.managerTel}',
				                  '${v.managerEmail}'
				                )">
				                수정
				              </button>
				            </td>
				          </tr>
				      </tbody>
				    </table>
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

 <!-- 수정 모달창 -->
	<div class="modal fade" id="editModal" tabindex="-1">
	  <div class="modal-dialog">
	    <form class="modal-content" action="/vendor/update" method="post">
	      <div class="modal-header">
	        <h5 class="modal-title">거래처 정보 수정</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	
	      <div class="modal-body">
	        <input type="hidden" name="id" id="editId">
	
	        <div class="mb-3">
	          <label class="form-label">전화번호</label>
	          <input type="text" class="form-control" name="tel" id="editTel">
	        </div>
	
	        <div class="mb-3">
	          <label class="form-label">담당자 번호</label>
	          <input type="text" class="form-control" name="managerTel" id="editManagerTel">
	        </div>
	
	        <div class="mb-3">
	          <label class="form-label">담당자 이메일</label>
	          <input type="email" class="form-control" name="managerEmail" id="editManagerEmail">
	        </div>
	      </div>
	
	      <div class="modal-footer">
	        <button type="submit" class="btn btn-primary">수정</button>
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	      </div>
	    </form>
	  </div>
	</div>

	


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

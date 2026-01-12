<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
              
			  <div class="d-flex justify-content-between align-items-center mb-3">
				  <h4 class="fw-bold mb-0">거래처 목록</h4>
				  <button class="btn btn-primary"
				          data-bs-toggle="modal"
				          data-bs-target="#vendorAddModal">
				    <i class="bx bx-plus"></i> 거래처 추가
				  </button>
				</div>
			  				
              <!-- 검색 영역 -->
				<div class="card mb-4">
				  <div class="card-body">
				      <div class="row g-3 align-items-end">
				
				        <form method="get" action="/vendor/list">
						  <div class="row g-3 align-items-end">
						
						    <div class="col-md-4">
						      <label class="form-label">거래처명</label>
						      <input type="text"
						             class="form-control"
						             name="vendorName"
						             value="${vendorDTO.vendorName}">
						    </div>
						
						    <div class="col-md-3">
						      <label class="form-label">사업자 번호</label>
						      <input type="text"
						             class="form-control"
						             name="vendorBusinessNumber"
						             value="${vendorDTO.vendorBusinessNumber}">
						    </div>
						
						    <div class="col-md-3">
						      <label class="form-label">거래처 코드</label>
						      <input type="text"
						             class="form-control"
						             name="vendorCode"
						             value="${vendorDTO.vendorCode}">
						    </div>
						
						    <div class="col-md-2 d-grid">
						      <button type="submit" class="btn btn-primary">
						        <i class="bx bx-search"></i> 검색
						      </button>
						    </div>
						
						  </div>
						</form>
				
				      </div>
				  </div>
				</div>
				
	            <div class="card">
				  <div class="table-responsive">
				    <table class="table">
				      <thead>
				        <tr>
				          <th>거래처코드</th>
				          <th>거래처명</th>
				          <th>사업자번호</th>
				          <th>사업자주소</th>
				          <th>대표자명</th>
				          <th>생성일자</th>
				          <th>담당자명</th>
				          <th>전화번호</th>
				          <th>이메일</th>
				        </tr>
				      </thead>
				      <tbody>
				        <c:forEach var="v" items="${vendorList}">
				          <tr>
				            <td>${v.vendorCode}</td>
				            <td>${v.vendorName}</td>
				            <td>${v.vendorBusinessNumber}</td>
				            <td>${v.vendorAddress}</td>
				            <td  class="text">${v.vendorCeoName}</td>
				            <td><fmt:formatDate value="${v.vendorCreatedAt}" pattern="yyyy-MM-dd"/> </td>
				            <td>${v.vendorManagerName}</td>
				            <td>${v.vendorManagerTel}</td>
				            <td>${v.vendorManagerEmail}</td>
				            <td>
				              <button class="btn btn-sm btn-outline-warning"
				                data-bs-toggle="modal"
				                data-bs-target="#editModal"
				                onclick="update(${v.vendorId})">
				                수정
				              </button>
				            </td>
				          </tr>
				        </c:forEach>
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
	        <input type="hidden" name="vendorId" id="vendorId">
	
	        <div class="mb-3">
	          <label class="form-label">담당자 번호</label>
	          <input type="text" class="form-control" name="vendorManagerTel" id="vendorManagerTel">
	        </div>
	
	        <div class="mb-3">
	          <label class="form-label">담당자 이름</label>
	          <input type="text" class="form-control" name="vendorManagerName" id="vendorManagerName">
	        </div>
	
	        <div class="mb-3">
	          <label class="form-label">담당자 이메일</label>
	          <input type="email" class="form-control" name="vendorManagerEmail" id="vendorManagerEmail">
	        </div>
	      </div>
	
	      <div class="modal-footer">
	        <button type="submit" class="btn btn-primary">수정</button>
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	      </div>
	    </form>
	  </div>
	</div>

	<!-- 거래처 등록 모달 -->
	<div class="modal fade" id="vendorAddModal" tabindex="-1" aria-hidden="true">
	  <div class="modal-dialog modal-lg modal-dialog-centered modal-scrollable">
	    <div class="modal-content">
	
	      <!-- 헤더 -->
	      <div class="modal-header">
	        <h5 class="modal-title">거래처 등록</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	
	      <!-- 바디 -->
	      <div class="modal-body">
	        <form action="add" method="post" id="vendorAddForm">
	
	          <div class="row">
	
	            <!-- 사업자 번호 -->
	            <div class="col-md-12 mb-3">
	              <label class="form-label">사업자 번호</label>
	              <div class="d-flex gap-2">
	                <input type="text" class="form-control"
	                       name="vendorBusinessNumber1"
	                       maxlength="3" placeholder="123" required>
	                <span class="align-self-center">-</span>
	                <input type="text" class="form-control"
	                       name="vendorBusinessNumber2"
	                       maxlength="2" placeholder="45" required>
	                <span class="align-self-center">-</span>
	                <input type="text" class="form-control"
	                       name="vendorBusinessNumber3"
	                       maxlength="5" placeholder="67890" required>
	              </div>
	            </div>
	
	            <!-- 사업자명 -->
	            <div class="col-md-12 mb-3">
	              <label class="form-label">사업자 이름</label>
	              <input type="text" class="form-control" name="vendorName" required>
	            </div>
	
	            <!-- 주소 -->
	            <div class="col-md-12 mb-3">
	              <label class="form-label">사업자 주소</label>
	              <div class="input-group mb-2">
	                <input type="text" class="form-control"
	                       id="vendorAddress"
	                       name="vendorAddress"
	                       placeholder="주소 검색 버튼을 눌러주세요"
	                       readonly required>
	                <button type="button"
	                        class="btn btn-outline-secondary"
	                        onclick="execDaumPostcode()">
	                  주소 검색
	                </button>
	              </div>
	              <input type="text"
	                     class="form-control"
	                     id="vendorAddressDetail"
	                     name="vendorAddressDetail"
	                     placeholder="상세주소 입력">
	            </div>
	
	            <!-- 대표자명 -->
	            <div class="col-md-6 mb-3">
	              <label class="form-label">대표자명</label>
	              <input type="text" class="form-control" name="vendorCeoName" required>
	            </div>
	
	            <!-- 업태 -->
	            <div class="col-md-6 mb-3">
	              <label class="form-label">업태명</label>
	              <input type="text" class="form-control" name="vendorBusinessType">
	            </div>
	
	            <!-- 담당자 -->
	            <div class="col-md-6 mb-3">
	              <label class="form-label">담당자명</label>
	              <input type="text" class="form-control" name="vendorManagerName">
	            </div>
	
	            <div class="col-md-6 mb-3">
	              <label class="form-label">담당자 번호</label>
	              <input type="text" class="form-control" name="vendorManagerTel">
	            </div>
	
	            <div class="col-md-6 mb-3">
	              <label class="form-label">담당자 이메일</label>
	              <input type="email" class="form-control" name="vendorManagerEmail">
	            </div>
	
	          </div>
	        </form>
	      </div>
	
	      <!-- 푸터 -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
	          취소
	        </button>
	        <button type="submit" class="btn btn-primary" form="vendorAddForm">
	          등록
	        </button>
	      </div>
	
	    </div>
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
    
    <!-- 카카오 API -->
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
    <!-- js -->
    <script src="/js/vendor/main.js"></script>
    <script src="/js/vendor/search.js"></script>
  </body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	            <h4 class="fw-bold mb-3">물품 목록</h4>
	            
	            <!-- 검색 영역 -->
				<div class="card mb-4">
				  <div class="card-body">
				      <div class="row g-3 align-items-end">
				
				        <!-- 품명 -->
				        <div class="col-md-4">
				          <label class="form-label">품명</label>
				          <input
				            type="text"
				            class="form-control"
				            id="searchItemName"
				            placeholder="원재료명 입력"
				            value="${param.itemName}"
				          />
				        </div>
				
				        <!-- 카테고리 -->
				        <div class="col-md-3">
				          <label class="form-label">카테고리</label>
				          <select class="form-select" id="searchCategory">
				            <option value="">전체</option>
				            <option value="FD" ${param.category == 'FD' ? 'selected' : ''}>식품</option>
				            <option value="NF" ${param.category == 'NF' ? 'selected' : ''}>비식품</option>
				          </select>
				        </div>
				
				        <!-- 거래처 코드 -->
				        <div class="col-md-3">
				          <label class="form-label">거래처 코드</label>
				          <input
				            type="text"
				            class="form-control"
				            id="searchVendorCode"
				            placeholder="거래처 코드"
				            value="${param.vendorCode}"
				          />
				        </div>
				
				        <!-- 검색 버튼 -->
				        <div class="col-md-2 d-grid">
				          <button type="button" class="btn btn-primary" onclick="searchItems()">
				            <i class="bx bx-search"></i> 검색
				          </button>
				        </div>
				
				      </div>
				  </div>
				</div>
	            
	            <!-- 물품 목록 -->
				<div class="card">
				  <div class="table-responsive text-nowrap">
				    <table class="table">
				      <thead>
				        <tr>
				          <th>즐겨찾기</th>
				          <th>물품코드</th>
				          <th>물품명</th>
				          <th>카테고리</th>
				          <th>사용여부</th>
				          <th>관리</th>
				        </tr>
				      </thead>
				      <tbody id="itemTableBody">
				        <c:forEach var="item" items="${ItemList}">
						    <tr>
						      <td class="text">
							      <button class="btn btn-sm btn-light"
								      onclick="toggleFavorite(this, 'am0012')"
								      title="즐겨찾기">
								      <i class="bx bx-star"></i>
								  </button>
							  </td>
						      <td>${item.itemCode}</td>
						      <td>${item.itemName}</td>
						      <td class="text">${item.itemCategory}</td>
						      <td class="text">
						      	<c:choose>
						            <c:when test="${item.itemEnable == false}">
									  <span class="badge bg-label-success">사용</span>
									</c:when>
									<c:otherwise>
									  <span class="badge bg-label-danger">미사용</span>
									</c:otherwise>
					            </c:choose>
						      </td>
						      <td class="text">
							    <button class="btn btn-sm btn-outline-warning btn-update-item"
								  data-bs-toggle="modal"
								  data-bs-target="#editModal"
								  data-id="${item.itemId}"
								  data-name="${item.itemName}"
								  data-itemuse="${item.itemEnable}"
								  data-autouse="${item.itemAutoOrder}">
								  수정
								</button>
							    <button class="btn btn-sm btn-outline-danger btn-update-price"
							      data-bs-toggle="modal"
							      data-bs-target="#editModal"
							      data-id="${item.itemId}"
							      data-name="${item.itemName}">
							      단가 등록
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
	    <form class="modal-content" method="post">
	      <div class="modal-header">
	        <h5 class="modal-title">title</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	
	      <div class="modal-body">
	        <input type="hidden" name="itemId" id="itemId">
	
			<!-- 물품 수정 / 단가 등록 변경(속성값 readonly) -->
	        <div class="mb-3">
	          <label class="form-label">물품명</label>
	          <input type="text" class="form-control" name="itemName" id="itemName">
	        </div>
	        
	 		<!-- 단가 등록 -->
	        <!-- 거래처 코드 -->
	        <div class="mb-3 priceBox">
		        <label class="form-label">거래처코드</label>
		        <select class="form-select" name="vendorId">
		          <c:forEach var="v" items="${vendorList}">
				    <option value="${v.vendorId}">
				      ${v.vendorName}
				    </option>
				    
				  </c:forEach>
		        </select>
		    </div>
		    				    	
	 		<!-- 단가 등록 시 -->
	        <div class="mb-3 priceBox">
	          <label class="form-label">단가</label>
	          <input type="text" class="form-control" name="itemSupplyPrice" id="itemPrice">
	        </div>
			
			<!-- 물품 수정 시 -->
	        <div class="mb-3 itemBox">
	          <label class="form-label">물품사용여부</label>
	          <select class="form-select" name="itemEnable" id="itemUseYn">
	            <option value="0">사용</option>
	            <option value="1">미사용</option>
	          </select>
	        </div>
	        
			<!-- 물품 수정 시 -->
	        <div class="mb-3 itemBox">
	          <label class="form-label">자동발주승인</label>
	          <select class="form-select" name="itemAutoOrder" id="autoOrderUseYn">
	            <option value="0">승인</option>
	            <option value="1">미승인</option>
	          </select>
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
    
    <script src="/js/item/search.js"></script>
    <script src="/js/item/update.js"></script>
  </body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
    <link rel="stylesheet" href="/css/order/approve.css"/>

    <!-- Helpers -->
    <script src="/vendor/js/helpers.js"></script>

    <!--! Template customizer & Theme config files MUST be included after core stylesheets and helpers.js in the <head> section -->
    <!--? Config:  Mandatory theme config file contain global vars & default theme options, Set your preferred theme option in this file.  -->
    <script src="/js/config.js"></script>
  </head>

  <body data-user-type="${fn:startsWith(member.memberId, '1') ? 'HQ' : 'STORE'}">
    <!-- Layout wrapper -->
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
        <!-- Menu -->
		  <sec:authorize access="hasAnyRole('STORE')">
			  <c:import url="/WEB-INF/views/template/aside_store.jsp"></c:import>
		  </sec:authorize>
		  <sec:authorize access="!hasAnyRole('STORE')">
			  <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>
		  </sec:authorize>
        <!-- / Menu -->

        <!-- Layout container -->
        <div class="layout-page ">
        <c:import url="/WEB-INF/views/template/header.jsp"></c:import>
          <!-- Content wrapper -->
          <div class="content-wrapper d-flex flex-column"">
            
            <!-- Content -->	
            <div class="container-xxl flex-grow-1 container-p-y">
					      <div class="row mb-4">
							  <div class="col">
							    <h4 class="fw-bold">
							    	<c:choose>
									<c:when test="${hasRequest}">
							   		   <span class="text-muted fw-normal">발주 관리 /</span> 승인 처리
									</c:when>
									<c:when test="${hasApproved}">
							      		<span class="text-muted fw-normal">발주 관리 /</span> 입고 처리
									</c:when>
									<c:when test="${hasWaitRelease}">
							      		<span class="text-muted fw-normal">발주 관리 /</span> 출고 처리
									</c:when>
								  </c:choose>
							    </h4>
							  </div>
						  </div>
				
				        <!-- ================= 발주 화면 ================= -->
				        <div class="card p-3">
				          <div class="row g-3">
				
				            <!-- ================= 왼쪽: 발주 목록 ================= -->
				            <div class="col-xl-7 col-lg-12">
				              <div class="card h-100 d-flex flex-column">
				
				                <div class="card-header d-flex justify-content-between">
				                  <c:choose>
									<c:when test="${hasRequest}">
									  <h5 class="mb-0">발주 승인</h5>
									</c:when>
									<c:when test="${hasApproved}">
									  <h5 class="mb-0">입고 관리</h5>
									</c:when>
								  </c:choose>
				                  <div class="d-flex gap-2">
								  <!-- 본사 -->
				                  <c:choose>
									  <c:when test="${fn:startsWith(member.memberId, '1') or fn:startsWith(member.memberId, '9')}">
									  	
									    <c:if test="${hasRequest}">
									      <button type="button" class="btn btn-sm btn-success" id="approveBtn">승인</button>
									      <button type="button" class="btn btn-sm btn-warning" id="rejectBtn">반려</button>
									    </c:if>
									  </c:when>
									</c:choose>
				                  </div>
				                </div>
				
				                <!-- 탭 -->
				                <div class="card-body pb-0">
				                  <ul class="nav nav-tabs">
				                    <!-- 본사의 경우 본사/가맹 둘다 표시 -->
								    <c:if test="${fn:startsWith(member.memberId, '1') or fn:startsWith(member.memberId, '9')}">
					                    <li class="nav-item">
					                      <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#hqOrderTab">
					                        본사 발주
					                      </button>
					                    </li>
					                    <li class="nav-item">
					                      <button class="nav-link" data-bs-toggle="tab" data-bs-target="#storeOrderTab">
					                        가맹 발주
					                      </button>
					                    </li>
								    </c:if>
								    <c:if test="${fn:startsWith(member.memberId, '2')}">
					                    <li class="nav-item">
					                      <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#storeOrderTab">
					                        가맹 발주
					                      </button>
					                    </li>
								    </c:if>
								    
				                  </ul>
				                </div>
				
				                <!-- 목록 -->
				                <div class="tab-content order-left-body">
								  <c:if test="${fn:startsWith(member.memberId, '1') or fn:startsWith(member.memberId, '9')}">
				                  <!-- 본사 발주 -->
				                  <div class="tab-pane fade show active" id="hqOrderTab">
				                    <table class="table table-bordered text-center align-middle mb-0">
				                      <thead class="table-light">
				                        <tr>
				                          <th class="chk-td">
											<input type="checkbox" class="hqCheckAll" data-order-type="HQ"/>                          
				                          </th>
				                          <th>발주번호</th>
				                          <th>금액</th>
				                          <th>요청자</th>
				                          <th>상태</th>
				                        </tr>
				                      </thead>
				                      <tbody>
				                        <c:forEach var="o" items="${orderHqList}">
				                          <tr class="order-row" data-order-no="${o.hqOrderId}" data-order-member="${member.memberId}" data-order-type="HQ">
				                            <td class="chk-td"><input type="checkbox" class="order-check"></input> </td>
				                            <td>${o.hqOrderId}</td>
				                            <td class="text-end">
				                              <fmt:formatNumber value="${o.hqOrderTotalAmount}"/>원
				                            </td>
				                            <td>${o.memberId}</td>
				                            <c:choose>
				                            	<c:when test="${o.hqOrderStatus == 100}">
						                            <td><span class="badge bg-label-warning">요청</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 150}">
						                            <td><span class="badge bg-label-danger">반려</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 200}">
						                            <td><span class="badge bg-label-success">승인</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 300}">
						                            <td><span class="badge bg-label-secondary">취소</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 350}">
						                            <td><span class="badge bg-label-info">출고</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 400}">
						                            <td><span class="badge bg-label-primary">입고</span></td>
				                            	</c:when>
				                            </c:choose>
				                          </tr>
				                        </c:forEach>
				                      </tbody>
				                    </table>
				                  </div>
								  </c:if>	
								  
								  
				                  <!-- 가맹 발주 -->
				                  <div class="tab-pane fade ${fn:startsWith(member.memberId, '2') ? 'active show' : ''}" id="storeOrderTab">
				                    <table class="table table-bordered text-center align-middle mb-0">
				                      <thead class="table-light">
				                        <tr>
				                          <th class="chk-td">
				                          	<input type="checkbox" class="hqCheckAll" data-order-type="STORE"/>
				                          </th>
				                          <th>발주번호</th>
				                          <th>금액</th>
				                          <th>가맹코드</th>
				                          <th>상태</th>
				                          <th>사유</th>
				                        </tr>
				                      </thead>
				                      <tbody>
				                        <c:forEach var="o" items="${orderStoreList}">
				                          <tr class="order-row" data-order-no="${o.hqOrderId}" data-order-type="STORE" data-status="${o.hqOrderStatus}">
				                            <td class="chk-td"><input type="checkbox" class="order-check" 
				                            <c:if test="${o.hqOrderStatus == 150 || o.hqOrderStatus == 350}">
				                            	disabled
				                            </c:if>
				                            /></td>
				                            <td>${o.hqOrderId}</td>
				                            <td class="text-end">
				                              <fmt:formatNumber value="${o.hqOrderTotalAmount}"/>원
				                            </td>
				                            <td>${o.memberId}</td>
				                            <c:choose>
				                            	<c:when test="${o.hqOrderStatus == 100}">
						                            <td><span class="badge bg-label-warning">요청</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 150}">
						                            <td><span class="badge bg-label-danger">반려</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 300}">
						                            <td><span class="badge bg-label-secondary">취소</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 330}">
						                            <td><span class="badge bg-label-info">출고대기</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 350}">
						                            <td><span class="badge bg-label-info">출고완료</span></td>
				                            	</c:when>
				                            	<c:when test="${o.hqOrderStatus == 400}">
						                            <td><span class="badge bg-label-primary">입고</span></td>
				                            	</c:when>
				                            </c:choose>
				                            <td>${o.storeRejectionReason}</td>
				                          </tr>
				                        </c:forEach>
				                      </tbody>
				                    </table>
				                  </div>
				
				                </div>
				              </div>
				            </div>
				
				            <!-- ================= 오른쪽 ================= -->
				            <div class="col-xl-5 col-lg-12 order-right">
				
				              <!-- 승인 리스트 -->
				              <div class="card approval-list">
				                <div class="card-header">
				                <c:choose>
								    <c:when test="${hasRequest}">
					                  <h5 class="mb-0">승인 리스트</h5>
									</c:when>
									<c:when test="${hasApproved}">
									  <h5 class="mb-0">입고 리스트</h5>
								    </c:when>
								</c:choose>
				                </div>
				                <div class="order-scroll">
				                  <table class="table table-sm table-bordered text-center mb-0">
				                    <thead>
				                      <tr>
				                        <th>발주번호</th>
				                        <c:choose>
										    <c:when test="${hasRequest}">
					                          <th>승인일자</th>
											</c:when>
											<c:when test="${hasApproved}">
					                          <th>입고일자</th>
										    </c:when>
									    </c:choose>
				                        <th>총금액</th>
				                      </tr>
				                    </thead>
				                    <tbody id="approvalListBody">
				                      <tr class="empty-row">
								        <td colspan="3" class="text-muted text-center">
								          선택된 발주가 없습니다
								        </td>
								      </tr>
				                    </tbody>
				                  </table>
				                </div>
				              </div>
				
				              <!-- 발주 상세 -->
				              <div class="card order-detail">
				                <div class="card-header">
				                  <c:choose>
								    <c:when test="${hasRequest}">
					                  <h5 class="mb-1">승인 상세</h5>
									</c:when>
									<c:when test="${hasApproved}">
									  <h5 class="mb-1">입고 상세</h5>
								    </c:when>
								    <c:when test="${hasWaitRelease}">
									  <h5 class="mb-1">출고 상세</h5>
								    </c:when>
								  </c:choose>
				                  <small class="text-muted">
				                    발주번호: <span id="selectedOrderId">-</span>
				                  </small>
				                </div>
				                <div class="order-scroll">
				                  <table class="table table-bordered text-center align-middle mb-0">
				                    <thead class="table-light">
				                      <tr>
				                        <th>상품명</th>
				                        <th>수량</th>
				                        <th>단가</th>
				                        <th>금액</th>
				                      </tr>
				                    </thead>
				                    <tbody id="orderDetailBody">
				                      <tr>
				                        <td colspan="4" class="text-muted py-4">
				                          발주를 선택하세요
				                        </td>
				                      </tr>
				                    </tbody>
				                  </table>
				                </div>
				              </div>
				
				            </div>
				          </div>
				        </div>
				
			</div>
			<!-- content 끝 -->
			
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
    
    <!-- 모달창 -->
	<c:import url="/WEB-INF/views/order/orderReject.jsp"></c:import>
	
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
	
	<!-- JS -->    
    <script src="/js/order/orderApprove.js"></script>
    <script src="/js/order/orderReject.js"></script>
    <script src="/js/order/orderCancel.js"></script>
  </body>
</html>
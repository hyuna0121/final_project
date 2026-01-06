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

    <title>Receivable Detail</title>

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
				
					<!-- ================= 물품대금 미수 요약 내역 ================= -->
					<div class="card mb-4">
					  <h5 class="card-header">물품대금 미수 내역</h5>
					
					  <div class="table-responsive">
					    <table class="table align-middle receivable-table">
					
					      <colgroup>
					        <col class="col-receivable">
					        <col class="col-date">
					        <col class="col-qty">
					        <col class="col-amount">
					        <col class="col-tax">
					        <col class="col-total">
					        <col style="width:120px;">
					      </colgroup>
					
					      <thead>
					        <tr>
					          <th class="text-first">채권코드</th>
					          <th class="text-first">발주일자</th>
					          <th class="text-end">품목 수</th>
					          <th class="text-end">공급가액</th>
					          <th class="text-end">세액</th>
					          <th class="text-end">합계</th>
					          <th class="text-center">상세</th>
					        </tr>
					      </thead>
					
					      <tbody>
					        <c:choose>
					
					          <c:when test="${empty receivableOrderSummaryDTO}">
					            <tr>
					              <td colspan="7" class="text-center text-muted">
					                데이터가 없습니다.
					              </td>
					            </tr>
					          </c:when>
					
					          <c:otherwise>
					            <c:forEach var="row" items="${receivableOrderSummaryDTO}">
					              <tr>
					                <td class="text-first">
					                  ${row.receivableId}
					                </td>
					
					                <td class="text-first">
					                  <fmt:formatDate value="${row.orderDate}" pattern="yyyy-MM-dd"/>
					                </td>
					
					                <td class="text-end">
					                  ${row.itemCount}건
					                </td>
					
					                <td class="text-end">
					                  <fmt:formatNumber value="${row.supplyAmount}" />
					                </td>
					
					                <td class="text-end">
					                  <fmt:formatNumber value="${row.taxAmount}" />
					                </td>
					
					                <td class="text-end fw-bold">
					                  <fmt:formatNumber value="${row.totalAmount}" />
					                </td>
					
					                <td class="text-center">
										<button
										  class="btn btn-sm btn-outline-primary"
										  data-bs-toggle="modal"
										  data-bs-target="#itemModal"
										  data-receivable-id="${row.receivableId}"
										  data-order-date='<fmt:formatDate value="${row.orderDate}" pattern="yyyy-MM-dd"/>'>
										  리스트 보기
										</button>
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
				            <th class="text-first">채권 코드</th>
				            <th class="text-first">계약일</th>
				            <th class="text-end">공급가액</th>
				            <th class="text-end">세액</th>
				            <th class="text-end">합계</th>
				            <th class="text-center">상태</th>
				          </tr>
				        </thead>
				        <tbody>
						  <c:choose>
						
						    <c:when test="${not empty receivableRoyaltyDTO}">
						        <tr>
						          <td class="text-first">${receivableRoyaltyDTO.receivableId}</td>
						
						          <td class="text-first">
						            <fmt:formatDate value="${receivableRoyaltyDTO.contractDate}" pattern="yyyy-MM-dd"/>
						          </td>
						
						          <td class="text-end">
						            <fmt:formatNumber value="${receivableRoyaltyDTO.supplyAmount}" type="number"/>
						          </td>
						
						          <td class="text-end">
						            <fmt:formatNumber value="${receivableRoyaltyDTO.taxAmount}" type="number"/>
						          </td>
						
						          <td class="text-end fw-bold">
						            <fmt:formatNumber value="${receivableRoyaltyDTO.totalAmount}" type="number"/>
						          </td>
						
						          <td class="text-center">
						            <c:choose>
						              <c:when test="${receivableRoyaltyDTO.status eq 'O'}">미지급</c:when>
						              <c:when test="${receivableRoyaltyDTO.status eq 'P'}">부분지급</c:when>
						              <c:when test="${receivableRoyaltyDTO.status eq 'C'}">완납</c:when>
						            </c:choose>
						          </td>
						        </tr>
						    </c:when>
						
						    <c:otherwise>
						      <tr>
						        <td colspan="6" class="text-center text-muted">
						          데이터가 없습니다.
						        </td>
						      </tr>
						    </c:otherwise>
						
						  </c:choose>
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
				            <th class="text-first">지급일</th>
				            <th class="text-center">지급 금액</th>
				            <th class="text-center">지급 구분</th>
				            <th class="text-center">비고</th>
				          </tr>
				        </thead>
							<tbody>
							  <c:choose>
							    <c:when test="${empty receivableTransactionDTO}">
							      <tr>
							        <td colspan="4" class="text-center text-muted">
							          데이터가 없습니다.
							        </td>
							      </tr>
							    </c:when>
							    <c:otherwise>
							      <c:forEach items="${receivableTransactionDTO}" var="paid">
							        <tr>
							          <!-- 지급일 -->
							          <td class="text-first">
							            <fmt:formatDate value="${paid.transactionDate}" pattern="yyyy-MM-dd" />
							          </td>
							          <td class="text-center">
							            <fmt:formatNumber value="${paid.transactionAmount}" pattern="#,###" />
							          </td>
							          <td class="text-center">
							            <c:choose>
							              <c:when test="${paid.sourceType eq 'CONTRACT'}">가맹비</c:when>
							              <c:when test="${paid.sourceType eq 'ORDER'}">물품대금</c:when>
							              <c:otherwise>-</c:otherwise>
							            </c:choose>
							          </td>
							          <td class="text-center">${paid.transactionMemo}</td>
							        </tr>
							      </c:forEach>
							    </c:otherwise>
							  </c:choose>
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
				            <td class="text-end">
			            		<fmt:formatNumber value="${receivableAmountSummaryDTO.productTotal}" type="number"/>
				            </td>
				          </tr>
				          <tr>
				            <th>가맹비 합계</th>
				            <td class="text-end">
				            	<fmt:formatNumber value="${receivableAmountSummaryDTO.royaltyTotal}" type="number"/>
				            </td>
				          </tr>
				          <tr>
				            <th>총 거래 금액</th>
				            <td class="text-end">
				            	<fmt:formatNumber value="${receivableAmountSummaryDTO.totalAmount}" type="number"/>
				            </td>
				          </tr>
				          <tr>
				            <th>지급 금액</th>
				            <td class="text-end">
				            	<fmt:formatNumber value="${receivableAmountSummaryDTO.paidAmount}" type="number"/>
				            </td>
				          </tr>
				          <tr>
				            <th class="text-danger">미지급 금액</th>
				            <td class="text-end text-danger fw-bold">
				            	<fmt:formatNumber value="${receivableAmountSummaryDTO.unpaidAmount}" type="number"/>
				            </td>
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
    
	<!-- ================= 물품대금 상세 모달 ================= -->
	<div class="modal fade" id="itemModal" tabindex="-1" aria-hidden="true">
	  <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
	    <div class="modal-content">
	
	      <!-- Header -->
	      <div class="modal-header">
	        <h5 class="modal-title">물품대금 상세 내역</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	
	      <!-- Body -->
	      <div class="modal-body">
	
	        <!-- 상단 요약 -->
	        <div class="row mb-3">
	          <div class="col-md-4">
	            <div class="text-muted small">채권코드</div>
	            <div class="fw-bold" id="modalReceivableId"></div>
	          </div>
	          <div class="col-md-4">
	            <div class="text-muted small">발주일자</div>
	            <div class="fw-bold" id="modalOrderDate"></div>
	          </div>
	        </div>
	
	        <!-- 품목 테이블 -->
	        <div class="table-responsive">
	          <table class="table table-bordered align-middle">
	            <thead class="table-light">
	              <tr>
	                <th class="text-center">품목명</th>
	                <th class="text-end">수량</th>
	                <th class="text-end">단가</th>
	                <th class="text-end">공급가액</th>
	                <th class="text-end">세액</th>
	                <th class="text-end">합계</th>
	              </tr>
	            </thead>
	            <tbody id="itemModalTbody">
	              <tr>
	                <td colspan="6" class="text-center text-muted">
	                  품목 데이터 없음
	                </td>
	              </tr>
	            </tbody>
	          </table>
	        </div>
	
	      </div>
	
	      <!-- Footer -->
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
	          닫기
	        </button>
	      </div>
	
	    </div>
	  </div>
	</div>
	<!-- ================= 모달 끝 ================= -->

	
	<script type="text/javascript" src="/js/receivable/receivableDetail.js"></script>
	
	
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
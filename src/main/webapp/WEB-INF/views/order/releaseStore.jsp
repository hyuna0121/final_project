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
    content="width=device-width, initial-scale=1.0, user-scalable=no"
  />

  <title>출고 처리</title>

  <!-- Favicon -->
  <link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />

  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link
    href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap"
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

  <!-- Page CSS -->
  <link rel="stylesheet" href="/css/order/main.css"/>
  <link rel="stylesheet" href="/css/order/approve.css"/>

  <!-- Helpers -->
  <script src="/vendor/js/helpers.js"></script>
  <script src="/js/config.js"></script>
  <base href="${pageContext.request.contextPath}/">
</head>

<body data-user-type="STORE">

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

    <!-- Layout page -->
    <div class="layout-page">
      <c:import url="/WEB-INF/views/template/header.jsp"/>

      <!-- Content wrapper -->
      <div class="content-wrapper">

        <!-- Content -->
        <div class="container-fluid flex-grow-1 container-p-y">

          <!-- ✅ 여기부터 너가 말한 "중복 wrapper" 구조 그대로 유지 -->

                  <!-- ================= 제목 ================= -->
                  <div class="row mb-4">
                    <div class="col">
                      <h4 class="fw-bold">
                        <span class="text-muted fw-light">재고 관리 /</span> 가맹 출고 내역
                      </h4>
                    </div>
                  </div>

                  <!-- ================= 메인 카드 ================= -->
                  <div class="card p-3">
                    <div class="row g-3">

                      <!-- ================= 상단: 출고 이력 ================= -->
                      <div class="col-12">
                        <div class="card h-100 d-flex flex-column">

                          <div class="card-header d-flex justify-content-between">
                            <h5 class="mb-0">출고 이력</h5>
                            <button class="btn btn-success btn-sm" id="requestReleaseBtn" data-bs-toggle="modal"
       						 data-bs-target="#releaseModal">출고요청</button>
                          </div>

                          <div class="order-left-body">
                            <table class="table table-bordered text-center align-middle mb-0">
                              <thead class="table-light">
                                <tr>
                                  <th style="width:70px">선택</th>
                                  <th>출고번호</th>
                                  <th>출고타입</th>
                                  <th>출고일자</th>
                                </tr>
                              </thead>
                              <tbody>
                                <c:forEach var="r" items="${releaseList}" varStatus="st">
                                  <tr class="release-row"
                                      data-input-id="${r.inputId}">
                                    <td>
                                    ${st.count}
                                    </td>
                                    <td>${r.inputId}</td>
									<td>
									  <c:choose>
									    <c:when test="${empty r.releaseReason}">
									      <span class="badge bg-label-primary">재고사용</span>
									    </c:when>
									
									    <c:when test="${not empty r.releaseReason}">
									      <span class="badge bg-label-danger">상품불량</span>
									    </c:when>
									  </c:choose>
									</td>
                                    <td>
                                      <fmt:formatDate value="${r.releaseCreatedAt}" pattern="yyyy-MM-dd"/>
                                    </td>
                                  </tr>
                                </c:forEach>

                                <c:if test="${empty releaseList}">
                                  <tr>
                                    <td colspan="4" class="text-muted py-4">
                                      출고 내역이 없습니다
                                    </td>
                                  </tr>
                                </c:if>

                              </tbody>
                            </table>
                          </div>

                        </div>
                      </div>

                      <!-- ================= 하단: 출고 상세 ================= -->
                      <div class="col-12">
                        <div class="card order-detail">

                          <div class="card-header">
                            <h5 class="mb-1">출고 상세</h5>
                            <small class="text-muted">
                              출고번호: <span id="selectedInputId">-</span>
                            </small>
                          </div>

                          <div class="order-scroll">
                            <table class="table table-bordered text-center align-middle mb-0">
                              <thead class="table-light">
                                <tr>
                                  <th>상품명</th>
                                  <th style="width:40%">출고수량</th>
                                </tr>
                              </thead>
                              <tbody id="releaseDetailBody">
                                <tr>
                                  <td colspan="2" class="text-muted py-4">
                                    출고 내역을 선택하세요
                                  </td>
                                </tr>
                              </tbody>
                            </table>
                          </div>

                        </div>
                      </div>

                    </div>
                  </div>

                  <!-- ✅ 중복 wrapper 끝 -->

        </div>
        <!-- / Content -->

        <!-- Footer -->
        <c:import url="/WEB-INF/views/template/footer.jsp"/>
        <!-- / Footer -->

        <div class="content-backdrop fade"></div>
      </div>
      <!-- / Content wrapper -->
    </div>
    <!-- / Layout page -->
  </div>
  
  <!-- 가맹 출고 모달 -->
  <div class="modal fade" id="releaseModal" tabindex="-1">
	  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
	    <div class="modal-content">
	
	      <div class="modal-header">
	        <h5 class="modal-title">가맹출고 요청</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	
	      <div class="modal-body">
	
	        <div class="d-flex justify-content-end mb-2">
	          <button class="btn btn-outline-primary btn-sm" id="btnAddItem">
	            물품등록
	          </button>
	        </div>
	        
	        <div class="mb-3">
			  <label class="form-label fw-semibold">출고타입</label>
			  <select class="form-select" id="releaseType" name="releaseType">
			    <option value="use" selected>재고사용</option>
			    <option value="faulty">상품불량</option>
			  </select>
			</div>
			
			<div class="mb-3">
			  <label class="form-label fw-semibold">출고사유</label>
			  <input
			    type="text"
			    class="form-control"
			    id="releaseReason"
			    name="releaseReason"
			    placeholder="상품불량 사유를 입력하세요"
			    disabled
			  />
			</div>
	
	        <table class="table table-bordered text-center align-middle">
	          <thead class="table-light">
	            <tr>
	              <th>물품명</th>
	              <th>재고수</th>	              
	              <th style="width:120px">수량</th>
	            </tr>
	          </thead>
	          <tbody id="selectedItemList">
	            <tr class="empty-row">
	              <td colspan="3" class="text-muted">
	                등록된 물품이 없습니다
	              </td>
	            </tr>
	          </tbody>
	        </table>
	
	      </div>
	
	      <div class="modal-footer">
	        <button class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
	        <button class="btn btn-primary" id="btnReleaseStock">출고요청</button>
	      </div>
	
	    </div>
	  </div>
	</div>
	
	<div class="modal fade" id="itemModal" tabindex="-1">
	  <div class="modal-dialog modal-md modal-dialog-centered modal-dialog-scrollable">
	    <div class="modal-content">
	
	      <div class="modal-header">
	        <h5 class="modal-title">물품 선택</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
	      </div>
	
	      <div class="modal-body">
	        <ul class="list-group" id="inventoryList">
	          <!-- JS로 렌더링 -->
	        </ul>
	      </div>
	
	      <div class="modal-footer">
	        <button class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
	      </div>
	
	    </div>
	  </div>
	</div>

  <!-- Overlay -->
  <div class="layout-overlay layout-menu-toggle"></div>
</div>
<!-- / Layout wrapper -->

<!-- Core JS -->
<script src="/vendor/libs/jquery/jquery.js"></script>
<script src="/vendor/libs/popper/popper.js"></script>
<script src="/vendor/js/bootstrap.js"></script>
<script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
<script src="/vendor/js/menu.js"></script>

<!-- Vendors JS -->
<script src="/vendor/libs/apex-charts/apexcharts.js"></script>

<!-- Main JS -->
<script src="/js/main.js"></script>

<!-- Page JS -->
<script src="/js/order/storeRelease.js"></script>
<script src="/js/order/storeStockRelease.js"></script>

</body>
</html>

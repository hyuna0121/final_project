<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>

<html lang="ko" class="light-style layout-menu-fixed">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>발주 관리</title>

  <link rel="stylesheet" href="/vendor/css/core.css" />
  <link rel="stylesheet" href="/vendor/css/theme-default.css" />
  <link rel="stylesheet" href="/css/order/main.css" />
</head>

<body>
<div class="layout-wrapper layout-content-navbar">
  <div class="layout-container">
    <c:import url="/WEB-INF/views/template/aside.jsp"/>

    <div class="layout-page">
      <div class="content-wrapper">

        <!-- ================= 발주 화면 ================= -->
        <div class="card p-3 order-container">
          <div class="row g-3">

            <!-- ================= 왼쪽: 발주 목록 ================= -->
            <div class="col-md-7">
              <div class="card h-100 d-flex flex-column">

                <div class="card-header d-flex justify-content-between">
                  <h5 class="mb-0">발주 목록</h5>
                  <div class="d-flex gap-2">
                    <button class="btn btn-success btn-sm" id="approveBtn">입고</button>
                    <button class="btn btn-warning btn-sm">출고</button>
                    <button class="btn btn-danger btn-sm">승인취소</button>
                  </div>
                </div>

                <!-- 탭 -->
                <div class="card-body pb-0">
                  <ul class="nav nav-tabs">
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
                  </ul>
                </div>

                <!-- 목록 -->
                <div class="tab-content order-left-body">

                  <!-- 본사 발주 -->
                  <div class="tab-pane fade show active" id="hqOrderTab">
                    <table class="table table-bordered text-center align-middle mb-0">
                      <thead class="table-light">
                        <tr>
                          <th style="width:40px;">
							<input type="checkbox" class="hqCheckAll"/>                          
                          </th>
                          <th>발주번호</th>
                          <th>금액</th>
                          <th>요청자</th>
                          <th>상태</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="o" items="${orderHqList}">
                          <tr class="order-row" data-order-no="${o.hqOrderId}">
                            <td><input type="checkbox" class="order-check"/></td>
                            <td>${o.hqOrderId}</td>
                            <td class="text-end">
                              <fmt:formatNumber value="${o.hqOrderTotalAmount}"/>원
                            </td>
                            <td>${o.memberId}</td>
                            <td><span class="badge bg-label-warning">요청</span></td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>

                  <!-- 가맹 발주 -->
                  <div class="tab-pane fade" id="storeOrderTab">
                    <table class="table table-bordered text-center align-middle mb-0">
                      <thead class="table-light">
                        <tr>
                          <th style="width:40px;">
                          	<input type="checkbox" class="hqCheckAll"/>
                          </th>
                          <th>발주번호</th>
                          <th>금액</th>
                          <th>가맹코드</th>
                          <th>상태</th>
                        </tr>
                      </thead>
                      <tbody>
                        <c:forEach var="o" items="${orderStoreList}">
                          <tr class="order-row" data-order-no="${o.hqOrderId}">
                            <td><input type="checkbox" class="order-check"/></td>
                            <td>${o.hqOrderId}</td>
                            <td class="text-end">
                              <fmt:formatNumber value="${o.hqOrderTotalAmount}"/>원
                            </td>
                            <td>${o.memberId}</td>
                            <td><span class="badge bg-label-warning">요청</span></td>
                          </tr>
                        </c:forEach>
                      </tbody>
                    </table>
                  </div>

                </div>
              </div>
            </div>

            <!-- ================= 오른쪽 ================= -->
            <div class="col-md-5 order-right">

              <!-- 입고/출고 리스트 -->
              <div class="card approval-list">
                <div class="card-header">
                  <h5 class="mb-0">리스트</h5>
                </div>
                <div class="order-scroll">
                  <table class="table table-sm table-bordered text-center mb-0">
                    <thead>
                      <tr>
                        <th>발주번호</th>
                        <th>승인일자</th>
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
                  <h5 class="mb-1">발주 상세</h5>
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

        <c:import url="/WEB-INF/views/template/footer.jsp"/>
      </div>
    </div>
  </div>
</div>

<script src="/vendor/libs/jquery/jquery.js"></script>
<script src="/vendor/js/bootstrap.js"></script>
<script src="/js/order/orderApprove.js"></script>
</body>
</html>
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
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>재고 관리</title>

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
<div class="layout-wrapper layout-content-navbar">
  <div class="layout-container">

    <!-- Aside -->
    <c:import url="/WEB-INF/views/template/aside.jsp" />

    <div class="layout-page">
      <!-- Header -->
      <c:import url="/WEB-INF/views/template/header.jsp" />

      <!-- Content -->
      <div class="content-wrapper">
        <div class="container-fluid flex-grow-1 container-p-y">

          <!-- 타이틀 -->
          <div class="row mb-4">
            <div class="col">
              <h4 class="fw-bold">
                <span class="text-muted fw-light">재고 관리 /</span> 재고 현황
              </h4>
            </div>
          </div>

          <!-- 재고 목록 카드 -->
          <div class="card">
            <div class="card-header">
              <h5 class="mb-0">재고 보유 목록</h5>
            </div>

            <div class="table-responsive">
              <table class="table table-bordered text-center align-middle mb-0 text-dark">
                <thead class="table-light">
                  <tr>
                    <th>상품ID</th>
                    <th>상품명</th>
                    <th>재고수량</th>
                    <th>최종입고일</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${empty stockList}">
                      <tr>
                        <td colspan="5" class="text-muted py-4">
                          재고 데이터가 없습니다.
                        </td>
                      </tr>
                    </c:when>

                    <c:otherwise>
                      <c:forEach var="s" items="${stockList}" varStatus="st">
                        <tr>
                          <td>${st.count}</td>
                          <td>${s.itemName}</td>
                          <td class="text-end fw-bold">
                            <fmt:formatNumber value="${s.stockQuantity}" />
                          </td>
                          <td>
						    -
                          </td>
                        </tr>
                      </c:forEach>
                    </c:otherwise>
                  </c:choose>
                </tbody>
              </table>
            </div>
          </div>

        </div>

        <!-- Footer -->
        <c:import url="/WEB-INF/views/template/footer.jsp" />
        <div class="content-backdrop fade"></div>
      </div>
    </div>
  </div>

  <div class="layout-overlay layout-menu-toggle"></div>
</div>

<!-- Core JS -->


<script src="/vendor/libs/jquery/jquery.js"></script>
<script src="/vendor/libs/popper/popper.js"></script>
<script src="/vendor/js/bootstrap.js"></script>
<script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
<script src="/vendor/js/menu.js"></script>

<!-- Main JS -->
<script src="/js/main.js"></script>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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

    <title>QSC 등록</title>

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
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/style.css">
    
    <link rel="stylesheet" href="/css/store/main.css">

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
		<c:import url="/WEB-INF/views/template/header.jsp"></c:import>
        
          <!-- Content wrapper -->
          <div class="content-wrapper">
            <!-- Content -->

            <div class="container-xxl flex-grow-1 container-p-y">
              <div class="row">
                <h4 class="fw-bold py-3 mb-3"><a href="/store/qsc/list" class="text-muted fw-normal">QSC /</a> 상세</h4>
                <div id="tab-content-area">
					<div class="card shadow-none border bg-white">
                            <div class="row g-3 p-4">
                                <div class="col-12 text-center mb-4" style="margin-top: 50px">
                                    <h3 class="fw-bold">[ ${dto.qscTitle} ]</h3>
                                </div>
                                <div class="col-12 text-end">
                                    <h6 class="mb-1 text-muted">담당자 : <span class="text-dark fw-bold">${dto.memName}</span></h6>
                                    <h6 class="mb-4 text-muted">가맹점명 : <span class="text-dark fw-bold">${dto.storeName}</span></h6>
                                </div>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover table-striped">
                                    <thead>
                                        <tr>
                                            <th style="width: 5%;">No</th>
                                            <th style="width: 10%;">카테고리</th>
                                            <th>질문</th>
                                            <th style="width: 8%;">배점</th>
                                            <th style="width: 8%;">점수</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <c:forEach items="${dto.qscDetailDTOS}" var="detail" varStatus="status">
                                            <tr>
                                                <td class="text-primary">${status.count}</td>
                                                <td>${detail.questionDTO.listCategory}</td>
                                                <td>${detail.questionDTO.listQuestion}</td>
                                                <td>${detail.questionDTO.listMaxScore}</td>
                                                <td>
                                                    ${detail.detailScore}
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <tr class="fw-bold">
                                            <td class="text-primary" colspan="3">총점</td>
                                            <td>${dto.qscQuestionTotalScore}</td>
                                            <td><span id="displayTotalScore" class="text-primary">${dto.qscTotalScore}</span></td>
                                        </tr>
                                        <tr class="fw-bold">
                                            <input type="hidden" id="hiddenTotalMax" value="${totalMax}">
                                            <td class="text-primary" colspan="3">등급</td>
                                            <td>
                                                <c:if test="${dto.qscGrade eq 'A'}"><span class="badge bg-label-primary">A</span></c:if>
                                                <c:if test="${dto.qscGrade eq 'B'}"><span class="badge bg-label-success">B</span></c:if>
                                                <c:if test="${dto.qscGrade eq 'C'}"><span class="badge bg-label-warning">C</span></c:if>
                                                <c:if test="${dto.qscGrade eq 'D'}"><span class="badge bg-label-danger">D</span></c:if>
                                            </td>
                                            <td><span id="displayTotalScoreTo" class="text-primary">${dto.qscScore}</span></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="row g-3 p-4">
                                <div class="col-md-12">
                                    <label class="form-label" for="qscOpinion">종합 의견</label>
                                    <div class="input-group">
                                        <textarea class="form-control" rows="3" id="qscOpinion" readonly>${dto.qscOpinion}</textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex justify-content-end gap-2 p-4">
                                <a href="/store/qsc/list" class="btn btn-outline-secondary">목록</a>
                                <sec:authentication property="principal.member" var="memberInfo"/>
                                <sec:authorize access="hasAnyRole('EXEC', 'MASTER')" var="isAdmin" />
                                <c:if test="${(dto.memberId eq memberInfo.memberId) or isAdmin}">
                                    <a href="/store/qsc/edit?qscId=${dto.qscId}"class="btn btn-primary">수정</a>
                                </c:if>
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

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>
    
    <script type="text/javascript" src="/js/store/qsc/add.js"></script>
  </body>
</html>
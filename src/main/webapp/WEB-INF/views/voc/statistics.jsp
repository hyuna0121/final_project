<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<html
  lang="ko"
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

    <title>VOC 통계 분석</title>

    <meta name="description" content="" />

    <link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap"
      rel="stylesheet"
    />

    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />

    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />

    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="/vendor/libs/apex-charts/apex-charts.css" />
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/style.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
    
    <link rel="stylesheet" href="/css/store/main.css">

    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>
    
    <style>
      .card-icon-bg {
        width: 40px;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 0.375rem;
      }
    </style>
  </head>

  <body>
    <div class="layout-wrapper layout-content-navbar">
      <div class="layout-container">
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>
        <div class="layout-page">
		<c:import url="/WEB-INF/views/template/header.jsp"></c:import>
        
          <div class="content-wrapper">
            <div class="container-xxl flex-grow-1 container-p-y">
              
              <div class="row">
			    <div class="col-12 px-0">
                    <ul class="nav nav-pills mb-3" role="tablist">
                        <li class="nav-item">
                        	<a href="/store/voc/list" class="nav-link"><i class='bx bx-support me-1'></i> VOC</a>
                        </li>
                        <li class="nav-item">
                        	<a href="/store/voc/statistics" class="nav-link active"><i class="bx bx-bar-chart-alt-2 me-1"></i> 통계</a>
                        </li>
                    </ul>
                </div>
              </div>
            <div class="d-flex justify-content-between align-items-center mb-4">
                
                <h4 class="fw-bold py-3 mb-0">
                    <span class="text-muted fw-normal">VOC /</span> 통계 분석
                </h4>

                <div class="d-flex gap-2">
                    <div class="input-group" style="width: 200px;">
                        <span class="input-group-text bg-white"><i class="bx bx-calendar"></i></span>
                        <input type="text" id="monthPicker" class="form-control bg-white" placeholder="날짜 선택" readonly>
                    </div>
                </div>
                
            </div>

              <div>
                <div class="row">
                    <div class="col-lg-3 col-md-6 col-6 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title d-flex align-items-start justify-content-between">
                                    <div class="card-icon-bg bg-label-primary">
                                    	<a href="javascript:void(0);" id="btnTotalVoc">
						                    <i class="bx bx-folder-plus fs-3"></i>
						                </a>
                                    </div>
                                </div>
                                <span class="fw-semibold d-block mb-1">이번 달 접수</span>
                                <h3 class="card-title mb-2" id="kpiTotal">-건</h3>
                                <small class="fw-semibold" id="kpiTotalDiff">-</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 col-6 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title d-flex align-items-start justify-content-between">
                                    <div class="card-icon-bg bg-label-success">
                                        <i class="bx bx-check-circle fs-3"></i>
                                    </div>
                                </div>
                                <span class="fw-semibold d-block mb-1">처리 완료</span>
                                <h3 class="card-title mb-2" id="kpiResolved">-건</h3>
                                <small class="text-muted" id="kpiRate">처리율 -%</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 col-6 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title d-flex align-items-start justify-content-between">
                                    <div class="card-icon-bg bg-label-warning">
                                        <i class="bx bx-time fs-3"></i>
                                    </div>
                                </div>
                                <span class="fw-semibold d-block mb-1">미처리 / 진행중</span>
                                <h3 class="card-title mb-2" id="kpiPending">-건</h3>
                                <small class="text-danger fw-semibold">집중 관리 필요</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 col-6 mb-4">
                        <div class="card">
                            <div class="card-body">
                                <div class="card-title d-flex align-items-start justify-content-between">
                                    <div class="card-icon-bg bg-label-info">
                                        <i class="bx bx-stopwatch fs-3"></i>
                                    </div>
                                </div>
                                <span class="fw-semibold d-block mb-1">평균 처리 시간</span>
                                <h3 class="card-title mb-2" id="kpiAvgTime">-시간</h3>
                                <small class="fw-semibold" id="kpiAvgTimeDiff">-</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-8 col-lg-8 order-1 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title m-0 me-2">일별 VOC 접수 추이</h5>
                                <small class="text-muted">최근 한달 데이터</small>
                            </div>
                            <div class="card-body px-0">
                                <div id="vocTrendChart" class="px-2" style="min-height: 300px;"></div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-4 col-lg-4 order-2 mb-4">
                        <div class="card h-100">
                            <div class="card-header d-flex align-items-center justify-content-between">
                                <h5 class="card-title m-0 me-2">불만 유형</h5>
                            </div>
                            <div class="card-body">
                                <div id="vocCategoryChart" class="mb-3"></div>
                                
                                <ul class="p-0 m-0">
                                    <li class="d-flex mb-4 pb-1">
                                        <div class="avatar flex-shrink-0 me-3">
                                        	<a href="javascript:void(0);" class="voc-link" data-type="HYGIENE">
								                <span class="avatar-initial rounded bg-label-primary"><i class='bx bx-spray-can'></i></span>
								            </a>
                                        </div>
                                        <div class="d-flex w-100 flex-wrap align-items-center justify-content-between gap-2">
                                            <div class="me-2">
                                                <h6 class="mb-0">HYGIENE</h6>
                                                <small class="text-muted">위생, 청결</small>
                                            </div>
                                            <div class="user-progress">
                                                <small class="fw-semibold" id="hygieneProgress"></small>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="d-flex mb-4 pb-1">
                                        <div class="avatar flex-shrink-0 me-3">
                                        	<a href="javascript:void(0);" class="voc-link" data-type="SERVICE">
	                                            <span class="avatar-initial rounded bg-label-success"><i class="bx bx-user-voice"></i></span>
								            </a>
                                        </div>
                                        <div class="d-flex w-100 flex-wrap align-items-center justify-content-between gap-2">
                                            <div class="me-2">
                                                <h6 class="mb-0">SERVICE</h6>
                                                <small class="text-muted">직원 태도, 불친절</small>
                                            </div>
                                            <div class="user-progress">
                                                <small class="fw-semibold" id="serviceProgress"></small>
                                            </div>
                                        </div>
                                    </li>
                                    <li class="d-flex">
                                        <div class="avatar flex-shrink-0 me-3">
                                        	<a href="javascript:void(0);" class="voc-link" data-type="TASTE">
	                                            <span class="avatar-initial rounded bg-label-info"><i class='bx bx-coffee'></i></span>
								            </a>
                                        </div>
                                        <div class="d-flex w-100 flex-wrap align-items-center justify-content-between gap-2">
                                            <div class="me-2">
                                                <h6 class="mb-0">TASTE</h6>
                                                <small class="text-muted">음식 맛, 온도</small>
                                            </div>
                                            <div class="user-progress">
                                                <small class="fw-semibold" id="tasteProgress">25%</small>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 col-lg-6 order-0 mb-4">
                        <div class="card h-100">
                            <div class="card-header d-flex align-items-center justify-content-between">
                                <h5 class="card-title m-0 me-2">불만 다발 가맹점 (Top 5)</h5>
                            </div>
                            <div class="card-body">
                                <ul class="p-0 m-0" id="topStoreList">
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 col-lg-6 order-1 mb-4">
                        <div class="card h-100">
                             <div class="card-header d-flex align-items-center justify-content-between">
                                <h5 class="card-title m-0 me-2">CS 담당자 처리 현황</h5>
                            </div>
                            <div class="table-responsive text-nowrap">
                                <table class="table table-borderless">
                                    <thead>
                                        <tr>
                                            <th>담당자</th>
                                            <th>처리 완료</th>
                                            <th>처리 중</th>
                                            <th>처리 대기</th>
                                            <th>평균시간</th>
                                        </tr>
                                    </thead>
                                    <tbody id="managerTableBody">
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                </div> </div>
            </div>
            <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
            <div class="content-backdrop fade"></div>
          </div>
          </div>
        </div>

      <div class="layout-overlay layout-menu-toggle"></div>
    </div>
    <script src="/vendor/libs/jquery/jquery.js"></script>
    <script src="/vendor/libs/popper/popper.js"></script>
    <script src="/vendor/js/bootstrap.js"></script>
    <script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="/vendor/js/menu.js"></script>

    <script src="/vendor/libs/apex-charts/apexcharts.js"></script>
    
    <script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>

    <script src="/js/main.js"></script>
    <script src="/js/store/voc/statistics.js"></script>

  </body>
</html>
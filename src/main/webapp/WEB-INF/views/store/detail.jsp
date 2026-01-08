<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

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

    <title>가맹점 관리</title>

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
    
    <!-- kakao -->
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoKey}&libraries=services"></script>
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
              
			    <div class="col-12 px-0">
                    <ul class="nav nav-pills mb-3" role="tablist">
                        <li class="nav-item">
                        	<a href="/store/detail" class="nav-link active"><i class="bx bx-store me-1"></i> 가맹점 정보</a>
                        </li>
                        <li class="nav-item">
                        	<a href="/store/contract/list" class="nav-link"><i class="bx bx-file me-1"></i> 계약 기록</a>
                        </li>
                        <li class="nav-item">
                        	<a href="/store/evaluation" class="nav-link"><i class="bx bx-clipboard me-1"></i> 평가 현황</a>
                        </li>
                    </ul>
                </div>
                <h4 class="fw-bold py-3 mb-3"><a href="/store/list" class="text-muted fw-normal">가맹점 /</a> 상세 정보</h4>
               	<div class="col-md-6 col-lg-6 mb-4">
				    <div class="card h-100">
				        <div class="card-header d-flex justify-content-between align-items-center">
				            <h5 class="mb-0"><i class="bx bx-detail text-primary" style="margin-right: 10px"></i> 상세 정보</h5>
				            <button type="button" class="btn btn-outline-warning btn-sm">
				                <span class="tf-icons bx bx-edit-alt"></span> 정보 수정
				            </button>
				        </div>
				        <div class="card-body">
				            <div class="info-container">
				                <ul class="list-unstyled">
				                    <li class="mb-3">
				                        <span class="fw-bold me-2">가맹점명:</span>
				                        <span>${store.storeName}</span> 
				                    </li>
				                    <li class="mb-3">
				                        <span class="fw-bold me-2">상태:</span>
				                        <span class="badge bg-label-success">${store.storeStatus}</span>
				                    </li>
				                    <li class="mb-3">
				                        <span class="fw-bold me-2">영업 시간:</span>
				                        <span>${store.storeStartTime} ~ ${store.storeCloseTime}</span> 
				                    </li>
				                    <li class="mb-3">
				                        <span class="fw-bold me-2">등록일:</span>
				                        <span>${store.storeCreatedAt}</span> 
				                    </li>
				                    <li class="mb-3">
				                        <span class="fw-bold me-2">최종 수정일:</span>
				                        <span>${store.storeUpdatedAt}</span> 
				                    </li>
				                </ul>
				            </div>
				        </div>
				    </div>
				</div>
				
				<div class="col-md-6 col-lg-6 mb-4">
				    <div class="card h-100">
				        <div class="card-header">
				            <h5 class="mb-0"><i class="bx bx-map text-primary" style="margin-right: 10px"></i>주소</h5>
				        </div>
				        <div class="card-body">
				            <div id="map" style="width: 100%; height: 300px; background-color: #f0f0f0; border-radius: 0.375rem; display: flex; align-items: center; justify-content: center;">
				            	<input type="hidden" value="${store.storeLatitude}" id="storeLatitude">
				            	<input type="hidden" value="${store.storeLongitude}" id="storeLongitude">
				            </div>
				            <div class="mt-3">
				            	<span>${store.storeAddress} (${store.storeZonecodeStr})</span>
				            </div>
				        </div>
				    </div>
				</div>
				
				<div class="col-12">
				    <div class="card">
				        <div class="card-header d-flex justify-content-between align-items-center">
				            <h5 class="mb-0"><i class="bx bx-briefcase text-primary" style="margin-right: 10px"></i>가맹점 담당자 이력</h5>
				            <div>
				            	<c:set var="hasManager" value="${not empty manageList}" />
				                <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateManagerModal">
				                    <span class="tf-icons bx ${hasManager ? 'bx-refresh' : 'bx-user-plus'}"></span> 
				                    ${hasManager ? '담당자 교체' : '담당자 배정'}
				                </button>
				            </div>
				        </div>
				        <div class="table-responsive text-nowrap">
				            <table class="table table-hover">
				                <thead>
				                    <tr>
				                        <th>이력 ID</th>
				                        <th>담당</th>
				                        <th>담당 시작일</th>
				                        <th>담당 종료일</th>
				                        <th>상태</th> 
				                    </tr>
				                </thead>
				                <tbody class="table-border-bottom-0">
				                    <c:forEach var="history" items="${manageList}">
				                    	<c:set var="isActive" value="${empty history.manageEndDate}" />
				                        <tr>
				                            <td><strong>${history.manageId}</strong></td>
				                            <td>
				                            	<div class="d-flex align-items-center">
				                                	<div class="avatar avatar-xs me-2">
				                                        <span class="avatar-initial rounded-circle ${isActive ? 'bg-label-success' : 'bg-label-secondary'}">${history.memName.charAt(0)}</span>
				                                    </div>
					                            	${history.memName}
				                            	</div>
				                            </td> 
				                            <td>${history.manageStartDate}</td>
				                            <td>${isActive ? '-' : history.manageEndDate}</td>
				                            <td>
				                                <span class="badge ${isActive ? 'bg-label-success' : 'bg-label-secondary'}">
									                ${isActive ? '현재 담당중' : '담당 종료'}
									            </span>
				                            </td>
				                        </tr>
				                    </c:forEach>
				                    <c:if test="${empty manageList}">
				                        <tr>
				                            <td colspan="5" class="text-center">담당 이력이 없습니다.</td>
				                        </tr>
				                    </c:if>
				                </tbody>
				            </table>
				        </div>
				    </div>
                </div>
	          </div>
            </div>
            
           	<div class="modal fade" id="updateManagerModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
		        <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
		            <div class="modal-content">
		            
		                <div class="modal-header">
		                    <h5 class="modal-title"><i class="bx bx-briefcase text-primary" style="margin-right: 10px"></i>가맹점 담당자 배정</h5>
		                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		                </div>
		                
		                <div class="modal-body">
		                    <form id="updateManagerForm" onsubmit="return false;">
		                        <div class="row g-3 mb-3">
		                            <div class="col-md-6 position-relative">
		                                <label class="form-label" for="managerNameInput">사원명 검색 <span class="text-danger">*</span></label>
		                                <div class="input-group">
		                                    <input type="text" id="managerNameInput" class="form-control" placeholder="사원명 입력" onkeyup="if(window.event.keyCode==13){searchManager()}" required />
		                                    <input type="hidden" id="memberId" name="memberId" />
		                                    <button class="btn btn-primary" type="button" onclick="searchManager()">
		                                        <i class="bx bx-search"></i>
		                                    </button>
		                                </div>
		                                
		                                <ul id="managerResultList" class="list-group position-absolute overflow-auto" 
								        	style="max-height: 200px; width: 90%; z-index: 1050; display: none; margin-top: 5px; box-shadow: 0 0.25rem 1rem rgba(0,0,0,0.15); background-color: rgba(255, 255, 255, 0.9);">
								        </ul>
		                            </div>
		                            
		                            <div class="col-md-6 position-relative">
		                                <label class="form-label" for="manageStartDate">담당 시작일 <span class="text-danger">*</span></label>
	                                    <input type="date" id="manageStartDate" class="form-control" />
		                            </div>
		                            <input type="hidden" id="storeId" value="${store.storeId}">
		                        </div>
		                        
		                        <div id="selectedManager" class="mt-3">
						            <label class="form-label">담당자</label>
						            <div class="card">
						                <div class="card-body p-3">
						                	<div id="emptyState" class="text-center py-4">
								                <i class="bx bx-search-alt text-muted fs-1 mb-2"></i>
								                <p class="text-muted mb-0">사원명을 검색 후 선택해주세요</p>
								            </div>
								            
						                    <div id="managerInfo" class="d-flex align-items-start" style="display: none !important;">
						                    	<div class="avatar avatar-md me-3">
								                    <span id="selectedAvatar" class="avatar-initial rounded-circle bg-label-primary fs-5"></span>
								                </div>
								                
								               <div class="flex-grow-1">
								                    <div class="mb-2">
								                        <div class="d-flex justify-content-between align-items-center gap-2">
								                            <h6 class="mb-1 fw-bold">
								                            	<span id="selectedName"></span> 
								                            	<small id="selectedId" class="text-muted"></small>
								                            </h6>
									                        <small class="text-primary">영업부</small>
								                        </div>
								                    </div>
								                    
								                    
								                    <div class="mt-2 pt-2 border-top">
								                    	<div class="row g-2">
								                            <div class="col-12">
								                                <small class="text-muted d-flex align-items-center">
								                                    <i class="bx bx-envelope text-primary me-1"></i>
								                                    <span id="selectedEmail"></span>
								                                </small>
								                            </div>
								                            <div class="col-12">
								                                <small class="text-muted d-flex align-items-center">
								                                    <i class="bx bx-phone text-primary me-1"></i>
								                                    <span id="selectedPhone"></span>
								                                </small>
								                            </div>
								                            <div class="col-12">
								                                <small class="text-muted d-flex align-items-center">
								                                    <i class="bx bx-store text-primary me-1"></i>
								                                    <span>현재 담당 가맹점 수: <strong id="selectedStoreCount" class="text-primary">0</strong>개</span>
								                                </small>
								                            </div>
								                        </div>
								                    </div>
								               </div>
						                    </div>
						                </div>
						            </div>
						        </div>
		                    </form>
		                </div>
		                
		                <div class="modal-footer">
		                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
		                    <button type="button" class="btn btn-primary" onclick="submitManagerUpdate()">배정</button>
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
    
    <script>
	    const currentPath = window.location.pathname;
	
	    document.querySelectorAll('.nav-pills .nav-link').forEach(link => {
	        if (link.getAttribute('href') === currentPath) {
	            link.classList.add('active');
	        } else {
	            link.classList.remove('active');
	        }
	    });
	</script>
    

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
    
    <script type="text/javascript" src="/js/store/detail.js"></script>
  </body>
</html>
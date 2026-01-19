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

    <title>VOC 관리</title>

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
	<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

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
              
			    <div class="col-12 px-0">
                    <ul class="nav nav-pills mb-3" role="tablist">
                        <li class="nav-item">
                        	<a href="/store/voc/list" class="nav-link active"><i class="bx bx-support me-1"></i> VOC</a>
                        </li>
						<sec:authorize access="hasAnyRole('DEPT_SALES')">
							<li class="nav-item">
								<a href="/store/voc/my-list" class="nav-link"><i class="bx bx-user-check"></i> 담당 가맹점</a>
							</li>
						</sec:authorize>
                        <li class="nav-item">
                        	<a href="/store/voc/statistics" class="nav-link"><i class="bx bx-bar-chart-alt-2 me-1"></i> 통계</a>
                        </li>
                    </ul>
                </div>
                <h4 class="fw-bold py-3 mb-3"><span class="text-muted fw-normal">VOC /</span> 목록</h4>
                <div id="tab-content-area">
                   	<div class="card shadow-none border bg-white mb-4">
						<div class="card-body py-3 px-3">
							<form id="vocSearchForm" method="get" action="${baseUrl}">
							    <input type="hidden" name="page" id="page" value="1">
								<input type="hidden" name="perPage" id="hiddenPerPage" value="${pager.perPage}">
							    <div class="row g-3">
							        <div class="col-12 col-lg-3">
							            <label class="form-label small">불만 유형</label>
							            <select class="form-select" id="searchVocType" name="searchVocType">
							                <option value="">전체</option>
							                <option value="HYGIENE" ${pager.searchVocType eq 'HYGIENE' ? 'selected' : ''}>위생</option>
							                <option value="TASTE" ${pager.searchVocType eq 'TASTE' ? 'selected' : ''}>맛</option>
							                <option value="SERVICE" ${pager.searchVocType eq 'SERVICE' ? 'selected' : ''}>서비스</option>
							            </select>
							        </div>
							
							        <div class="col-12 col-lg-3">
							            <label class="form-label small">처리 상태</label>
							            <select class="form-select" id="searchVocStatus" name="searchVocStatus">
							                <option value="">전체</option>
							                <option value="0" ${pager.searchVocStatus eq 0 ? 'selected' : ''}>처리 대기</option>
							                <option value="1" ${pager.searchVocStatus eq 1 ? 'selected' : ''}>처리 중</option>
							                <option value="2" ${pager.searchVocStatus eq 2 ? 'selected' : ''}>처리 완료</option>
							            </select>
							        </div>
							
							        <div class="col-12 col-lg-6">
									    <label class="form-label small">접수 기간</label>
									    <div class="input-group">
									        <span class="input-group-text"><i class="bx bx-calendar"></i></span>
									        <input type="text" class="form-control" id="daterange" placeholder="기간을 선택하세요" />
									    </div>
									    
									    <input type="hidden" id="searchStartDate" name="searchStartDate" value="${pager.searchStartDate}" />
									    <input type="hidden" id="searchEndDate" name="searchEndDate" value="${pager.searchEndDate}" />
									</div>
							
							        <div class="col-12 col-lg-3">
							            <label class="form-label small">가맹점명</label>
							            <div class="input-group">
					                    	<span class="input-group-text"><i class="bx bx-store"></i></span>
					                        <input type="text" class="form-control" placeholder="가맹점명" id="searchStoreName" name="searchStoreName" value="${pager.searchStoreName}" />
					                    </div>
							        </div>
							
							        <div class="col-12 col-lg-6">
							            <label class="form-label small">제목</label>
							            <div class="input-group">
							            	<span class="input-group-text"><i class='bx bx-detail'></i></span>
								            <input type="text" class="form-control" placeholder="제목 검색" id="searchVocTitle" name="searchVocTitle" value="${pager.searchVocTitle}" />
							            </div>
							        </div>
							
							        <div class="col-12 col-lg-3 d-flex align-items-end justify-content-end gap-2">
							            <button class="btn btn-outline-secondary text-nowrap" type="button" onclick="resetSearchForm()"> 
							                <i class="bx bx-refresh"></i> 초기화
							            </button>
							            <button class="btn btn-primary text-nowrap" type="button" onclick="searchVoc()">
							                <i class="bx bx-search me-1"></i> 조회
							            </button>
							        </div>
							    </div>
							</form>
						</div>
					</div>
					        
					<div class="card shadow-none border bg-white">
					     	
						<div class="card-header d-flex justify-content-between align-items-center">
							<select class="form-select" style="width: auto; margin-right: 1rem;" onchange="changePerPage(this.value)">
								<option value="10" ${pager.perPage == 10 ? 'selected' : ''}>10개씩 보기</option>
								<option value="50" ${pager.perPage == 50 ? 'selected' : ''}>50개씩 보기</option>
								<option value="100" ${pager.perPage == 100 ? 'selected' : ''}>100개씩 보기</option>
							</select>
					        <div>
					       		<button type="button" class="btn btn-outline-success me-2" onclick="downloadExcel()">
					            	<i class='bx bx-download me-1'></i> 엑셀 다운로드
					            </button>
								<sec:authorize access="hasAnyRole('DEPT_CS', 'EXEC', 'MASTER')">
									<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerVocModal">
										<i class="bx bx-plus me-1"></i> VOC 등록
									</button>
								</sec:authorize>
					     	</div>
						</div>
					  
					    <div class="table-responsive">
					    	<table class="table table-hover table-striped">
					          
					        	<thead>
					            	<tr>
					              		<th width="7%" onclick="moveSort('vocId')" style="cursor: pointer;">ID <i id="icon_vocId" class="bx bx-sort-alt-2 sort-icon"></i></th>
					              		<th onclick="moveSort('storeName')" style="cursor: pointer;">가맹점명 <i id="icon_storeName" class="bx bx-sort-alt-2 sort-icon"></i></th>
						                <th onclick="moveSort('type')" style="cursor: pointer;">유형 <i id="icon_type" class="bx bx-sort-alt-2 sort-icon"></i></th>
					              		<th onclick="moveSort('title')" style="cursor: pointer;">제목 <i id="icon_title" class="bx bx-sort-alt-2 sort-icon"></i></th>
						              	<th onclick="moveSort('writer')" style="cursor: pointer;">작성자 <i id="icon_writer" class="bx bx-sort-alt-2 sort-icon"></i></th>
						              	<th onclick="moveSort('status')" style="cursor: pointer;">진행상태 <i id="icon_status" class="bx bx-sort-alt-2 sort-icon"></i></th>
						              	<th onclick="moveSort('datetime')" style="cursor: pointer;">접수일시 <i id="icon_datetime" class="bx bx-sort-alt-2 sort-icon"></i></th>
						            </tr>
					          	</thead>
					            
					          	<tbody>
					            	<c:forEach items="${list}" var="dto">
					       				<tr>
					         				<td class="fw-bold">${dto.vocId}</td>
								            <td>
												<a href="/store/voc/detail?vocId=${dto.vocId}"
								            	   class="fw-bold text-primary">${dto.storeName}</a>
											</td>
								            <td>
								            	<c:if test="${dto.vocType eq 'HYGIENE'}"><span class="badge bg-label-primary">위생</span></c:if>
								            	<c:if test="${dto.vocType eq 'SERVICE'}"><span class="badge bg-label-secondary">서비스</span></c:if>
								            	<c:if test="${dto.vocType eq 'TASTE'}"><span class="badge bg-label-danger">맛</span></c:if>
								            </td>
								            <td>${dto.vocTitle}</td>
								            <td>${dto.memName}</td>
								            <td>
								            	<c:if test="${dto.vocStatus eq 0}"><span class="badge bg-label-warning">${dto.vocStatusStr}</span></c:if>
								            	<c:if test="${dto.vocStatus eq 1}"><span class="badge bg-label-info">${dto.vocStatusStr}</span></c:if>
								            	<c:if test="${dto.vocStatus eq 2}"><span class="badge bg-label-success">${dto.vocStatusStr}</span></c:if>
								            </td>
								            <td>${dto.vocCreatedAtStr}</td>
					                    </tr>
					                </c:forEach>
									<c:if test="${empty list}"><td colspan="7" class="text-center">해당 데이터가 없습니다.</td></c:if>
					            </tbody>
					        </table>
					    </div>
					            
					    <div class="card-footer d-flex justify-content-center">
					        <nav aria-label="Page navigation">
					            <ul class="pagination">
					                <li class="page-item ${pager.begin == 1 ? 'disabled' : ''}"><a class="page-link" href="javascript:movePage(${pager.begin - 1})"><i class="bx bx-chevron-left"></i></a></li>
					                <c:forEach begin="${pager.begin}" end="${pager.end}" var="i">
									    <li class="page-item ${pager.page == i ? 'active' : ''}"><a class="page-link" href="javascript:movePage(${i})">${i}</a></li>
							  		</c:forEach>
					                <li class="page-item next"><a class="page-link" href="javascript:movePage(${pager.end + 1})"><i class="bx bx-chevron-right"></i></a></li>
					            </ul>
					        </nav>
					    </div>
					</div>
                </div>
			  	
	          </div>

			<sec:authorize access="hasAnyRole('DEPT_CS', 'EXEC', 'MASTER')">
				<div class="modal fade" id="registerVocModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
					<div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" role="document">
						<div class="modal-content">

							<div class="modal-header">
								<h5 class="modal-title">신규 VOC 등록</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>

							<div class="modal-body">
								<form id="registerStoreForm">
									<div class="row g-3">
										<div class="col-md-12">
											<label class="form-label" for="storeNameInput">가맹점명 검색 <span class="text-danger">*</span></label>
											<div class="input-group input-group-merge">
												<span class="input-group-text"><i class="bx bx-store"></i></span>
												<input type="text" id="storeNameInput" name="storeName" class="form-control" placeholder="가맹점명 입력" onkeyup="if(window.event.keyCode==13){searchStore()}" required />
												<input type="hidden" id="storeId" name="storeId" />
												<button class="btn btn-primary" type="button" onclick="searchStore()">
													<i class="bx bx-search"></i>
												</button>
											</div>

											<ul id="storeResultList" class="list-group position-absolute overflow-auto"
												style="max-height: 200px; width: 90%; z-index: 1050; display: none; margin-top: 5px; box-shadow: 0 0.25rem 1rem rgba(0,0,0,0.15); background-color: rgba(255, 255, 255, 0.9);">
											</ul>
										</div>

										<div class="col-12"><hr class="my-2"></div>

										<div class="col-md-6">
											<label class="form-label" for="vocType">불만 유형 <span class="text-danger">*</span></label>
											<div class="input-group">
												<select class="form-select" id="vocType">
													<option value="HYGIENE" selected>위생</option>
													<option value="TASTE">맛</option>
													<option value="SERVICE">서비스</option>
												</select>
											</div>
										</div>

										<div class="col-md-6 position-relative">
											<label class="form-label" for="vocContact">고객 연락처 <span class="text-danger">*</span></label>
											<div class="input-group">
												<input type="text" id="vocContact" class="form-control" placeholder="연락처 입력" required />
											</div>
										</div>

										<div class="col-12"><hr class="my-2"></div>

										<div class="col-md-12">
											<label class="form-label" for="vocTitle">제목 <span class="text-danger">*</span></label>
											<div class="input-group">
												<input type="text" id="vocTitle" name="vocTitle" class="form-control" placeholder="위생관련 컴플레인" required />
											</div>
										</div>

										<div class="col-md-12">
											<label class="form-label" for="vocContents">상세 내용</label>
											<div class="input-group">
												<textarea class="form-control" rows="3" id="vocContents"></textarea>
											</div>
										</div>

									</div>
								</form>
							</div>

							<div class="modal-footer">
								<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
								<button type="button" class="btn btn-primary" onclick="submitVocRegistration()">저장</button>
							</div>

						</div>
					</div>
				</div>
			</sec:authorize>

     
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
    
    <script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    

    <!-- Main JS -->
    <script src="/js/main.js"></script>

    <!-- Page JS -->
    <script src="/js/dashboards-analytics.js"></script>

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    
    <script type="text/javascript" src="/js/store/voc/voc.js"></script>
	<script type="text/javascript" src="/js/pager/sort.js"></script>
    
  </body>
</html>
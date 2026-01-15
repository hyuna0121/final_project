<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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

    <title>QSC 리스트</title>

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
  	<sec:authentication property="principal.member" var="memberInfo"/>
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
							<a href="/store/qsc/list" class="nav-link active"><i class="bx bx-task me-1"></i> QSC</a>
						</li>
						<li class="nav-item">
							<a href="/store/qsc/admin/question" class="nav-link active"><i class="bx bx-list-check me-1"></i> 항목</a>
						</li>
                    </ul>
                </div>
                <h4 class="fw-bold py-3 mb-3"><span class="text-muted fw-normal">QSC /</span> 질문 목록</h4>
                <div id="tab-content-area">
                   	<div class="card shadow-none border bg-white mb-4">
						<div class="card-body py-3 px-3">
					    	<form id="questionSearchForm" method="get" action="/store/qsc/admin/question">
					    		<input type="hidden" name="page" id="page" value="1">
								<input type="hidden" name="perPage" id="hiddenPerPage" value="${pager.perPage}">
					      		<div class="row g-3">
					        		<div class="col-12 col-sm-6 col-md-4 col-lg-2">
					          			<label class="form-label small">카테고리</label>
								        	<select class="form-select" id="searchCategory" name="searchCategory">
								            	<option value="">전체</option>
								                <option value="Quality" ${pager.searchCategory == 'Quality' ? 'selected' : ''}>Quality</option>
								                <option value="Service" ${pager.searchCategory == 'Service' ? 'selected' : ''}>Service</option>
								                <option value="Cleanliness" ${pager.searchCategory == 'Cleanliness' ? 'selected' : ''}>Cleanliness</option>
								            </select>
					        		</div>
									<div class="col-12 col-sm-6 col-md-4 col-lg-2">
										<label class="form-label small">사용여부</label>
										<select class="form-select" id="searchIsUse" name="searchIsUse">
											<option value="">전체</option>
											<option value="true" ${pager.searchIsUse eq true ? 'selected' : ''}>사용</option>
											<option value="false" ${pager.searchIsUse eq false ? 'selected' : ''}>미사용</option>
										</select>
									</div>
									<div class="col-12 col-md-6 col-lg-4">
										<label class="form-label small">질문</label>
										<div class="input-group">
											<span class="input-group-text"><i class='bx bx-detail'></i></span>
											<input type="text" class="form-control" placeholder="질문" id="searchQuestion" name="searchQuestion" value="${pager.searchQuestion}" />
										</div>
									</div>


							        <div class="col-12 col-lg-4 d-flex align-items-end justify-content-end gap-2 mt-4">
										<button class="btn btn-outline-secondary text-nowrap" type="button" onclick="resetSearchForm()"><i class="bx bx-refresh"></i> 초기화</button>
							            <button class="btn btn-primary text-nowrap" onclick="searchQuestion()">
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
								<!-- 영업팀 or Admin 권한 -->
								<sec:authorize access="hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')">
									<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerQuestionModal">
										<i class="bx bx-plus me-1"></i> 질문 등록
									</button>
								</sec:authorize>
					     	</div>
						</div>
					  
					    <div class="table-responsive">
					    	<table class="table table-hover table-striped">
					          
					        	<thead>
					            	<tr>
					              		<th width="7%" onclick="moveSort('listId')" style="cursor: pointer;">ID <i id="icon_listId" class="bx bx-sort-alt-2 sort-icon"></i></th>
					              		<th onclick="moveSort('category')" style="cursor: pointer;">카테고리 <i id="icon_category" class="bx bx-sort-alt-2 sort-icon"></i></th>
					              		<th onclick="moveSort('question')" style="cursor: pointer;">질문 <i id="icon_question" class="bx bx-sort-alt-2 sort-icon"></i></th>
						                <th onclick="moveSort('score')" style="cursor: pointer;">배점 <i id="icon_score" class="bx bx-sort-alt-2 sort-icon"></i></th>
						              	<th onclick="moveSort('isUsed')" style="cursor: pointer;">사용여부 <i id="icon_isUsed" class="bx bx-sort-alt-2 sort-icon"></i></th>
										<sec:authorize access="hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')"><th>변경</th></sec:authorize>
						            </tr>
					          	</thead>
					            
					          	<tbody>
					            	<c:forEach items="${list}" var="dto">
					       				<tr>
					         				<td class="fw-bold">${dto.listId}</td>
								            <td>
												<c:if test="${dto.listCategory eq 'Quality'}"><span class="badge bg-label-primary">${dto.listCategory}</span></c:if>
												<c:if test="${dto.listCategory eq 'Service'}"><span class="badge bg-label-warning">${dto.listCategory}</span></c:if>
												<c:if test="${dto.listCategory eq 'Cleanliness'}"><span class="badge bg-label-info">${dto.listCategory}</span></c:if>
											</td>
								            <td>${dto.listQuestion}</td>
								            <td>${dto.listMaxScore}</td>
								            <td>
								            	<c:if test="${dto.listIsUse eq true}"><span class="badge bg-label-success">사용</span></c:if>
								            	<c:if test="${dto.listIsUse eq false}"><span class="badge bg-label-danger">미사용</span></c:if>
								            </td>
											<sec:authorize access="hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')">
												<td>
													<button class="btn btn-sm btn-icon btn-outline-secondary"
															data-id="${dto.listId}"
															data-category="${dto.listCategory}"
															data-question="${dto.listQuestion}"
															data-score="${dto.listMaxScore}"
															data-status="${dto.listIsUse}"
															onclick="openUpdateModal(this)">
														<i class="bx bx-edit"></i>
													</button>
												</td>
											</sec:authorize>
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

			<sec:authorize access="hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')">
				<div class="modal fade" id="registerQuestionModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
					<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
						<div class="modal-content">

							<div class="modal-header">
								<h5 class="modal-title">신규 QSC 질문 등록</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>

							<div class="modal-body">
								<form id="registerQuestionForm">
									<div class="row g-3">
										<div class="col-md-6">
											<label class="form-label" for="listCategory">카테고리 <span class="text-danger">*</span></label>
											<div class="input-group">
												<select class="form-select" id="listCategory">
													<option value="Quality" selected>Quality</option>
													<option value="Service">Service</option>
													<option value="Cleanliness">Cleanliness</option>
												</select>
											</div>
										</div>

										<div class="col-md-6">
											<label class="form-label" for="listMaxScore">배점 <span class="text-danger">*</span></label>
											<div class="input-group">
												<span class="input-group-text"><i class="bx bx-star"></i></span>
												<input type="text" id="listMaxScore" name="listMaxScore" class="form-control" placeholder="1 ~ 10" oninput="handleMaxScore(this)" required />
											</div>
										</div>

										<div class="col-md-12">
											<label class="form-label" for="listQuestion">질문 <span class="text-danger">*</span></label>
											<div class="input-group">
												<span class="input-group-text"><i class='bx bx-detail'></i></span>
												<input type="text" id="listQuestion" name="listQuestion" class="form-control" placeholder="질문 입력" required />
											</div>
										</div>


									</div>
								</form>
							</div>

							<div class="modal-footer">
								<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
								<button type="button" class="btn btn-primary" onclick="submitQuestionRegistration()">저장</button>
							</div>

						</div>
					</div>
				</div>

				<div class="modal fade" id="updateQuestionModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
					<div class="modal-dialog modal-dialog-centered modal-dialog-scrollable" role="document">
						<div class="modal-content">

							<div class="modal-header">
								<h5 class="modal-title">QSC 질문 사용여부 변경</h5>
								<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
							</div>

							<div class="modal-body">
								<form id="updateQuestionForm">
									<input type="hidden" id="updateListId">
									<div class="row g-3">
										<div class="col-md-4">
											<label class="form-label" for="updateListCategory">카테고리</label>
											<div class="input-group">
											<span class="form-control" id="updateListCategory"></span>
											</div>
										</div>

										<div class="col-md-4">
											<label class="form-label" for="listMaxScore">배점</label>
											<div class="input-group">
												<span class="input-group-text"><i class="bx bx-star"></i></span>
												<span class="form-control" id="updateListMaxScore"></span>
											</div>
										</div>

										<div class="col-md-4">
											<label class="form-label" for="listStatus">사용여부 <span class="text-danger">*</span></label>
											<div class="input-group">
												<select class="form-select" id="listStatus">
													<option value="true" selected>사용</option>
													<option value="false">미사용</option>
												</select>
											</div>
										</div>

										<div class="col-md-12">
											<label class="form-label" for="updateListQuestion">질문</label>
											<div class="input-group">
												<span class="input-group-text"><i class='bx bx-detail'></i></span>
												<span class="form-control" id="updateListQuestion"><i class='bx bx-detail'></i></span>
											</div>
										</div>


									</div>
								</form>
							</div>

							<div class="modal-footer">
								<button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
								<button type="button" class="btn btn-primary" onclick="submitQuestionUpdate()">저장</button>
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

    <!-- Main JS -->
    <script src="/js/main.js"></script>

    <!-- Page JS -->
    <script src="/js/dashboards-analytics.js"></script>

    <!-- Place this tag in your head or just before your close body tag. -->
    <script async defer src="https://buttons.github.io/buttons.js"></script>
    
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/ko.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/plugins/monthSelect/index.js"></script>
    
    <script type="text/javascript" src="/js/store/qsc/question.js"></script>
	<script type="text/javascript" src="/js/pager/sort.js"></script>
  </body>
</html>
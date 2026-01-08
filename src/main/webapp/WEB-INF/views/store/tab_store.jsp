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
                        	<a href="/store/list" class="nav-link active"><i class="bx bx-store me-1"></i> 가맹점 정보</a>
                        </li>
                        <li class="nav-item">
                        	<a href="/store/contract/list" class="nav-link"><i class="bx bx-file me-1"></i> 계약 기록</a>
                        </li>
                        <li class="nav-item">
                        	<a href="/store/evaluation" class="nav-link"><i class="bx bx-clipboard me-1"></i> 평가 현황</a>
                        </li>
                    </ul>
                </div>
                <h4 class="fw-bold py-3 mb-3"><span class="text-muted fw-normal">가맹점 /</span> 목록</h4>
                <div id="tab-content-area">
                   	<div class="card shadow-none border bg-white mb-4">
						<div class="card-body py-3 px-3">
					    	<form id="storeSearchForm" method="get" action="/store/list">
					    		<input type="hidden" name="page" id="page" value="1">
					      		<div class="row g-3">
					        		<div class="col-12 col-sm-6 col-md-4 col-lg-2">
					          			<label class="form-label small">운영 상태</label>
								        	<select class="form-select" id="filterStatus" name="storeStatus">
								            	<option value="">전체</option>
								                <option value="오픈 준비" ${pager.storeStatus == '오픈 준비' ? 'selected' : ''}>오픈 준비</option>
								                <option value="오픈" ${pager.storeStatus == '오픈' ? 'selected' : ''}>오픈</option>
								                <option value="폐업" ${pager.storeStatus == '폐업' ? 'selected' : ''}>폐업</option>
								            </select>
					        		</div>
							        <div class="col-12 col-sm-6 col-md-4 col-lg-2">
										<label class="form-label small">오픈 시간</label>
							            <input type="time" class="form-control" id="filterOpenTime" name="storeStartTime" value="${pager.storeStartTime}" />
							        </div>
							        <div class="col-12 col-sm-6 col-md-4 col-lg-2">
										<label class="form-label small">종료 시간</label>
							            <input type="time" class="form-control" id="filterCloseTime" name="storeCloseTime" value="${pager.storeCloseTime}" />
							        </div>
									<div class="col-12 col-sm-6 col-md-4 col-lg-3">
										<label class="form-label small">주소 (지역)</label>
										<div class="input-group">
					                    	<span class="input-group-text"><i class='bx bx-map'></i></span>
					                    	<input type="text" class="form-control" placeholder="예: 서울 강남구" id="filterAddress" name="storeAddress" value="${pager.storeAddress}" />
					                    </div>
									</div>
							        <div class="col-12 col-sm-6 col-md-4 col-lg-3">
							            <label class="form-label small">가맹점명</label>
							        	<div class="input-group">
					                    	<span class="input-group-text"><i class="bx bx-store"></i></span>
					                        <input type="text" class="form-control" placeholder="가맹점명" id="filterKeyword" name="storeName" value="${pager.storeName}" />
					                    </div>
							        </div>
							        <div class="col-12 d-flex align-items-end justify-content-end gap-2 mt-4">
										<button class="btn btn-outline-secondary text-nowrap" type="button" onclick="resetSearchForm()"><i class="bx bx-refresh"></i> 초기화</button>
							            <button class="btn btn-primary text-nowrap" onclick="searchStores()">
							            	<i class="bx bx-search me-1"></i> 조회
							            </button>
							        </div>
					           	</div>
							</form>
						</div>
					</div>
					        
					<div class="card shadow-none border bg-white">
					     	
						<div class="card-header d-flex justify-content-between align-items-center">
					    	<h5 class="mb-0">가맹점 목록</h5>
					        <div>
					       		<button type="button" class="btn btn-outline-success me-2" onclick="downloadExcel()">
					            	<i class='bx bx-download me-1'></i> 엑셀 다운로드
					            </button>
					          	<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerStoreModal">
					                <i class="bx bx-plus me-1"></i> 가맹점 등록
					          	</button>
					     	</div>
						</div>
					  
					    <div class="table-responsive">
					    	<table class="table table-hover table-striped">
					          
					        	<thead>
					            	<tr>
					              		<th width="5%">ID</th>
					              		<th>가맹점명</th>
					              		<th>가맹점주</th>
						                <th>주소</th>
						              	<th>운영상태</th>
						              	<th>운영시간</th>
						                <th>관리</th>
						            </tr>
					          	</thead>
					            
					          	<tbody>
					            	<c:forEach items="${list}" var="dto">
					       				<tr>
					         				<td class="fw-bold">${dto.storeId}</td>
								            <td><a class="fw-bold text-primary" href="/store/detail?storeId=${dto.storeId}">${dto.storeName}</a></td>
								            <td>${dto.memName}</td>
								            <td>${dto.storeAddress}</td>
								            <td>
								            	<c:if test="${dto.storeStatus eq '오픈'}"><span class="badge bg-label-info">${dto.storeStatus}</span></c:if>
								            	<c:if test="${dto.storeStatus eq '오픈 준비'}"><span class="badge bg-label-warning">${dto.storeStatus}</span></c:if>
								            	<c:if test="${dto.storeStatus eq '폐업'}"><span class="badge bg-label-danger">${dto.storeStatus}</span></c:if>
								            </td>
								            <td>${dto.storeStartTime} ~ ${dto.storeCloseTime}</td>
					                        <td>
					                        	<button class="btn btn-sm btn-icon btn-outline-secondary" onclick="location.href='/store/detail?storeId=${dto.storeId}'"><i class="bx bx-edit"></i></button>
					                     	</td>
					                    </tr>
					                </c:forEach>
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
	          
          	<div class="modal fade" id="registerStoreModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
		        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" role="document">
		            <div class="modal-content">
		            
		                <div class="modal-header">
		                    <h5 class="modal-title">신규 가맹점 등록</h5>
		                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
		                </div>
		                
		                <div class="modal-body">
		                    <form id="registerStoreForm">
		                        <div class="row g-3">
		                            <div class="col-md-6">
		                                <label class="form-label" for="storeName">가맹점명 <span class="text-danger">*</span></label>
		                                <div class="input-group">
		                                    <span class="input-group-text"><i class="bx bx-store"></i></span>
		                                    <input type="text" id="storeName" name="storeName" class="form-control" placeholder="가맹점 이름 입력" required />
		                                </div>
		                            </div>
		
		                            <div class="col-md-6 position-relative">
		                                <label class="form-label" for="ownerNameInput">점주 검색 <span class="text-danger">*</span></label>
		                                <div class="input-group">
		                                    <input type="text" id="ownerNameInput" class="form-control" placeholder="점주명 입력" onkeyup="if(window.event.keyCode==13){searchOwner()}" required />
		                                    <input type="hidden" id="memberId" name="memberId" />
		                                    <button class="btn btn-primary" type="button" onclick="searchOwner()">
		                                        <i class="bx bx-search"></i>
		                                    </button>
		                                </div>
		                                
		                                <ul id="ownerResultList" class="list-group position-absolute overflow-auto" 
								        	style="max-height: 200px; width: 90%; z-index: 1050; display: none; margin-top: 5px; box-shadow: 0 0.25rem 1rem rgba(0,0,0,0.15); background-color: rgba(255, 255, 255, 0.9);">
								        </ul>
		                            </div>
		                            
		                            <hr class="my-4" />
		
		                            <div class="col-md-12">
		                                <label class="form-label" for="storeAddress">가맹점 주소 <span class="text-danger">*</span></label>
		                                <div class="input-group">
		                                    <input type="text" id="storeAddress" name="storeAddress" class="form-control" placeholder="주소 검색 버튼을 클릭하세요" readonly required />
		                                    <button class="btn btn-outline-primary" type="button" onclick="searchAddress()">
		                                        <i class="bx bx-map me-1"></i> 주소 검색
		                                    </button>
		                                </div>
		                            </div>
		                            
		                            <div class="col-md-6">
		                                <label class="form-label" for="storeDetailAddress">상세 주소</label>
		                                <div class="input-group">
		                                    <input type="text" id="storeDetailAddress" name="storeDetailAddress" class="form-control" required />
		                                </div>
		                            </div>
		                            
		                            <div class="col-md-6">
		                                <label class="form-label" for="storeZonecode">우편번호 <span class="text-danger">*</span></label>
		                                <div class="input-group">
		                                    <input type="text" id="storeZonecode" name="storeZonecode" class="form-control" readonly="readonly" required />
		                                </div>
		                            </div>
		                            
		                            <input type="hidden" id="storeLatitude" />
		                            <input type="hidden" id="storeLongitude" />
		                            
		                            <div class="col-md-12">
			                            <div id="map" style="width:100%; height:300px; margin-top:25px; border-radius: 0.375rem;"></div>
		                            </div>
		                            
		                            
		                        </div>
		                    </form>
		                </div>
		                
		                <div class="modal-footer">
		                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
		                    <button type="button" class="btn btn-primary" onclick="submitStoreRegistration()">저장</button>
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
    
    <script type="text/javascript" src="/js/store/tab_store.js"></script>
  </body>
</html>
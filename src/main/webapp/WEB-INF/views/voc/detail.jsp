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

    <title>VOC</title>

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
              <h4 class="fw-bold py-3 mb-4"><a href="/store/voc/list" class="text-muted fw-light">VOC /</a> 상세 내역</h4>

              <div class="row">
                <div class="col-xl-7 col-lg-7 col-md-12">
                    <div class="card h-100 mb-4">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bx bx-user-voice me-1"></i> 불만 접수 내용</h5>
                            <c:if test="${dto.vocStatus eq 0}"><span class="badge bg-label-warning">처리 대기</span></c:if>
			            	<c:if test="${dto.vocStatus eq 1}"><span class="badge bg-label-info">처리 중</span></c:if>
			            	<c:if test="${dto.vocStatus eq 2}"><span class="badge bg-label-success">처리 완료</span></c:if>
                        </div>
                        
                        <div class="card-body">
                        	<div class="row mb-3">
		                        <div class="p-3 bg-light border rounded-3">
		                            <h6 class="fw-bold mb-3"><i class="bx bx-store me-1"></i> 가맹점 정보</h6>
		                            <div class="row g-3">
		                                <div class="col-md-3 ps-md-4 border-end">
		                                    <label class="text-muted small d-block">가맹점명</label>
		                                    <span id="detailStoreName" class="fw-semibold fs-6 text-primary">${dto.storeName}</span>
		                                </div>
		                                <div class="col-md-3 ps-md-4 border-end">
		                                    <label class="text-muted small d-block">가맹점주</label>
		                                    <span id="detailMemName" class="fw-semibold fs-6">${dto.ownerName}</span>
		                                </div>
		                                <div class="col-md-6 ps-md-4">
		                                    <label class="text-muted small d-block">주소</label>
		                                    <span id="detailStoreAddress" class="fw-semibold fs-6">${dto.storeAddress}</span>
		                                </div>
		                            </div>
		                        </div>
		                    </div>
		                    
                            <div class="row g-3 mb-4">
					            <div class="col-md-3 ps-md-4 border-end">
					                <label class="text-muted small d-block mb-1">불만 유형</label>
					                <span class="fw-bold fs-6 text-danger">${dto.vocType}</span>
					            </div>
					            <div class="col-md-3 ps-md-4 border-end">
					                <label class="text-muted small d-block mb-1">작성자</label>
					                <span class="fw-semibold fs-6 text-dark">${dto.memName}</span>
					            </div>
					            <div class="col-md-3 ps-md-4 border-end">
					                <label class="text-muted small d-block mb-1">고객 연락처</label>
					                <span class="fw-semibold fs-6 text-dark">${dto.vocContact}</span>
					            </div>
					            <div class="col-md-3 ps-md-4">
					                <label class="text-muted small d-block mb-1">접수 일시</label>
					                <span class="fw-semibold fs-6 text-dark">${dto.vocCreatedAtStr}</span>
					            </div>
					        </div>
					        
                            <div class="row mb-3">
                                <div class="col-12 ps-md-4">
					                <label class="text-muted small d-block mb-2">제목</label>
					                <span class="fw-bold fs-5 text-dark">${dto.vocTitle}</span>
					            </div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-12 ps-md-4">
					                <label class="text-muted small d-block mb-2">상세 내용</label>
					                <div class="p-3 bg-white border rounded-2" style="min-height: 200px;">
					                    <span class="fs-6 text-secondary" style="white-space: pre-line; line-height: 1.6;">${dto.vocContents}</span>
					                </div>
					            </div>
                            </div>
                            
                            <div class="text-end">
                                <a href="/store/voc/list" class="btn btn-outline-secondary">목록</a>
                            </div>
                        </div>
                        
                    </div>
                  </div>

                  <div class="col-xl-5 col-lg-5 col-md-12">
                      <div class="card h-100">
                          <div class="card-header d-flex justify-content-between align-items-center">
                              <h5 class="mb-0"><i class="bx bx-chat me-1"></i>처리 내역 및 소통</h5>
                          </div>
                          
                          <div class="card-body overflow-auto" style="max-height: 500px; background-color: #f8f9fa;" id="replyArea">
                              <c:forEach var="reply" items="${replyList}">
						        <div class="card mb-3 shadow-sm">
						            <div class="card-body p-3">
						                <div class="d-flex justify-content-between mb-1">
						                    <strong class="text-primary">${reply.replyWriter}</strong>
						                    <small class="text-muted">${reply.createdAtStr}</small>
						                </div>
						                <p class="mb-1" style="white-space: pre-line;">${reply.replyContent}</p>
						
						                <c:if test="${not empty reply.fileUuidName}">
						                    <div class="mt-2">
						                        <a href="/upload/${reply.fileUuidName}" target="_blank">
						                            <img src="/upload/${reply.fileUuidName}" class="img-thumbnail" style="max-height: 150px;" alt="첨부이미지">
						                        </a>
						                    </div>
						                </c:if>
						            </div>
						        </div>
						    </c:forEach>
                          </div>

                          <div class="card-footer p-3">
                              <div id="filePreview" class="mb-2 small text-primary" style="display: none;">
						        <i class="bx bx-paperclip"></i> <span id="fileNameDisplay"></span>
						        <button type="button" class="btn-close btn-close-sm ms-2" onclick="clearFile()"></button>
						    </div>
						
						    <div class="input-group input-group-merge">
						        <input type="file" id="replyFile" style="display: none;" onchange="showFileName()">
						        
						        <button class="btn btn-outline-secondary" type="button" onclick="document.getElementById('replyFile').click()">
						            <i class="bx bx-image-add"></i>
						        </button>
						
						        <textarea class="form-control" id="replyContent" rows="2" placeholder="메시지를 입력하세요..."></textarea>
						        
						        <button class="btn btn-primary" type="button" onclick="submitReply()">
						            <i class="bx bx-send"></i> 등록
						        </button>
						    </div>
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
    
    <script type="text/javascript" src="/js/store/voc/detail.js"></script>
  </body>
</html>
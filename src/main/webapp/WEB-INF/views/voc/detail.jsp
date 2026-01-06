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
    <link rel="stylesheet" href="/css/store/voc.css">

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
                          
                          <div class="card-body overflow-auto" style="max-height: 500px; background-color: #f8f9fa; padding-bottom: 0;" id="replyArea">
                              <c:forEach var="process" items="${list}">
                              	<c:set var="isMe" value="${process.memName == '최영업'}" />
						        <div class="d-flex w-100 my-3 ${isMe ? 'justify-content-end' : 'justify-content-start'}">
						            <div style="max-width: 80%;" class="${isMe ? 'text-end' : 'text-start'}">
						                <small class="d-block mb-1 ${isMe ? 'me-2 text-primary fw-bold' : 'ms-2 text-dark fw-bold'}">
						                    ${process.memName}
						                </small>
						                
						                <div class="chat-bubble ${isMe ? 'chat-right' : 'chat-left'} text-start">
										    <span class="d-block">${process.processContents}</span>
										
										    <c:if test="${not empty process.fileDTOs and not empty process.fileDTOs[0].fileOriginalName}">
										        <c:if test="${not empty process.processContents}">
										            <hr class="my-2 ${isMe ? 'border-white opacity-50' : 'border-secondary opacity-25'}">
										        </c:if>
										
										        <div class="file-list d-flex flex-column gap-1">
										            <c:forEach var="file" items="${process.fileDTOs}">
										                <div class="d-flex align-items-center justify-content-between">
										                    
										                    <div class="d-flex align-items-center" style="cursor: pointer;" 
										                         onclick="previewFile('${file.fileOriginalName}', '${file.fileSavedName}')">
										                        <i class="bx bx-file me-1 ${isMe ? 'text-white' : 'text-secondary'}"></i>
										                        <span class="${isMe ? 'text-white' : 'text-dark'} text-truncate" 
										                              style="font-size: 0.85rem;">
										                            ${file.fileOriginalName}
										                        </span>
										                    </div>
										                </div>
										            </c:forEach>
										        </div>
										    </c:if>
										</div>
						
						                <div class="chat-time ${isMe ? 'me-1' : 'ms-1'}">
						                    ${process.processCreatedAtStr}
						                </div>
						            </div>
						        </div>
						    </c:forEach>
                          </div>

                          <div class="card-footer p-3">
                              <div id="filePreview" class="d-flex flex-wrap gap-2 mb-2 small text-primary" style="display: none;">
						    </div>
						
						    <div class="input-group input-group-merge">
						        <label class="input-group-text bg-white border-end-0" for="replyFile" style="cursor: pointer;">
						            <i class="bx bx-paperclip"></i>
						        </label>
						        
						        <input type="file" multiple id="replyFile" style="display: none;" onchange="showFileName()">
						
								<input type="hidden" id="vocId" value="${dto.vocId}">
						        <textarea class="form-control" id="processContents" rows="2" placeholder="메시지를 입력하세요..." style="resize: none; padding: 20px 10px 10px;"></textarea>
						        
						        <button class="btn btn-primary" type="button" onclick="submitVocProcess()">
						            <i class="bx bx-send"></i> 등록
						        </button>
						    </div>
                          </div>
                      </div>
                  </div>

              </div>
            </div>
            <!-- / Content -->
            <div class="modal fade" id="imagePreviewModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
			    <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable" role="document"> 
			    	<div class="modal-content">
			            <div class="modal-header">
			            	<h5 class="modal-title fs-6 text-secondary">미리보기</h5>
			                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			            </div>
			            <div class="modal-body p-20 text-center">
			                <img id="previewImage" src="" class="img-fluid rounded shadow" alt="미리보기">
			                
			                <div id="noPreviewMsg" class="alert alert-light text-center d-none">
			                    <i class="bx bx-info-circle mb-2 fs-1"></i><br>
			                    미리보기를 지원하지 않는 파일 형식입니다.<br>
			                    다운로드 아이콘을 눌러 확인해주세요.
			                </div>
			            </div>
			            <div class="modal-footer">
			                <a id="modalDownloadBtn" href="#" class="btn btn-primary">
			                    <i class="bx bx-download me-1"></i> 다운로드
			                </a>
			                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
			            </div>
			        </div>
			    </div>
			</div>

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
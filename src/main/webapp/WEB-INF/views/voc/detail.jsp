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
		  	<sec:authentication property="principal.member" var="memberInfo"/>

            <div class="container-xxl flex-grow-1 container-p-y">
              <h4 class="fw-bold py-3 mb-4"><a href="/store/voc/list" class="text-muted fw-light">VOC /</a> 상세 내역</h4>

              <div class="row">
                <div class="col-xl-7 col-lg-7 col-md-12 mb-4 mb-lg-0">
                    <div class="card h-100 mb-4">
                        <div class="card-header" style="padding-bottom: 10px;">
							<div class="d-flex justify-content-between align-items-center mb-4">
								<h5 class="mb-0"><i class="bx bx-user-voice me-1"></i> 불만 접수 내용</h5>
								<c:if test="${dto.vocStatus eq 0}"><span class="badge bg-label-warning">처리 대기</span></c:if>
								<c:if test="${dto.vocStatus eq 1}"><span class="badge bg-label-info">처리 중</span></c:if>
								<c:if test="${dto.vocStatus eq 2}"><span class="badge bg-label-success">처리 완료</span></c:if>
							</div>
							<div class="d-flex justify-content-between">
								<div class="d-flex align-items-center small gap-3">
									<div class="d-flex align-items-center">
										<div class="avatar avatar-xs me-2">
											<span class="avatar-initial rounded-circle bg-label-success">${dto.memName.charAt(0)}</span>
										</div>
										${dto.memName}
									</div>
									<span>${dto.vocCreatedAtStr}</span>
								</div>
								<div class="small">
									<sec:authorize access="hasAnyRole('DEPT_SALES', 'EXEC', 'MASTER')">
										<c:if test="${dto.vocStatus eq 1}">
											<button type="button" id="updateBtn" class="btn btn-sm btn-success"><i class='bx bx-check-double'></i> 완료 처리</button>
										</c:if>
										<c:if test="${dto.vocStatus eq 2}">
											<span>${dto.vocUpdatedAtStr}</span>
										</c:if>
									</sec:authorize>
								</div>
							</div>
                        </div>
                        <div class="card-body">
							<div class="col-12"><hr class="mt-1 mb-0 border-light"></div>
                        	<div style="padding-top: 20px;">
		                        <div class="p-3 bg-light border rounded-3 mb-3">
		                            <h6 class="fw-bold mb-3 d-flex align-items-center gap-1"><i class='bx bx-notepad'></i><span>정보</span></h6>
		                            <div class="row g-3">
		                                <div class="col-md-4 ps-md-4">
		                                    <label class="small d-block">가맹점</label>
		                                    <span id="detailStoreName" class="fw-semibold fs-6 text-primary">${dto.storeName} (${dto.ownerName})</span>
		                                </div>
										<div class="col-md-3 ps-md-4">
											<label class="small d-block mb-1">불만 유형</label>
											<c:if test="${dto.vocType eq 'HYGIENE'}"><span class="badge bg-label-primary">위생</span></c:if>
											<c:if test="${dto.vocType eq 'SERVICE'}"><span class="badge bg-label-secondary">서비스</span></c:if>
											<c:if test="${dto.vocType eq 'TASTE'}"><span class="badge bg-label-danger">맛</span></c:if>
										</div>
										<div class="col-md-4">
											<label class="small d-block mb-1">고객 연락처</label>
											<span class="fw-semibold fs-6">${dto.vocContact}</span>
										</div>

		                            </div>
		                        </div>
		                    </div>
							<div class="p-3 bg-light border rounded-3 mb-3">
								<input type="hidden" id="vocId" value="${dto.vocId}">
								<div class="row mb-3">
									<div class="col-12 ps-md-4">
										<label class="small d-block mb-2">제목</label>
										<span id="titleDisplay" class="fw-bold fs-5">${dto.vocTitle}</span>
										<input type="text" id="titleEdit" class="form-control fw-bold" value="${dto.vocTitle}" style="display: none;">
									</div>
								</div>
								<div class="row mb-3">
									<div class="col-12 ps-md-4">
										<label class="small d-block mb-2">상세 내용</label>
										<div style="min-height: 200px;">
											<span id="contentsDisplay" class="fs-6 text-secondary" style="white-space: pre-line; line-height: 1.6;">${dto.vocContents}</span>
											<textarea id="contentsEdit" class="form-control" style="display: none; white-space: pre-line;">${dto.vocContents}</textarea>
										</div>
									</div>
								</div>

							</div>

                            <div class="text-end">
                                <a href="/store/voc/list" id="listBtn" class="btn btn-outline-secondary" style="margin-right: 10px;">목록</a>

								<sec:authorize access="hasAnyRole('DEPT_CS', 'EXEC', 'MASTER')">
									<c:if test="${dto.vocStatus eq 0 and dto.memberId eq memberInfo.memberId}">
										<button type="button" id="editBtn" class="btn btn-primary">수정</button>
										<button type="button" id="cancelBtn" class="btn btn-secondary" style="display: none; margin-right: 10px;">취소</button>
										<button type="button" id="saveBtn" class="btn btn-primary" style="display: none;">저장</button>
									</c:if>
								</sec:authorize>
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
                              <input type="hidden" value="${listSize}" id="isFirst">
                              <c:forEach var="process" items="${list}">
								  <c:set var="isMe" value="${process.memberId eq memberInfo.memberId}" />
						        <div class=" d-flex w-100 my-3 ${isMe ? 'justify-content-end' : 'justify-content-start'}">
						            <div style="max-width: 80%;" class="msg-container ${isMe ? 'text-end' : 'text-start'}">
						                <small class="d-block mb-1 ${isMe ? 'me-2 text-primary fw-bold' : 'ms-2 text-dark fw-bold'}">
						                    ${process.memName}
						                </small>
						                <div class="chat-bubble ${isMe ? 'chat-right' : 'chat-left'} text-start">
											<c:if test="${process.processIsDeleted eq 0}"><span>${process.processContents}</span></c:if>
											<c:if test="${process.processIsDeleted eq 1}"><span>삭제된 메세지입니다.</span></c:if>

										    <c:if test="${not empty process.fileDTOs and not empty process.fileDTOs[0].fileOriginalName}">
										        <c:if test="${not empty process.processContents}">
										            <hr class="my-2 ${isMe ? 'border-white opacity-50' : 'border-secondary opacity-25'}">
										        </c:if>
										
										        <div class="file-list d-flex flex-column gap-1">
										            <c:forEach var="file" items="${process.fileDTOs}">
										                <div class="d-flex align-items-center justify-content-between">
										                    
										                    <div class="d-flex align-items-center" style="cursor: pointer; width: 100%;"
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

										<div class="d-flex align-items-center ${isMe ? 'justify-content-end me-1' : 'justify-content-start ms-1'} mt-1">
											<sec:authorize access="hasAnyRole('EXEC', 'MASTER')" var="isAdmin" />
											<c:if test="${(isMe or isAdmin) and process.processIsDeleted ne 1}">
												<i class="bx bx-trash text-secondary delete-btn me-2"
												   style="cursor: pointer; font-size: 1rem;"
												   onclick="deleteProcess('${process.processId}')"
												   title="삭제"></i>
											</c:if>

											<span class="chat-time text-muted small me-2">
												${process.processCreatedAtStr}
											</span>
										</div>
						            </div>
						        </div>
						    </c:forEach>
                          </div>

                          <div class="card-footer p-3">
                              <div id="filePreview" class="d-flex flex-wrap gap-2 mb-2 small text-primary" style="display: none;">
						    </div>

						  	<sec:authorize access="hasAnyRole('STORE', 'DEPT_SALES','EXEC', 'MASTER')">
								<div class="input-group input-group-merge">
									<label class="input-group-text bg-white border-end-0" for="replyFile" style="cursor: pointer;">
										<i class="bx bx-paperclip"></i>
									</label>

									<input type="file" multiple id="replyFile" style="display: none;" onchange="showFileName()">

									<textarea class="form-control" id="processContents" rows="2" placeholder="메시지를 입력하세요..." style="resize: none; padding: 20px 10px 10px;"></textarea>

									<button class="btn btn-primary" type="button" onclick="submitVocProcess()">
										<i class="bx bx-send"></i> 등록
									</button>
								</div>
							</sec:authorize>
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
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    
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
                        	<a href="/store/list" class="nav-link"><i class="bx bx-store me-1"></i> 가맹점 정보</a>
                        </li>
                        <li class="nav-item">
                        	<a href="/store/contract/list" class="nav-link active"><i class="bx bx-file me-1"></i> 계약 기록</a>
                        </li>
                        <li class="nav-item">
                        	<a href="/store/evaluation" class="nav-link"><i class="bx bx-clipboard me-1"></i> 평가 현황</a>
                        </li>
                    </ul>
                </div>
                <h4 class="fw-bold py-3 mb-3"><span class="text-muted fw-normal">가맹점 /</span> 계약 목록</h4>
                <div id="tab-content-area">
        		    <div class="card shadow-none border bg-white mb-4">
				        <div class="card-body py-4 px-4">
				            <form id="contractSearchForm" method="get" action="/store/contract/list">
				            	<input type="hidden" name="page" id="page" value="1">
				                <div class="row g-3">
					                <div class="col-12 col-md-3 col-lg-3">
					                    <label class="form-label small">계약 상태</label>
					                    <select class="form-select" id="searchContractStatus" name="searchContractStatus">
					                        <option value="">전체</option>
					                        <option value="0" ${pager.searchContractStatus eq 0 ? 'selected' : ''}>대기 (PENDING)</option>
					                        <option value="1" ${pager.searchContractStatus eq 1 ? 'selected' : ''}>유효 (Active)</option>
					                        <option value="2" ${pager.searchContractStatus eq 2 ? 'selected' : ''}>만료 (Expired)</option>
					                    </select>
					                </div>
					                
					                <div class="col-12 col-md-9 col-lg-5">
									    <label class="form-label small">계약 기간</label>
									    <div class="input-group">
									        <input type="date" class="form-control" id="searchStartDate" name="searchStartDate" 
									               value="${pager.searchStartDate}" placeholder="시작일" title="검색 시작일">
									        
									        <span class="input-group-text px-2">~</span>
									        
									        <input type="date" class="form-control" id="searchEndDate" name="searchEndDate" 
									               value="${pager.searchEndDate}" placeholder="종료일" title="검색 종료일">
									    </div>
									</div>
									
									<div class="col-12 col-md-12 col-lg-4">
					                    <label class="form-label small">가맹점명</label>
					                    <div class="input-group">
					                    	<span class="input-group-text"><i class="bx bx-store"></i></span>
					                        <input type="text" class="form-control" placeholder="가맹점명" id="searchStoreName" name="searchStoreName" value="${pager.searchStoreName}" />
					                    </div>
					                </div>
					                
					                <div class="col-12 col-md-6 col-lg-6">
							            <label class="form-label small">로열티</label>
							            <div class="input-group">
							            	<span class="input-group-text">₩</span>
							                <input type="number" class="form-control" placeholder="최소" id="searchRoyaltyMin" name="searchRoyaltyMin" value="${pager.searchRoyaltyMin}" >
							                <span class="input-group-text px-2">~</span>
							                <input type="number" class="form-control" placeholder="최대" id="searchRoyaltyMax" name="searchRoyaltyMax" value="${pager.searchRoyaltyMax}" >
							                <span class="input-group-text">원</span>
							            </div>
							        </div>
									
									<div class="col-12 col-md-6 col-lg-6">
							            <label class="form-label small">여신(보증금)</label>
							            <div class="input-group">
							            	<span class="input-group-text">₩</span>
							                <input type="number" class="form-control" placeholder="최소" id="searchDepositMin" name="searchDepositMin" value="${pager.searchDepositMin}" > 
							                <span class="input-group-text px-2">~</span>
							                <input type="number" class="form-control" placeholder="최대" id="searchDepositMax" name="searchDepositMax" value="${pager.searchDepositMax}" >
							                <span class="input-group-text">원</span>
							            </div>
							        </div>
				
				                    <div class="col-12 col-md-12 d-flex align-items-end justify-content-end gap-2 mt-5">
				                        <button class="btn btn-outline-secondary text-nowrap" type="button" onclick="resetSearchForm()"><i class="bx bx-refresh"></i> 초기화</button>
				                        <button class="btn btn-primary text-nowrap" onclick="searchContract()"><i class="bx bx-search"></i> 조회</button>
				                    </div>
				                </div>
				            </form>
				        </div>
				    </div>
					
					<div class="card shadow-none border bg-white">
					     	
						<div class="card-header d-flex justify-content-between align-items-center">
					    	<h5 class="mb-0">가맹점 계약 목록</h5>
					        <div>
					       		<button type="button" class="btn btn-outline-success me-2" onclick="downloadExcel()">
					            	<i class='bx bx-download me-1'></i> 엑셀 다운로드
					            </button>
					          	<button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#registerContractModal">
					                <i class="bx bx-plus me-1"></i> 계약 등록
					          	</button>
					     	</div>
						</div>
					  
					    <div class="table-responsive">
					    	<table class="table table-hover table-striped">
					          
					        	<thead>
					            	<tr>
					              		<th width="5%">
					              			계약번호
					              		</th>
					              		<th>
					                		가맹점명
					              		</th>
						                <th class="text-end">
						                	로얄티
						              	</th>
						              	<th class="text-end"> 
						                	여신(보증금)
						              	</th>
						              	<th>
						                	계약 시작일
						              	</th>
						                <th>
						                	계약 종료일
						                </th>
						                <th>상태</th>
						            </tr>
					          	</thead>
					            
					          	<tbody id="contractTableBody">
					            	<c:forEach items="${list}" var="dto">
					       				<tr>
					         				<td class="fw-bold">${dto.contractId}</td>
								            <td>
								            	<a href="javascript:void(0);"
								            	   class="fw-bold text-primary"
								            	   onclick="getContractDetail('${dto.contractId}')">${dto.storeName}</a>
								            </td>
								            <td class="text-end">
								            	<fmt:formatNumber value="${dto.contractRoyalti}" pattern="#,###" />
								            </td>
								            <td class="text-end">
								            	<fmt:formatNumber value="${dto.contractDeposit}" pattern="#,###" />
								            </td>
								            <td>${dto.contractStartDate}</td>
								            <td>${dto.contractEndDate}</td>
								            <td>
								            	<c:if test="${dto.contractStatus eq 0}"><span class="badge bg-label-warning">PENDING</span></c:if>
								            	<c:if test="${dto.contractStatus eq 1}"><span class="badge bg-label-info">ACTIVE</span></c:if>
								            	<c:if test="${dto.contractStatus eq 2}"><span class="badge bg-label-danger">EXPIRED</span></c:if>
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
	          
			      <div class="modal fade" id="registerContractModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
			        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" role="document">
			            <div class="modal-content">
			                <div class="modal-header">
			                    <h5 class="modal-title">가맹점 계약 등록</h5>
			                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
			                </div>
			                <div class="modal-body">
			                    <form id="registerContractForm">
			                        <div class="row g-3">
			                        
			                        	<div class="col-md-12">
			                                <label class="form-label" for="storeNameInput">가맹점명 검색 <span class="text-danger">*</span></label>
			                                <div class="input-group">
			                                	<span class="input-group-text"><i class="bx bx-store"></i></span>
			                                    <input type="text" id="storeNameInput" class="form-control" placeholder="가맹점명 입력" onkeyup="if(window.event.keyCode==13){searchStore()}" required />
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
			                                <label class="form-label" for="royalti">로얄티</label>
			                                <div class="input-group">
			                                    <span class="input-group-text">₩</span>
			                                    <input type="number" id="royalti" class="form-control" placeholder="500000" />
			                                    <span class="input-group-text">원</span>
			                                </div>
			                            </div>
			                            <div class="col-md-6">
			                                <label class="form-label" for="deposit">여신 (보증금)</label>
			                                <div class="input-group">
			                                    <span class="input-group-text">₩</span>
			                                    <input type="number" id="deposit" class="form-control" placeholder="50000000" />
			                                    <span class="input-group-text">원</span>
			                                </div>
			                            </div>
			                            <div class="col-12"><hr class="my-2"></div>
			                            
										<div class="col-md-6">
											<label class="form-label" for="startDate">계약 시작일</label>
											<input type="date" id="startDate" class="form-control" required />
										</div>
										
										<div class="col-md-6">
											<label class="form-label" for="endDate">계약 종료일</label>
											<input type="date" id="endDate" class="form-control" required />
										</div>
			                          
			
			                            <div class="col-12 mt-3">
			                                <label class="form-label">첨부파일</label>
			                                <div id="fileContainer">
			                                    <div class="input-group mb-2">
			                                        <input type="file" class="form-control" name="contractFiles">
			                                        <button type="button" class="btn btn-outline-primary" onclick="addFileField()">
			                                            <i class="bx bx-plus"></i>
			                                        </button>
			                                    </div>
			                                </div>
			                                <div class="form-text small text-muted">
			                                    ※  + 버튼을 누르면 첨부파일 칸이 추가됩니다.
			                                </div>
			                            </div>
			
			                        </div>
			                    </form>
			                </div>
			                <div class="modal-footer">
			                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
			                    <button type="button" class="btn btn-primary" onclick="submitContractRegistration()">계약 저장</button>
			                </div>
			            </div>
			        </div>
			    </div>
			    
				<div class="modal fade" id="detailContractModal" tabindex="-1" aria-hidden="true">
				    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" role="document">
				        <div class="modal-content">
				            <div class="modal-header border-bottom-0"> <h5 class="modal-title fw-bold" id="titleArea">가맹 계약 정보</h5>
				                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				            </div>
			
				            
				            <div class="modal-body pt-0">
			                    <div class="col-12"><hr class="mt-3 mb-1 border-light"></div>
				                <div class="d-flex gap-4 align-items-center bg-white border rounded-3 p-3 mt-3 mb-3">
			                        <div class="col-md-2" style="margin-left: 5px;">
			                            <span class="text-muted small d-block mb-1">계약 번호</span>
			                            <span id="detailContractId" class="fw-bold text-dark"></span> 
			                        </div>
			                        <div>
			                            <span class="text-muted small d-block mb-1">현재 상태</span>
			                            <div id="detailStatusArea"></div>
			                        </div>
			                    </div>
			
			                    <div class="col-12"><hr class="mb-4 border-light"></div>
				
				                <div class="row g-4">
				                    <div class="col-12">
				                        <div class="p-3 bg-light border rounded-3">
				                            <h6 class="fw-bold mb-3"><i class="bx bx-store me-1"></i> 가맹점 정보</h6>
				                            <div class="row g-3">
				                                <div class="col-md-3 ps-md-4 border-end">
				                                    <label class="text-muted small d-block">가맹점명</label>
				                                    <span id="detailStoreName" class="fw-semibold fs-6 text-primary"></span>
				                                </div>
				                                <div class="col-md-3 ps-md-4 border-end">
				                                    <label class="text-muted small d-block">가맹점주</label>
				                                    <span id="detailMemName" class="fw-semibold fs-6"></span>
				                                </div>
				                                <div class="col-md-6 ps-md-4">
				                                    <label class="text-muted small d-block">주소</label>
				                                    <span id="detailStoreAddress" class="fw-semibold fs-6"></span>
				                                </div>
				                            </div>
				                        </div>
				                    </div>
				
				                    <div class="col-12">
			                            <div class="row g-3">
			                                <div class="col-md-6">
			                                    <div class="p-3 bg-light border rounded-3">
			                                        <h6 class="fw-bold mb-3"><i class="bx bx-calendar me-1"></i> 계약 기간</h6>
			                                        <div class="row g-3">
			                                            <div class="col-md-6 ps-md-4 border-end">
			                                                <label class="text-muted small d-block">계약 시작일</label>
			                                                <span id="detailStartDate" class="fw-semibold mode-view"></span>
			                                                <input type="date" id="editStartDate" class="form-control form-control-sm mode-edit d-none" />
			                                            </div>
			                                            <div class="col-md-6 ps-md-4">
			                                                <label class="text-muted small d-block">계약 종료일</label>
			                                                <span id="detailEndDate" class="fw-semibold mode-view"></span>
			                                                <input type="date" id="editEndDate" class="form-control form-control-sm mode-edit d-none" />
			                                            </div>
			                                        </div>
			                                    </div>
			                                </div>
			
			                                <div class="col-md-6">
			                                    <div class="p-3 bg-light border rounded-3">
			                                        <h6 class="fw-bold mb-3"><i class="bx bx-won me-1"></i> 계약 조건</h6>
			                                        <div class="row g-3">
			                                            <div class="col-md-6 ps-md-4 border-end">
			                                                <label class="text-muted small d-block">로얄티</label>
			                                                <span id="detailRoyalty" class="fw-semibold mode-view"></span>
			                                                <input type="number" id="editRoyalty" class="form-control form-control-sm mode-edit d-none" placeholder="숫자만 입력" />
			                                            </div>
			                                            <div class="col-md-6 ps-md-4">
			                                                <label class="text-muted small d-block">여신(보증금)</label>
			                                                <span id="detailDeposit" class="fw-semibold mode-view"></span>
			                                                <input type="number" id="editDeposit" class="form-control form-control-sm mode-edit d-none" placeholder="숫자만 입력" />
			                                            </div>
			                                        </div>
			                                    </div>
			                                </div>
			                            </div>
				                    </div>
				                    
				                    <div class="col-12"><hr class="my-1 border-light"></div>
				                    <div class="col-12">
			                            <div class="p-3 bg-white border rounded-3">
			                                <h6 class="fw-bold mb-3"><i class="bx bx-file"></i> 첨부파일</h6>
			                                
			                                <ul class="list-group mode-view" id="detailFileList_view"></ul>
			                                
			                                <div id="detailFileList_edit" class="mode-edit d-none">
										        <ul id="existingFileContainer" class="list-group mb-3"></ul>
										
												<div class="border rounded-3 p-3 bg-light">
											        <div class="d-flex align-items-center justify-content-between mb-3">
											            <small class="text-muted me-auto">새 파일 추가</small>
											            <button type="button" class="btn btn-sm btn-outline-primary" onclick="addEditFileField()">
											                <i class="bx bx-plus"></i> 추가
											            </button>
											        </div>
											        <div id="newFileContainer"></div>
												</div>
										    </div>
										    
			                            </div>
									</div>
									<div class="col-12"><hr class="my-1 border-light"></div>
				                </div>
				            </div>
				
				            <div class="modal-footer d-flex justify-content-between bg-light border-top-0">
				                <button type="button" id="btnPdfDownload" class="btn btn-danger" onclick="downloadContractPdf()">
									<i class="bx bxs-file-pdf me-1"></i> 계약서 PDF 저장
								</button>
								<div class="d-felx">
									<button type="button" id="btnEditMode" class="btn btn-primary px-4 me-2" onclick="enableEditMode()">
							            <i class="bx bx-edit me-1"></i> 수정
							        </button>
					                <button type="button" id="btnCloseModal" class="btn btn-secondary px-4" data-bs-dismiss="modal">닫기</button>
					                
							        <button type="button" id="btnCancelEdit" class="btn btn-secondary px-4 me-2 d-none" onclick="cancelEditMode()">
							            취소
							        </button>
					                <button type="button" id="btnSaveContract" class="btn btn-primary px-4 d-none" onclick="updateContract()">
							            계약 저장
							        </button>
								</div>
				            </div>
				        </div>
				    </div>
				</div>
				
			<div style="position: absolute; left: -9999px;">
			    <div id="contractPdfTemplate" style="width: 210mm; min-height: 297mm; padding: 25mm; background: white; color: black; font-family: 'Malgun Gothic', 'Dotum', sans-serif; box-sizing: border-box;">
			        
			        <div style="border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 30px;">
			            <p style="text-align: right; font-size: 10pt; color: #555;">문서번호: <span id="pdfContractId"></span></p>
			            <h1 style="text-align: center; font-size: 22pt; font-weight: bold; margin: 0;">프랜차이즈 가맹계약서</h1>
			            <p style="text-align: center; font-size: 11pt; margin-top: 10px;">(기타 서비스업 표준계약서 준용)</p>
			        </div>
			
			        <div style="margin-bottom: 20px; line-height: 1.8; font-size: 11pt; text-align: justify;">
			            <p>
			                <strong>(주)카페ERP</strong>(이하 "가맹본부"라 한다)와 
			                <strong><span id="pdfStoreName" style="text-decoration: underline;"></span></strong>(이하 "가맹점사업자"라 한다)은 
			                상호 대등한 입장에서 공정한 거래질서에 따라 다음과 같이 가맹계약을 체결한다. 
			            </p>
			        </div>
			
			        <h3 style="font-size: 12pt; font-weight: bold; margin-top: 20px; margin-bottom: 10px;">제 8 조 [가맹점의 표시]</h3>
			        <p style="font-size: 10pt; margin-bottom: 5px;">이 계약에 의하여 가맹점사업자가 개설하게 되는 가맹점의 표시는 다음과 같다. </p>
			        <table style="width: 100%; border-collapse: collapse; border: 1px solid #000; font-size: 10pt;">
			            <tr>
			                <th style="border: 1px solid #000; padding: 8px; background-color: #f3f3f3; width: 30%;">상호명(점포명)</th>
			                <td style="border: 1px solid #000; padding: 8px;"><span id="pdfStoreNameTable"></span></td>
			            </tr>
			            <tr>
			                <th style="border: 1px solid #000; padding: 8px; background-color: #f3f3f3;">주소</th>
			                <td style="border: 1px solid #000; padding: 8px;"><span id="pdfStoreAddress"></span></td>
			            </tr>
			        </table>
			
			        <h3 style="font-size: 12pt; font-weight: bold; margin-top: 20px; margin-bottom: 10px;">제 11 조 [계약의 발효일과 계약기간]</h3>
			        <p style="font-size: 10pt; line-height: 1.6;">
			            이 계약은 <strong><span id="pdfStartDate"></span></strong>부터 발효되며 그 기간은 
			            <strong><span id="pdfEndDate"></span></strong>까지로 한다. 
			        </p>
			
			        <h3 style="font-size: 12pt; font-weight: bold; margin-top: 20px; margin-bottom: 10px;">제 17 조 [계속가맹금]</h3>
			        <p style="font-size: 10pt; margin-bottom: 5px;">가맹점사업자가 가맹본부에 지급하여야 할 계속가맹금(로얄티)의 내역은 다음 표와 같다. </p>
			        <table style="width: 100%; border-collapse: collapse; border: 1px solid #000; font-size: 10pt;">
			            <thead style="background-color: #f3f3f3;">
			                <tr>
			                    <th style="border: 1px solid #000; padding: 8px;">구분</th>
			                    <th style="border: 1px solid #000; padding: 8px;">금액 (단위: 원)</th>
			                    <th style="border: 1px solid #000; padding: 8px;">지급기한</th>
			                </tr>
			            </thead>
			            <tbody>
			                <tr>
			                    <td style="border: 1px solid #000; padding: 8px;">영업표지 사용료(로얄티)</td>
			                    <td style="border: 1px solid #000; padding: 8px; text-align: right; font-weight: bold;">
			                        <span id="pdfRoyalty"></span>
			                    </td>
			                    <td style="border: 1px solid #000; padding: 8px;">매월 1일</td>
			                </tr>
			            </tbody>
			        </table>
			
			        <h3 style="font-size: 12pt; font-weight: bold; margin-top: 20px; margin-bottom: 10px;">제 18 조 [계약이행보증금]</h3>
			        <div style="font-size: 10pt; line-height: 1.6; border: 1px solid #ddd; padding: 10px; background-color: #fafafa;">
			            가맹점사업자는 계속가맹금 및 상품 등의 대금과 관련한 채무액 또는 손해배상액의 지급을 담보하기 위하여 
			            계약이행보증금으로 <strong>금 <span id="pdfDeposit"></span>정</strong>을 
			            가맹본부에 지급(또는 예치)한다. 
			        </div>
			
			        <div style="margin-top: 60px; line-height: 1.8;">
			            <p style="margin-bottom: 20px;">
			                가맹본부와 가맹점사업자는 이 가맹계약서에 열거된 각 조항을 면밀히 검토하고 충분히 이해하였으며, 
			                이 계약의 체결을 증명하기 위하여 계약서 2통을 작성하여 각각 기명날인한 후 각 1통씩 보관한다.
			            </p>
			            <p style="text-align: center; font-size: 12pt; margin-top: 30px;">
			                <strong><span id="pdfCreatedAt"></span></strong>
			            </p>
			        </div>
			
			        <div style="margin-top: 250px; display: flex; justify-content: space-between; font-size: 10pt;">
			            <div style="width: 48%; border: 1px solid #000; padding: 15px;">
			                <p style="font-weight: bold; margin-bottom: 10px; font-size: 11pt;">[가맹본부]</p>
			                <p>상 호: (주)카페ERP</p>
			                <p>주 소: 서울특별시 강남구 테헤란로 123</p>
			                <p>대표자: 홍 길 동 (인)</p>
			            </div>
			            <div style="width: 48%; border: 1px solid #000; padding: 15px;">
			                <p style="font-weight: bold; margin-bottom: 10px; font-size: 11pt;">[가맹점사업자]</p>
			                <p>상 호: <span id="pdfSignStoreName"></span></p>
			                <p>주 소: <span id="pdfSignAddress">(가맹점 주소)</span></p>
			                <p>성 명: <span id="pdfSignOwner"></span> (인)</p>
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
    
    <script type="text/javascript" src="/js/store/tab_contract.js"></script>
  </body>
</html>
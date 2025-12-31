<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
	
    <div class="card shadow-none border bg-white mb-4">
        <div class="card-body py-3 px-3">
            <form id="contractSearchForm" onsubmit="return false;">
                <div class="row g-3">
                    <div class="col-md-2">
                        <label class="form-label small text-muted">계약 상태</label>
                        <select class="form-select" id="searchContractStatus">
                            <option value="">전체</option>
                            <option value="PENDING">대기 (PENDING)</option>
                            <option value="ACTIVE">유효 (Active)</option>
                            <option value="EXPIRED">만료 (Expired)</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label small text-muted">계약 시작일 구간</label>
                        <div class="input-group">
                            <input type="date" class="form-control" id="searchStartDateFrom" />
                            <span class="input-group-text">~</span>
                            <input type="date" class="form-control" id="searchStartDateTo" />
                        </div>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label small text-muted">가맹점 주소</label>
                        <input type="text" class="form-control" placeholder="시/군/구 입력" id="searchStoreAddress" />
                    </div>

                    <div class="col-md-3">
                        <label class="form-label small text-muted">로얄티 / 여신(보증금)</label>
                        <div class="input-group">
                            <select class="form-select" style="flex: 0 0 40%;">
                                <option value="royalti">로얄티</option>
                                <option value="deposit">여신</option>
                            </select>
                            <input type="number" class="form-control" placeholder="최소 금액" />
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small text-muted">가맹점명 검색</label>
                        <div class="input-group input-group-merge">
                            <span class="input-group-text"><i class="bx bx-search"></i></span>
                            <input type="text" class="form-control" placeholder="가맹점 이름" id="searchStoreName" />
                        </div>
                    </div>
                    <div class="col-md-6 d-flex align-items-end justify-content-end gap-2">
                        <button class="btn btn-outline-secondary" type="reset"><i class="bx bx-refresh"></i> 초기화</button>
                        <button class="btn btn-primary px-5" onclick="searchContracts()"><i class="bx bx-search"></i> 조회</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
	

	        
	<div class="card shadow-none border bg-white">
	     	
		<div class="card-header d-flex justify-content-between align-items-center">
	    	<h5 class="mb-0">가맹점 계약 목록</h5>
	        <div>
	       		<button type="button" class="btn btn-outline-success me-2">
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
	              			계약번호 <i class="bx bx-sort-alt-2 sort-icon"></i>
	              		</th>
	              		<th>
	                		가맹점명 <i class="bx bx-sort-alt-2 sort-icon"></i>
	              		</th>
		                <th class="text-end">
		                	로얄티 <i class="bx bx-sort-alt-2 sort-icon"></i>
		              	</th>
		              	<th class="text-end"> 
		                	여신(보증금) <i class="bx bx-sort-alt-2 sort-icon"></i>
		              	</th>
		              	<th>
		                	계약 시작일 <i class="bx bx-sort-alt-2 sort-icon"></i>
		              	</th>
		                <th>
		                	계약 종료일 <i class="bx bx-sort-alt-2 sort-icon"></i>
		                </th>
		                <th>상태</th>
		            </tr>
	          	</thead>
	            
	          	<tbody>
	            	<c:forEach items="${list}" var="dto">
	       				<tr>
	         				<td>${dto.contractId}</td>
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
	                <li class="page-item prev"><a class="page-link" href="#"><i class="bx bx-chevron-left"></i></a></li>
	                <li class="page-item active"><a class="page-link" href="#">1</a></li>
	                <li class="page-item"><a class="page-link" href="#">2</a></li>
	                <li class="page-item next"><a class="page-link" href="#"><i class="bx bx-chevron-right"></i></a></li>
	            </ul>
	        </nav>
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
                                    <input type="text" id="storeNameInput" class="form-control" placeholder="가맹점명 입력" onkeyup="if(window.event.keyCode==13){searcStore()}" required />
                                    <input type="hidden" id="storeId" name="storeId" />
                                    <button class="btn btn-primary" type="button" onclick="searcStore()">
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
                            
                            <div class="col-md-12">
                                <label class="form-label" for="contractStatus">계약 상태</label>
                                <select id="contractStatus" class="form-select">
                                	<option value="0">PENDING (대기)</option>
                                    <option value="1">ACTIVE (유효)</option>
                                </select>
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
	            <div class="modal-header">
	                <h5 class="modal-title">계약 상세 정보</h5>
	                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	            </div>
	            <div class="modal-body">
	                <div class="row g-3">
	                    <div class="col-md-6">
	                        <label class="form-label text-muted small">계약 번호</label>
	                        <input type="text" id="detailContractId" class="form-control bg-white fw-bold" readonly />
	                    </div>
	                    <div class="col-md-6">
	                        <label class="form-label text-muted small">가맹점명</label>
	                        <input type="text" id="detailStoreName" class="form-control bg-white" readonly />
	                    </div>
	                    <div class="col-12"><hr class="my-1 border-light"></div>
	                    <div class="col-md-6">
	                        <label class="form-label text-muted small">로얄티</label>
	                        <input type="text" id="detailRoyalty" class="form-control bg-white" readonly />
	                    </div>
	                    <div class="col-md-6">
	                        <label class="form-label text-muted small">여신(보증금)</label>
	                        <input type="text" id="detailDeposit" class="form-control bg-white" readonly />
	                    </div>
	                    <div class="col-md-4">
	                        <label class="form-label text-muted small">시작일</label>
	                        <input type="text" id="detailStartDate" class="form-control bg-white" readonly />
	                    </div>
	                    <div class="col-md-4">
	                        <label class="form-label text-muted small">종료일</label>
	                        <input type="text" id="detailEndDate" class="form-control bg-white" readonly />
	                    </div>
	                    <div class="col-md-4">
	                        <label class="form-label text-muted small">상태</label>
	                        <div id="detailStatusArea"></div>
	                    </div>
	                    
	                    <div class="col-12 mt-4">
	                        <h6 class="text-muted mb-3"><i class="bx bx-file"></i> 첨부파일 다운로드</h6>
	                        <ul class="list-group" id="detailFileList">
	                            </ul>
	                    </div>
	                </div>
	            </div>
	            <div class="modal-footer d-flex justify-content-between">
	                <button type="button" class="btn btn-danger" onclick="downloadContractPdf()">
	                    <i class="bx bxs-file-pdf me-1"></i> 계약서 PDF 저장
	                </button>
	                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
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
                <strong><span id="pdfStoreName" style="text-decoration: underline;"></span></strong>(이하 "가맹점사업자"라 한다)는 
                상호 대등한 입장에서 공정한 거래질서에 따라 다음과 같이 가맹계약을 체결한다. 
            </p>
        </div>

        <h3 style="font-size: 12pt; font-weight: bold; margin-top: 20px; margin-bottom: 10px;">제 8 조 [가맹점의 표시]</h3>
        <p style="font-size: 10pt; margin-bottom: 5px;">이 계약에 의하여 가맹점사업자가 개설하게 되는 가맹점의 표시는 다음과 같다. </p>
        <table style="width: 100%; border-collapse: collapse; border: 1px solid #000; font-size: 10pt;">
            <tr>
                <th style="border: 1px solid #000; padding: 8px; background-color: #f3f3f3; width: 30%;">상호(점포명)</th>
                <td style="border: 1px solid #000; padding: 8px;"><span id="pdfStoreNameTable"></span></td>
            </tr>
            <tr>
                <th style="border: 1px solid #000; padding: 8px; background-color: #f3f3f3;">계약 상태</th>
                <td style="border: 1px solid #000; padding: 8px;"><span id="pdfStatus"></span></td>
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
                    <td style="border: 1px solid #000; padding: 8px; text-align: center;">영업표지 사용료(로얄티)</td>
                    <td style="border: 1px solid #000; padding: 8px; text-align: right; font-weight: bold;">
                        <span id="pdfRoyalty"></span>
                    </td>
                    <td style="border: 1px solid #000; padding: 8px; text-align: center;">매월 1일</td>
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
                <strong><span id="pdfToday"></span></strong>
            </p>
        </div>

        <div style="margin-top: 40px; display: flex; justify-content: space-between; font-size: 10pt;">
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
    
    <script type="text/javascript" src="/js/store/tab_contract.js"></script>
    
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
	<div class="card shadow-none border bg-white mb-4">
		<div class="card-body py-3 px-3">
	    	<form id="storeSearchForm" onsubmit="return false;">
	      		<div class="row g-3">
	        		<div class="col-md-2">
	          			<label class="form-label small text-muted">운영 상태</label>
				        	<select class="form-select" id="filterStatus">
				            	<option value="">전체</option>
				                <option value="OPEN">운영중</option>
				                <option value="CLOSED">폐업</option>
				                <option value="RENOVATION">인테리어 공사</option>
				            </select>
	        		</div>
			        <div class="col-md-3">
			        	<label class="form-label small text-muted">주소 (지역)</label>
			        	<input type="text" class="form-control" placeholder="예: 서울 강남구" id="filterAddress" />
			        </div>
			        <div class="col-md-2">
			        	<label class="form-label small text-muted">오픈 시간</label>
			            <input type="time" class="form-control" id="filterOpenTime" />
			        </div>
			        <div class="col-md-3">
			            <label class="form-label small text-muted">가맹점명</label>
			            <input type="text" class="form-control" placeholder="검색어 입력" id="filterKeyword" />
			        </div>
			        <div class="col-md-2 d-flex align-items-end">
			            <button class="btn btn-primary w-100" onclick="searchStores()">
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
	       		<button type="button" class="btn btn-outline-success me-2">
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
	              		<th>
	                		가맹점명 <i class="bx bx-sort-alt-2 sort-icon"></i>
	              		</th>
		                <th>
		                	주소 <i class="bx bx-sort-alt-2 sort-icon"></i>
		              	</th>
		              	<th>
		                	운영 상태 <i class="bx bx-sort-alt-2 sort-icon"></i>
		              	</th>
		              	<th>
		                	운영 시간 <i class="bx bx-sort-alt-2 sort-icon"></i>
		              	</th>
		                <th>관리</th>
		            </tr>
	          	</thead>
	            
	          	<tbody>
	            	<c:forEach items="${list}" var="dto">
	       				<tr>
	         				<td>${dto.storeId}</td>
				            <td><span class="fw-bold text-primary">${dto.storeName}</span></td>
				            <td>${dto.storeAddress}</td>
				            <td>
				            	<c:if test="${dto.storeStatus eq '오픈'}"><span class="badge bg-label-info">${dto.storeStatus}</span></c:if>
				            	<c:if test="${dto.storeStatus eq '오픈 준비'}"><span class="badge bg-label-warning">${dto.storeStatus}</span></c:if>
				            </td>
				            <td>${dto.storeStartTime} ~ ${dto.storeCloseTime}</td>
	                        <td>
	                        	<button class="btn btn-sm btn-icon btn-outline-secondary"><i class="bx bx-edit"></i></button>
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
                                <div class="input-group input-group-merge">
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
    
    <script type="text/javascript" src="/js/store/tab_store.js"></script>
    
</html>
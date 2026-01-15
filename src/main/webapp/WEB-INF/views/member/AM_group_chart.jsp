<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<html lang="ko" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="/assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>조직도 관리 - 인사관리</title>
    
    <link rel="icon" type="image/x-icon" href="/assets/img/favicon/favicon.ico" />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    
    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>

</head>

<body>
<div class="layout-wrapper layout-content-navbar">
    <div class="layout-container">
        
        <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>

        <div class="layout-page">
        <c:import url="/WEB-INF/views/template/header.jsp"></c:import>
            <div class="content-wrapper">
                <div class="container-xxl flex-grow-1 container-p-y">
                    
                    <h4 class="fw-bold py-3 mb-4">
                        <span class="text-muted fw-light">부서 관리 /</span> 조직도 및 부서 관리
                    </h4>

                    <div class="row">
                        <div class="col-md-4 col-lg-3 mb-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-header d-flex justify-content-between align-items-center border-bottom pb-3">
                                    <h5 class="mb-0 fw-bold text-dark"><i class='bx bx-buildings me-2 text-primary'></i>부서 목록</h5>
                                </div>
                                
                                <div class="card-body pt-3 px-2">
								    <div class="list-group list-group-flush" id="deptList">
								        <a class="list-group-item list-group-item-action dept-item active mb-2" data-dept="0">
								            <div class="d-flex w-100 justify-content-between align-items-center">
								                <span><i class='bx bx-globe me-2'></i>전체 부서</span>
								                <span class="badge bg-white text-primary shadow-sm rounded-pill">${totalCount}</span>
								            </div>
								        </a>
								
								        <c:set var="currentGroup" value=""/>
								        
								       <c:forEach var="dept" items="${deptCount}">
    
										    <c:if test="${dept.memDeptGroupName != null and currentGroup ne dept.memDeptGroupName}">
										        <div class="list-group-header fw-bold mt-2 mb-1 px-3 text-muted" style="font-size: 0.8rem;">
										            ${dept.memDeptGroupName}
										        </div>
										        <c:set var="currentGroup" value="${dept.memDeptGroupName}"/>
										    </c:if>
										
										    <a class="list-group-item list-group-item-action dept-item sub-dept" 
										       data-dept="${dept.deptCode}" 
										       data-name="${dept.memDeptName}">
										        
										        <div class="d-flex w-100 justify-content-between align-items-center">
										            <span>${dept.memDeptName}</span>
										            
										            <div class="d-flex align-items-center">
										                <i class='bx bx-edit-alt me-2 text-muted dept-edit-icon' 
										                   style="cursor: pointer; opacity: 0.6;" 
										                   onclick="openDeptEdit(event, '${dept.deptCode}', '${dept.memDeptName}')"
										                   onmouseover="this.style.opacity=1" 
										                   onmouseout="this.style.opacity=0.6">
										                </i>
														
										                <span class="badge bg-white text-primary shadow-sm rounded-pill" style="font-size:0.75rem;">
										                    ${dept.count}
										                </span>
										            </div>
										        </div>
										    </a>
										    
										</c:forEach>
								    </div>
								</div>
                            </div>
                        </div>

                        <div class="col-md-8 col-lg-9 mb-4">
                            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center mb-4 gap-3">
                                
                                <div class="d-flex align-items-baseline">
                                    <h4 class="mb-0 fw-bold text-dark me-2" id="selectedDeptTitle">전체 사원</h4>
                                    <span class="text-muted fs-6" id="selectedDeptCount">(총 ${totalCount}명)</span>
                                </div>

                                <div class="top-controls">
                                    <div class="form-check form-switch m-0 d-flex align-items-center">
                                        <input class="form-check-input my-0 me-2" type="checkbox" id="checkRetired" style="cursor: pointer;">
                                        <label class="form-check-label text-nowrap text-muted fw-semibold" for="checkRetired" style="cursor: pointer;">퇴사자 포함</label>
                                    </div>

                                    <div class="input-group input-group-merge shadow-sm" style="width: 280px; border-radius: 10px; overflow: hidden; height: 45px;">
                                        <span class="input-group-text border-0 ps-3 bg-white"><i class="bx bx-search"></i></span>
                                        <input type="text" class="form-control border-0 bg-white" placeholder="이름, 부서, 사번 검색" id="searchMember">
                                    </div>
                                </div>
                            </div>

                            <div class="table-responsive text-nowrap" style="min-height: 500px;">
                                <table class="table table-borderless">
                                    <colgroup>
                                        <col style="width: 20%;">
                                        <col style="width: 10%;">
                                        <col style="width: 15%;">
                                        <col style="width: 15%;">
                                        <col style="width: 20%;">
                                        <col style="width: 20%;">
                                    </colgroup>
                                    <thead>
                                        <tr>
                                            <th>이름 / 사번</th>
                                            <th >부서</th>
                                            <th class="text-center">직급</th>
                                            <th class="text-center">상태</th>
                                            <th class="text-center">연락처</th>
                                            <th class="text-center">연락처</th>
                                        </tr>
                                    </thead>
                                    <tbody id="memberTableBody">
                                        </tbody>
                                </table>
                                
                                <div id="noDataMessage" class="text-center py-5" style="display: none;">
                                    <div class="py-5">
                                        <div class="mb-3">
                                            <span class="badge bg-label-secondary p-3 rounded-circle">
                                                <i class="bx bx-user-x fs-1"></i>
                                            </span>
                                        </div>
                                        <h5 class="text-muted mb-1">표시할 사원이 없습니다.</h5>
                                        <p class="text-muted small">검색 조건을 확인하거나 부서를 선택해주세요.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> 
                </div>
                <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
                <div class="content-backdrop fade"></div>
            </div>
        </div>
    </div>
    <div class="layout-overlay layout-menu-toggle"></div>
</div>



<div class="modal fade" id="modalDeptEdit" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">부서명 수정</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="mb-0">
                    <label class="form-label">부서명</label>
                    <input type="text" id="editDeptName" class="form-control" />
                    <input type="hidden" id="editDeptId" />
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">취소</button>
                <button type="button" class="btn btn-primary" onclick="alert('수정되었습니다.')">저장</button>
            </div>
        </div>
    </div>
</div>


<script src="/vendor/libs/jquery/jquery.js"></script>
<script src="/vendor/libs/popper/popper.js"></script>
<script src="/vendor/js/bootstrap.js"></script>
<script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
<script src="/vendor/js/menu.js"></script>
<script src="/js/main.js"></script>
<script src="/js/member/AM_member_detail.js"></script>
<script src="/js/member/AM_group_chat.js"></script>
<link rel="stylesheet" href="/css/member/AM_group_chart.css" />
</body>
</html>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<html
  lang="ko"
  class="light-style layout-menu-fixed"
  dir="ltr"
  data-theme="theme-default"
  data-assets-path="../assets/"
  data-template="vertical-menu-template-free"
>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>보안 관리 - 로그인 이력 | Sneat</title>
    
    <link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Public+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap" rel="stylesheet" />
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
                <span class="text-muted fw-light">보안 관리 /</span> 로그인 이력 조회
              </h4>

              <div class="card mb-4">
                <div class="card-body">
                    <form id="searchForm" action="./admin_login_history" method="get" class="row gx-3 gy-2 align-items-center">
                        <input type="hidden" name="page" id="pageInput" value="${pager.page}">
                        
                        <div class="col-md-4">
                            <label class="form-label">조회 기간</label>
                            <div class="input-group">
                                <input type="date" name="startDate" class="form-control" value="${param.startDate}">
                                <span class="input-group-text">~</span>
                                <input type="date" name="endDate" class="form-control" value="${param.endDate}">
                            </div>
                        </div>

                        <div class="col-md-2">
                            <label class="form-label">결과 필터</label>
                            <select name="isSuccess" class="form-select color-dropdown">
                                <option value="" ${empty param.isSuccess ? 'selected' : ''}>전체</option>
                                <option value="true" ${param.isSuccess == 'true' ? 'selected' : ''}>성공</option>
                                <option value="false" ${param.isSuccess == 'false' ? 'selected' : ''}>실패</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">검색어 (이름, ID, IP)</label>
                            <input type="text" name="searchKeyword" class="form-control" 
                                   placeholder="이름, 로그인ID, IP 입력" value="${param.searchKeyword}" />
                        </div>

                        <div class="col-md-2">
                            <label class="form-label d-block">&nbsp;</label>
                            <button type="submit" class="btn btn-primary w-100">
                                <span class="tf-icons bx bx-search"></span> 검색
                            </button>
                        </div>
                    </form>
                </div>
              </div>

              <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div class="mb-3">
                        <h5>총 이력: ${totalCount}건</h5>
                        <div class="text-muted small">
                            (최근 3개월 데이터가 기본으로 조회됩니다.)
                        </div>
                    </div>
                    <div>
                        <button type="button" class="btn btn-outline-success me-2">
                            <i class='bx bx-download me-1'></i> 엑셀 다운로드
                        </button>
                    </div>
                </div>
                
                <div class="table-responsive text-nowrap">
                  <table class="table table-hover">
                    <thead>
                      <tr class="table-light">
                        <th>일시</th>
                        <th>접속자 (사번)</th>
                        <th>로그인 ID (입력값)</th>
                        <th>IP 주소</th>
                        <th>유형</th>
                        <th>결과</th>
                      </tr>
                    </thead>
                    <tbody class="table-border-bottom-0">
                    
                        <c:forEach items="${historyList}" var="log">
                            <tr>
                                <td>
                                    <fmt:parseDate value="${log.memLogHisCreatedTime}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" type="both" />
                                    <fmt:formatDate value="${parsedDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty log.memName}">
                                            <span class="fw-bold text-dark">${log.memName}</span>
                                            <small class="text-muted">(${log.memberId})</small>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>${log.memLogHisLoginId}</td>

                                <td><span class="text-secondary">${log.memLogHisClientIp}</span></td>
                                
                                <td>
                                    <span class="badge bg-label-secondary">${log.memLogHisActionType}</span>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${log.memLogHisIsSuccess}">
                                            <span class="badge bg-label-success">성공</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-label-danger">실패</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty historyList}">
                            <tr>
                                <td colspan="6" class="text-center py-4">조회된 이력이 없습니다.</td>
                            </tr>
                        </c:if>

                    </tbody>
                  </table>
                </div>
                
                <div class="card-footer d-flex justify-content-center">
				    <nav aria-label="Page navigation">
				        <ul class="pagination">
				            
				            <li class="page-item ${pager.begin == 1 ? 'disabled' : ''}">
				                <a class="page-link" href="javascript:movePage(${pager.begin - 1})">
				                    <i class="bx bx-chevron-left"></i>
				                </a>
				            </li>
				
				            <c:forEach begin="${pager.begin}" end="${pager.end}" var="i">
				                <li class="page-item ${pager.page == i ? 'active' : ''}">
				                    <a class="page-link" href="javascript:movePage(${i})">${i}</a>
				                </li>
				            </c:forEach>
				            
				            <li class="page-item">
				                <a class="page-link" href="javascript:movePage(${pager.end + 1})">
				                    <i class="bx bx-chevron-right"></i>
				                </a>
				            </li>
				        </ul>
				    </nav>
				</div>
                
              </div> </div> <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
            <div class="content-backdrop fade"></div>
          </div>
        </div>
      </div>
      <div class="layout-overlay layout-menu-toggle"></div>
    </div>

    <script src="/vendor/libs/jquery/jquery.js"></script>
    <script src="/vendor/libs/popper/popper.js"></script>
    <script src="/vendor/js/bootstrap.js"></script>
    <script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="/vendor/js/menu.js"></script>
    <script src="/js/main.js"></script>

    <script>
        // 페이징 이동 함수
        function movePage(page) {
    if (page < 1) page = 1;

    const form = document.getElementById('searchForm');
    const formData = new FormData(form);
    const params = new URLSearchParams(formData);

    params.set('page', page);

    const currentUrlParams = new URLSearchParams(window.location.search);
    currentUrlParams.forEach((value, key) => {
        if (key.startsWith('sortConditions')) {
            params.append(key, value);
        }
    });

    location.href = form.action + '?' + params.toString();
}
    </script>
  </body>
</html>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<html lang="en" class="light-style layout-menu-fixed" dir="ltr" data-theme="theme-default" data-assets-path="../assets/" data-template="vertical-menu-template-free">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no, minimum-scale=1.0, maximum-scale=1.0" />
    <title>Receivable Detail - ERP View</title>
    
    <link rel="icon" type="image/x-icon" href="../assets/img/favicon/favicon.ico" />
    <link rel="stylesheet" href="/vendor/fonts/boxicons.css" />
    <link rel="stylesheet" href="/vendor/css/core.css" class="template-customizer-core-css" />
    <link rel="stylesheet" href="/vendor/css/theme-default.css" class="template-customizer-theme-css" />
    <link rel="stylesheet" href="/css/demo.css" />
    <link rel="stylesheet" href="/vendor/libs/perfect-scrollbar/perfect-scrollbar.css" />
    <link rel="stylesheet" href="/vendor/libs/apex-charts/apex-charts.css" />
    <link rel="stylesheet" href="/css/receivable/receivableDetail.css" />
    <script src="/vendor/js/helpers.js"></script>
    <script src="/js/config.js"></script>

    <style>
        /* 위에 작성한 ERP Style CSS 내용 삽입 */
         body { background-color: #f4f6f9; font-family: 'Malgun Gothic', 'Noto Sans KR', sans-serif; }
        .card { border: 1px solid #dce1e7; box-shadow: none !important; border-radius: 4px !important; margin-bottom: 20px; }
        .card-header { background-color: #fff; border-bottom: 1px solid #dce1e7; padding: 12px 20px; font-weight: 700; font-size: 15px; color: #333; }
        .table thead th { background-color: #f1f3f8 !important; border-bottom: 2px solid #dce1e7 !important; color: #444; font-weight: 700; font-size: 13px; text-transform: none; padding: 8px; text-align: center; }
        .table tbody td { padding: 6px 8px; font-size: 13px; color: #555; border-bottom: 1px solid #eee; vertical-align: middle; }
        .text-end { font-family: 'Consolas', monospace; letter-spacing: -0.5px; }
        .info-table { width: 100%; border-collapse: collapse; border: 1px solid #dce1e7; margin-bottom: 0; }
        .info-table th { background-color: #f1f3f8; width: 120px; padding: 8px 15px; text-align: left; font-weight: 600; border: 1px solid #dce1e7; font-size: 13px; color: #555;}
        .info-table td { background-color: #fff; padding: 8px 15px; border: 1px solid #dce1e7; font-size: 13px; color: #333; font-weight: 600;}
        .btn-erp { border-radius: 3px; font-size: 12px; padding: 4px 10px; }
        .total-summary-row th { background-color: #f8f9fa; color: #333; text-align: right;}
        .total-summary-row td { background-color: #fff; text-align: right; font-weight: bold;}
    </style>
</head>

<body>
    <div class="layout-wrapper layout-content-navbar">
        <div class="layout-container">
            <c:import url="/WEB-INF/views/template/aside.jsp"></c:import>
            <div class="layout-page">
                <c:import url="/WEB-INF/views/template/header.jsp"></c:import>

                <div class="content-wrapper">
                    <div class="container-xxl flex-grow-1 container-p-y">
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="fw-bold py-3 mb-0">
                                <span class="text-muted fw-light">매출/수금 관리 ></span> 미수금 상세 조회
                            </h5>
                            <div>
                                <button class="btn btn-primary btn-erp" onclick="history.back()"><i class="bx bx-list-ul me-1"></i>목록</button>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-lg-9 col-12">
                                
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <i class="bx bx-info-circle me-2"></i>기본 정보
                                    </div>
                                    <div class="card-body p-0">
                                        <table class="info-table">
                                            <tr>
                                                <th>가맹점 코드</th>
                                                <td>${receivableSummaryDTO.storeId}</td>
                                                <th>지점명</th>
                                                <td>${receivableSummaryDTO.storeName}</td>
                                                <th>조회 월</th>
                                                <td class="text-primary">${receivableSummaryDTO.baseMonth}</td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                                <div class="card mb-4">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <span><i class="bx bx-package me-2"></i>물품대금 미수 내역</span>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover table-sm align-middle mb-0">
                                            <colgroup>
                                                <col style="width: 12%">
                                                <col style="width: 10%">
                                                <col style="width: 8%">
                                                <col style="width: 12%">
                                                <col style="width: 12%">
                                                <col style="width: 12%">
                                                <col style="width: 12%">
                                                <col style="width: 8%">
                                            </colgroup>
                                            <thead>
                                                <tr>
                                                    <th>채권코드</th>
                                                    <th>발주일자</th>
                                                    <th>품목 수</th>
                                                    <th>공급가액</th>
                                                    <th>세액</th>
                                                    <th>합계</th>
                                                    <th>남은 금액</th>
                                                    <th>상세</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty receivableOrderSummaryDTO}">
                                                        <tr><td colspan="8" class="text-center py-4 text-muted">데이터가 없습니다.</td></tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="row" items="${receivableOrderSummaryDTO}">
                                                            <tr>
                                                                <td class="text-center">${row.receivableId}</td>
                                                                <td class="text-center"><fmt:formatDate value="${row.orderDate}" pattern="yyyy-MM-dd"/></td>
                                                                <td class="text-end" style="padding-right: 15px;">${row.itemCount}건</td>
                                                                <td class="text-end"><fmt:formatNumber value="${row.supplyAmount}" /></td>
                                                                <td class="text-end"><fmt:formatNumber value="${row.taxAmount}" /></td>
                                                                <td class="text-end fw-bold"><fmt:formatNumber value="${row.totalAmount}" /></td>
                                                                <td class="text-end fw-bold ${row.remainAmount == 0 ? 'text-success' : 'text-danger'}">
                                                                    <fmt:formatNumber value="${row.remainAmount}" />
                                                                </td>
                                                                <td class="text-center">
                                                                    <button class="btn btn-xs btn-outline-secondary"
                                                                        data-bs-toggle="modal" data-bs-target="#itemModal"
                                                                        data-receivable-id="${row.receivableId}"
                                                                        data-order-date='<fmt:formatDate value="${row.orderDate}" pattern="yyyy-MM-dd"/>'>
                                                                        <i class="bx bx-search"></i>
                                                                    </button>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div class="card mb-4">
                                    <div class="card-header">
                                        <span><i class="bx bx-building-house me-2"></i>가맹비 미수 내역</span>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover table-sm mb-0">
                                            <thead>
                                                <tr>
                                                    <th>채권 코드</th>
                                                    <th>계약일</th>
                                                    <th>공급가액</th>
                                                    <th>세액</th>
                                                    <th>합계</th>
                                                    <th>상태</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty receivableRoyaltyDTO}">
                                                        <tr>
                                                            <td class="text-center">${receivableRoyaltyDTO.receivableId}</td>
                                                            <td class="text-center"><fmt:formatDate value="${receivableRoyaltyDTO.contractDate}" pattern="yyyy-MM-dd"/></td>
                                                            <td class="text-end"><fmt:formatNumber value="${receivableRoyaltyDTO.supplyAmount}" type="number"/></td>
                                                            <td class="text-end"><fmt:formatNumber value="${receivableRoyaltyDTO.taxAmount}" type="number"/></td>
                                                            <td class="text-end fw-bold"><fmt:formatNumber value="${receivableRoyaltyDTO.totalAmount}" type="number"/></td>
                                                         <td class="text-center">
														    <c:choose>
														        <c:when test="${receivableRoyaltyDTO.status eq 'O'}">
														            <span class="badge bg-label-danger">미지급</span>
														        </c:when>
														        <c:when test="${receivableRoyaltyDTO.status eq 'P'}">
														            <span class="badge bg-label-warning">부분지급</span>
														        </c:when>
														        <c:when test="${receivableRoyaltyDTO.status eq 'C'}">
														            <span class="badge bg-label-success">완납</span>
														        </c:when>
														    </c:choose>
														</td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr><td colspan="6" class="text-center py-4 text-muted">데이터가 없습니다.</td></tr>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div class="card mb-4">
                                    <div class="card-header d-flex justify-content-between align-items-center">
                                        <span><i class="bx bx-history me-2"></i>수금 이력</span>
                                        <button type="button" class="btn btn-sm btn-primary btn-erp" data-bs-toggle="modal" data-bs-target="#paymentModal">
                                            <i class="bx bx-plus me-1"></i>수금 등록
                                        </button>
                                    </div>
                                    <div class="table-responsive">
                                        <table class="table table-bordered table-hover table-sm mb-0">
                                            <thead>
                                                <tr>
                                                    <th>수금일</th>
                                                    <th>담당자</th>
                                                    <th>수금 금액</th>
                                                    <th>구분</th>
                                                    <th>비고</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:choose>
                                                    <c:when test="${empty receivableTransactionDTO}">
                                                        <tr><td colspan="5" class="text-center py-4 text-muted">수금 내역이 없습니다.</td></tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach items="${receivableTransactionDTO}" var="paid">
                                                            <tr>
                                                                <td class="text-center"><fmt:formatDate value="${paid.transactionDate}" pattern="yyyy-MM-dd" /></td>
                                                                <td class="text-center">${paid.memberName}</td>
                                                                <td class="text-end fw-bold text-primary"><fmt:formatNumber value="${paid.transactionAmount}" pattern="#,###" /></td>
                                                                <td class="text-center">
                                                                    <c:choose>
                                                                        <c:when test="${paid.sourceType eq 'CONTRACT'}">가맹비</c:when>
                                                                        <c:when test="${paid.sourceType eq 'ORDER'}">물품대금</c:when>
                                                                        <c:otherwise>-</c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>${paid.transactionMemo}</td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                            <div class="col-lg-3 col-12">
                                <div class="card sticky-top" style="top: 85px; border-top: 3px solid #696cff;">
                                    <div class="card-header bg-white border-bottom-0 pb-0">
                                        <h6 class="mb-0 fw-bold">금액 요약</h6>
                                        <small class="text-muted">Total Summary</small>
                                    </div>
                                    <div class="card-body mt-3">
                                        <ul class="list-group list-group-flush">
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0 pb-1 border-0">
                                                <span class="text-muted">물품대금 합계</span>
                                                <span class="fw-semibold"><fmt:formatNumber value="${receivableAmountSummaryDTO.productTotal}" type="number"/></span>
                                            </li>
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-1 pb-3 border-bottom">
                                                <span class="text-muted">가맹비 합계</span>
                                                <span class="fw-semibold"><fmt:formatNumber value="${receivableAmountSummaryDTO.royaltyTotal}" type="number"/></span>
                                            </li>
                                            
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0 pt-3 border-0">
                                                <span class="fw-bold text-dark">총 거래 금액</span>
                                                <span class="fw-bold text-dark"><fmt:formatNumber value="${receivableAmountSummaryDTO.totalAmount}" type="number"/></span>
                                            </li>
                                            <li class="list-group-item d-flex justify-content-between align-items-center px-0 border-0">
                                                <span class="fw-bold text-primary">수금 금액</span>
                                                <span class="fw-bold text-primary"><fmt:formatNumber value="${receivableAmountSummaryDTO.paidAmount}" type="number"/></span>
                                            </li>
                                        </ul>
                                        <div class="mt-3 p-3 bg-label-danger rounded text-center">
                                            <small class="d-block text-danger fw-semibold mb-1">미수금 총액</small>
                                            <h4 class="mb-0 text-danger fw-bold"><fmt:formatNumber value="${receivableAmountSummaryDTO.unpaidAmount}" type="number"/> 원</h4>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div> </div>
                    <c:import url="/WEB-INF/views/template/footer.jsp"></c:import>
                    <div class="content-backdrop fade"></div>
                </div>
            </div>
        </div>
        <div class="layout-overlay layout-menu-toggle"></div>
    </div>

    <div class="modal fade" id="itemModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content" style="border-radius: 4px;">
                <div class="modal-header bg-light border-bottom py-3">
                    <h5 class="modal-title fs-5 fw-bold">물품대금 상세 내역</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <div class="p-3 bg-white border-bottom">
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="small text-muted d-block">채권코드</label>
                                <span class="fw-bold text-dark" id="modalReceivableId">-</span>
                            </div>
                            <div class="col-6">
                                <label class="small text-muted d-block">발주일자</label>
                                <span class="fw-bold text-dark" id="modalOrderDate">-</span>
                            </div>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-bordered table-striped table-sm mb-0">
                            <thead>
                                <tr>
                                    <th>품목명</th>
                                    <th>수량</th>
                                    <th>단가</th>
                                    <th>공급가액</th>
                                    <th>세액</th>
                                    <th>합계</th>
                                </tr>
                            </thead>
                            <tbody id="itemModalTbody">
                                <tr><td colspan="6" class="text-center text-muted py-4">데이터 없음</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer py-2 bg-light border-top">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-md modal-dialog-centered">
            <div class="modal-content" style="border-radius: 4px;">
                <div class="modal-header bg-primary text-white py-3">
                    <h5 class="modal-title text-white" id="paymentModalLabel">수금 등록</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body pt-4">
                    <form id="paymentForm">
                        <input type="hidden" id="storeId" value="${receivableSummaryDTO.storeId}" />
                        <input type="hidden" id="baseMonth" value="${receivableSummaryDTO.baseMonth}" />
                        
                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label fw-bold small text-muted">채권 선택</label>
                                <select class="form-select form-select-sm" id="receivableSelect" required>
                                    <option value="">채권 선택</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold small text-muted">수금 구분</label>
                                <input type="text" class="form-control form-control-sm bg-light" id="sourceTypeText" readonly />
                                <input type="hidden" name="sourceType" id="sourceType" />
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-bold small text-muted">남은 금액</label>
                                <input type="text" class="form-control form-control-sm text-end bg-light fw-bold text-danger" id="remainAmount" readonly />
                            </div>
                            <div class="col-6">
                                <label class="form-label fw-bold small text-muted">수금 금액</label>
                                <input type="text" class="form-control form-control-sm text-end border-primary fw-bold" id="payAmount" name="transactionAmount" value="0" />
                            </div>
                            <div class="col-12">
                                <div class="d-flex gap-1 justify-content-end">
                                    <button type="button" class="btn btn-outline-secondary btn-xs quick-pay" data-amount="10000">+1만</button>
                                    <button type="button" class="btn btn-outline-secondary btn-xs quick-pay" data-amount="50000">+5만</button>
                                    <button type="button" class="btn btn-outline-secondary btn-xs quick-pay" data-amount="100000">+10만</button>
                                    <button type="button" class="btn btn-outline-primary btn-xs" id="payAllBtn">전액</button>
                                    <button type="button" class="btn btn-outline-danger btn-xs" id="resetAmountBtn">초기화</button>
                                </div>
                            </div>
                            <div class="col-12">
                                <label class="form-label fw-bold small text-muted">비고</label>
                                <textarea class="form-control form-control-sm" name="transactionMemo" rows="2"></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer py-2 bg-light border-top">
                    <button type="button" class="btn btn-secondary btn-sm" data-bs-dismiss="modal">취소</button>
                    <button type="button" class="btn btn-primary btn-sm" id="paymentSaveBtn">저장</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript" src="/js/receivable/receivableDetail.js"></script>
    <script type="text/javascript" src="/js/receivable/receivable-payment.js"></script>
    <script src="/vendor/libs/jquery/jquery.js"></script>
    <script src="/vendor/libs/popper/popper.js"></script>
    <script src="/vendor/js/bootstrap.js"></script>
    <script src="/vendor/libs/perfect-scrollbar/perfect-scrollbar.js"></script>
    <script src="/vendor/js/menu.js"></script>
    <script src="/vendor/libs/apex-charts/apexcharts.js"></script>
    <script src="/js/main.js"></script>
    <script src="/js/dashboards-analytics.js"></script>
</body>
</html>
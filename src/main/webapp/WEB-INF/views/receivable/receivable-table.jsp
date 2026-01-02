<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:if test="${not empty errorMessage}">
  <div id="searchError" class="alert alert-danger mb-3">
    ${errorMessage}
  </div>
</c:if>

<table class="table table-hover align-middle">
  <thead class="table-light">
    <tr>
      <th>가맹점</th>
      <th>기준월</th>
      <th class="text-end">총 미수금</th>
      <th class="text-center">관리</th>
    </tr>
  </thead>

  <tbody>
    <c:forEach var="row" items="${receivables}">
      <tr>
        <td class="fw-semibold">${row.storeName}</td>
        <td>${row.baseMonth}</td>

        <td class="text-end fw-bold text-primary">
          <fmt:formatNumber value="${row.totalAmount}" />
        </td>

        <td class="text-center">
          <a href="/receivable/receivableDetail?storeId=${row.storeId}&storeName=${row.storeName}&baseMonth=${row.baseMonth}"
             class="btn btn-sm btn-outline-primary">
            상세
          </a>
        </td>
      </tr>
    </c:forEach>

    <c:if test="${empty receivables}">
      <tr>
        <td colspan="4" class="text-center text-muted py-4">
          조회된 데이터가 없습니다.
        </td>
      </tr>
    </c:if>
  </tbody>
</table>
<jsp:include page="/WEB-INF/views/common/pagination.jsp" />
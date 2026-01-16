<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<table class="table table-hover align-middle">
	<thead class="table-light">
	  <tr>
	    <th>거래처 코드</th>
	    <th>거래처명</th>
	    <th>기준월</th>
	    <th class="text-end">총 미지급금액</th>
	    <th class="text-end">남은 미지급금액</th>
	    <th class="text-center">상태</th>
	    <th class="text-center">지급</th>
	  </tr>
	</thead>


	<tbody>
	  <c:forEach var="row" items="${list}">
	    <tr>
	      <td class="fw-semibold">${row.vendorCode}</td>
	      <td>${row.vendorName}</td>
	      <td>${row.baseMonth}</td>
	
	      <!-- 총 미지급금액 (고정값) -->
	      <td class="text-end fw-bold text-primary">
	        <fmt:formatNumber value="${row.totalUnpaidAmount}" />
	      </td>
	
	      <!-- 남은 미지급금액 (지급 반영) -->
	      <td class="text-end fw-bold text-danger">
	        <fmt:formatNumber value="${row.remainUnpaidAmount}" />
	      </td>
	
	      <!-- 상태 -->
	      <td class="text-center">
	        <span class="badge
	          ${row.payStatus == 'PAID' ? 'bg-success' :
	            row.payStatus == 'PARTIAL' ? 'bg-warning' : 'bg-secondary'}">
	          <c:choose>
	            <c:when test="${row.payStatus == 'PAID'}">완납</c:when>
	            <c:when test="${row.payStatus == 'PARTIAL'}">부분지급</c:when>
	            <c:otherwise>미지급</c:otherwise>
	          </c:choose>
	        </span>
	      </td>
	
	      <!-- 지급 버튼 -->
	      <td class="text-center">
	        <button
	          type="button"
	          class="btn btn-sm btn-primary"
	          onclick="openPayModal(
	            '${row.vendorCode}',
	            '${row.baseMonth}',
	            ${row.remainUnpaidAmount}
	          )"
	          <c:if test="${row.payStatus == 'PAID'}">disabled</c:if>
	        >
	          지급
	        </button>
	      </td>
	    </tr>
	  </c:forEach>
	
	  <c:if test="${empty list}">
	    <tr>
	      <td colspan="7" class="text-center text-muted py-4">
	        조회된 데이터가 없습니다.
	      </td>
	    </tr>
	  </c:if>
	</tbody>
</table>

 <jsp:include page="/WEB-INF/views/common/pagination.jsp" />

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:choose>
  <c:when test="${empty items}">
    <tr>
      <td colspan="4" class="text-muted py-4">
        상세 내역이 없습니다
      </td>
    </tr>
  </c:when>

  <c:otherwise>
    <c:forEach var="item" items="${items}">
      <tr>
        <td>${item.hqOrderItemName}</td>
        <td>${item.hqOrderQty}</td>
        <td>${item.hqOrderPrice}</td>
        <td>${item.hqOrderAmount}</td>
      </tr>
    </c:forEach>
  </c:otherwise>
</c:choose>
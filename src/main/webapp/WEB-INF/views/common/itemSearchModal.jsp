<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="modal fade" id="productSearchModal" tabindex="-1">
  <div class="modal-dialog modal-lg modal-dialog-scrollable">
    <div class="modal-content">

      <div class="modal-header">
        <h5 class="modal-title">물품 검색</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>

      <div class="modal-body">

        <!-- 거래처 선택 (본사만 노출) -->
        <c:if test="${showVendorSelect}">
          <div class="row g-2 mb-2">
            <div class="col-md-12">
              <select class="form-select" id="vendorCode" name="vendorCode">
                <option value="">거래처 선택</option>
                <c:forEach var="v" items="${vendorList}">
                  <option value="${v.vendorCode}">${v.vendorName}</option>
                </c:forEach>
              </select>
            </div>
          </div>
        </c:if>

        <!-- 검색 -->
        <div class="row g-2 mb-3">
          <div class="col-md-9">
            <input type="text" class="form-control" id="keyword"
                   placeholder="물품코드 또는 물품명">
          </div>
          <div class="col-md-3 d-grid">
            <button type="button"
                    class="btn btn-primary"
                    onclick="searchItem()">
              검색
            </button>
          </div>
        </div>

        <!-- 검색 결과 -->
        <div class="table-responsive">
          <table class="table table-hover text-center">
            <thead class="table-light">
              <tr>
                <th>물품코드</th>
                <th>물품명</th>
                <th>거래처명</th>
                <th>단가</th>
                <th>선택</th>
              </tr>
            </thead>
            <tbody id="itemSearchResult">
              <!-- JS로 렌더링 -->
              
            </tbody>
          </table>
        </div>

      </div>

      <div class="modal-footer">
        <button type="button"
                class="btn btn-secondary"
                data-bs-dismiss="modal">
          닫기
        </button>
      </div>

    </div>
  </div>
</div>

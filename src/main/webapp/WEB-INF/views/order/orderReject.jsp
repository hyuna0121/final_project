<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!-- 반려 모달 -->
<div class="modal fade" id="rejectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title">반려 사유 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <textarea id="rejectReason"
                		  name="storeRejectionReason"
                          class="form-control"
                          rows="4"
                          placeholder="반려 사유를 입력하세요"></textarea>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    취소
                </button>
                <button type="button" class="btn btn-danger" id="confirmRejectBtn">
                    반려 처리
                </button>
            </div>

        </div>
    </div>
</div>
function updateActionButtons() {
  const checkedCount = $('.order-check:checked').length;

  // 승인 버튼
  $('#approveBtn').prop('disabled', checkedCount === 0);

  // 반려 버튼 (1개일 때만 가능)
  const canReject = checkedCount === 1;
  $('#rejectBtn')
    .prop('disabled', !canReject)
    .toggleClass('btn-secondary', !canReject)
    .toggleClass('btn-warning', canReject);
}

// 반려 버튼 클릭 → 모달 띄우기
$('#rejectBtn').on('click', function () {
	if ($(this).prop('disabled')) return;

	  const $checked = $('.order-check:checked').first();
	  const orderNo = $checked.closest('.order-row').data('order-no');
	  
	  $('#rejectReason').val('');
	  $(this).data('order-no', orderNo);

	  new bootstrap.Modal(document.getElementById('rejectModal')).show();
});

// 반려 처리 버튼 클릭
$('#confirmRejectBtn').on('click', function () {
	const rejectId = $('#rejectBtn').data('order-no');
    const reason = $('#rejectReason').val().trim();
	
		
    if (reason === '') {
        alert('반려 사유를 입력하세요.');
        return;
    }

    $.ajax({
        url: '/order/reject',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            rejectId: rejectId,
            rejectReason: reason
        }),
        success: function () {
            alert('반려 처리되었습니다.');
			updateOrderStatusToReject(rejectId);
        },
        error: function () {
            alert('반려 처리 중 오류가 발생했습니다.');
        }
    });
	
});

function updateOrderStatusToReject(rejectId){
	const $row = $(`.order-row[data-order-no="${rejectId}"]`);
	// 1️ 상태 배지 변경
    $row.find('.badge')
      .removeClass('bg-label-warning')
      .addClass('bg-label-danger')
      .text('반려');

    // 2️ 체크박스 비활성화
    $row.find('.order-check')
      .prop('checked', false)
      .prop('disabled', true);
	
    // 3️ row 비활성화 스타일
    $row.addClass('row-disabled');

    // 4️ row 클릭 이벤트 막기 (선택)
    $row.off('click');
	
	const modal = bootstrap.Modal.getInstance(
	    document.getElementById('rejectModal')
	  );
	modal.hide();
}

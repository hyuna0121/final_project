
$(document).on('click', '#receiveBtn', function () {

  const $approvalRows = $('#approvalListBody tr[data-order-no]');

  console.log('입고 대상 개수:', $approvalRows.length);

  if ($approvalRows.length === 0) {
    alert('입고할 발주가 없습니다.');
    return;
  }

  const orderNos = [];
  $approvalRows.each(function () {
	const orderNo = $(this).data('order-no');
	
	// 🔥 상세페이지와 동일한 판별 로직
	const orderType = orderNo.charAt(0) === "P" ? "HQ" : "STORE";
	
	orderNos.push({
  	  orderNo: orderNo,
  	  orderType: orderType
	});
	
  });

  if (!confirm('선택한 발주를 입고 처리하시겠습니까?')) {
    return;
  }

  // 여기까지는 절대 초기화하지 마라

  $.ajax({
    url: '/order/receive',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(orderNos),

    success: function () {
      alert('입고 처리되었습니다.');

      // 여기서만 초기화
      resetApprovalList();
      resetCheckboxes();
      updateOrderStatusToReceive(orderNos);
    },

    error: function () {
      alert('입고 처리 중 오류가 발생했습니다.');
    }
  });
});

function updateOrderStatusToReceive(orders) {
  orders.forEach(order => {
    const orderNo = order.orderNo;

    const $row = $(`.order-row[data-order-no="${orderNo}"]`);
	
	// 1️ 상태 배지 변경
    $row.find('.badge')
      .removeClass('bg-label-success')
      .addClass('bg-label-primary')
      .text('입고');

    // 2️ 체크박스 비활성화
    $row.find('.order-check')
      .prop('checked', false)
      .prop('disabled', true);

    // 3️ row 비활성화 스타일
    $row.addClass('row-disabled');

    // 4️ row 클릭 이벤트 막기 (선택)
    $row.off('click');
  });
}

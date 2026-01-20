$(document).on('click', '#updateReceiveStatusByStoreOrder', function () {

  const $approvalRows = $('#approvalListBody tr[data-order-no]');

  console.log('출고 대상 개수:', $approvalRows.length);

  if ($approvalRows.length === 0) {
    alert('출고할 발주가 없습니다.');
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

  if (!confirm('선택한 발주를 출고 처리하시겠습니까?')) {
    return;
  }

  // 여기까지는 절대 초기화하지 마라

  $.ajax({
    url: '/order/updateReceiveStatusByStoreOrder',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(orderNos),

    success: function () {
      alert('출고 처리되었습니다.');

      // 여기서만 초기화
      resetApprovalList();
      resetCheckboxes();
      updateOrderStatusToRelease(orderNos);
    },

    error: function () {
      alert('출고 처리 중 오류가 발생했습니다.');
    }
  });
})


$(document).on('click', '#updateCancelReceiveStatusByStoreOrder', function () {

  const $approvalRows = $('#approvalListBody tr[data-order-no]');

  console.log('출고 대상 개수:', $approvalRows.length);

  if ($approvalRows.length === 0) {
    alert('출고 취소 할 발주가 없습니다.');
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

  if (!confirm('선택한 발주를 출고 취소 처리하시겠습니까?')) {
    return;
  }

  // 여기까지는 절대 초기화하지 마라

  $.ajax({
    url: '/order/updateCancelReceiveStatusByStoreOrder',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(orderNos),

    success: function () {
      alert('출고 취소 처리되었습니다.');

      // 여기서만 초기화
      resetApprovalList();
      resetCheckboxes();
      updateOrderStatusToCancelRelease(orderNos);
    },

    error: function () {
      alert('출고 취소 처리 중 오류가 발생했습니다.');
    }
  });
});

// 본사 출고 (가맹입고 포함)
$(document).on('click', '#receiveByStoreBtn', function () {

  const $approvalRows = $('#approvalListBody tr[data-order-no]');

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
    url: '/order/releaseByHq',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(orderNos),

    success: function () {

      // 여기서만 초기화
      resetApprovalList();
      resetCheckboxes();
      updateOrderStatusToReceive(orderNos);
    },

    error: function () {
      alert('본사 출고 처리 중 오류가 발생했습니다.');
    }
  });
  
});
function updateOrderStatusToRelease(orders) {
  orders.forEach(order => {
    const orderNo = order.orderNo;

    const $row = $(`.order-row[data-order-no="${orderNo}"]`);
	
	// 1️ 상태 배지 변경
    $row.find('.badge')
      .removeClass('bg-label-info')
      .addClass('bg-label-success')
      .text('출고완료');

  });
}  function updateOrderStatusToCancelRelease(orders) {
    orders.forEach(order => {
      const orderNo = order.orderNo;

      const $row = $(`.order-row[data-order-no="${orderNo}"]`);
  	
  	// 1️ 상태 배지 변경
      $row.find('.badge')
        .removeClass('bg-label-success')
        .addClass('bg-label-info')
        .text('출고대기');

    });
  }
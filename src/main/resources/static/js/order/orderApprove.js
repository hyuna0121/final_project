/* 상세페이지 불러오기 */
$(document).on('click', '.order-row', function () {
  const orderNo = $(this).data('order-no');
  const orderType = orderNo.charAt(0) == "P" ? "HQ" : "STORE"; 
  console.log(orderType);
  console.log('orderNo =', orderNo); // ⭐ 이거 반드시 찍혀야 함
  const selectedOrderId = document.querySelector("#selectedOrderId");
  selectedOrderId.innerHTML = orderNo;

  $.ajax({
    url: '/order/detail',
    type: 'GET',
    data: { orderNo: orderNo, orderType: orderType },
    success: function (html) {
      $('#orderDetailBody').html(html);
    },
    error: function (err) {
      console.error(err);
    }
  });
});

$(document).ready(function () {

  // 발주 체크박스 클릭
  $(document).on('change', '.order-check', function () {

    const $checkbox = $(this);
    const $row = $checkbox.closest('.order-row');

    const orderNo = $row.data('order-no');
    const amount = $row.find('td').eq(2).text().trim(); // 금액
    const orderDate = new Date().toISOString().slice(0, 10); // 임시 날짜

    if ($checkbox.is(':checked')) {
      addToApprovalList(orderNo, orderDate, amount);
    } else {
      removeFromApprovalList(orderNo);
    }
  });

});

/* ===============================
   승인 리스트에 추가
================================ */
function addToApprovalList(orderNo, orderDate, amount) {

  // 이미 있으면 추가 안 함
  if ($('#approvalListBody').find(`[data-order-no="${orderNo}"]`).length > 0) {
    return;
  }

  // "선택된 발주가 없습니다" 행 제거
  $('#approvalListBody tr.empty-row').remove();

  const html = `
    <tr data-order-no="${orderNo}">
      <td>${orderNo}</td>
      <td>${orderDate}</td>
      <td class="text-end">${amount}</td>
    </tr>
  `;

  $('#approvalListBody').append(html);
  
}

/* ===============================
   승인 리스트에서 제거
================================ */
function removeFromApprovalList(orderNo) {

  $('#approvalListBody').find(`[data-order-no="${orderNo}"]`).remove();

  // 전부 제거되면 빈 문구 표시
  if ($('#approvalListBody tr').length === 0) {
    $('#approvalListBody').html(`
      <tr class="empty-row">
        <td colspan="3" class="text-muted text-center">
          선택된 발주가 없습니다
        </td>
      </tr>
    `);
  }
}


$(document).ready(function () {
	
  /* ===============================
     전체 선택 (Select All)
  ================================ */
  $(document).on('change', '.hqCheckAll', function () {

    const isChecked = $(this).is(':checked');
    const orderType = $(this).data('order-type'); // HQ or STORE

    $(`.order-row[data-order-type="${orderType}"] .order-check`)
      .each(function () {
        const $checkbox = $(this);

        if ($checkbox.is(':checked') === isChecked) return;

        $checkbox.prop('checked', isChecked).trigger('change');
      });
  });
});

  /* ===============================
     개별 체크 해제 시 전체선택 해제
  ================================ */
  $(document).on('change', '.order-check', function () {
    const total = $('.order-check').length;
    const checked = $('.order-check:checked').length;

    $('#hqCheckAll').prop('checked', total === checked);
  });



/* ===============================
   승인 버튼 클릭 html 수정
================================ */
// 승인으로 html 처리
function updateOrderStatusToApproved(orders) {
  orders.forEach(order => {
    const orderNo = order.orderNo;

    const $row = $(`.order-row[data-order-no="${orderNo}"]`);
	
	// 1️ 상태 배지 변경
    $row.find('.badge')
      .removeClass('bg-label-warning bg-label-danger')
      .addClass('bg-label-success')
      .text('승인');

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
// 승인리스트 초기화
function resetApprovalList() {
  $('#approvalListBody').html(`
    <tr class="empty-row">
      <td colspan="3" class="text-muted text-center">
        선택된 발주가 없습니다
      </td>
    </tr>
  `);
}
function resetCheckboxes() {
  $('.order-check').prop('checked', false);
  $('#hqCheckAll').prop('checked', false);
}

/* ===============================
   승인 버튼 클릭 서버 update
================================ */
$(document).on('click', '#approveBtn', function () {

  const $approvalRows = $('#approvalListBody tr[data-order-no]');

  console.log('승인 대상 개수:', $approvalRows.length);

  if ($approvalRows.length === 0) {
    alert('승인할 발주가 없습니다.');
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

  if (!confirm('선택한 발주를 승인 처리하시겠습니까?')) {
    return;
  }

  // 여기까지는 절대 초기화하지 마라

  $.ajax({
    url: '/order/approve',
    type: 'POST',
    contentType: 'application/json',
    data: JSON.stringify(orderNos),

    success: function () {
      alert('승인 처리되었습니다.');

      // 여기서만 초기화
      resetApprovalList();
      resetCheckboxes();
      updateOrderStatusToApproved(orderNos);
    },

    error: function () {
      alert('승인 처리 중 오류가 발생했습니다.');
    }
  });
});


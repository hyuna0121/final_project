let currentTab = "HQ"

// 로딩 시 본사 탭이 active니까 반려버튼 숨김
$(document).ready(function () {
  $("#rejectBtn").hide().prop("disabled", true);
  $("#approveBtn").prop("disabled", true);
});

// Bootstrap 탭 이벤트(탭이 "실제로" 바뀐 뒤 실행)
$(document).on("shown.bs.tab", 'button[data-bs-toggle="tab"]', function (e) {
  const target = $(e.target).attr("data-bs-target"); // "#hqOrderTab" or "#storeOrderTab"

  // 버튼/체크 초기화(원하면 체크만 빼도 됨)
  $(".order-check").prop("checked", false);
  $("#approveBtn, #rejectBtn").prop("disabled", true);

  if (target === "#hqOrderTab") {
	currentTab = "HQ";
    $("#rejectBtn").hide();   // ✅ 본사 탭 → 반려 숨김
  } else if (target === "#storeOrderTab") {
	currentTab = "STORE";
    $("#rejectBtn").show();   // ✅ 가맹 탭 → 반려 표시
  }
});

$(document).on("change", ".order-check", function () {

  const checked = $(".order-check:checked");
  const checkedCount = checked.length;

  // 아무것도 선택 안 했을 때
  if (checkedCount === 0) {
    $("#approveBtn, #rejectBtn").prop("disabled", true);
    return;
  }

  /* =========================
     승인 버튼 (공통)
     ========================= */
  // 본사 / 가맹 모두
  // 단일, 다중 선택 → 승인 가능
  $("#approveBtn").prop("disabled", false);

  /* =========================
     반려 버튼 (가맹만)
     ========================= */
  if (currentTab === "STORE") {

    // 단일 선택일 때만 반려 가능
    if (checkedCount === 1) {

      const row = checked.closest(".order-row");
      const status = row.data("status");

      // 이미 반려된 건은 반려 불가
      if (status !== 150) {
        $("#rejectBtn").prop("disabled", false);
      } else {
        $("#rejectBtn").prop("disabled", true);
      }

    } else {
      // 다중 선택 → 반려 불가
      $("#rejectBtn").prop("disabled", true);
    }
  }
});


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

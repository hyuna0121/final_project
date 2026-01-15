console.log("js연결")

$(function () {

  // 기준월 month picker (기존 receivable.js와 동일)
  flatpickr("#baseMonth", {
    plugins: [
      new monthSelectPlugin({
        shorthand: true,
        dateFormat: "Y-m",
        altFormat: "Y년 m월"
      })
    ]
  });

});

/**
 * HQ 미지급금 조회
 */
function searchPayables(page) {
  if (page) {
    $("input[name='pager.page']").val(page);
  }

  $.ajax({
    url: "/api/hq-payable/list",
    type: "GET",
    data: $("#searchForm").serialize(),
    success: function (res) {

      // 요약 영역
      $("#summaryArea").removeClass("d-none");
      $("#totalUnpaidAmount").text(res.summary.totalUnpaidAmount.toLocaleString());
      $("#payableCount").text(res.summary.payableCount);
      $("#summaryBaseMonth").text(res.summary.baseMonth ?? "-");

      // 리스트
      if (res.list.length === 0) {
        $("#emptyMessage").show();
        $("#payableTableArea").addClass("d-none");
        return;
      }

      $("#emptyMessage").hide();
      $("#payableTableArea").removeClass("d-none");
      $("#payableTableArea").html(res.tableHtml);

      // 페이징
      renderPagination(res.pager, searchPayables);
    }
  });
}

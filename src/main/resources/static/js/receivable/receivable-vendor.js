document.addEventListener("DOMContentLoaded", function () {
  initBaseMonthPicker();
});

/* =========================
 * 기준 월 선택기
 * ========================= */
function initBaseMonthPicker() {
  flatpickr("#baseMonth", {
    locale: "ko",
    allowInput: true,
    plugins: [
      new monthSelectPlugin({
        shorthand: true,
        dateFormat: "Y-m",
        altFormat: "Y년 m월"
      })
    ]
  });
}

/* =========================
 * 조회 버튼 클릭
 * ========================= */
function searchPayables() {
  const pageInput = document.querySelector('input[name="pager.page"]');
  if (pageInput) pageInput.value = 1;

  loadPayables();
}

/* =========================
 * 페이지 이동 (⭐ 기존 receivable 방식 핵심 ⭐)
 * ========================= */
window.onPageChange = function(page) {
  const pageInput = document.querySelector('input[name="pager.page"]');
  if (pageInput) pageInput.value = page;

  loadPayables();
};

/* =========================
 * 목록 조회
 * ========================= */
function loadPayables() {
  const form = document.getElementById("searchForm");
  const formData = new FormData(form);

  fetch("/receivable/vendor/search", {
    method: "POST",
    body: formData
  })
    .then(res => res.text())
    .then(html => {
      document.getElementById("payableTableArea").innerHTML = html;
      document.getElementById("payableTableArea").classList.remove("d-none");
      document.getElementById("emptyMessage").classList.add("d-none");
    })
    .catch(err => {
      console.error("vendor payable list 조회 실패", err);
      alert("미지급금 목록 조회 중 오류가 발생했습니다.");
    });

  loadSummary();
}

/* =========================
 * 요약 조회
 * ========================= */
function loadSummary() {
  const form = document.getElementById("searchForm");
  const formData = new FormData(form);

  fetch("/receivable/vendor/summary", {
    method: "POST",
    body: formData
  })
    .then(res => res.json())
    .then(data => {
      if (!data) return;

      document.getElementById("totalUnpaidAmount").innerText =
        Number(data.totalUnpaidAmount || 0).toLocaleString();

      document.getElementById("payableCount").innerText =
        (data.payableCount || 0) + "건";

      const baseMonth = document.getElementById("baseMonth").value;
      document.getElementById("summaryBaseMonth").innerText =
        baseMonth ? baseMonth : "-";

      document.getElementById("summaryArea").classList.remove("d-none");
    })
    .catch(err => {
      console.error("vendor payable summary 조회 실패", err);
    });
}

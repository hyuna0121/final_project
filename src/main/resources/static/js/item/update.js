
function hidePriceFields() {
   /*단가영역 숨기기, 물품영역 보이기*/
	$(".priceBox").hide();
	$(".itemBox").show();  
}

function showPriceFields() {
   /*단가영역 보이기, 물품영역 숨기기*/
  $(".priceBox").show();
  $(".itemBox").hide();
}

function boolTo01(value) {
	/* true(1)이 미승인 */
  return value === true || value === "true" ? "1" : "0";
}

/* name input 태그(물품수정/단가등록 모두 사용됨) */
const name = document.querySelector("#itemName");	
const id = document.querySelector("#itemId");
const form = document.querySelector(".modal-content");

document.addEventListener("click", function (e) {
  const btn = e.target.closest(".btn-update-item");
  if (!btn) return;

  document.querySelector(".modal-title").textContent = "물품 수정";
  hidePriceFields();

  name.value = btn.dataset.name;
  name.readOnly = false;
  id.value = btn.dataset.id;
  document.querySelector("#itemUseYn").value = boolTo01(btn.dataset.itemuse);
  document.querySelector("#autoOrderUseYn").value = boolTo01(btn.dataset.autouse);
  form.action = "/item/updateItem"
});

document.addEventListener("click", function (e) {
  const btn = e.target.closest(".btn-update-price");
  if (!btn) return;
  const modalbtn = document.querySelector(".modal-footer");
  modalbtn.children[0].textContent = '등록';

  document.querySelector(".modal-title").textContent = "단가 등록";
  showPriceFields();
  name.value = btn.dataset.name;
  name.readOnly = true;
  id.value = btn.dataset.id;
  form.action = "/item/insertPrice"
});
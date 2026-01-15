
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

$(document).on("click", ".btn-update-item", function () {
  console.log("update item click OK");

  $(".modal-title").text("물품 수정");
  hidePriceFields();

  $("#itemName").val($(this).data("name")).prop("readonly", false);
  $("#itemId").val($(this).data("id"));
  $("#itemUseYn").val(boolTo01($(this).data("itemuse")));
  $("#autoOrderUseYn").val(boolTo01($(this).data("autouse")));

  $(".modal-content").attr("action", "/item/updateItem");
});

$(document).on("click", ".btn-update-price", function () {
  console.log("update price click OK");

  $(".modal-title").text("단가 등록");
  showPriceFields();

  $("#itemName").val($(this).data("name")).prop("readonly", true);
  $("#itemId").val($(this).data("id"));

  $(".modal-content").attr("action", "/item/insertPrice");
});
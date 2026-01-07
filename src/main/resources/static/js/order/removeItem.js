function removeSelectedItems() {

  const checkedItems = document.querySelectorAll(".order-check:checked");

  if (checkedItems.length === 0) {
    alert("취소할 상품을 선택하세요.");
    return;
  }

  checkedItems.forEach(checkbox => {
    const tr = checkbox.closest("tr");
    tr.remove();
  });

  // 삭제 후 총 금액 재계산
  updateGrandTotal();
}

function checkAll(){
	const isChecked = document.getElementById("checkAll").checked;
	const items = document.querySelectorAll(".order-check");

	items.forEach(checkbox => {
	  checkbox.checked = isChecked;
	});
	
}
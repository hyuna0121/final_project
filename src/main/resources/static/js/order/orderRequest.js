/* 물품 목록 불러오기 */
function searchItem() {
  const vendorCode = document.getElementById("vendorCode").value;
  const keyword = document.getElementById("keyword").value;
  console.log(vendorCode, keyword)
  fetch(`/order/itemSearch?vendorCode=${vendorCode}&keyword=${keyword}`)
    .then(res => res.json())
    .then(list => {
      renderItemResult(list);
    });
}

function renderItemResult(list) {
  const tbody = document.getElementById("itemSearchResult");
  tbody.innerHTML = "";

  if (list.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="5">검색 결과가 없습니다.</td>
      </tr>
    `;
    return;
  }

  list.forEach(item => {
    tbody.innerHTML += `
      <tr>
        <td>${item.itemCode}</td>
        <td>${item.itemName}</td>
        <td>${item.vendorName}</td>
        <td class="text-end">${item.itemSupplyPrice.toLocaleString()}</td>
        <td>
          <button class="btn btn-sm btn-primary"
                  onclick="selectItem('${item.itemId}','${item.itemCode}','${item.itemName}','${item.itemSupplyPrice}','${item.vendorCode}')">
            선택
          </button>
        </td>
      </tr>
    `;
  });
}


/* 물품 등록 */
function selectItem(itemId, itemCode, itemName, itemSupplyPrice, vendorCode) {
  
  let check = confirm("물품을 선택하시겠습니까?");
  if (!check){
	return;
  }
	
  const tbody = document.getElementById("orderItemBody");

  /* 1️ 중복 상품 체크 */
  if (document.querySelector(`tr[data-item-code="${itemCode}"]`)) {
    alert("이미 선택된 물품입니다.");
    return;
  }
  
  /* 2️ index 계산 (중요) */
  const index = tbody.querySelectorAll("tr").length;

  /* 3️ row 생성 */
  const tr = document.createElement("tr");
  tr.classList.add("item-row");
  tr.setAttribute("data-item-code", itemCode);
  tr.setAttribute("data-price", itemSupplyPrice);

  tr.innerHTML = `
    <td>
      <input type="checkbox" class="order-check">
    </td>
    <td>
		<input type="hidden" name="items[${index}].itemId" value="${itemId}">
		${itemCode}
		<input type="hidden" name="items[${index}].itemCode" value="${itemCode}">
		<input type="hidden" name="items[${index}].itemName" value="${itemName}">
		<input type="hidden" name="items[${index}].vendorCode" value="${vendorCode}">
	</td>
    <td>${itemName}</td>
    <td class="text-end">
		${itemSupplyPrice.toLocaleString()}
		<input type="hidden" name="items[${index}].itemSupplyPrice" value="${itemSupplyPrice}">	
	</td>
    <td>
      <input type="text"
             class="form-control text-end qty"
			 name="items[${index}].ItemQuantity"
             oninput="updateRowTotal(this)">
    </td>
    <td class="row-total text-end">0</td>
  `;

  /* 3️ 테이블에 추가 */
  tbody.appendChild(tr);

}

function renderItemResult(list) {
  const tbody = document.getElementById("itemSearchResult");
  tbody.innerHTML = "";

  if (list.length === 0) {
    tbody.innerHTML = `
      <tr>
        <td colspan="5">검색 결과가 없습니다.</td>
      </tr>
    `;
    return;
  }

  list.forEach(item => {
    tbody.innerHTML += `
      <tr>
        <td>${item.itemCode}</td>
        <td>${item.itemName}</td>
        <td>${item.vendorName}</td>
        <td class="text-end">${item.itemSupplyPrice.toLocaleString()}</td>
        <td>
          <button class="btn btn-sm btn-primary"
                  onclick="selectItem('${item.itemId}','${item.itemCode}','${item.itemName}','${item.itemSupplyPrice}','${item.vendorCode}')">
            선택
          </button>
        </td>
      </tr>
    `;
  });
}

/* 물품 등록 취소 */
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

function toggleAllCheckboxes(){
	const isChecked = document.getElementById("checkAll").checked;
	const items = document.querySelectorAll(".order-check");

	items.forEach(checkbox => {
	  checkbox.checked = isChecked;
	});
	
}

/* 목록 중 하나라도 체크해제 시 ALL체크도 해제 */
document.addEventListener("change", function (e) {
  if (e.target.classList.contains("order-check")) {
    const all = document.querySelectorAll(".order-check");
    const checked = document.querySelectorAll(".order-check:checked");

    document.getElementById("checkAll").checked =
      all.length > 0 && all.length === checked.length;
  }
});

/* 물품 총액 계산 */
function updateRowTotal(input) {
  const tr = input.closest("tr");
  const price = Number(tr.dataset.price);
  const qty = Number(input.value);

  const total = price * qty;
  tr.querySelector(".row-total").innerText = total.toLocaleString();

  updateGrandTotal();
}

function updateGrandTotal() {
  let sum = 0;

  document.querySelectorAll(".row-total").forEach(td => {
    sum += Number(td.innerText.replace(/,/g, ""));
  });
  
  // 화면 표시용 (콤마)
  document.getElementById("grandTotalView").value = sum.toLocaleString();

  // 서버 전송용 (숫자만)
  document.getElementById("grandTotal").value = sum;
}



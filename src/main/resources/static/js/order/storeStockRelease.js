let selectedItems = [];

const releaseModal = new bootstrap.Modal(document.getElementById("releaseModal"));
const itemModal = new bootstrap.Modal(document.getElementById("itemModal"));

document.getElementById("btnAddItem").addEventListener("click", () => {
  itemModal.show();
  loadInventory();
});

function loadInventory() {
  fetch("/stock/storeInventory")   // ⭐ 절대경로
    .then(res => {
      if (!res.ok) throw new Error("HTTP " + res.status);
      return res.json();
    })
    .then(data => {
      const ul = document.getElementById("inventoryList");
      ul.innerHTML = "";

      data.forEach(item => {
        const li = document.createElement("li");
        li.className = "list-group-item d-flex justify-content-between align-items-center";

        li.innerHTML = `
          <div>
            <div class="fw-semibold">${item.itemName}</div>
            <small class="text-muted">보유수량: ${item.stockQuantity}</small>
          </div>
          <button type="button" class="btn btn-sm btn-outline-primary">선택</button>
        `;

        li.querySelector("button").addEventListener("click", () => {
          selectItem(item);
          itemModal.hide();
        });

        ul.appendChild(li);
      });
    })
    .catch(err => console.error(err));
}

function selectItem(item) {
  if (selectedItems.find(i => i.itemId === item.itemId)) {
    alert("이미 선택된 상품입니다.");
    return;
  }

  selectedItems.push({
    itemId: item.itemId,
    itemName: item.itemName,
    stockQuantity: item.stockQuantity,
    quantity: 1
  });

  renderSelectedItems();
}
function renderSelectedItems() {
  const tbody = document.getElementById("selectedItemList");
  tbody.innerHTML = "";

  // 선택된 상품이 없을 때
  if (selectedItems.length === 0) {
    const tr = document.createElement("tr");
    tr.className = "empty-row";
    tr.innerHTML = `
      <td colspan="3" class="text-muted">
        등록된 물품이 없습니다
      </td>
    `;
    tbody.appendChild(tr);
    return;
  }

  // 선택된 상품 렌더링
  selectedItems.forEach((item, index) => {
    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td>${item.itemName}</td>
      <td>${item.stockQuantity}</td>
      <td>
        <input 
          type="number"
          class="form-control form-control-sm text-center"
          min="1"
          max="${item.stockQuantity}"
          value="${item.quantity || 1}"
        />
      </td>
    `;

    // 수량 변경 이벤트
    const qtyInput = tr.querySelector("input");
    qtyInput.addEventListener("change", (e) => {
      let value = parseInt(e.target.value, 10);

      if (isNaN(value) || value < 1) value = 1;
      if (value > item.stockQuantity) value = item.stockQuantity;

      e.target.value = value;
      item.quantity = value;
    });

    tbody.appendChild(tr);
  });
}

document.getElementById("btnReleaseStock").addEventListener("click", () => {
  const form = document.createElement("form");
  form.method = "post";
  form.action = "/stock/storeStockUse";

  selectedItems.forEach((item, index) => {
	  // releaseType
	  const typeInput = document.createElement("input");
	  typeInput.type = "hidden";
	  typeInput.name = "releaseType";
	  typeInput.value = document.getElementById("releaseType").value;
	  form.appendChild(typeInput);

	  // releaseReason (faulty일 때만)
	  const reasonValue = document.getElementById("releaseReason").value;
	  if (typeInput.value === "faulty") {
	    const reasonInput = document.createElement("input");
	    reasonInput.type = "hidden";
	    reasonInput.name = "releaseReason";
	    reasonInput.value = reasonValue;
	    form.appendChild(reasonInput);
	  }
	  
	  // items 리스트
      const code = document.createElement("input");
      code.type = "hidden";
      code.name = `items[${index}].itemId`;
      code.value = item.itemId;

      const qty = document.createElement("input");
      qty.type = "hidden";
      qty.name = `items[${index}].quantity`;
      qty.value = item.quantity;

      form.appendChild(code);
      form.appendChild(qty);
  });

  document.body.appendChild(form);
  form.submit();
});

const releaseTypeSelect = document.getElementById("releaseType");
const releaseReasonInput = document.getElementById("releaseReason");

releaseTypeSelect.addEventListener("change", () => {
  if (releaseTypeSelect.value === "faulty") {
    releaseReasonInput.disabled = false;
    releaseReasonInput.focus();
  } else {
    releaseReasonInput.value = "";
    releaseReasonInput.disabled = true;
  }
})

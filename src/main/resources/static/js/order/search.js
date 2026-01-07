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
                  onclick="selectItem('${item.itemCode}','${item.itemName}',${item.itemSupplyPrice})">
            선택
          </button>
        </td>
      </tr>
    `;
  });
}

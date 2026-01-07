function selectItem(itemCode, itemName, itemSupplyPrice) {
  
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

  /* 2️ row 생성 */
  const tr = document.createElement("tr");
  tr.classList.add("item-row");
  tr.setAttribute("data-item-code", itemCode);
  tr.setAttribute("data-price", itemSupplyPrice);

  tr.innerHTML = `
    <td>
      <input type="checkbox" class="order-check">
    </td>
    <td>
		${itemCode}
		<input type="hidden" name="items[0].itemCode" value="am0012">
	</td>
    <td>${itemName}</td>
    <td class="text-end">${itemSupplyPrice.toLocaleString()}</td>
    <td>
      <input type="number"
             class="form-control text-end qty"
             min="0"
             value="0"
             oninput="updateRowTotal(this)">
	  <input type="hidden" name="items[0].quantity" value="3">
    </td>
    <td class="row-total text-end">0</td>
  `;

  /* 3️ 테이블에 추가 */
  tbody.appendChild(tr);

}
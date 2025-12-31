
function searchItems() {
  $.ajax({
    url: "/item/search",
    type: "GET",
    dataType: "json",
    data: {
      itemName: $("#searchItemName").val(),
      category: $("#searchCategory").val(),
      vendorCode: $("#searchVendorCode").val()
    },
    success: function(list) {
      let html = "";

      if (list.length === 0) {
        html = `
          <tr>
            <td colspan="7" class="text-center text-muted">
              검색 결과가 없습니다.
            </td>
          </tr>`;
      } else {
        $.each(list, function(i, item) {
          html += `
            <tr>
			  <td class="text">
			      <button class="btn btn-sm btn-light"
				      onclick="toggleFavorite(this, 'am0012')"
				      title="즐겨찾기">
				      <i class="bx bx-star"></i>
				  </button>
			  </td>
			  <td>${item.itemCode}</td>
		      <td>${item.itemName}</td>
		      <td class="text">${item.itemCategory}</td>
			  <td class="text">
			    ${
			      item.itemEnable == 0
			        ? '<span class="badge bg-label-success">사용</span>'
			        : '<span class="badge bg-label-danger">미사용</span>'
			    }
			  </td>
		      <td class="text">
				<button class="btn btn-sm btn-warning btn-update-item"
				  data-bs-toggle="modal"
				  data-bs-target="#editModal"
				  data-name="${item.itemName}"
				  data-itemuse="${item.itemEnable}"
				  data-autouse="${item.itemAutoOrder}">
				  수정
				</button>
			    <button class="btn btn-sm btn-danger btn-update-price"
			      data-bs-toggle="modal"
			      data-bs-target="#editModal"
			      data-name="${item.itemName}"
			      data-price="${item.itemSupplyPrice}"
			      data-priceuse="${item.itemPriceEnable}">
			      단가 수정
			    </button>
			  </td>
            </tr>`;
        });
      }

      $("#itemTableBody").html(html);
    },
	error: function (xhr, status, error) {
	  console.log("xhr.status =", xhr.status);
	  console.log("xhr.responseText =", xhr.responseText);
	  console.log("status =", status);
	  console.log("error =", error);
	  alert("검색 실패");
	}
  })
}

